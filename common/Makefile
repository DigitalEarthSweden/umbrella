MAKEFILE_DIR := $(patsubst %/,%,$(dir $(lastword $(MAKEFILE_LIST))))

# Give an error message when using an old version of GNU Make.
MAKE_MAJOR_VERSION := $(word 1,$(subst ., ,$(MAKE_VERSION)))
ifeq ($(shell test $(MAKE_MAJOR_VERSION) -lt 4; echo $$?),0)
  $(error GNU Make version 4.0 or newer is required)
endif

# Only use rules/variables from the Makefiles. This eliminates a lot
# of attempted matches from the implicit rules for SCCS.
MAKEFLAGS += --no-builtin-variables

# Run "make Q='' <target>" to get commands echoed.
Q ?= @

ifndef CI_REGISTRY
	$(error CI_REGISTRY not defined)
endif
ifndef CI_REGISTRY_BASE_PATH
	$(error CI_REGISTRY_BASE_PATH not defined)
endif
ifndef ORGANIZATION_NAME
	$(error ORGANIZATION_NAME not defined)
endif

# The Ubuntu version to base upstream images on.
UBUNTU_VER ?= 24.04
UBUNTU_IMAGE_NAME ?= $(ORGANIZATION_NAME)-ubuntu
UBUNTU_IMAGE ?= $(CI_REGISTRY)/$(ORGANIZATION_NAME)-upstream/$(UBUNTU_IMAGE_NAME):$(UBUNTU_VER)

DOCKERFILE ?= Dockerfile

# Docker build-context argument for buildpack-deps and debian-slim.
DOCKER_BUILDPACK_DEPS_CONTEXT ?= --build-context buildpack-deps:bookworm=docker-image://$(CI_REGISTRY)/$(CI_REGISTRY_BASE_PATH)/$(ORGANIZATION_NAME)-buildpack-deps:$(UBUNTU_VER)
DOCKER_SLIM_CONTEXT ?= --build-context debian:bookworm-slim=docker-image://$(CI_REGISTRY)/$(CI_REGISTRY_BASE_PATH)/$(UBUNTU_IMAGE_NAME):$(UBUNTU_VER)

# The start of the pytest command.
PYTEST_PREFIX_CMD = uv run pytest -vv --cov --cov-report term-missing

build-timeout: BUILD_TIMEOUT ?= 15
build-timeout:
	$(Q)echo "$(BUILD_TIMEOUT)"

extra-build-repository:
	$(Q)echo "$(EXTRA_BUILD_REPOSITORY)"

# Default to root directory.
IMAGE_BUILD_DIR ?= $(MAKEFILE_DIR)/..

COSIGN_CMD ?= true

sign-image:
	$(eval DIGEST := $(shell docker inspect $(IMAGE_VAR):$(IMAGE_REV) | jq -r '.[].Id'))
	$(Q)$(COSIGN_CMD) sign --yes --recursive $(IMAGE_VAR):$(IMAGE_REV)@$(DIGEST)

ifdef LOCAL_IMAGE
ifndef PIPELINE_TIME
  # Lexically sortable, monotonically increasing.
  PIPELINE_TIME := $(shell date +"%Y%m%d%H%M%S")
endif

# Builds an upstream image. Will push image if make is invoked with:
# make PUSH_OPTION="--push" ..
build-upstream-image: IMAGE_REV = prod-$(PIPELINE_TIME)-$(COMMIT_SHORT_SHA)
endif
build-upstream-image: IMAGE_VAR ?= $(CI_REGISTRY)/$(CI_REGISTRY_BASE_PATH)/$(ORGANIZATION_NAME)-$(IMAGE_BASE_NAME)
build-upstream-image:
	$(Q)cd $(IMAGE_BUILD_DIR) && \
          docker build $(PUSH_OPTION) $(DOCKER_ARGS) $(DOCKER_EXTRA_UPSTREAM_ARGS) $(DOCKER_PROVENANCE_FLAGS) $(addprefix --tag ,$(DOCKER_TAGS)) --build-arg BUILDKIT_INLINE_CACHE=1 --cache-from $(IMAGE_VAR):$(IMAGE_REV) $(addprefix --cache-from ,$(DOCKER_TAGS)) --tag $(IMAGE_VAR):$(IMAGE_REV) --file $(DOCKERFILE) .
	$(Q)$(MAKE) IMAGE_VAR=$(IMAGE_VAR) IMAGE_REV=$(IMAGE_REV) sign-image

PUSH_CMD ?= true

# Builds a gdal upstream image. Will push image if make is invoked with:
# make PUSH_CMD=docker ..
build-gdal-upstream-image: IMAGE_VAR ?= $(CI_REGISTRY)/$(CI_REGISTRY_BASE_PATH)/$(ORGANIZATION_NAME)-$(IMAGE_BASE_NAME)
build-gdal-upstream-image:
	$(Q)cd $(IMAGE_BUILD_DIR) && \
          $(IMAGE_REV_PREFIX)/build.sh $(DOCKER_ARGS) --platform linux/amd64 --tag $(IMAGE_REV)
	$(Q)$(PUSH_CMD) tag ghcr.io/osgeo/gdal:$(IMAGE_REV_PREFIX)-$(IMAGE_REV)-amd64 $(IMAGE_VAR):$(IMAGE_REV_PREFIX)-$(IMAGE_REV)
	$(Q)$(PUSH_CMD) push $(IMAGE_VAR):$(IMAGE_REV_PREFIX)-$(IMAGE_REV)
	$(Q)$(MAKE) IMAGE_VAR=$(IMAGE_VAR) IMAGE_REV=$(IMAGE_REV_PREFIX)-$(IMAGE_REV) sign-image

UPSTREAM_REPO_NAME ?= not-set-upstream-repo-name

# Pull a minimal amount of data from a git repository.
# FIXME: add --filter=tree:0 when Github supports it.
$(UPSTREAM_REPO_NAME): UPSTREAM_BRANCH ?= main
$(UPSTREAM_REPO_NAME): NO_CHECKOUT ?= --no-checkout
$(UPSTREAM_REPO_NAME): NO_SHALLOW ?= --depth 1 --filter=blob:none
$(UPSTREAM_REPO_NAME): SHELL = /bin/bash
$(UPSTREAM_REPO_NAME):
	$(Q)[ -d $(UPSTREAM_REPO_NAME) ] || \
          git clone $(NO_SHALLOW) $(NO_CHECKOUT) $(UPSTREAM_REPO)
	$(Q)[ "$(NO_SPARSE)" = "" -a  "$(NO_CHECKOUT)" = "" ] || \
          (cd $(UPSTREAM_REPO_NAME) && \
          ([ "$(NO_SPARSE)" != "" ] || git sparse-checkout set $(UPSTREAM_DIRS)) && \
          git checkout $(UPSTREAM_BRANCH))

.PHONY: sign-image \
        build-upstream-image build-gdal-upstream-image

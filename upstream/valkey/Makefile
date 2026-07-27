MAKEFILE_DIR := $(patsubst %/,%,$(dir $(lastword $(MAKEFILE_LIST))))

UPSTREAM_REPO = https://github.com/valkey-io/valkey-container
UPSTREAM_REPO_NAME = valkey-container
UPSTREAM_BRANCH = mainline

UPSTREAM_DIRS = 9.1/debian

# FIXME: remove this when UBUNTU_VER in common/Makefile is 26.04.
UBUNTU_VER = 26.04

include ../../common/Makefile

build-images: build-ubuntu-91-image

UBUNTU_91_ARGS = IMAGE_BUILD_DIR=$(UPSTREAM_REPO_NAME)/9.1/debian \
            IMAGE_BASE_NAME=valkey \
            DOCKER_ARGS=" --build-context debian:trixie-slim=docker-image://$(CI_REGISTRY)/$(CI_REGISTRY_BASE_PATH)/$(UBUNTU_IMAGE_NAME):$(UBUNTU_VER)"

build-ubuntu-91-image: $(UPSTREAM_REPO_NAME)
	$(Q)$(MAKE) IMAGE_REV=9.1 $(UBUNTU_91_ARGS) build-upstream-image

.PHONY: build-images \
        build-ubuntu-91-image

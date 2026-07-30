MAKEFILE_DIR := $(patsubst %/,%,$(dir $(lastword $(MAKEFILE_LIST))))

UPSTREAM_REPO = https://github.com/nodejs/docker-node
UPSTREAM_REPO_NAME = docker-node

UPSTREAM_DIRS = 24/trixie 24/trixie-slim 26/trixie-slim

# FIXME: remove this when UBUNTU_VER in common/Makefile is 26.04.
UBUNTU_VER = 26.04
DOCKER_BUILDPACK_DEPS_CONTEXT = --build-context buildpack-deps:trixie=docker-image://$(CI_REGISTRY)/$(CI_REGISTRY_BASE_PATH)/$(ORGANIZATION_NAME)-buildpack-deps:$(UBUNTU_VER)
DOCKER_SLIM_CONTEXT = --build-context debian:trixie-slim=docker-image://$(CI_REGISTRY)/$(CI_REGISTRY_BASE_PATH)/$(UBUNTU_IMAGE_NAME):$(UBUNTU_VER)

include ../../common/Makefile

build-images: build-big-24-image build-slim-24-image build-slim-26-image

BIG_24_ARGS = IMAGE_BUILD_DIR=$(UPSTREAM_REPO_NAME)/24/trixie \
            IMAGE_BASE_NAME=node \
            DOCKER_ARGS="$(DOCKER_BUILDPACK_DEPS_CONTEXT)"

build-big-24-image: $(UPSTREAM_REPO_NAME)
	$(Q)perl -pi -e 's#&& set -ex#&& apt-get update && apt-get upgrade -y && rm -rf /var/lib/apt/lists/* && set -ex#g' $(UPSTREAM_REPO_NAME)/24/trixie/Dockerfile
	$(Q)perl -pi -e 's#groupadd --gid 1000 node #groupmod -n node ubuntu#g' $(UPSTREAM_REPO_NAME)/24/trixie/Dockerfile
	$(Q)perl -pi -e 's#useradd --uid 1000(.)+$$#usermod -m -d /home/node -l node ubuntu#g' $(UPSTREAM_REPO_NAME)/24/trixie/Dockerfile
	$(Q)$(MAKE) IMAGE_REV=24 $(BIG_24_ARGS) build-upstream-image

SLIM_24_ARGS = IMAGE_BUILD_DIR=$(UPSTREAM_REPO_NAME)/24/trixie-slim \
            IMAGE_BASE_NAME=node \
            DOCKER_ARGS="$(DOCKER_SLIM_CONTEXT)"

build-slim-24-image: $(UPSTREAM_REPO_NAME)
	$(Q)perl -pi -e 's#&& set -ex#&& apt-get update && apt-get upgrade -y && rm -rf /var/lib/apt/lists/* && set -ex#g' $(UPSTREAM_REPO_NAME)/24/trixie-slim/Dockerfile
	$(Q)perl -pi -e 's#groupadd --gid 1000 node #groupmod -n node ubuntu#g' $(UPSTREAM_REPO_NAME)/24/trixie-slim/Dockerfile
	$(Q)perl -pi -e 's#useradd --uid 1000(.)+$$#usermod -m -d /home/node -l node ubuntu#g' $(UPSTREAM_REPO_NAME)/24/trixie-slim/Dockerfile
	$(Q)$(MAKE) IMAGE_REV=24-slim $(SLIM_24_ARGS) build-upstream-image

SLIM_26_ARGS = IMAGE_BUILD_DIR=$(UPSTREAM_REPO_NAME)/26/trixie-slim \
            IMAGE_BASE_NAME=node \
            DOCKER_ARGS="$(DOCKER_SLIM_CONTEXT)"

build-slim-26-image: $(UPSTREAM_REPO_NAME)
	$(Q)perl -pi -e 's#&& set -ex#&& apt-get update && apt-get upgrade -y && rm -rf /var/lib/apt/lists/* && set -ex#g' $(UPSTREAM_REPO_NAME)/26/trixie-slim/Dockerfile
	$(Q)perl -pi -e 's#groupadd --gid 1000 node #groupmod -n node ubuntu#g' $(UPSTREAM_REPO_NAME)/26/trixie-slim/Dockerfile
	$(Q)perl -pi -e 's#useradd --uid 1000(.)+$$#usermod -m -d /home/node -l node ubuntu#g' $(UPSTREAM_REPO_NAME)/26/trixie-slim/Dockerfile
	$(Q)$(MAKE) IMAGE_REV=26-slim $(SLIM_26_ARGS) build-upstream-image

.PHONY: build-images \
        build-big-24-image build-slim-24-image \
        build-slim-26-image

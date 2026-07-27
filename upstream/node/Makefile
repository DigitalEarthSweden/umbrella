MAKEFILE_DIR := $(patsubst %/,%,$(dir $(lastword $(MAKEFILE_LIST))))

UPSTREAM_REPO = https://github.com/nodejs/docker-node
UPSTREAM_REPO_NAME = docker-node

UPSTREAM_DIRS = 24/bookworm 24/bookworm-slim

include ../../common/Makefile

build-images: build-big-24-image build-slim-24-image

BIG_24_ARGS = IMAGE_BUILD_DIR=$(UPSTREAM_REPO_NAME)/24/bookworm \
            IMAGE_BASE_NAME=node \
            DOCKER_ARGS="$(DOCKER_BUILDPACK_DEPS_CONTEXT)"

build-big-24-image: $(UPSTREAM_REPO_NAME)
	$(Q)perl -pi -e 's#&& set -ex#&& apt-get update && apt-get upgrade -y && rm -rf /var/lib/apt/lists/* && set -ex#g' docker-node/24/bookworm/Dockerfile
	$(Q)perl -pi -e 's#groupadd --gid 1000 node #groupmod -n node ubuntu#g' docker-node/24/bookworm/Dockerfile
	$(Q)perl -pi -e 's#useradd --uid 1000(.)+$$#usermod -m -d /home/node -l node ubuntu#g' docker-node/24/bookworm/Dockerfile
	$(Q)$(MAKE) IMAGE_REV=24 $(BIG_24_ARGS) build-upstream-image

SLIM_24_ARGS = IMAGE_BUILD_DIR=$(UPSTREAM_REPO_NAME)/24/bookworm-slim \
            IMAGE_BASE_NAME=node \
            DOCKER_ARGS="$(DOCKER_SLIM_CONTEXT)"

build-slim-24-image: $(UPSTREAM_REPO_NAME)
	$(Q)perl -pi -e 's#&& set -ex#&& apt-get update && apt-get upgrade -y && rm -rf /var/lib/apt/lists/* && set -ex#g' docker-node/24/bookworm-slim/Dockerfile
	$(Q)perl -pi -e 's#groupadd --gid 1000 node #groupmod -n node ubuntu#g' docker-node/24/bookworm-slim/Dockerfile
	$(Q)perl -pi -e 's#useradd --uid 1000(.)+$$#usermod -m -d /home/node -l node ubuntu#g' docker-node/24/bookworm-slim/Dockerfile
	$(Q)$(MAKE) IMAGE_REV=24-slim $(SLIM_24_ARGS) build-upstream-image


.PHONY: build-images \
        build-big-24-image build-slim-24-image

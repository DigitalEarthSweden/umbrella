MAKEFILE_DIR := $(patsubst %/,%,$(dir $(lastword $(MAKEFILE_LIST))))

UPSTREAM_REPO = https://github.com/docker-library/postgres
UPSTREAM_REPO_NAME = postgres
UPSTREAM_BRANCH = master

UPSTREAM_DIRS = 18/trixie

# FIXME: remove this when UBUNTU_VER in common/Makefile is 26.04.
UBUNTU_VER = 26.04
DOCKER_SLIM_CONTEXT = --build-context debian:trixie-slim=docker-image://$(CI_REGISTRY)/$(CI_REGISTRY_BASE_PATH)/$(UBUNTU_IMAGE_NAME):$(UBUNTU_VER)

include ../../common/Makefile

build-images: $(UPSTREAM_REPO_NAME)
	$(Q)$(MAKE) build-images-internal

build-images-internal: build-big-18-image
	$(Q)$(MAKE) build-dependencies

BIG_18_ARGS = IMAGE_BUILD_DIR=$(UPSTREAM_REPO_NAME)/18/trixie \
            IMAGE_BASE_NAME=postgres \
            DOCKER_ARGS="$(DOCKER_SLIM_CONTEXT)"

build-big-18-image:
	$(Q)cd $(UPSTREAM_REPO_NAME) && patch -p1 < ../use-default-gosu.patch
	$(Q)perl -pi -e 's#less \\$$#less; apt-get update; apt-get -y upgrade \\#g' $(UPSTREAM_REPO_NAME)/18/trixie/Dockerfile
	$(Q)perl -pi -e 's#apt-get update;#export DEBIAN_FRONTEND=noninteractive; apt-get update;#g' $(UPSTREAM_REPO_NAME)/18/trixie/Dockerfile
	$(Q)perl -pi -e 's#apt trixie-pgdg main#apt resolute-pgdg main#g' $(UPSTREAM_REPO_NAME)/18/trixie/Dockerfile
	$(Q)perl -pi -e 's#ENV PG_VERSION 18\.([0-9\-]+)(.+)\+(.+)$$#ENV PG_VERSION=18\.\1\.pgdg26\.04\+\3#g' $(UPSTREAM_REPO_NAME)/18/trixie/Dockerfile
	$(Q)$(MAKE) IMAGE_REV=18-trixie $(BIG_18_ARGS) build-upstream-image

build-dependencies: build-postgis

build-postgis:
	$(Q)$(MAKE) -C ../postgis build-images

.PHONY: build-images build-big-18-image \
  build-dependencies \
  build-postgis

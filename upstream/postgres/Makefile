MAKEFILE_DIR := $(patsubst %/,%,$(dir $(lastword $(MAKEFILE_LIST))))

UPSTREAM_REPO = https://github.com/docker-library/postgres
UPSTREAM_REPO_NAME = postgres
UPSTREAM_BRANCH = master

UPSTREAM_DIRS = 18/bookworm

include ../../common/Makefile

build-images: $(UPSTREAM_REPO_NAME)
	$(Q)$(MAKE) build-images-internal

build-images-internal: build-big-18-image

BIG_18_ARGS = IMAGE_BUILD_DIR=$(UPSTREAM_REPO_NAME)/18/bookworm \
            IMAGE_BASE_NAME=postgres \
            DOCKER_ARGS="$(DOCKER_SLIM_CONTEXT)"

build-big-18-image:
	$(Q)cd $(UPSTREAM_REPO_NAME) && patch -p1 < ../use-default-gosu.patch
	$(Q)perl -pi -e 's#less \\$$#less; apt-get update; apt-get -y upgrade \\#g' $(UPSTREAM_REPO_NAME)/18/bookworm/Dockerfile
	$(Q)perl -pi -e 's#apt-get update;#export DEBIAN_FRONTEND=noninteractive; apt-get update;#g' $(UPSTREAM_REPO_NAME)/18/bookworm/Dockerfile
	$(Q)perl -pi -e 's#apt bookworm-pgdg main#apt noble-pgdg main#g' $(UPSTREAM_REPO_NAME)/18/bookworm/Dockerfile
	$(Q)perl -pi -e 's#ENV PG_VERSION 18\.([0-9\-]+)(.+)\+(.+)$$#ENV PG_VERSION=18\.\1\.pgdg24\.04\+\3#g' $(UPSTREAM_REPO_NAME)/18/bookworm/Dockerfile
	$(Q)$(MAKE) IMAGE_REV=18-bookworm $(BIG_18_ARGS) build-upstream-image

.PHONY: build-images build-big-18-image

MAKEFILE_DIR := $(patsubst %/,%,$(dir $(lastword $(MAKEFILE_LIST))))

UPSTREAM_REPO = https://github.com/terriajs/terriajs
UPSTREAM_REPO_NAME = terriajs
NO_CHECKOUT =
NO_SHALLOW =
NO_SPARSE = true

# renovate: datasource=github-tags depName=terriajs/terriajs
TERRIAJS_VERSION = 2f2b227e1
UPSTREAM_BRANCH = $(TERRIAJS_VERSION)

include ../../common/Makefile

build-images: build-latest-release-image

DOCKER_TERRIAMAP_ARGS = --target deploy \
  --build-context node:24=docker-image://$(CI_REGISTRY)/$(CI_REGISTRY_UPSTREAM_BASE_PATH)/$(ORGANIZATION_NAME)-node:26 \
  --build-context node:24-slim=docker-image://$(CI_REGISTRY)/$(CI_REGISTRY_UPSTREAM_BASE_PATH)/$(ORGANIZATION_NAME)-node:26-slim

TERRIAMAP_ARGS = IMAGE_BUILD_DIR=$(UPSTREAM_REPO_NAME) \
    IMAGE_BASE_NAME=terriamap \
    DOCKERFILE=apps/terriamap/Dockerfile \
    DOCKER_ARGS="$(DOCKER_TERRIAMAP_ARGS)"

build-latest-release-image: $(UPSTREAM_REPO_NAME)
	$(eval TERRIAMAP_VERSION := $(shell jq '.version' < $(UPSTREAM_REPO_NAME)/apps/terriamap/package.json | perl -p -e 's#"##g'))
	$(Q)perl -pi -e 's#apt-get update &&#apt-get update && apt-get upgrade -y &&#g' $(UPSTREAM_REPO_NAME)/apps/terriamap/Dockerfile
	$(Q)$(MAKE) IMAGE_REV=$(TERRIAMAP_VERSION) $(TERRIAMAP_ARGS) build-upstream-image

.PHONY: build-images \
        build-latest-release-image

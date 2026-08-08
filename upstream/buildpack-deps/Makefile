MAKEFILE_DIR := $(patsubst %/,%,$(dir $(lastword $(MAKEFILE_LIST))))

UPSTREAM_REPO = https://github.com/docker-library/buildpack-deps
UPSTREAM_REPO_NAME = buildpack-deps
UPSTREAM_BRANCH = master

UPSTREAM_DIRS = ubuntu/noble ubuntu/resolute

include ../../common/Makefile

build-images: $(UPSTREAM_REPO_NAME)
	$(Q)$(MAKE) build-images-internal

build-images-internal: build-noble-image build-resolute-image

DOCKER_NOBLE_CURL_CONTEXT = --build-context ubuntu:noble=docker-image://$(CI_REGISTRY)/$(CI_REGISTRY_BASE_PATH)/$(UBUNTU_IMAGE_NAME):24.04

NOBLE_CURL_ARGS = IMAGE_BUILD_DIR=$(UPSTREAM_REPO_NAME)/ubuntu/noble/curl \
            IMAGE_BASE_NAME=buildpack-deps \
            DOCKER_ARGS="$(DOCKER_NOBLE_CURL_CONTEXT)"

DOCKER_NOBLE_SCM_CONTEXT = --build-context buildpack-deps:noble-curl=docker-image://$(CI_REGISTRY)/$(CI_REGISTRY_BASE_PATH)/$(ORGANIZATION_NAME)-buildpack-deps:noble-curl

NOBLE_SCM_ARGS = IMAGE_BUILD_DIR=$(UPSTREAM_REPO_NAME)/ubuntu/noble/scm \
            IMAGE_BASE_NAME=buildpack-deps \
            DOCKER_ARGS="$(DOCKER_NOBLE_SCM_CONTEXT)"

DOCKER_NOBLE_CONTEXT = --build-context buildpack-deps:noble-scm=docker-image://$(CI_REGISTRY)/$(CI_REGISTRY_BASE_PATH)/$(ORGANIZATION_NAME)-buildpack-deps:noble-scm

NOBLE_ARGS = IMAGE_BUILD_DIR=$(UPSTREAM_REPO_NAME)/ubuntu/noble \
            IMAGE_BASE_NAME=buildpack-deps \
            DOCKER_ARGS="$(DOCKER_NOBLE_CONTEXT)"

build-noble-image:
	$(Q)$(MAKE) IMAGE_REV=noble-curl $(NOBLE_CURL_ARGS) build-upstream-image
	$(Q)$(MAKE) IMAGE_REV=noble-scm $(NOBLE_SCM_ARGS) build-upstream-image
	$(Q)$(MAKE) IMAGE_REV=24.04 $(NOBLE_ARGS) build-upstream-image

DOCKER_RESOLUTE_CURL_CONTEXT = --build-context ubuntu:resolute=docker-image://$(CI_REGISTRY)/$(CI_REGISTRY_BASE_PATH)/$(UBUNTU_IMAGE_NAME):26.04

RESOLUTE_CURL_ARGS = IMAGE_BUILD_DIR=$(UPSTREAM_REPO_NAME)/ubuntu/resolute/curl \
            IMAGE_BASE_NAME=buildpack-deps \
            DOCKER_ARGS="$(DOCKER_RESOLUTE_CURL_CONTEXT)"

DOCKER_RESOLUTE_SCM_CONTEXT = --build-context buildpack-deps:resolute-curl=docker-image://$(CI_REGISTRY)/$(CI_REGISTRY_BASE_PATH)/$(ORGANIZATION_NAME)-buildpack-deps:resolute-curl

RESOLUTE_SCM_ARGS = IMAGE_BUILD_DIR=$(UPSTREAM_REPO_NAME)/ubuntu/resolute/scm \
            IMAGE_BASE_NAME=buildpack-deps \
            DOCKER_ARGS="$(DOCKER_RESOLUTE_SCM_CONTEXT)"

DOCKER_RESOLUTE_CONTEXT = --build-context buildpack-deps:resolute-scm=docker-image://$(CI_REGISTRY)/$(CI_REGISTRY_BASE_PATH)/$(ORGANIZATION_NAME)-buildpack-deps:resolute-scm

RESOLUTE_ARGS = IMAGE_BUILD_DIR=$(UPSTREAM_REPO_NAME)/ubuntu/resolute \
            IMAGE_BASE_NAME=buildpack-deps \
            DOCKER_ARGS="$(DOCKER_RESOLUTE_CONTEXT)"

build-resolute-image:
	$(Q)$(MAKE) IMAGE_REV=resolute-curl $(RESOLUTE_CURL_ARGS) build-upstream-image
	$(Q)$(MAKE) IMAGE_REV=resolute-scm $(RESOLUTE_SCM_ARGS) build-upstream-image
	$(Q)$(MAKE) IMAGE_REV=26.04 $(RESOLUTE_ARGS) build-upstream-image

.PHONY: build-images build-images-internal \
        build-noble-image build-resolute-image

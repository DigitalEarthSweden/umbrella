IMAGE_VAR = $(CI_REGISTRY)/$(CI_REGISTRY_BASE_PATH)/datacube-ows

IMAGE_BUILD_DIR = ../..

DOCKER_ARGS += --build-arg BASE_IMAGE=$(CI_REGISTRY)/$(CI_REGISTRY_UPSTREAM_BASE_PATH)/$(ORGANIZATION_NAME)-datacube-ows:1.9.15
DOCKER_ARGS += --build-arg CONFIG_DIR=org-config/$(ORGANIZATION_NAME)
DOCKER_ARGS += $(DOCKER_EXTRA_ARGS)

DOCKERFILE = packages/datacube-ows/Dockerfile
DOCKER_TAGS = $(IMAGE_VAR):latest
LOCAL_IMAGE = 1

build-images: build-upstream-image
	$(Q)$(MAKE) IMAGE_VAR=$(IMAGE_VAR) IMAGE_REV=latest sign-image

include ../../common/Makefile

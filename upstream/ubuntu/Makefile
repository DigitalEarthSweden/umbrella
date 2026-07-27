MAKEFILE_DIR := $(patsubst %/,%,$(dir $(lastword $(MAKEFILE_LIST))))

include ../../common/Makefile

build-images: build-2404-image build-2604-image

build-2404-image:
	$(Q)$(MAKE) IMAGE_REV=24.04 DOCKER_ARGS="--build-arg UBUNTU_VERSION=24.04" IMAGE_BUILD_DIR=. IMAGE_BASE_NAME=ubuntu build-upstream-image

build-2604-image:
	$(Q)$(MAKE) IMAGE_REV=26.04 DOCKER_ARGS="--build-arg UBUNTU_VERSION=26.04" IMAGE_BUILD_DIR=. IMAGE_BASE_NAME=ubuntu build-upstream-image

.PHONY: build-images build-2404-image build-2604-image

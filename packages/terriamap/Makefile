IMAGE_VAR = $(CI_REGISTRY)/$(CI_REGISTRY_BASE_PATH)/terriamap

IMAGE_BUILD_DIR = TerriaMap

DOCKER_ARGS += --target deploy
DOCKER_ARGS += --build-context node:20=docker-image://$(CI_REGISTRY)/$(CI_REGISTRY_UPSTREAM_BASE_PATH)/$(ORGANIZATION_NAME)-node:24
DOCKER_ARGS += --build-context node:20-slim=docker-image://$(CI_REGISTRY)/$(CI_REGISTRY_UPSTREAM_BASE_PATH)/$(ORGANIZATION_NAME)-node:24-slim
DOCKER_ARGS += $(DOCKER_EXTRA_ARGS)

DOCKER_TAGS = $(IMAGE_VAR):latest
LOCAL_IMAGE = 1

BUILD_TIMEOUT = 25
EXTRA_BUILD_REPOSITORY = TerriaMap

build-images:
	$(Q)perl -pi -e 's#"--config-file", "serverconfig.json" \]#"--config-file", "serverconfig.json", "--proxy-auth", "proxyauth.json" \]#g' TerriaMap/Dockerfile
	$(Q)$(MAKE) build-images-internal

build-images-internal: build-upstream-image
	$(Q)$(MAKE) IMAGE_VAR=$(IMAGE_VAR) IMAGE_REV=latest sign-image

include ../../common/Makefile

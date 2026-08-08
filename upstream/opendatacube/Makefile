UPSTREAM_REPO_NAME = datacube-ows
UPSTREAM_BRANCH = 1.9.12
NO_CHECKOUT =
NO_SHALLOW =
NO_SPARSE = true

include ../../common/Makefile

build-images: build-explorer-image build-ows-image

DOCKER_EXPLORER_DEPS_CONTEXT = --build-context ghcr.io/osgeo/gdal:ubuntu-small-3.13.2@sha256:49b1b7a9779340ad66e7f87ea78ea632e923867df24e68c6d17f0079220e16b3=docker-image://$(CI_REGISTRY)/$(CI_REGISTRY_BASE_PATH)/$(ORGANIZATION_NAME)-gdal:ubuntu-small-3.13.2

EXPLORER_VERSION = 3.1.10

EXPLORER_ARGS = IMAGE_BASE_NAME=explorer \
            IMAGE_BUILD_DIR=datacube-explorer \
            DOCKER_ARGS="$(DOCKER_EXPLORER_DEPS_CONTEXT) --build-arg EXPLORER_VERSION=$(EXPLORER_VERSION)"

build-explorer-image:
	$(Q)$(MAKE) UPSTREAM_REPO_NAME=datacube-explorer UPSTREAM_BRANCH=$(EXPLORER_VERSION) UPSTREAM_REPO="https://github.com/opendatacube/datacube-explorer" datacube-explorer
	$(Q)$(MAKE) IMAGE_REV=$(EXPLORER_VERSION) $(EXPLORER_ARGS) build-upstream-image

DOCKER_OWS_DEPS_CONTEXT = --build-context ghcr.io/osgeo/gdal:ubuntu-small-3.13.1@sha256:836d1646ff9ab30d7db947c7b9690de55f34c2fd7cc5af6086a0854ccb378f59=docker-image://$(CI_REGISTRY)/$(CI_REGISTRY_BASE_PATH)/$(ORGANIZATION_NAME)-gdal:ubuntu-small-3.13.2

OWS_VERSION = 1.9.15

OWS_ARGS = IMAGE_BASE_NAME=datacube-ows \
            IMAGE_BUILD_DIR=datacube-ows \
            DOCKER_ARGS="$(DOCKER_OWS_DEPS_CONTEXT)"

build-ows-image:
	$(Q)$(MAKE) UPSTREAM_REPO_NAME=datacube-ows UPSTREAM_BRANCH=$(OWS_VERSION) UPSTREAM_REPO="https://github.com/opendatacube/datacube-ows" datacube-ows
	$(Q)perl -pi -e "s#uv sync #export SETUPTOOLS_SCM_PRETEND_VERSION=$(OWS_VERSION) && uv sync #g" datacube-ows/Dockerfile
	$(Q)$(MAKE) IMAGE_REV=$(OWS_VERSION) $(OWS_ARGS) build-upstream-image

.PHONY: build-images \
        build-explorer-image build-ows-image

MAKEFILE_DIR := $(patsubst %/,%,$(dir $(lastword $(MAKEFILE_LIST))))

UPSTREAM_REPO = https://github.com/postgis/docker-postgis
UPSTREAM_REPO_NAME = docker-postgis
UPSTREAM_BRANCH = master

POSTGIS_18_DIR = 18-3.6
UPSTREAM_DIRS = $(POSTGIS_18_DIR)

include ../../common/Makefile

build-images: $(UPSTREAM_REPO_NAME)
	$(Q)$(MAKE) build-images-internal

build-images-internal: build-big-18-image

DOCKER_POSTGRES_18_CONTEXT = --build-context docker.io/postgres:18-trixie=docker-image://$(CI_REGISTRY)/$(CI_REGISTRY_BASE_PATH)/$(ORGANIZATION_NAME)-postgres:18-bookworm

BIG_18_ARGS = IMAGE_BUILD_DIR=$(UPSTREAM_REPO_NAME)/$(POSTGIS_18_DIR) \
            IMAGE_BASE_NAME=postgis \
            DOCKER_ARGS="$(DOCKER_BUILDPACK_DEPS_CONTEXT) $(DOCKER_POSTGRES_18_CONTEXT)"

build-big-18-image:
	$(Q)perl -pi -e 's#apt-get update #apt-get update && apt-get -y upgrade#g' $(UPSTREAM_REPO_NAME)/$(POSTGIS_18_DIR)/Dockerfile
	$(Q)perl -pi -e 's#\.pgdg13\+1#\.pgdg24\.04\+1#g' $(UPSTREAM_REPO_NAME)/$(POSTGIS_18_DIR)/Dockerfile
	$(Q)perl -pi -e 's#POSTGIS_VERSION=([0-9]+)\.([0-9\-]+)\.([0-9]+)\+dfsg-([0-9]+)#POSTGIS_VERSION=\1\.\2\.4\+dfsg-\4#g' $(UPSTREAM_REPO_NAME)/$(POSTGIS_18_DIR)/Dockerfile
	$(Q)perl -pi -e 's#ca-certificates #ca-certificates pgstat pgtop #g' $(UPSTREAM_REPO_NAME)/$(POSTGIS_18_DIR)/Dockerfile
	$(Q)$(MAKE) IMAGE_REV=$(POSTGIS_18_DIR) $(BIG_18_ARGS) build-upstream-image

.PHONY: build-images build-images-internal \
        build-big-18-image

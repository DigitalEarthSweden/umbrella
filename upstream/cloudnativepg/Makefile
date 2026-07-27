MAKEFILE_DIR := $(patsubst %/,%,$(dir $(lastword $(MAKEFILE_LIST))))

UPSTREAM_REPO = https://github.com/cloudnative-pg/postgres-containers
UPSTREAM_REPO_NAME = postgres-containers
NO_CHECKOUT =
NO_SHALLOW =
NO_SPARSE = true

# FIXME: remove this when UBUNTU_VER in common/Makefile is 26.04.
UBUNTU_VER = 26.04

include ../../common/Makefile

build-images: build-postgres-18-image

POSTGRES_18_VER = 18.4
POSTGRES_18_MAJOR = 18

POSTGRES_18_BASE_ARG = --build-arg BASE=$(CI_REGISTRY)/$(CI_REGISTRY_BASE_PATH)/$(UBUNTU_IMAGE_NAME):$(UBUNTU_VER)
POSTGRES_18_EXT_ARG = --build-arg EXTENSIONS='postgresql-18-pgaudit postgresql-18-pgvector postgresql-18-pg-failover-slots pgstat pgtop'
POSTGRES_18_VER_ARGS = --build-arg PG_VERSION=$(POSTGRES_18_VER) --build-arg PG_MAJOR=$(POSTGRES_18_MAJOR)
POSTGRES_18_ARGS = IMAGE_BUILD_DIR=$(UPSTREAM_REPO_NAME) \
            IMAGE_BASE_NAME=cloudnativepg-postgres \
            DOCKER_ARGS=" $(POSTGRES_18_VER_ARGS) $(POSTGRES_18_EXT_ARG) --target standard $(POSTGRES_18_BASE_ARG)"

build-postgres-18-image: SHELL = /bin/bash
build-postgres-18-image: $(UPSTREAM_REPO_NAME)
	$(Q)(cd $(UPSTREAM_REPO_NAME) && [[ "$$(grep "$(POSTGRES_18_MAJOR)\." docker-bake.hcl)" =~ "$(POSTGRES_18_VER)" ]]) || \
        (echo "Update POSTGRES_18_MAJOR" && exit 1)
	$(Q)$(MAKE) IMAGE_REV=$(POSTGRES_18_MAJOR) $(POSTGRES_18_ARGS) build-upstream-image

.PHONY: build-images \
        build-postgres-18-image

MAKEFILE_DIR := $(patsubst %/,%,$(dir $(lastword $(MAKEFILE_LIST))))

UPSTREAM_BASE_REPO = https://github.com/davidfrantz/base_image
UPSTREAM_BASE_REPO_NAME = base_image
UPSTREAM_REPO = https://github.com/pjonsson/force
UPSTREAM_REPO_NAME = force
UPSTREAM_BRANCH=docker-install-build-deps
NO_CHECKOUT =
NO_SHALLOW =
NO_SPARSE = true

include ../../common/Makefile

build-images: build-31005-image

GDAL_CURRENT_VERSION = 3.13.0

BASE_10_DEPS_CONTEXT = --build-context ghcr.io/osgeo/gdal:ubuntu-small-3.13.0@sha256:e0fedbcc5b51bd12617d6a6cf8b7c3244d98cbd29b266925fd9061f40081b351=docker-image://$(CI_REGISTRY)/$(CI_REGISTRY_BASE_PATH)/$(ORGANIZATION_NAME)-gdal:ubuntu-small-$(GDAL_CURRENT_VERSION)

BASE_10_ARGS = IMAGE_BUILD_DIR=$(UPSTREAM_BASE_REPO_NAME) \
            DOCKER_ARGS="$(BASE_10_DEPS_CONTEXT)"

FORCE_31005_DEPS_CONTEXT = --build-context davidfrantz/base:latest=docker-image://$(CI_REGISTRY)/$(CI_REGISTRY_BASE_PATH)/$(ORGANIZATION_NAME)-base_image:1.0

FORCE_31005_ARGS = IMAGE_BUILD_DIR=$(UPSTREAM_REPO_NAME) \
            DOCKER_ARGS="$(FORCE_31005_DEPS_CONTEXT)"

# FIXME: no 3.10.05 release, so this rule builds 3.10.04-dev for now.
build-31005-image: $(UPSTREAM_REPO_NAME)
	$(Q)$(MAKE) UPSTREAM_REPO_NAME=$(UPSTREAM_BASE_REPO_NAME) UPSTREAM_BRANCH=reproducible-build UPSTREAM_REPO=https://github.com/pjonsson/base_image $(UPSTREAM_BASE_REPO_NAME)
	$(Q)$(MAKE) IMAGE_REV=1.0 IMAGE_BASE_NAME=$(UPSTREAM_BASE_REPO_NAME) $(BASE_10_ARGS) build-upstream-image
	$(Q)cd $(UPSTREAM_REPO_NAME) && patch -p1 < ../force_lto.patch
	$(Q)perl -pi -e 's#^CFLAGS=#CFLAGS=-fpermissive #g' $(UPSTREAM_REPO_NAME)/Makefile
	$(Q)perl -pi -e 's|#include <numpy/ndarrayobject.h>|#define NPY_NO_DEPRECATED_API NPY_1_7_API_VERSION\n#include <numpy/ndarrayobject.h>\n#include <numpy/npy_2_compat.h>|' $(UPSTREAM_REPO_NAME)/src/modules/higher-level/py-udf-hl.c
	$(Q)perl -pi -e 's#pylab\.desc_sensor->elsize = NPOW_10#PyDataType_SET_ELSIZE(pylab.desc_sensor, NPOW_10)#g'  $(UPSTREAM_REPO_NAME)/src/modules/higher-level/py-udf-hl.c
	$(Q)perl -pi -e 's#pylab\.desc_bandname->elsize = NPOW_10#PyDataType_SET_ELSIZE(pylab.desc_bandname, NPOW_10)#g' $(UPSTREAM_REPO_NAME)/src/modules/higher-level/py-udf-hl.c
	$(Q)$(MAKE) IMAGE_REV=3.10.04-dev IMAGE_BASE_NAME=$(UPSTREAM_REPO_NAME) $(FORCE_31005_ARGS) build-upstream-image

.PHONY: build-images \
        build-31005-image

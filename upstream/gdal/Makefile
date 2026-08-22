MAKEFILE_DIR := $(patsubst %/,%,$(dir $(lastword $(MAKEFILE_LIST))))

UPSTREAM_REPO = https://github.com/OSGeo/gdal
UPSTREAM_REPO_NAME = gdal

# Includes time for building all dependencies.
BUILD_TIMEOUT = 75

include ../../common/Makefile

build-images: build-3130-image build-3133-image

build-3130-image:
	$(Q)$(MAKE) UPSTREAM_REPO_NAME=gdal-3130 UPSTREAM_BRANCH=v3.13.0 UPSTREAM_DIRS=docker UPSTREAM_REPO="--branch v3.13.0 $(UPSTREAM_REPO) gdal-3130" gdal-3130
	$(Q)perl -pi -e "s| apt-get update -y| perl -pi -e 's#//archive\\\\.ubuntu\\\\.com#//mirror.bahnhof.net#g' /etc/apt/sources.list.d/ubuntu.sources && apt-get update -y|g" gdal-3130/docker/ubuntu-*/Dockerfile
	$(Q)$(MAKE) build-3130-image-internal

# Used by FORCE for version 1 of $(ORGANIZATION_NAME)_s2_msi_l2a.
build-3130-image-internal: build-slim-3130-image

SLIM_3130_ARGS = IMAGE_BUILD_DIR=gdal-3130/docker \
             IMAGE_BASE_NAME=gdal \
             DOCKER_ARGS="--release --gdal v3.13.0 --proj 9.8.1"

# Add NETCDF support to small image since Sentinel-3 requires that.
# WARNING: this triggers build of the FORCE image.
build-slim-3130-image:
	$(Q)perl -p -i -e 's#sqlite3 bash-completion#sqlite3 libnetcdf-dev\$$\{APT_ARCH_SUFFIX\} libnetcdf-c\+\+4-1 netcdf-bin bash-completion#' gdal-3130/docker/ubuntu-small/Dockerfile
	$(Q)perl -p -i -e 's#libxerces-c3.2 #libxerces-c3.2 libaec0 libnetcdf-c\+\+4-1 netcdf-bin #' gdal-3130/docker/ubuntu-small/Dockerfile
	$(Q)$(MAKE) IMAGE_REV_PREFIX=ubuntu-small IMAGE_REV=3.13.0 $(SLIM_3130_ARGS) build-gdal-upstream-image
	$(Q)$(MAKE) -C ../force build-images

build-3133-image:
	$(Q)$(MAKE) UPSTREAM_REPO_NAME=gdal-3133 UPSTREAM_BRANCH=v3.13.3 UPSTREAM_DIRS=docker UPSTREAM_REPO="--branch v3.13.3 $(UPSTREAM_REPO) gdal-3133" gdal-3133
	$(Q)perl -pi -e "s| apt-get update -y| perl -pi -e 's#//archive\\\\.ubuntu\\\\.com#//mirror.bahnhof.net#g' /etc/apt/sources.list.d/ubuntu.sources && apt-get update -y|g" gdal-3133/docker/ubuntu-*/Dockerfile
	$(Q)$(MAKE) build-3133-image-internal

build-3133-image-internal: build-slim-3133-image

SLIM_3133_ARGS = IMAGE_BUILD_DIR=gdal-3133/docker \
             IMAGE_BASE_NAME=gdal \
             DOCKER_ARGS="--release --gdal v3.13.3 --proj 9.8.1"

# Add NETCDF support to small image since Sentinel-3 requires that.
# Add us_nga_egm08_25 since our DEM stitching tools require that.
# WARNING: this triggers build of the opendatacube images.
build-slim-3133-image:
	$(Q)perl -p -i -e 's#sqlite3 bash-completion#sqlite3 libnetcdf-dev\$$\{APT_ARCH_SUFFIX\} libnetcdf-c\+\+4-1 netcdf-bin bash-completion#' gdal-3133/docker/ubuntu-small/Dockerfile
	$(Q)perl -p -i -e 's#libxerces-c3.2 #libxerces-c3.2 libaec0 libnetcdf-c\+\+4-1 netcdf-bin #' gdal-3133/docker/ubuntu-small/Dockerfile
	$(Q)perl -p -i -e 's#&& rm -rf proj #&& /build\$$\{PROJ_INSTALL_PREFIX\}/bin/projsync --file us_nga_egm08_25.tif --target-dir /build\$$\{PROJ_INSTALL_PREFIX\}/share/proj && rm -rf proj #' gdal-3133/docker/ubuntu-small/Dockerfile
	$(Q)$(MAKE) IMAGE_REV_PREFIX=ubuntu-small IMAGE_REV=3.13.3 $(SLIM_3133_ARGS) build-gdal-upstream-image
	$(Q)$(MAKE) -C ../opendatacube build-images

.PHONY: build-images \
  build-3130-image build-3130-image-internal build-slim-3130-image \
  build-3133-image build-3133-image-internal build-slim-3133-image

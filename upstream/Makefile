# Give an error message when using an old version of GNU Make.
MAKE_MAJOR_VERSION := $(word 1,$(subst ., ,$(MAKE_VERSION)))
ifeq ($(shell test $(MAKE_MAJOR_VERSION) -lt 4; echo $$?),0)
  $(error GNU Make version 4.0 or newer is required)
endif

# Only use rules/variables from the Makefiles. This eliminates a lot
# of attempted matches from the implicit rules for SCCS.
MAKEFLAGS += --no-builtin-variables

# Run "make Q='' <target>" to get commands echoed.
Q ?= @

# PostGIS builds Postgres, and opendatacube builds gdal.
# Sort directories so gdal will build as early as possible,
# and FORCE will build as late as possible. Directories between the two
# are sorted alphabetically.
DIRS = opendatacube cloudnativepg node postgis valkey force

IMAGE_TARGETS = $(addsuffix /build-images, $(DIRS))

TARGETS = $(IMAGE_TARGETS)

all: $(TARGETS)

$(TARGETS): FORCE
	$(Q)$(MAKE) -Orecurse -C $(dir $@) $(notdir $@)

REGCTL_CMD = regctl
REGCTL = $(REGCTL_CMD) $(REGCTL_PARAMS)

# Authentication expected through DOCKER_AUTH_CONFIG, so list some tags to
# detect authentication issues before doing anything important.
registry-test-login:
	$(Q)$(REGCTL_CMD) tag ls $(CI_REGISTRY)/$(CI_REGISTRY_BASE_PATH)/support-releaser -v error > /dev/null

# Set this to something to avoid empty rule names.
UPSTREAM_IMAGES ?= upstream-images-not-defined

# Mangle : to get a valid rule name.
DELIMIT := __@__
UPSTREAM_IMAGES_TMP := $(subst :,$(DELIMIT),$(UPSTREAM_IMAGES))

ifdef COMMIT_SHORT_SHA
ifndef PIPELINE_TIME
  # Lexically sortable, monotonically increasing.
  PIPELINE_TIME := $(shell date +"%Y%m%d%H%M%S")
endif

$(UPSTREAM_IMAGES_TMP): PROD_TAG = prod-$(PIPELINE_TIME)-$(COMMIT_SHORT_SHA)
endif
$(UPSTREAM_IMAGES_TMP):
	$(eval _exlist := $(subst $(DELIMIT), ,$@))
	$(eval IMAGE := $(firstword $(_exlist)))
	$(eval TAG := $(lastword $(_exlist)))
	$(Q)$(REGCTL) image copy --referrers $(CI_REGISTRY)/$(CI_REGISTRY_UPSTREAM_PATH)/$(IMAGE):$(TAG) $(CI_REGISTRY)/$(CI_REGISTRY_BASE_PATH)/$(IMAGE):$(PROD_TAG)
	$(Q)$(REGCTL) image copy --referrers $(CI_REGISTRY)/$(CI_REGISTRY_BASE_PATH)/$(IMAGE):$(PROD_TAG) $(CI_REGISTRY)/$(CI_REGISTRY_BASE_PATH)/$(IMAGE):latest

upstream-transfer: SHELL = /bin/bash
upstream-transfer: registry-test-login
	$(Q)[ "$(UPSTREAM_IMAGES)" != "upstream-images-not-defined" ] || (echo "UPSTREAM_IMAGES not defined" && exit 1)
	$(Q)$(MAKE) $(UPSTREAM_IMAGES_TMP)

# Rule to force rebuilds
.PHONY: FORCE
FORCE:

.PHONY: all

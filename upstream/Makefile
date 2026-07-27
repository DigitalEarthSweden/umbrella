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

# Rule to force rebuilds
.PHONY: FORCE
FORCE:

.PHONY: all

# syntax=docker/dockerfile:1.29.0@sha256:572cebbc2b15e6f84c077742952674889cb63cd5e9b80abdffcbe587b6f19183
# check=skip=InvalidDefaultArgInFrom

# Docker 29 only permits disabling warnings globally, and it must happen on the first
# lines after the syntax line.
#
# We want this file to fail building without argument.
ARG BUILDKIT_SBOM_SCAN_CONTEXT=true

ARG BASE_IMAGE
FROM $BASE_IMAGE

ARG CONFIG_DIR
# The overlay mirrors /app: it adds or replaces files, never deletes upstream ones.
COPY --link --chown=1000:1000 $CONFIG_DIR/packages/terriamap/wwwroot/ /app/wwwroot/
COPY --link --chown=1000:1000 $CONFIG_DIR/packages/terriamap/serverconfig.json /app/serverconfig.json

# syntax=docker/dockerfile:1.27.1@sha256:4edf897a3ffa55b89f906fc8cc78afdb3f1834cc9c7083565e611a8a7d5fe99e
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

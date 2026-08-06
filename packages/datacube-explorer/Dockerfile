# syntax=docker/dockerfile:1@sha256:87999aa3d42bdc6bea60565083ee17e86d1f3339802f543c0d03998580f9cb89
# check=skip=InvalidDefaultArgInFrom

# Docker 29 only permits disabling warnings globally, and it must happen on the first
# lines after the syntax line.
#
# We want this file to fail building without argument.
ARG BUILDKIT_SBOM_SCAN_CONTEXT=true

ARG BASE_IMAGE
FROM $BASE_IMAGE

# Permit colon in bucket names (some verisons of Ceph permits this).
RUN sed -i '/^VALID_BUCKET/c\VALID_BUCKET = re.compile(r"^[a-zA-Z0-9.\\-_:]{1,255}$")' /app/lib/python3.*/site-packages/botocore/handlers.py

ARG CONFIG_DIR
COPY --link $CONFIG_DIR/packages/datacube-explorer/settings.env.py /app/lib/python3.14/site-packages/settings.env.py

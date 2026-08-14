# syntax=docker/dockerfile:1.26.0@sha256:ecfaec9ed6d810b56388c508f4121597bfbba70d41a6dfeee4d8cad5f295fc32
# check=skip=InvalidDefaultArgInFrom

# Docker 29 only permits disabling warnings globally, and it must happen on the first
# lines after the syntax line.
#
# We want this file to fail building without argument.
ARG BUILDKIT_SBOM_SCAN_CONTEXT=true

ARG BASE_IMAGE
FROM $BASE_IMAGE

ARG CONFIG_DIR
COPY --link --chown=1000:1000 $CONFIG_DIR/packages/datacube-ows/config/ /config/

# Permit colon in bucket names (some verisons of Ceph permits this).
RUN sed -i '/^VALID_BUCKET/c\VALID_BUCKET = re.compile(r"^[a-zA-Z0-9.\\-_:]{1,255}$")' /app/lib/python3.*/site-packages/botocore/handlers.py

USER root

COPY --link packages/datacube-ows/numpy_log_errors.patch /root/

RUN --mount=type=cache,target=/var/cache/apt,sharing=locked \
    --mount=type=cache,target=/var/lib/apt,sharing=locked \
    export DEBIAN_FRONTEND=noninteractive && \
    apt-get -qq update && \
    apt-get -qq -y --no-install-recommends install patch > /dev/null && \
    cd /app/lib/python3.14/site-packages && \
    patch -p1 < /root/numpy_log_errors.patch && \
    rm /root/numpy_log_errors.patch && \
    apt-get purge -y patch

USER ubuntu

ENV                     MPLCONFIGDIR=/tmp

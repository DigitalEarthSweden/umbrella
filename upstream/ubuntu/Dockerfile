# syntax=docker/dockerfile:1.25.0@sha256:0adf442eae370b6087e08edc7c50b552d80ddf261576f4ebd6421006b2461f12
# check=skip=InvalidDefaultArgInFrom

# Docker 29 only permits disabling warnings globally, and it must happen on the first
# lines after the syntax line.
#
# We want this file to fail building without argument.
ARG BUILDKIT_SBOM_SCAN_CONTEXT=true
ARG UBUNTU_VERSION
FROM ubuntu:$UBUNTU_VERSION
ARG UBUNTU_VERSION
LABEL org.opencontainers.image.ref.name="$(ORGANIZATION_NAME)-ubuntu"
LABEL org.opencontainers.image.version=$UBUNTU_VERSION
RUN export DEBIAN_FRONTEND=noninteractive && \
    perl -pi -e 's#//archive\.ubuntu\.com#//mirror.bahnhof.net#g' /etc/apt/sources.list /etc/apt/sources.list.d/ubuntu.sources && \
    echo 'Acquire::Retries "10";' > /etc/apt/apt.conf.d/80-retries && \
    apt-get update && \
    apt-get -qq -y upgrade  && \
    apt-get autoclean && \
    rm -rf /var/lib/apt/lists/*
CMD ["/bin/bash"]

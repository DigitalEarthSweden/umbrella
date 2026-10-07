# syntax=docker/dockerfile:1.27.1@sha256:4edf897a3ffa55b89f906fc8cc78afdb3f1834cc9c7083565e611a8a7d5fe99e
# check=skip=InvalidDefaultArgInFrom

# Docker 29 only permits disabling warnings globally, and it must happen on the first
# lines after the syntax line.
#
# We want this file to fail building without argument.
ARG BUILDKIT_SBOM_SCAN_CONTEXT=true
ARG UBUNTU_VERSION
FROM ubuntu:$UBUNTU_VERSION
ARG UBUNTU_VERSION
ARG ORGANIZATION_NAME
LABEL org.opencontainers.image.ref.name="$ORGANIZATION_NAME-ubuntu"
LABEL org.opencontainers.image.version=$UBUNTU_VERSION
RUN rm -f /usr/bin/pebble && rm -rf /var/lib/pebble && \
    export DEBIAN_FRONTEND=noninteractive && \
    perl -pi -e 's#//archive\.ubuntu\.com#//mirror.bahnhof.net#g' /etc/apt/sources.list /etc/apt/sources.list.d/ubuntu.sources && \
    echo 'Acquire::Retries "10";' > /etc/apt/apt.conf.d/80-retries && \
    apt-get update && \
    apt-get -qq -y upgrade  && \
    apt-get autoclean && \
    rm -rf /var/lib/apt/lists/*
CMD ["/bin/bash"]

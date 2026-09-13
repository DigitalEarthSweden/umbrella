# The non-secret parts of the environment configuration used by the CI.
# Sourced by developers that want to reproduce a build.
# Comments must start at column 1, everything else goes into the environment.
export CI_REGISTRY=harbor.digitalearth.se
export CI_REGISTRY_BASE_PATH=des-images
export CI_REGISTRY_UPSTREAM_BASE_PATH=des-upstream
export ORGANIZATION_NAME=des
export UPSTREAM_IMAGES="des-cloudnative-pg:1.30.0 des-cloudnativepg-pgbouncer:1 des-cloudnativepg-postgres:18 des-cloudnativepg-postgis:3 des-postgres:18-bookworm des-postgis:18-3.6 des-valkey:9.1"

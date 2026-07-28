# Monorepo

This repository currently builds and signs lightly modified upstream-images.

The largest change is that everything is based on Ubuntu, and there is
an `apt-get update && apt-get upgrade` added to the build so the latest
security updates from Ubuntu are installed. This shortens the build time for
images based on these in a typical CI-run since they don't need to install
that many packages with security updates.

The built images are pushed to a private registry and signed with cosign.

If you want to use this repository to push to your own registry, you should
be able to clone the repository and follow the configuration steps described
below.

# Repository Configuration

## Building Patched Upstream Images

Add an environment `upstream-build` in `Settings->Environments`, and set
the following environment variables:

- `CI_REGISTRY`: name of CI registry to push images to, for example`ghcr.io`.
- `CI_REGISTRY_BASE_PATH`: directory (~staging area) that `UPSTREAM_IMAGES` are transferred to, we use `$ORGANIZATION_NAME-images`
- `CI_REGISTRY_READ_USER`: Username to pull `$CI_REGISTRY/$CI_REGISTRY_BASE_PATH/support-releaser`
- `CI_REGISTRY_UPSTREAM_BASE_PATH`: directory where upstream images are pushed to, we use `$ORGANIZATION_NAME-upstream`
- `ORGANIZATION_NAME`: images are named `$ORGANIZATION_NAME-$IMAGE_NAME`, so set this to the short name of your organization
- `UPSTREAM_IMAGES`: space-separated list of upstream image names to be transferred to `$CI_REGISTRY_BASE_PATH` after being built

Also configure the following secrets in the `upstream-build` environment:

- `CI_REGISTRY_READ_USER_PASSWORD`: Password for `CI_REGISTRY_READ_USER`
- `DOCKER_AUTH_CONFIG_RW`: This is a `DOCKER_AUTH_CONFIG` with credentials that are allowed to push to `$CI_REGISTRY/$CI_REGISTRY_BASE_PATH`
- `DOCKER_AUTH_CONFIG_UPSTREAM_RW`: This is a `DOCKER_AUTH_CONFIG` with credentials that are allowed to push to `$CI_REGISTRY/$CI_REGISTRY_UPSTREAM_BASE_PATH`

# Miscellaneous Information

## Creating a `DOCKER_AUTH_CONFIG`

Base64-encode your username and password with a colon between them:

```shell
printf 'username:password' | base64
# This gives the output: dXNlcm5hbWU6cGFzc3dvcmQ=
```

and put that into this JSON blob:

```json
{
  "auths": {
    "my-registry.somewhere.com": {
      "auth": "dXNlcm5hbWU6cGFzc3dvcmQ="
    }
  }
}
```

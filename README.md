# clang-format

## Quick Run

```bash
cd your/source/tree
podman run --rm -v "${PWD}"/src ghcr.io/cwpearson/clang-format-16:latest clang-format ...
```

Inside the container, the working directory is /src, we use the volume mount to map the host working directory `${PWD}` into `/src`: `-v "${PWD}"/src`.

## Building the Image Locally

```bash
podman build -f clang-format-16.dockerfile -t clang-format-16:latest
podman build -f clang-format-8.dockerfile -t clang-format-8:latest
```

## Deploy

1. Create a "personal access token (classic)" with `write:packages`
  * account > settings > developer settings > personal access tokens
2. Put that personal access token as the repository secret `GHCR_TOKEN`.

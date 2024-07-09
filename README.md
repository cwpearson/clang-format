# 

```bash
podman build -f clang-format-16.dockerfile -t clang-format-16:latest
podman build -f clang-format-8.dockerfile -t clang-format-8:latest
```

## Deploy

1. Create a "personal access token (classic)" with `write:packages`
  * account > settings > developer settings > personal access tokens
2. Put that personal access token as the repository secret `GHCR_TOKEN`.

### Image build

```
mkdir -p build
export TMPDIR=$(pwd)/build

VERSION=2.0.0

podman build \
  --build-arg VERSION=$VERSION \
  -f Dockerfile \
  -t ghcr.io/randomcoww/kea:$VERSION
```

```
podman push ghcr.io/randomcoww/kea:$VERSION
```
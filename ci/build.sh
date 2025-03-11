#!/bin/bash
# -------------------------------------------
# Build linux packages
# -------------------------------------------
set -e

# clean dist
if [ -d dist ]; then
    rm -rf dist
fi

mkdir -p dist

if [ $# -gt 0 ]; then
    export SEMVER="$1"
fi

if [ -n "$SEMVER" ]; then
    echo "Using version: $SEMVER"
fi

packages=(
    deb
    apk
    rpm
)

for package_type in "${packages[@]}"; do
    echo ""
    if command -V nfpm >/dev/null >&2; then
        nfpm package --packager "$package_type" --target ./dist/
    else
        docker run --rm -v "$PWD:/tmp" -w /tmp goreleaser/nfpm package \
            --target /tmp/dist/ \
            --packager "$package_type"
    fi
done

echo "Created all linux packages"
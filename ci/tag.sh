#!/bin/sh
set -e
bump="${1:-patch}"

CURRENT_VERSION=$(git describe --tags --abbrev=0)

case "$bump" in
    patch)
        NEXT_VERSION=$(echo "$CURRENT_VERSION" | awk -F. '{$NF+=1; OFS="."; print $1"."$2"."($3 + 1)}')
        ;;
    minor)
        NEXT_VERSION=$(echo "$CURRENT_VERSION" | awk -F. '{$NF+=1; OFS="."; print $1"."($2 + 1)"."$3}')
        ;;
    major)
        NEXT_VERSION=$(echo "$CURRENT_VERSION" | awk -F. '{$NF+=1; OFS="."; print ($1 + 1)"."$2"."$3}')
        ;;
esac

if [ -z "$NEXT_VERSION" ]; then
    echo "invalid version bump. something unexpected went wrong" >&2
    exit 1
fi

git config --global user.email "info@thin-edge.io"
git config --global user.name "Versioneer"
echo "Creating tag: $NEXT_VERSION" >&2
git tag -a "$NEXT_VERSION" -m "Release $NEXT_VERSION"
git push origin "$NEXT_VERSION"

# return next version
echo "$NEXT_VERSION"
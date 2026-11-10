#!/usr/bin/env bash
# Update packages/docker-desktop/default.nix to the latest Docker Desktop
# release. Reads the official Sparkle appcast for the current version and
# build, then re-prefetches the dmg hash. Requires curl, jq and nix on PATH.
set -euo pipefail

here="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
pkg="$here/default.nix"

appcast=$(curl -fsSL "https://desktop.docker.com/mac/main/arm64/appcast.xml")
version=$(printf '%s' "$appcast" | sed -n 's/.*<title>Version \([0-9.]*\) ([0-9]*).*/\1/p' | head -1)
url=$(printf '%s' "$appcast" | sed -n 's/.*enclosure url="\([^"]*\)".*/\1/p' | head -1)

if [ -z "$version" ] || [ -z "$url" ]; then
  echo "could not parse appcast" >&2
  exit 1
fi

echo "latest Docker Desktop: $version ($url)"

hash=$(nix store prefetch-file --json "$url" | jq -r .hash)

# BSD sed (macOS) requires an explicit empty backup suffix for -i.
sed -i '' \
  -e "s|version = \"[^\"]*\";|version = \"$version\";|" \
  -e "s|https://desktop.docker.com/mac/main/arm64/[0-9]*/Docker.dmg|$url|" \
  -e "s|hash = \"sha256-[^\"]*\";|hash = \"$hash\";|" \
  "$pkg"

echo "updated $pkg -> $version"

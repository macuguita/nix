#!/usr/bin/env bash
# updater.sh — updates ryujinx-canary version, source hash, and deps.json
set -euo pipefail
cd "$(dirname "${BASH_SOURCE[0]}")"

# Make sure jq, curl, nix-prefetch-url, and update-source-version are available
NEEDED_TOOLS=(jq curl nix-prefetch-url update-source-version)
for tool in "${NEEDED_TOOLS[@]}"; do
  if ! command -v "$tool" &>/dev/null; then
    echo "missing required tool: $tool (try: nix shell nixpkgs#jq nixpkgs#curl nixpkgs#common-updater-scripts)" >&2
    exit 1
  fi
done

# If NEW_VERSION is not set, fetch the latest canary version
if [ -z "${NEW_VERSION+x}" ]; then
    RELEASE_DATA=$(curl -s "https://git.ryujinx.app/api/v1/repos/projects/Ryubing/tags")
    if [ -z "$RELEASE_DATA" ] || [[ $RELEASE_DATA =~ "imposed ratelimits" ]]; then
        echo "failed to get release job data" >&2
        exit 1
    fi
    NEW_VERSION_TAG=$(echo "$RELEASE_DATA" | jq -r '[.[] | select(.name | startswith("Canary"))][0].name')
    NEW_VERSION="${NEW_VERSION_TAG#Canary-}"
fi

OLD_VERSION="$(sed -nE 's/\s*version = "(.*)".*/\1/p' ./default.nix)"
echo "comparing versions $OLD_VERSION -> $NEW_VERSION"

if [[ "$OLD_VERSION" == "$NEW_VERSION" ]]; then
    echo "Already up to date!"
    if [[ "${1-default}" != "--deps-only" ]]; then
      exit 0
    fi
fi

if [[ "${1-default}" != "--deps-only" ]]; then
    URL="https://git.ryujinx.app/projects/Ryubing/archive/Canary-${NEW_VERSION}.tar.gz"
    SRI="$(nix-prefetch-url --unpack --type sha256 "$URL" 2>/dev/null | tail -n1 | xargs nix hash convert --hash-algo sha256 --to sri)"

    sed -i -E "s/version = \".*\";/version = \"${NEW_VERSION}\";/" ./default.nix
    sed -i -E "s|hash = \"sha256-.*\";|hash = \"${SRI}\";|" ./default.nix
fi

echo "building Nuget lockfile"

FETCH_DEPS_SCRIPT=$(nix build --impure --no-link --print-out-paths --expr '
  let
    flake = builtins.getFlake (toString ./../../..);
    pkgs = flake.inputs.nixpkgs.legacyPackages.${builtins.currentSystem};
  in (pkgs.callPackage ./default.nix { }).fetch-deps
')

echo "fetch-deps script: $FETCH_DEPS_SCRIPT"
"$FETCH_DEPS_SCRIPT" ./deps.json
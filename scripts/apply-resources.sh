#!/usr/bin/env bash
# Copies the OmaBrowse bundled resources into the Chromium source tree before
# a build. Run it alongside apply-branding.sh, after the patches are applied.
# Usage: apply-resources.sh <src-dir> [resources-dir]
set -euo pipefail

src=${1:?usage: apply-resources.sh <src-dir> [resources-dir]}
res=${2:-$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)/resources}

# Built-in !bangs list, referenced by components/resources/omabrowse_resources.grdp.
install -D -m 644 "$res/bangs.json" \
    "$src/components/search_engines/resources/omabrowse_bangs.json"

echo "resources applied to $src"

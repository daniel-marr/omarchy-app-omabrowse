#!/usr/bin/env bash
# Copies the OmaBrowse logo set into the Chromium source tree before a build.
# build.sh runs it after Helium's own resources, so the OmaBrowse files win.
# Usage: apply-branding.sh <src-dir> [branding-dir]
set -euo pipefail

src=${1:?usage: apply-branding.sh <src-dir> [branding-dir]}
brand=${2:-$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)/branding}
theme="$src/chrome/app/theme"

install_png() { install -m 644 "$brand/$1" "$2"; }

# Linux desktop and window icons.
linux="$theme/chromium/linux"
install_png omabrowse-24.png  "$linux/product_logo_24.png"
install_png omabrowse-48.png  "$linux/product_logo_48.png"
install_png omabrowse-64.png  "$linux/product_logo_64.png"
install_png omabrowse-128.png "$linux/product_logo_128.png"
install_png omabrowse-256.png "$linux/product_logo_256.png"
install -m 644 "$brand/omabrowse-32.xpm" "$linux/product_logo_32.xpm"

# Shared product logos.
shared="$theme/chromium"
install_png omabrowse-16.png  "$shared/product_logo_16.png"
install_png omabrowse-22.png  "$shared/product_logo_22_mono.png"
install_png omabrowse-24.png  "$shared/product_logo_24.png"
install_png omabrowse-48.png  "$shared/product_logo_48.png"
install_png omabrowse-64.png  "$shared/product_logo_64.png"
install_png omabrowse-128.png "$shared/product_logo_128.png"
install_png omabrowse-256.png "$shared/product_logo_256.png"

# In-browser logos at 100% and 200% scale.
install_png omabrowse-16.png "$theme/default_100_percent/chromium/product_logo_16.png"
install_png omabrowse-32.png "$theme/default_100_percent/chromium/product_logo_32.png"
install_png omabrowse-32.png "$theme/default_200_percent/chromium/product_logo_16.png"
install_png omabrowse-64.png "$theme/default_200_percent/chromium/product_logo_32.png"

# Vector logo, used by the profile picker.
install -m 644 "$brand/omabrowse.svg" "$theme/chromium/product_logo.svg"

# New tab page favicon (Helium's replace_resources.py installs its own first).
install_png omabrowse-favicon-ntp-16.png "$theme/default_100_percent/common/favicon_ntp.png"
install_png omabrowse-favicon-ntp-32.png "$theme/default_200_percent/common/favicon_ntp.png"

echo "branding applied to $src"

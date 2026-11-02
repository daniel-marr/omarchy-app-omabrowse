#!/usr/bin/env bash
# Installs the OmaBrowse build for the current user only (no root needed).
# Side by side with stock Helium: own install dir, own launcher, own desktop
# entry, and its own default profile (~/.config/net.imput.omabrowse).
# Usage: install-local.sh [build-out-dir]
set -euo pipefail

out=${1:-/home/dan/omabrowse-build/src/out/Default}
prefix="$HOME/.local/opt/omabrowse"
bin_dir="$HOME/.local/bin"
apps_dir="$HOME/.local/share/applications"
here="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

# Runtime files, matching the list scripts/package.sh uses.
files="helium
chrome_100_percent.pak
chrome_200_percent.pak
helium_crashpad_handler
chromedriver
icudtl.dat
libEGL.so
libGLESv2.so
libvk_swiftshader.so
libvulkan.so.1
product_logo_256.png
resources.pak
v8_context_snapshot.bin
vk_swiftshader_icd.json"

rm -rf "$prefix"
mkdir -p "$prefix/locales" "$bin_dir" "$apps_dir"
for f in $files; do
    cp -r "$out/$f" "$prefix/"
done
cp "$out"/locales/*.pak "$prefix/locales/"
(cd "$prefix" && ln -sf helium chrome)

# Launcher: same environment the upstream wrapper sets, pointed at the copy.
cat > "$bin_dir/omabrowse" <<WRAP
#!/bin/sh
export CHROME_WRAPPER="$prefix/omabrowse"
export LD_LIBRARY_PATH="$prefix:$prefix/lib\${LD_LIBRARY_PATH:+:\${LD_LIBRARY_PATH}}"
exec "$prefix/helium" --ozone-platform=wayland --ozone-platform-hint=wayland --enable-features=AcceleratedVideoDecodeLinuxGL,AcceleratedVideoDecodeLinuxZeroCopyGL,VaapiVideoDecoder "\$@"
WRAP
chmod +x "$bin_dir/omabrowse"

cat > "$apps_dir/omabrowse.desktop" <<DESK
[Desktop Entry]
Version=1.0
Name=OmaBrowse
GenericName=Web Browser
Exec=$bin_dir/omabrowse %U
StartupNotify=true
Terminal=false
Icon=$prefix/product_logo_256.png
Type=Application
Categories=Network;WebBrowser;
MimeType=text/html;x-scheme-handler/http;x-scheme-handler/https;
Actions=new-window;new-private-window;

[Desktop Action new-window]
Name=New Window
Exec=$bin_dir/omabrowse

[Desktop Action new-private-window]
Name=New Incognito Window
Exec=$bin_dir/omabrowse --incognito
DESK

echo "installed to $prefix"
echo "launcher: $bin_dir/omabrowse"
echo "desktop entry: $apps_dir/omabrowse.desktop"

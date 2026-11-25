#!/usr/bin/env bash
# Publish a compiled DumbOS ROM build directly to GitHub Releases (DumbOS-ROM/releases).
# Published releases appear automatically on https://dumbos-rom.github.io/#downloads.
#
# Usage:
#   ./publish-build.sh <codename> <zip_path> [android_version] [changelog_note]
# Example:
#   ./publish-build.sh angler out/target/product/angler/DumbOS-22.2-20261125-UNOFFICIAL-angler.zip "Android 15" "Fix 3-button and gesture navigation bar"

set -euo pipefail

if [ "$#" -lt 2 ]; then
  echo "Usage: $0 <codename> <zip_path> [android_version] [changelog_note]" >&2
  exit 1
fi

CODENAME="$1"
ZIP_PATH="$2"
ANDROID_VER="${3:-Android 14/15}"
NOTE="${4:-Minimalist monochrome OLED build with DumbLauncher, single-process Recents, and microG.}"

if [ ! -f "$ZIP_PATH" ]; then
  echo "ERROR: File not found: $ZIP_PATH" >&2
  exit 1
fi

DATE_TAG="$(date +%Y%m%d)"
TAG="${CODENAME}-${DATE_TAG}"
FILENAME="$(basename "$ZIP_PATH")"
SHA256="$(sha256sum "$ZIP_PATH" | awk '{print $1}')"
SHA_FILE="${ZIP_PATH}.sha256sum"
printf "%s  %s\n" "$SHA256" "$FILENAME" > "$SHA_FILE"

BODY_FILE="$(mktemp)"
trap 'rm -f "$BODY_FILE"' EXIT

cat > "$BODY_FILE" <<EOF
### DumbOS for \`${CODENAME}\`

- **Android Version**: ${ANDROID_VER}
- **Package**: \`${FILENAME}\`
- **SHA-256**: \`${SHA256}\`

#### Changelog / Notes
${NOTE}

#### Clean Flash Steps
1. Boot into Recovery (TWRP / Lineage Recovery).
2. Wipe Data / Factory Reset (if coming from another ROM).
3. Sideload or flash \`${FILENAME}\` (microG & Aurora Store are pre-integrated).
4. Reboot to System.
EOF

echo "Publishing ${TAG} to DumbOS-ROM/releases..."
if gh release view "$TAG" --repo DumbOS-ROM/releases >/dev/null 2>&1; then
  gh release upload "$TAG" "$ZIP_PATH" "$SHA_FILE" --repo DumbOS-ROM/releases --clobber
  gh release edit "$TAG" --repo DumbOS-ROM/releases --notes-file "$BODY_FILE"
else
  gh release create "$TAG" "$ZIP_PATH" "$SHA_FILE" \
    --repo DumbOS-ROM/releases \
    --title "DumbOS (${CODENAME}) — ${DATE_TAG}" \
    --notes-file "$BODY_FILE"
fi

echo "Done! Live at: https://dumbos-rom.github.io/#downloads"

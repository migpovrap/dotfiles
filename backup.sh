#!/bin/bash
set -euo pipefail
umask 077

REPO_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# 1Password must be unlocked; `op` talks to the desktop app, no `op signin` needed.
if ! op whoami >/dev/null 2>&1; then
  echo "1Password CLI is not signed in. Unlock the app and enable CLI integration." >&2
  exit 1
fi

TMP_DIR="$(mktemp -d)"
trap 'rm -rf "$TMP_DIR"' EXIT

echo "Exporting GPG material to $TMP_DIR"
gpg -a --export >"$TMP_DIR/pubkeys.asc"
gpg -a --export-secret-keys >"$TMP_DIR/privatekeys.asc"
gpg --export-ownertrust >"$TMP_DIR/trust.txt"

update_or_create() {
  local title="$1" file="$2"
  if op document get "$title" >/dev/null 2>&1; then
    echo "Updating $title in 1Password..."
    op document edit "$title" "$file" >/dev/null
  else
    echo "Creating $title in 1Password..."
    op document create "$file" --title "$title" >/dev/null
  fi
}

update_or_create "GPG Private Keys" "$TMP_DIR/privatekeys.asc"
update_or_create "GPG Public Keys" "$TMP_DIR/pubkeys.asc"
update_or_create "GPG TrustDB" "$TMP_DIR/trust.txt"

# Revocation certificate in its own item, usable without the key export.
fpr=$(gpg --list-secret-keys --with-colons | awk -F: '/^fpr:/ {print $10; exit}')
revcert="$HOME/.gnupg/openpgp-revocs.d/${fpr}.rev"
if [[ -f "$revcert" ]]; then
  update_or_create "GPG Revocation Certificate" "$revcert"
else
  echo "No revocation certificate found for ${fpr:-<no key>}." >&2
fi

echo "GPG backup stored in 1Password."

# Package list, without touching the curated Brewfile.
echo "Writing Brewfile.lock..."
brew bundle dump --file="$REPO_DIR/Brewfile.lock" --force

# App preferences. Raycast has no reliable defaults export; do it in the app.
echo "Backing up app preferences..."
defaults export com.surteesstudios.Bartender "$REPO_DIR/plists/bartender5.plist"
defaults export com.lwouis.alt-tab-macos "$REPO_DIR/plists/alttab.plist"
defaults export com.knollsoft.Rectangle "$REPO_DIR/plists/rectangle.plist"
defaults export pl.maketheweb.cleanshotx "$REPO_DIR/plists/cleanshotx.plist"
defaults export com.if.Amphetamine "$REPO_DIR/plists/amphetamine.plist"
defaults export com.apple.HIToolbox "$REPO_DIR/plists/hitoolbox.plist" ||
  echo "HIToolbox export failed (no custom input sources to export?)." >&2

echo "Raycast: export manually from Raycast → Advanced → Export."
echo "Backup complete."

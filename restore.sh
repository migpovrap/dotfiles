#!/bin/bash
set -euo pipefail

REPO_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# --- GPG keys (only when the local keyring is empty) -----------------------
if [ ! -d "$HOME/.gnupg" ] || [ -z "$(ls -A "$HOME/.gnupg")" ]; then
  echo "GPG directory is empty or doesn't exist. Proceeding with restoration..."

  if ! op whoami >/dev/null 2>&1; then
    eval "$(op signin)"
  fi

  umask 077
  TMP_DIR="$(mktemp -d)"
  trap 'rm -rf "$TMP_DIR"' EXIT

  echo "Retrieving GPG keys from 1Password..."
  op document get "GPG Private Keys" >"$TMP_DIR/privatekeys.asc"
  op document get "GPG Public Keys" >"$TMP_DIR/pubkeys.asc"
  op document get "GPG TrustDB" >"$TMP_DIR/trust.txt"

  gpg --import "$TMP_DIR/privatekeys.asc"
  gpg --import "$TMP_DIR/pubkeys.asc"
  gpg --import-ownertrust "$TMP_DIR/trust.txt"

  echo "GPG keys restored successfully."
else
  echo "GPG directory is not empty. Skipping restoration."
fi

# --- App preferences -------------------------------------------------------
echo "Restoring app preferences..."
for app in "com.surteesstudios.Bartender" "com.lwouis.alt-tab-macos" \
           "com.knollsoft.Rectangle" "pl.maketheweb.cleanshotx" \
           "com.if.Amphetamine"; do
  APP_PID="$(pgrep -f "$app" || true)"
  [ -n "$APP_PID" ] && kill "$APP_PID" 2>/dev/null || true
done

import_defaults() {
  local domain="$1" file="$2"
  [ -f "$file" ] || { echo "  skipped $domain (no backup file)"; return 0; }
  if defaults import "$domain" "$file" 2>/dev/null; then
    echo "  restored $domain"
  else
    echo "  skipped $domain (app missing or never launched)"
  fi
}

import_defaults com.surteesstudios.Bartender "$REPO_DIR/plists/bartender5.plist"
import_defaults com.lwouis.alt-tab-macos        "$REPO_DIR/plists/alttab.plist"
import_defaults com.knollsoft.Rectangle         "$REPO_DIR/plists/rectangle.plist"
import_defaults pl.maketheweb.cleanshotx        "$REPO_DIR/plists/cleanshotx.plist"
import_defaults com.if.Amphetamine              "$REPO_DIR/plists/amphetamine.plist"
import_defaults com.apple.HIToolbox             "$REPO_DIR/plists/hitoolbox.plist"

# --- Manual steps ----------------------------------------------------------
cat <<'EOF'

Remaining manual steps:
  1. Raycast -> Settings -> Advanced -> Import Settings... (pick the .rayconfig from iCloud Drive)
  2. Log out and back in for the HIToolbox (input source) changes to take effect.

EOF

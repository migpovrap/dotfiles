#!/bin/bash
set -e

# Check if the ~/.gnupg directory is empty or doesn't exist
if [ ! -d "$HOME/.gnupg" ] || [ -z "$(ls -A $HOME/.gnupg)" ]; then
  echo "GPG directory is empty or doesn't exist. Proceeding with restoration..."

  # Ensure the user is authenticated in 1Password
  eval $(op signin)

  # Temporary directory
  TMP_DIR=$(mktemp -d)
  echo "Retrieving GPG keys from 1Password..."

  # Fetch from 1Password
  op document get "GPG Private Keys" > "$TMP_DIR/privatekeys.asc"
  op document get "GPG Public Keys" > "$TMP_DIR/pubkeys.asc"
  op document get "GPG TrustDB" > "$TMP_DIR/trust.txt"

  # Import into GPG
  echo "Importing private keys..."
  gpg --import "$TMP_DIR/privatekeys.asc"

  echo "Importing public keys..."
  gpg --import "$TMP_DIR/pubkeys.asc"

  echo "Importing trust database..."
  gpg --import-ownertrust "$TMP_DIR/trust.txt"

  echo "GPG keys restored successfully."
  rm -rf "$TMP_DIR"
else
  echo "GPG directory is not empty. Skipping restoration."
fi

echo "Restore launhpad layout from iCloud"
lporg save --icloud


echo "Restoring app perferences..."
for app in "com.surteesstudios.Bartender" "com.lwouis.alt-tab-macos" "com.knollsoft.Rectangle" "pl.maketheweb.cleanshotx" "com.if.Amphetamine" "com.raycast.macos"; do
  APP_PID=$(pgrep -f "$app")
  if [ -n "$APP_PID" ]; then
    kill "$APP_PID"
  fi
done

defaults import com.surteesstudios.Bartender ../plists/bartender5.plist
defaults import com.lwouis.alt-tab-macos ../plists/alttab.plist
defaults import com.knollsoft.Rectangle ../plists/rectangle.plist
defaults import pl.maketheweb.cleanshotx ../plists/cleanshotx.plist
defaults import com.if.Amphetamine ../plists/amphetamine.plist
defaults import com.raycast.macos ../plists/raycast.plist

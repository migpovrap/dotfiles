#!/bin/bash
set -e

# Ensure the user is authenticated in 1Password
eval $(op signin)

# Temporary directory
TMP_DIR=$(mktemp -d)
echo "Saving GPG keys to $TMP_DIR"

gpg -a --export >"$TMP_DIR/pubkeys.asc"
gpg -a --export-secret-keys >"$TMP_DIR/privatekeys.asc"
gpg --export-ownertrust >"$TMP_DIR/trust.txt"

# Function to update or create a document in 1Password
update_or_create() {
    local doc_name="$1"
    local file_path="$2"

    # Check if the document exists
    if op document get "$doc_name" >/dev/null 2>&1; then
        echo "Updating $doc_name in 1Password..."
        op document edit "$doc_name" "$file_path"
    else
        echo "Creating $doc_name in 1Password..."
        op document create "$file_path" --title "$doc_name"
    fi
}

# Update or create each document
update_or_create "GPG Private Keys" "$TMP_DIR/privatekeys.asc"
update_or_create "GPG Public Keys" "$TMP_DIR/pubkeys.asc"
update_or_create "GPG TrustDB" "$TMP_DIR/trust.txt"

echo "Backup stored securely in 1Password."
rm -rf "$TMP_DIR"

echo "Saving launchpad layout to iCloud"
lporg save --icloud


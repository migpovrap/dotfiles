#!/bin/bash

# Exit immediately if a command exits with a non-zero status
set -e

# Install Homebrew if not installed
if ! command -v brew &>/dev/null; then
  echo "Installing Homebrew..."
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
else
  echo "Homebrew is already installed."
fi

brew install chezmoi
brew install --cask 1password 1password-cli

echo "Sign in to 1Password desktop, set up the op cli also open the App Store, and ensure iCloud is correctly configured."
read -p "Press Enter to continue."

chezmoi init --apply migpovrap

echo "Setup completed successfully."
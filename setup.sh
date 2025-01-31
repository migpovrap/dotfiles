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

# Install chezmoi
echo "Installing chezmoi..."
brew install chezmoi

# Prompt user for GitHub username
read -rp "Enter your GitHub username: " GITHUB_USERNAME

# Validate input
if [ -z "$GITHUB_USERNAME" ]; then
  echo "Error: GitHub username cannot be empty."
  exit 1
fi

# Initialize and apply chezmoi configuration
echo "Initializing chezmoi..."
chezmoi init --apply "$GITHUB_USERNAME"

echo "Setup completed successfully."


#!/bin/bash
# Runs before chezmoi applies files and externals.
set -e

if [ ! -f "$HOME/.oh-my-zsh/oh-my-zsh.sh" ]; then
  RUNZSH=no CHSH=no KEEP_ZSHRC=yes \
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
fi

# Miguel's dotFiles

The repository contains the configuration files that I use in macOS, it's managed using chezmoi and some custom scripts, all of the private information and keys that are typically stored in this files are stored in 1Password using the integration provided by chezmoi.
The sricpts are used to automate the backup and restore of gpg keys, using 1Password cli.


## Contents:

- `setup.sh`: One line setup script to configure a new machine.
- `backup.sh`: Saves GPG keys and app preferences to 1Password.
- `restore.sh`: Restores GPG keys and app preferences.
- `Brewfile`: Homebrew formulae and casks (no App Store apps).
- `Brewfile.mas`: App Store apps installed with `mas` after signing in.
- `plists/`: Directory containing app preference files in plist format.
- `home/`: Chezmoi home directory.
- `home/private_dot_local/executable_pinentry_op.sh`: gpg-agent pinentry backed by 1Password.
- `home/private_Library/private_Keyboard Layouts/PT-PC.bundle`: custom Ukelele layout.

- Config for:
  - Neovim
  - Tmux
  - Alacritty
  - bat
  - fzf
  - yazi
  - zed
  - zsh using oh-my-zsh

## Installation

> [!WARNING]
> This are my personal macOS dotfiles and configurations, it's not intended to be used as is, because it's tailored to my personal use case, but feel free to fork it and modify it to your needs or use it as a reference.
The one line setup sript is intended to be use by me to setup a new machine, or mine after a factory reset. It assumes that you will have the secret keys and ssh keys in 1Password, also that some files are stored in specific locations on the machine and Google Drive.
After all of this if you still want to use it, you should fork it and review all the code and modified it for your needs and preferences.

**One line setup**
```shell
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/migpovrap/dotfiles/main/setup.sh)"
```

### After setup (manual)

- **App Store:** sign in, then install the App Store apps:
  ```shell
  brew bundle --file="$HOME/.local/share/chezmoi/Brewfile.mas"
  ```
  They live outside `Brewfile` on purpose: `mas` fails without a signed-in account, and the setup
  script runs with `set -e`, so one failure would abort everything after it.
- **Keyboard layout:** `PT-PC.bundle` is deployed by chezmoi. Enable it once in
  System Settings → Keyboard → Input Sources; the enabled list is captured by `backup.sh`
  (`com.apple.HIToolbox`) and restored by `restore.sh`. Log out and back in after a restore.
- **Raycast:** the app is installed, its settings are not. Import them from
  Raycast → Settings → Advanced.
- **Touch ID for sudo:** the setup script writes `/etc/pam.d/sudo_local` on macOS 14+; older
  systems ignore that file, and the script warns instead.

## Keyboard shortcuts CheatSheet

<details>
  <summary>Terminal (ZSH)</summary>

  | Keybinding | Action |
  |------------|--------|
  | `Ctrl + F`       | Bind Ctrl + F to search for files (fzf-file-widget) |
  | `Ctrl + H`       | Bind Ctrl + H to search for command history (fzf-history-widget) |
  | `Up Arrow`     | History search backward |
  | `Down Arrow`     | History search forward |

</details>

<details>
  <summary>Tmux shortcuts</summary>

  | Keybinding       | Action |
  |------------------|--------|
  | `Ctrl + Space`        | Prefix key |
  | `Prefix + n`     | Open a new window |
  | `Prefix + w`     | Close the current window |
  | `Prefix + o`     | Open sessionx manager |
  | `Prefix + I`     | Reaload Tmux Enviroment |
  | `Shift + Alt + Left`       | Switch to the previous window |
  | `Shift + Alt + Right`      | Switch to the next window |
  | `Prefix + -`     | Split window vertically |
  | `Prefix + \`     | Split window horizontally |
  | `x`              | Kill the current pane without confirmation |

</details>

<details>
  <summary>Neovim shortcuts</summary>

  | Keybinding       | Action |
  |------------------|--------|
  | `Space`          | Set leader key |
  | `Leader + q`     | Quit Neovim |
  | `Leader + e`     | Toggle NvimTree |
  | `Leader + ff`    | Find files using Telescope |
  | `Leader + fg`    | Grep files using Telescope |
  | `Up Arrow` (visual) | Enable selection with Up key |
  | `Down Arrow` (visual) | Enable selection with Down key |
  | `Left Arrow` (visual) | Enable selection with Left key |
  | `Right Arrow` (visual) | Enable selection with Right key |
  | `Ctrl + c`       | Yank in normal and visual mode |
  | `Ctrl + v`       | Paste in normal and visual mode |
  | `Ctrl + z`       | Undo in normal and visual mode |
  | `Ctrl + Shift + z` | Redo in normal and visual mode |
  | `Alt + Up Arrow` | Go to the top of the page |
  | `Alt + Down Arrow` | Go to the bottom of the page |
  | `Alt + Left Arrow` | Go to the beginning of the line |
  | `Alt + Right Arrow` | Go to the end of the line |
  | `Ctrl + a`       | Select all text |
  | `Backspace` (visual) | Delete the selected text |
  | `Shift + Up Arrow` (insert) | Enable selection with Shift + Up key |
  | `Shift + Down Arrow` (insert) | Enable selection with Shift + Down key |
  | `Shift + Left Arrow` (insert) | Enable selection with Shift + Left key |
  | `Shift + Right Arrow` (insert) | Enable selection with Shift + Right key |
  | `Ctrl + n`       | Open a new tab |
  | `Ctrl + w`       | Close the current tab |
  | `Ctrl + f`       | Open a Telescope menu to select the search mode |
  | `Ctrl + l`       | Toggle the nvim-tree pane |
  | `Ctrl + s`       | Save the current file |
  | `Ctrl + Left Mouse Click` | Go to definition |

</details>

<details>
  <summary>Yazi shortcuts</summary>

  **General**
  | Keybinding       | Action |
  |------------------|--------|
  | `<Esc>`          | Exit visual mode, clear selected, or cancel search |
  | `q`              | Quit



  **Operations**
  | Keybinding       | Action |
  |------------------|--------|
  | `<Enter>`        | Open selected files |
  | `y`              | Yank selected files (copy) |
  | `x`              | Yank selected files (cut) |
  | `p`              | Paste yanked files |
  | `d`              | Trash selected files |
  | `D`              | Permanently delete selected files |
  | `r`              | Rename selected file(s) |
  | `s`              | Search files by name (fd) |
  | `S`              | Search file contents (ripgrep) |
  | `z`              | Jump to a directory via zoxide |
  | `Z`              | Jump to a file/directory via fzf |

  **Help**
  | Keybinding       | Action |
  |------------------|--------|
  | `<F1>`           | Open help with shortcuts cheatsheet |

</details>

-----------

### Future improvements
- [ ] Use Cmd key on Nvim instead of Ctrl.
- [ ] Add more shortcuts to the cheatsheet.
- [ ] Find defaults setting True tone, app notifications, disable window manager.


## Acknowledgements
- [Mathias Bynens](https://mathiasbynens.be/) and [Kevin Suttle](https://kevinsuttle.com/) for their macOS defaults [repositories](https://github.com/kevinSuttle/MacOS-Defaults).
- [Yann Bertrand](https://yann-bertrand.fr/) for his macOS defaults list and tools [repository](https://github.com/yannbertrand/macos-defaults).
- [Kyle Crawford](https://github.com/kcrawford) for his amazing tool to manage the dock, [dockutil](https://github.com/kcrawford/dockutil). 
- [Jake Hilborn](https://github.com/jakehilborn) for his tool to config the dislay settings from the cli, [displayplacer](https://github.com/jakehilborn/displayplacer).
- [Inês Costa](https://github.com/inesiscosta) for her dotfiles repository, used as inspiration for some scripts and organization.

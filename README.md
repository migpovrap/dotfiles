# Miguel's dotFiles

The repository contains the configuration files that I use in macOS, it's managed using chezmoi and some custom scripts, all of the private information and keys that are typically stored in this files are stored in 1Password using the integration provided by chezmoi.
A cron job is used to keep brew updated and keep in sync with the formulas and casks that are listed in the Brewfile. The sricpts are used to automate the backup and restore of gpg keys, using 1Password cli, and encrypt and decrypt files stored in Google Drive or other non local storage.


**It contains configurations for:**

- NeoVim
- iTerm2
- tmux
- Alacritty
- Zed
- LinearMouse
- Git
- ZsH using Oh-My-ZsH
- Brew
- macOS custom settings
- In the future maybe more??

## Installation

> [!WARNING]
> This are my personal macOS dotfiles and configurations, it's not intended to be used as is, because it's tailored to my personal use case, but feel free to fork it and modify it to your needs or use it as a reference.
The one line setup sript is intended to be use by me to setup a new machine, or mine after a factory reset. It assumes that you will have the secret keys and ssh keys in 1Password, also that some files are stored in specific locations on the machine and Google Drive.
After all of this if you still want to use it, you shoudl fork it and review all the code and modified it for your needs and preferences.

**One line setup**
```shell
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/migpovrap/dotfiles/main/setup.sh)"
```

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
  | `s`              | Search files by content via ripgrep |
  | `z`              | Jump to a directory via zoxide |
  | `Z`              | Jump to a file/directory via fzf |
  | `f`              | Search the current directory using fzf(`f`) and ripgrep(`g`) |

  **Help**
  | Keybinding       | Action |
  |------------------|--------|
  | `<F1>`           | Open help with shortcuts cheatsheet |

</details>

-----------

### Future improvements
- [X] Use op cli to store and restore gnupg keys.
- [ ] Finish the script to encrypt and decrypt files stored in Google Drive.
- [ ] Use chezmoi and it's integration with 1Password to store to store gnupg keys.
- [ ] Use Cmd key on Nvim instead of Ctrl.
- [ ] Add more shortcuts to the cheatsheet.
- [ ] Write a better README.md with instructions on how to customize this for personal use.


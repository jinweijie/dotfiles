# ZSH Manager

Simple script to install, setup, and manage dotfiles with stow on Ubuntu/Debian.

## Quick Start (New Machine)

```bash
# 1. Clone this repo
git clone <your-repo-url> ~/dotfiles
cd ~/dotfiles

# 2. Install packages, setup zsh, and link dotfiles
chmod +x dot_manager.sh
./dot_manager.sh all
```

Then restart your terminal or run `zsh`.

## Commands

### `install`
Installs required system packages.
```bash
./dot_manager.sh install
```

### `setup`
Sets up Zsh and installs the Zim framework.
```bash
./dot_manager.sh setup
```

### `stow`
Links dotfiles to your home directory.
```bash
./dot_manager.sh stow
```

### `uninstall`
Removes Zsh, configuration, and restored system state.
```bash
./dot_manager.sh uninstall
```

### `set_proxy`
Sets `http_proxy` and `https_proxy` environment variables.
**Note:** To persist these settings in your current shell, you must source the script:
```bash
source ./dot_manager.sh set_proxy
```

### `unset_proxy`
Unsets proxy environment variables.
```bash
source ./dot_manager.sh unset_proxy
```

### `all`
Runs install, setup, and stow in sequence.
```bash
./dot_manager.sh all
```

## Workflow

1.  **Clone repo** - `git clone <repo-url> ~/dotfiles && cd ~/dotfiles`
2.  **Install & Setup** - `./dot_manager.sh all` (installs packages, sets up zsh, links dotfiles)
3.  **Or step by step:**
    -   `./dot_manager.sh install` - Install packages
    -   `./dot_manager.sh setup` - Setup zsh
    -   `./dot_manager.sh stow` - Link dotfiles (asks before replacing existing files)

## What Gets Installed

**System packages:** zsh, git, curl, zip, tmux, vim, bfs, fd, ripgrep, **stow**  
**Tools:** fzf (fuzzy finder), Zim framework

## Dotfiles Management

The script uses `stow` to link files directly from the repository root to your home directory.

It respects the `.stow-local-ignore` file to exclude repository metadata (like README, git files, etc.) from being linked.

When running `stow`, the script will:
- Check for existing dotfiles in your home directory
- Ask if you want to backup and replace them
- Create timestamped backups (e.g., `.zshrc.backup.20240101_120000`)
- Link dotfiles using stow

## Requirements

- Ubuntu/Debian Linux
- User with sudo privileges
- Internet connection

## Notes

- You'll be prompted for your password when installing/uninstalling
- Script is safe to run multiple times (skips already installed items)
- Existing dotfiles are backed up before replacement (with timestamp)
- After setup, restart terminal or run `zsh` to use zsh
- Dotfiles are automatically organized into stow directories on first run

## Troubleshooting

**Permission denied?**
```bash
chmod +x dot_manager.sh
```

**Can't change shell?**
```bash
chsh -s $(which zsh)
```

**No sudo access?**
Make sure your user is in the sudo group: `groups`

## Recommended Font

For the best visual experience with icons and glyphs, it is recommended to install a [Nerd Font](https://www.nerdfonts.com/font-downloads).

**Suggested:** [CascadiaMono Nerd Font](https://github.com/ryanoasis/nerd-fonts/releases/latest/download/CascadiaMono.zip)
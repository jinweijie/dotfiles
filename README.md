# Dotfiles

My personal dotfiles managed with [GNU Stow](https://www.gnu.org/software/stow/).

## Quick Setup

```bash
# Clone this repository
git clone https://github.com/jinweijie/dotfiles.git ~/dotfiles
cd ~/dotfiles

# Run the setup script
chmod +x dot_manager.sh
./dot_manager.sh all
```

This will:
1. Install required packages (zsh, git, stow, fzf, etc.)
2. Setup zsh and install Zim framework
3. Link dotfiles using stow (direct mapping from repo root)

## Structure

```
.
├── .zshrc          # zsh main config
├── .zimrc          # zim framework config
├── .vimrc          # vim configuration
├── .config/
│   ├── zellij/     # Zellij configuration
│   └── zsh/        # Zsh auxiliary config (fzf, proxy, utils)
├── .stow-local-ignore # Files to ignore when stowing
└── dot_manager.sh  # Setup and management script
```

## Commands


- `./dot_manager.sh all` - Complete setup (install + setup + stow)
- `./dot_manager.sh install` - Install packages
- `./dot_manager.sh setup` - Setup Zsh
- `./dot_manager.sh stow` - Link dotfiles
- `. ./dot_manager.sh set_proxy` - Set network proxy (source it to apply to shell)

## What's Included

- **zsh** with Zim framework and Powerlevel10k theme
- **fzf** fuzzy finder integration
- **vim** configuration
- **tmux** configuration
- Custom aliases and utility functions

## Vim Configuration

The `.vimrc` is configured with `vim-plug` for plugin management.

### Installation

The `.vimrc` includes an auto-installation script for `vim-plug`. Simply open Vim, and it should install automatically.

If that fails, or to install manually:

1.  **Download vim-plug**:
    ```bash
    curl -fLo ~/.vim/autoload/plug.vim --create-dirs \
        https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
    ```
2.  **Install Plugins**:
    Open Vim and run:
    :PlugInstall
    ```

    **Note:** If you are behind a proxy and plugins fail to install, set the proxy variables before opening vim:
    ```bash
    export http_proxy=http://127.0.0.1:7890
    export https_proxy=http://127.0.0.1:7890
    vim
    ```vim
    :PlugInstall
    ```

### Key Mappings

- `Leader`: `,` (comma)
- `,n`: Toggle NERDTree
- `,f`: Find files (fzf)
- `,b`: List buffers (fzf)
- `,g`: Git files (fzf)
- `<space>`: Clear search highlights

### Plugins

- **nerdtree**: File explorer
- **fzf.vim**: Fuzzy finder
- **vim-fugitive**: Git integration
- **lightline**: Proper status line
- **gruvbox**: Theme

- **gruvbox**: Theme

- **gruvbox**: Theme

## Zellij Configuration

The repository includes a `config.kdl` for **Zellij** with a customized Gruvbox theme and simplified UI.

### Installation

`zsh-manager.sh` will try to install Zellij automatically by downloading the linux binary. If you need to do it manually:

```bash
# Download binary
curl -LO https://github.com/zellij-org/zellij/releases/latest/download/zellij-x86_64-unknown-linux-musl.tar.gz
tar -xvf zellij-x86_64-unknown-linux-musl.tar.gz
chmod +x zellij
sudo mv zellij /usr/local/bin/
```

### Key Bindings

Zellij uses a mode-based system. Common default bindings + customs:

- **Ctrl + g**: Lock/Unlock interface
- **Ctrl + p**: Pane mode (n: new, x: close, arrow: move)
- **Ctrl + t**: Tab mode (n: new, x: close)
- **Alt + Arrows**: Navigate panes/tabs nicely
- **Ctrl + h/j/k/l**: Vim-style pane focus

## Requirements

- Ubuntu/Debian Linux
- User with sudo privileges
- Internet connection


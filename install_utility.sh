#!/bin/bash
set -euo pipefail

# install gdu
echo "Starting installation of gdu..."
curl -L https://github.com/dundee/gdu/releases/latest/download/gdu_linux_amd64.tgz | tar xz
chmod +x gdu_linux_amd64
sudo mv gdu_linux_amd64 /usr/bin/gdu
echo "Finished installation of gdu."

# layzygit
echo "Starting installation of lazygit..."
LAZYGIT_VERSION=$(curl -s "https://api.github.com/repos/jesseduffield/lazygit/releases/latest" | \grep -Po '"tag_name": *"v\K[^"]*')
curl -Lo lazygit.tar.gz "https://github.com/jesseduffield/lazygit/releases/download/v${LAZYGIT_VERSION}/lazygit_${LAZYGIT_VERSION}_Linux_x86_64.tar.gz"
tar xf lazygit.tar.gz lazygit
sudo install lazygit -D -t /usr/local/bin/
rm -rf lazygit.tar.gz lazygit
echo "Finished installation of lazygit."

# lazydocker
echo "Starting installation of lazydocker..."
LAZYDOCKER_VERSION=$(curl -s "https://api.github.com/repos/jesseduffield/lazydocker/releases/latest" | grep -Po '"tag_name": "v\K[0-9.]+')
curl -Lo lazydocker.tar.gz "https://github.com/jesseduffield/lazydocker/releases/latest/download/lazydocker_${LAZYDOCKER_VERSION}_Linux_x86_64.tar.gz"
mkdir lazydocker-temp
tar xf lazydocker.tar.gz -C lazydocker-temp
sudo mv lazydocker-temp/lazydocker /usr/local/bin
rm -rf lazydocker.tar.gz lazydocker-temp
echo "Finished installation of lazydocker."

# nerdfetch
echo "Starting installation of nerdfetch..."
curl -LO https://raw.githubusercontent.com/ThatOneCalculator/NerdFetch/main/nerdfetch
chmod +x nerdfetch
sudo mv nerdfetch /usr/local/bin/
echo "Finished installation of nerdfetch."

# lf
wget https://github.com/gokcehan/lf/releases/latest/download/lf-linux-amd64.tar.gz
tar -xvf lf-linux-amd64.tar.gz
chmod +x lf
sudo mv lf /usr/local/bin/
rm -rf lf-linux-amd64.tar.gz

# neovim
echo "Starting installation of neovim..."
curl -LO https://github.com/neovim/neovim/releases/latest/download/nvim-linux-x86_64.tar.gz
sudo rm -rf /opt/nvim-linux-x86_64
sudo tar -C /opt -xzf nvim-linux-x86_64.tar.gz
rm -rf nvim-linux-x86_64.tar.gz
echo "Finished installation of neovim."

# lazyvim
echo "Starting installation of lazyvim..."
DOTFILES="$HOME/dotfiles"
NVIM_DIR="$HOME/dotfiles/.config/nvim"

# 1. Ensure the dotfiles config directory exists
mkdir -p "$DOTFILES/.config"

# 2. Backup existing nvim config INTO dotfiles
if [ -d "$NVIM_DIR" ] && [ ! -L "$NVIM_DIR" ]; then
    echo "Backing up existing config to $DOTFILES/.config/nvim.bak"
    mv "$NVIM_DIR" "$DOTFILES/.config/nvim.bak"
fi

# 3. Clone LazyVim into dotfiles
if [ ! -d "$DOTFILES/.config/nvim" ]; then
    echo "Cloning LazyVim starter..."
    git clone https://github.com/LazyVim/starter "$DOTFILES/.config/nvim"
    rm -rf "$DOTFILES/.config/nvim/.git"
else
    echo "LazyVim directory already exists in dotfiles."
fi

# 4. Use Stow to link everything
cd "$DOTFILES"
# -v: verbose, -R: restow, -t: target directory
stow -v -R -t ~ .
cd -
echo "Finished installation of lazyvim."
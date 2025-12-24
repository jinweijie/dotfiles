#!/bin/bash

# Detect if the script is being sourced
(return 0 2>/dev/null) && sourced=1 || sourced=0

# Only set exit-on-error if NOT sourced (to prevent closing user's shell)
if [ "$sourced" -eq 0 ]; then
  set -e
fi

# Color codes for output
green='\033[0;32m'
yellow='\033[1;33m'
red='\033[0;31m'
bold='\033[1m'
reset='\033[0m'

# Helper functions for colored output
info() {
  printf "%b%s%b\n" "${green}${bold}" "$1" "${reset}"
}

warn() {
  printf "%b%s%b\n" "${yellow}${bold}" "$1" "${reset}"
}

die() {
  printf "%bError:%b %s\n" "${red}${bold}" "${reset}" "$1" >&2
  if [ "$sourced" -eq 1 ]; then
    return 1
  else
    exit 1
  fi
}

# Check if sudo is available and if user can use it
check_sudo() {
  if ! command -v sudo &> /dev/null; then
    die "sudo is not installed. Please install it first or run as root."
  fi
  
  # Check if user can use sudo (non-interactive check)
  if ! sudo -n true 2>/dev/null; then
    warn "This script requires sudo privileges. You may be prompted for your password."
    # Try to get sudo access
    sudo -v || die "Failed to obtain sudo privileges."
  fi
}

# Install function
install_packages() {
  info "Installing required packages..."
  check_sudo
  
  # Install system packages
  sudo -E apt update
  sudo -E apt install zsh git curl zip vim bfs fd ripgrep stow -y
  
  # Install Zellij
  if command -v zellij &> /dev/null; then
    info "Zellij already installed, skipping..."
  else
    info "Installing Zellij..."
    # Try cargo if available
    if command -v cargo &> /dev/null; then
      cargo install zellij
    else
      # Download binary directly (assuming x86_64 linux for this dotfiles setup)
      info "Downloading Zellij binary..."
      curl -LO https://github.com/zellij-org/zellij/releases/latest/download/zellij-x86_64-unknown-linux-musl.tar.gz
      tar -xvf zellij-x86_64-unknown-linux-musl.tar.gz
      chmod +x zellij
      
      # Move to /usr/local/bin if possible, otherwise user's bin
      if sudo mv zellij /usr/local/bin/; then
        info "Zellij installed to /usr/local/bin"
      else
        mkdir -p "$HOME/bin"
        mv zellij "$HOME/bin/"
        info "Zellij installed to $HOME/bin (ensure this is in your PATH)"
      fi
      
      # Cleanup
      rm zellij-x86_64-unknown-linux-musl.tar.gz
    fi
  fi
  
  # Install fzf
  if [ -d "$HOME/.fzf" ]; then
    info "fzf already installed, skipping..."
  else
    info "Installing fzf..."
    git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf
    ~/.fzf/install --all --no-update-rc
  fi
  
  info "Installation complete!"
  warn "Note: You may need to configure fonts for your terminal."
  warn "See: https://github.com/romkatv/powerlevel10k?tab=readme-ov-file#meslo-nerd-font-patched-for-powerlevel10k"
}

# Setup function (from setup.sh)
setup_zsh() {
  info "Setting up zsh..."
  
  # Change default shell to zsh
  if [ "$SHELL" != "$(which zsh)" ]; then
    info "Changing default shell to zsh..."
    chsh -s $(which zsh) || warn "Failed to change shell. You may need to run: chsh -s $(which zsh)"
  else
    info "zsh is already the default shell."
  fi
  
  # Install zim
  install_zim() {
    if [ -d "$HOME/.zim" ]; then
      info "Zim already installed"
    else
      info "Installing Zim framework..."
      curl -fsSL https://raw.githubusercontent.com/zimfw/install/master/install.zsh | zsh
    fi
  }
  
  install_zim
  info "Setup complete. Restart your terminal and switch to zsh."
}

# Uninstall function
uninstall_packages() {
  info "Uninstalling zsh configuration..."
  
  # Check if uninstall_oh_my_zsh function exists
  if command -v uninstall_oh_my_zsh &> /dev/null || type uninstall_oh_my_zsh &> /dev/null; then
    info "Uninstalling Oh My Zsh..."
    uninstall_oh_my_zsh
  else
    warn "uninstall_oh_my_zsh not found, skipping..."
  fi
  
  # Check if file exists before removing /etc/zsh/zshrc
  if [ -f /etc/zsh/zshrc ]; then
    info "Removing /etc/zsh/zshrc..."
    check_sudo
    sudo rm /etc/zsh/zshrc
  fi

  # Remove user config files
  if [ -f "$HOME/.zshrc" ]; then
    rm "$HOME/.zshrc"
    info "Removed ~/.zshrc"
  fi
  if [ -f "$HOME/.zimrc" ]; then
    rm "$HOME/.zimrc"
    info "Removed ~/.zimrc"
  fi
  
  # Remove zsh package
  info "Removing zsh package..."
  check_sudo
  sudo apt remove zsh -y

  # Remove fzf package and configuration
  info "Removing fzf..."
  if [ -d "$HOME/.fzf" ]; then
    rm -rf "$HOME/.fzf"
    info "Removed ~/.fzf directory"
  fi
  # Also try to remove apt package if it exists
  check_sudo
  sudo apt remove fzf -y

  # Remove stow package
  info "Removing stow package..."
  check_sudo
  sudo apt remove stow -y
  
  info "Uninstall complete!"
}

# Stow function to link dotfiles
stow_dotfiles() {
  local repo_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
  
  if ! command -v stow &> /dev/null; then
    die "stow is not installed. Run './dot_manager.sh install' first."
  fi
  
  info "Setting up dotfiles with stow..."
  
  # Check for existing dotfiles first (simple check for common files)
  local conflicts=()
  for file in "$repo_dir"/.*; do
    [ -f "$file" ] || continue
    local filename=$(basename "$file")
    # Skip excluded files
    grep -q "^$filename$" "$repo_dir/.stow-local-ignore" 2>/dev/null && continue
    
    local target="$HOME/$filename"
    if [ -e "$target" ] && [ ! -L "$target" ]; then
      conflicts+=("$filename")
    fi
  done
  
  if [ ${#conflicts[@]} -gt 0 ]; then
     warn "The following dotfiles already exist in your home directory:"
     for file in "${conflicts[@]}"; do
       echo "  - $file"
     done
     
     if [ -t 0 ] && [ -t 1 ]; then
        read -p "Do you want to backup and replace them? (y/N): " -n 1 -r
        echo ""
        if [[ ! $REPLY =~ ^[Yy]$ ]]; then
          warn "Skipping stow."
          return 1
        fi
     else
        warn "Non-interactive mode, skipping stow due to conflicts."
        return 1
     fi

     # Backup
     for file in "${conflicts[@]}"; do
       local target="$HOME/$file"
        local backup="$target.backup.$(date +%Y%m%d_%H%M%S)"
        info "Backing up $file to $backup"
        mv "$target" "$backup"
     done
  fi

  # Run stow in the repo directory
  cd "$repo_dir"
  info "Linking dotfiles..."
  stow . -t "$HOME" 2>/dev/null || {
     warn "Failed to stow, trying with --override..."
     stow . -t "$HOME" --override="*"
  }
  
  info "Dotfiles linked successfully!"
  
  # Run zimfw install to pick up new modules if .zimrc changed
  if [ -f "$HOME/.zim/zimfw.zsh" ]; then
    info "Running zimfw install to update modules..."
    # Ensure ZIM_HOME is set for the script
    export ZIM_HOME="$HOME/.zim"
    zsh "$HOME/.zim/zimfw.zsh" install
  fi
}

# Proxy functions
set_proxy() {
  # Use portable prompt (read -p is not zsh compatible default)
  printf "Enter proxy URL (e.g., http://127.0.0.1:7890): "
  read -r proxy_url
  
  if [ -z "$proxy_url" ]; then
    warn "No proxy URL provided. Aborting."
    return 1
  fi
  
  export http_proxy="$proxy_url"
  export https_proxy="$proxy_url"
  export HTTP_PROXY="$proxy_url"
  export HTTPS_PROXY="$proxy_url"
  export ALL_PROXY="$proxy_url"
  
  info "Proxy set to: $proxy_url"
  
  # Only warn about persistence if NOT sourced
  if [ "$sourced" -eq 0 ]; then
    warn "Note: You ran this script as a subprocess."
    warn "To persist changes in your current shell, indicate source usage:"
    warn "  source ./dot_manager.sh set_proxy"
  fi
}

unset_proxy() {
  unset http_proxy
  unset https_proxy
  unset HTTP_PROXY
  unset HTTPS_PROXY
  unset ALL_PROXY
  
  info "Proxy settings cleared."
}

# Main function
main() {
  if [ $# -eq 0 ]; then
    echo "Usage: $0 [command]"
    echo ""
    echo "Commands:"
    echo "  install     - Install required packages (zsh, git, stow, fzf, etc.)"
    echo "  setup       - Setup zsh and install Zim framework"
    echo "  stow        - Link dotfiles using stow (checks for existing files)"
    echo "  uninstall   - Remove zsh configuration and packages"
    echo "  set_proxy   - Set http/https proxy environment variables"
    echo "  unset_proxy - Unset proxy environment variables"
    echo "  all         - Run install, setup, and stow in sequence"
    
    if [ "$sourced" -eq 1 ]; then
      return 1
    else
      exit 1
    fi
  fi
  
  case "$1" in
    install)
      install_packages
      ;;
    setup)
      setup_zsh
      ;;
    stow)
      stow_dotfiles
      ;;
    uninstall)
      uninstall_packages
      ;;
    set_proxy)
      set_proxy
      ;;
    unset_proxy)
      unset_proxy
      ;;
    all)
      install_packages
      setup_zsh
      stow_dotfiles
      ;;
    *)
      die "Unknown command: $1. Use: install, setup, stow, uninstall, set_proxy, unset_proxy, or all"
      ;;
  esac
}

main "$@"


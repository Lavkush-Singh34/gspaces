#!/bin/bash

# Prevent interactive prompts
export DEBIAN_FRONTEND=noninteractive

# Install required packages
sudo apt install -y bat ranger

# Set up 'bat' alias (since Debian-based distros call it 'batcat')
echo 'alias bat="batcat"' >> ~/.zshrc

# Install Nix package manager if not installed
if ! command -v nix &> /dev/null; then
    curl -L https://nixos.org/nix/install | sh
fi

# Ensure Nix is available in the shell
echo '. /home/codespace/.nix-profile/etc/profile.d/nix.sh' >> ~/.zshrc
echo '. /home/codespace/.nix-profile/etc/profile.d/nix.sh' >> ~/.bashrc

# Reload shell environment before using Nix
. /home/codespace/.nix-profile/etc/profile.d/nix.sh

# Verify Nix installation
if ! command -v nix &> /dev/null; then
    echo "Nix installation failed. Please restart the shell and try again."
    exit 1
fi

# Enable Nix experimental features
mkdir -p ~/.config/nix
echo "experimental-features = nix-command flakes" >> ~/.config/nix/nix.conf

# Install fastfetch using Nix
nix profile install nixpkgs#fastfetch

# Install and enable 'zsh-autosuggestions'
ZSH_CUSTOM=${ZSH_CUSTOM:-~/.oh-my-zsh/custom}
if [ ! -d "$ZSH_CUSTOM/plugins/zsh-autosuggestions" ]; then
    git clone https://github.com/zsh-users/zsh-autosuggestions "$ZSH_CUSTOM/plugins/zsh-autosuggestions"
    echo 'plugins+=(zsh-autosuggestions)' >> ~/.zshrc
fi

# Change Zsh theme to 'gnzh'
sed -i 's/ZSH_THEME=".*"/ZSH_THEME="gnzh"/' ~/.zshrc

# Reload the shell properly
zsh -c "exec zsh"

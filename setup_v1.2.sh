#!/bin/bash

set -e  # Exit on error
export DEBIAN_FRONTEND=noninteractive

# Install required packages
echo "Installing required packages..."
sudo apt update && sudo apt install -y bat ranger

# Set up 'bat' alias if not already added
if ! grep -qxF 'alias bat="batcat"' ~/.zshrc; then
    echo 'alias bat="batcat"' >> ~/.zshrc
fi

# Ensure Nix is sourced in both Zsh and Bash
for rcfile in ~/.zshrc ~/.bashrc; do
    if ! grep -qxF '. /home/codespace/.nix-profile/etc/profile.d/nix.sh' "$rcfile"; then
        echo '. /home/codespace/.nix-profile/etc/profile.d/nix.sh' >> "$rcfile"
    fi
done

# Load Nix into the current shell session
. /home/codespace/.nix-profile/etc/profile.d/nix.sh

# Enable Nix experimental features
mkdir -p ~/.config/nix
if ! grep -qxF "experimental-features = nix-command flakes" ~/.config/nix/nix.conf; then
    echo "experimental-features = nix-command flakes" >> ~/.config/nix/nix.conf
fi

# Install fastfetch using Nix
echo "Installing fastfetch..."
nix profile install nixpkgs#fastfetch

# Install and enable 'zsh-autosuggestions'
ZSH_CUSTOM=${ZSH_CUSTOM:-~/.oh-my-zsh/custom}
if [ ! -d "$ZSH_CUSTOM/plugins/zsh-autosuggestions" ]; then
    echo "Installing Zsh Autosuggestions..."
    git clone https://github.com/zsh-users/zsh-autosuggestions "$ZSH_CUSTOM/plugins/zsh-autosuggestions"
    echo 'plugins+=(zsh-autosuggestions)' >> ~/.zshrc
fi

# Change Zsh theme to 'gnzh' if not already set
sed -i 's/^ZSH_THEME=".*"/ZSH_THEME="gnzh"/' ~/.zshrc

echo "✅ Setup complete! Restart your shell or run 'exec zsh' to apply changes."

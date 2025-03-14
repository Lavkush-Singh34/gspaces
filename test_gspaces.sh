#!bin/bash
sudo apt update && sudo apt upgrade -y
sudo apt install bat ranger -y
echo 'alias bat="batcat"' >> ~/.zshrc
source ~/.zshrc
curl -L https://nixos.org/nix/install | sh
echo '. /home/codespace/.nix-profile/etc/profile.d/nix.sh' >> ~/.bashrc
source ~/.bashrc

echo '. /home/codespace/.nix-profile/etc/profile.d/nix.sh' >> ~/.zshrc
source ~/.zshrc

mkdir -p ~/.config/nix
echo "experimental-features = nix-command flakes" >> ~/.config/nix/nix.conf

# nix-env -iA nixpkgs.fastfetch  # Install a package 
nix profile install nixpkgs#fastfetch
#nix-env -e neofetch           # Remove a package

# change .zshrc theme to gnzh and setup zsh auto-suggestions
git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions
zsh-autosuggestions

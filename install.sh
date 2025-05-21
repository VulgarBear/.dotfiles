#!/bin/bash

## Error handling
traperr() {
        c_error "ERROR: ${BASH_SOURCE[1]} at about ${BASH_LINENO[0]}"
}

set -o errtrace
trap trapper ERR

# Installing Packages and required items
## Update
sudo apt update
sudo add-apt-repository ppa:zhangsongcui3371/fastfetch -y
sudo apt update

## Install Nala
sudo apt install nala -y

## Install packages
sudo nala install $(< package.list) -y

## Git Clone
git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm

# Install Zoxide
curl -sSfL https://raw.githubusercontent.com/ajeetdsouza/zoxide/main/install.sh | sh
sudo mv ~/.local/bin/zoxide /usr/local/bin/

# Install oh-my-zsh
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"

# Move Configs
stow .

# Install Dysk
cd /usr/local/bin
sudo wget https://dystroy.org/dysk/download/x86_64-linux/dysk
sudo chmod +x dysk
cd ~/.dotfiles

# Install Node Version Manager
curl -o- https://fnm.vercel.app/install | bash

# Reload Shell
source ~/.zshrc
exec zsh

exit

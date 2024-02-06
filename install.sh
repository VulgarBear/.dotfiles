#!/bin/bash

## Author VulgarBear
## Created Feb 5th, 2024

## Variables


## Error handling
traperr() {
        c_error "ERROR: ${BASH_SOURCE[1]} at about ${BASH_LINENO[0]}"
}

set -o errtrace
trap trapper ERR

##

echo "Installing packages..."

pkgs=(nala, git, zsh, stow, fonts-powerline)
sudo apt-get -y --ignore-missing install "${pkgs[@]}"

sleep 1
## Setting up environment

echo "Confirming correct shell is used"
chsh -s /user/bin/zsh
echo $SHELL

sleep 1

echo "Installing Oh My ZSH with Powerlevel10"
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"

stow .
git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k
git clone https://github.com/zsh-users/zsh-syntax-highlighting.git $ZSH_CUSTOM/plugins/zsh-syntax-highlighting

exit

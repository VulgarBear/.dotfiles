#!/bin/bash

## Error handling
traperr() {
        c_error "ERROR: ${BASH_SOURCE[1]} at about ${BASH_LINENO[0]}"
}

set -o errtrace
trap trapper ERR

# Installing Packages
## Update
sudo apt update
sudo add-apt-repository ppa:zhangsongcui3371/fastfetch
sudo apt update
## Install Nala
sudo apt install nala -y

## Install packages
sudo nala install $(< .package.list)

exit

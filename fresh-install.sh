#!/usr/bin/env bash

# Config
#    Using '-e' ensures the script will exit if it encounters an error.
set -e
set -o pipefail

# Variables
DOTFILES="$HOME/.dotfiles"

# Sources
source $(dirname $0)/utils/color_codes.sh
source $(dirname $0)/utils/logging_utils.sh
source $(dirname $0)/utils/functions.sh

traperr() {
	echo "ERROR: ${BASH_SOURCE[1]} at about ${BASH_LINENO[0]}"
}

set -o errtrace
trap traperr ERR

#---------------------------------------------------------------------------------------------

# Begin Script

# Show Header

show_header
sleep 2

# Display 5 second count down before excution
for i in $(seq 5 -1 1); do
	echo -ne "$i\rGetting ready to proceed with the automation in... "
	sleep 1
done

echo ""

printf "${Purple}
####################################################
#${NC}                📁   ${BWhite}Pre-Config${NC}   📁              ${Purple}#
####################################################${NC}"
sleep 1
c_info "We need to check some preliminary things before we can really get to work..."
sleep 1

# Create bin folder if it doesn't exist
if [ -d "${HOME}/bin" ]; then
  c_success "💜 /bin directory exists!"
fi
if [[ ! -d "${HOME}/bin" ]]; then
  mkdir "${HOME}/bin"
  c_success "💜 Created /bin directory!"
fi

# Create python_env folder if it doesn't exist
if [ -d "${HOME}/python_env" ]; then
  c_success "💜 /python_env directory exists!"
fi
if [[ ! -d "${HOME}/python_env" ]]; then
  mkdir "${HOME}/python_env"
  c_success "💜 Created /python_env directory!"
fi

c_info "Getting on with the rest of it..."
sleep 1

# 3rd-Party PPA lists
echo -e "${BPurple}
####################################################
#${NC}              🌏  ${BWhite}3rd-party PPAs${NC}  🌏              ${BPurple}#
####################################################${NC}"
sleep 1
c_info "This step adds the private repositories for Ubuntu, Git, Docker, and NGINX, amongst others, so that we can be sure they are always the most up-to-date version."
sleep 1
c_question "Do you want to add the PPAs? [y/n]"
read ppa_answer
case "$ppa_answer" in
y | Y | yes | Yes)
	c_hilight "Adding PPAs..."
	add_ppas
	c_success "PPA list is updated!"
	;;
n | N | no | No)
	c_error "Skipping adding PPAs..."
	;;
*)
	c_warning "Please respond with yes or no..."
	;;
esac
sleep 1

# System Updates
echo -e "${BPurple}
####################################################
#${NC}              💻  ${BWhite}System Update${NC}  💻               ${BPurple}#
####################################################${NC}"
sleep 1
c_info "This step performs system updates. This step is reccommended to ensure a secure system!"
sleep 1
c_question "Do you want to perform a system update? [y/n]"
read update_answer
case $update_answer in
y | Y | yes | Yes)
	c_success "Performing system updates..."
	update_system
	;;
n | N | no | No)
	c_warning "Skipping system updates"
	;;
*)
	c_warning "Please respond with yes or no"
	;;
esac
sleep 1

# Package Installation, pulled from ./utils/packages.txt
echo -e "${BPurple}
####################################################
#${NC}           📦  ${BWhite}Package Installation${NC}  📦          ${BPurple}#
####################################################${NC}"
sleep 1
c_info "This step looks for a base packages list at ~/.dotfiles/utils/lists/packages.list and installs those packages."
sleep 1
c_question "Do you want to install base packages? [y/n]"
read apt_answer
case "$apt_answer" in
y | Y | yes | Yes)
	c_success "Installing packages..."
	install_packages
	;;
n | N | no | No)
	c_warning "Skipping package installation"
	;;
*)
	c_warning "Please respond with yes or no"
	;;
esac
sleep 1

# Install NVM and Node
echo -e "${BPurple}
####################################################
#${NC}        🧡  ${BWhite}NVM (Node Version Manager)${NC}  🧡        ${BPurple}#
####################################################${NC}"
sleep 1
if type "nvm" >/dev/null; then
	c_success "🧡 NVM is already installed!"
fi
if ! type "nvm" >/dev/null; then
	c_info "NVM (Node Version Manager) grants the ability to have multiple NodeJS versions installed, and manage them efficiently. It doesn't look like 🧡 NVM is currently installed..."
	sleep 1
	c_question "Would you like to install NVM and the latest LTS version of NodeJS? [y/n]"
	read node_answer
	case "$node_answer" in
	y | Y | yes | Yes)
		c_success "Installing NVM/Node..."
		install_node
		c_success "🧡 NVM/Node has been installed!"
		;;
	n | N | no | No)
		c_warning "Skipping 🧡 Node installation..."
		;;
	*)
		c_warning "Please respond with yes or no"
		;;
	esac
fi
sleep 1

# Finishing Steps
echo -e "${BPurple}
####################################################
#${NC}             🍻  ${BWhite}Finish Installation${NC}  🍻          ${BPurple}#
####################################################${NC}"
sleep 1
c_info "This step finalizes the creation of symlinks, PATH edits, and etc."

ln -s ${HOME}/.dotfiles/bin/* ${HOME}/bin

"export PATH="${HOME}/bin/:$PATH"" >> ~/.bashrc
"export PATH="${HOME}/bin/python_env:$PATH"" >> ~/.bashrc

# Script Finished
sleep 5
c_success "That's it, we've finished everything on the list!"
sleep 2
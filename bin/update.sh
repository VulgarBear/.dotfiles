#!/usr/bin/env bash

# Config
#    Using '-e' ensures the script will exit if it encounters an error.
set -e
set -o pipefail

# Variables
DOTFILES="$HOME/.dotfiles"

# Sources
source $HOME/.dotfiles/utils/color_codes.sh
source $HOME/.dotfiles/utils/logging_utils.sh
source $HOME/.dotfiles/utils/functions.sh

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

# Finishing Steps
echo -e "${BPurple}
####################################################
#${NC}             🍻  ${BWhite}Finish Installation${NC}  🍻          ${BPurple}#
####################################################${NC}"
sleep 1
c_info "This step finalizes the creation of symlinks, PATH edits, and etc."

ln -s ${HOME}/.dotfiles/bin/* ${HOME}/bin

#echo "export PATH="/bin/:$PATH"" >> ~/.bashrc
#echo "export PATH="/bin/python_env:$PATH"" >> ~/.bashrc

# Script Finished
sleep 5
c_success "That's it, we've finished everything on the list!"
sleep 2
clear
#!/usr/bin/env bash

# Sources
source $(dirname $0)/utils/color_codes.sh
source $(dirname $0)/utils/logging_utils.sh

# Variables
DOTFILES="$HOME/.dotfiles"
DOTFILES_UTILS="${DOTFILES}/utils"
DOTFILES_LISTS="${DOTFILES_UTILS}/lists"

LOGFILE='install-log'

dest="${HOME}/${1}"
old=".OLD"

# Functions

# Show Header
function show_header() {
  clear
  cat ${DOTFILES}/extras/vulgar_header
}

# Update 3rd-Party PPAs
function add_ppas() {
	##	Git
	sudo add-apt-repository ppa:git-core/ppa -y
	## OpenJDK
	sudo add-apt-repository ppa:openjdk-r/ppa -y
	##	Github
	sudo apt-key adv --keyserver keyserver.ubuntu.com --recv-key C99B11DEB97541F0
	sudo apt-add-repository https://cli.github.com/packages
	##	Docker
	curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
	sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable"
	##	Ubuntu Universe
	sudo add-apt-repository universe -y
}

# Update System
function update_system() {
	sudo apt-get update && sudo apt-get upgrade -y >> ${LOGFILE}
	sudo apt-get dist-upgrade -f >> ${LOGFILE}
	sudo apt autoremove -y >> ${LOGFILE}
}

# Install Packages
function install_packages() {
	## Install dos2unix and use to fix any formatting issues
	if [ -f "${DOTFILES_LISTS}/packages.txt" ]; then
		c_success "Found Packages list. Installing..."
		if ! dpkg-query -W -f='${Status} ${Version}\n' dos2unix | grep "^install ok" >/dev/null; then
			c_install "Installing package dos2unix for formating "
			sudo apt -y install dos2unix
			dos2unix -q ${DOTFILES_LISTS}/packages.txt
			c_info "packages.txt file formatted"
		else
			dos2unix -q ${DOTFILES_LISTS}/packages.txt
			c_info "packages.txt file formatted"
		fi
	fi
	##	Looks for a list of default packages to install
	if [ -f "${DOTFILES_LISTS}/packages.txt" ]; then
		for i in $(cat ${DOTFILES_LISTS}/packages.txt); do
			if ! dpkg-query -W -f='${Status} ${Version}\n' ${i} | grep "^install ok" >/dev/null; then
				c_install "Installing package ${i} "
				sudo apt -y install ${i}
			else
				c_success "Package ${i} is already installed. Skipping..."
			fi
		done
	else
		c_error "No Packages file found. Skipping package installation..."
	fi
}

# Install Dev Packages
function install_dev_packages() {
	## Install dos2unix and use to fix any formatting issues
	if [ -f "${DOTFILES_LISTS}/dev_packages.txt" ]; then
		c_success "Found Packages list. Installing..."
		if ! dpkg-query -W -f='${Status} ${Version}\n' dos2unix | grep "^install ok" >/dev/null; then
			c_install "Installing package dos2unix for formating "
			sudo apt -y install dos2unix
			dos2unix -q ${DOTFILES_LISTS}/dev_packages.txt
			c_info "dev_packages.txt file formatted"
		else
			dos2unix -q ${DOTFILES_LISTS}/dev_packages.txt
			c_info "dev_packages.txt file formatted"
		fi
	fi
	##	Looks for a list of default packages to install
	if [ -f "${DOTFILES_LISTS}/dev_packages.txt" ]; then
		for i in $(cat ${DOTFILES_LISTS}/dev_packages.txt); do
			if ! dpkg-query -W -f='${Status} ${Version}\n' ${i} | grep "^install ok" >/dev/null; then
				c_install "Installing package ${i} "
				sudo apt -y install ${i}
			else
				c_success "Package ${i} is already installed. Skipping..."
			fi
		done
	else
		c_error "No Packages file found. Skipping package installation..."
	fi
}

# Install NVM and Node
function install_node() {

	##	Starts off by installing NVM [https://github.com/nvm-sh/nvm] which allows for multiple NodeJS
	##	versions to be installed. It also looks for a list of default packages to be installed with
	##	every Node version, and modifies the ~/.bashrc file to load NVM and Bash_Completion.

	echo >>~/.bashrc
	echo "# Set up NVM" >>~/.bashrc
	curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.38.0/install.sh | bash

	export NVM_DIR="$([ -z "${XDG_CONFIG_HOME-}" ] && printf %s "${HOME}/.nvm" || printf %s "${XDG_CONFIG_HOME}/nvm")"
	[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"                 # This loads nvm
	[[ -r $NVM_DIR/bash_completion ]] && \. $NVM_DIR/bash_completion # This loads nvm bash_completion

	##	Check for a default packages list to install with every project
	if [ -f ${DOTFILES_CONFIG}/.nvm/default_packages ]; then
		cp ${DOTFILES_CONFIG}/.nvm/default_packages ~/.nvm/default-packages
	fi

	nvm install --lts
	nvm use --lts
}

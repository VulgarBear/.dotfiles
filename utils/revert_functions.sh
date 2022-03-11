#!/usr/bin/env bash

# Sources
source $(dirname $0)/utils/color_codes.sh
source $(dirname $0)/utils/logging_utils.sh

# Variables
DOTFILES="$HOME/.dotfiles"
DOTFILES_UTILS="${DOTFILES}/utils"
DOTFILES_LISTS="${DOTFILES_UTILS}/lists"

LOGFILE='revert-log'

# Functions

# Show Header
function show_header() {
  clear
  cat ${DOTFILES}/extras/vulgar_header
}

# Update 3rd-Party PPAs
function add_ppas() {
	##	Git
	sudo add-apt-repository --remove ppa:git-core/ppa -y
	## OpenJDK
	sudo add-apt-repository --remove ppa:openjdk-r/ppa -y
	##	Ubuntu Universe
	sudo add-apt-repository --remove universe -y
}

# Remove Packages
function install_packages() {
	## Install dos2unix and use to fix any formatting issues
	if [ -f "${DOTFILES_LISTS}/packages.txt" ]; then
		c_success "Found Packages list. Removing..."
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
        c_success "Package ${i} is already removed. Skipping..."
			else
				c_install "Removing package ${i} "
        sudo apt -y remove ${i}
			fi
		done
	else
		c_error "No Packages file found. Skipping package removal..."
	fi
}

# Remove Dev Packages
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
	##	Looks for a list of default packages to remove
	if [ -f "${DOTFILES_LISTS}/dev_packages.txt" ]; then
		for i in $(cat ${DOTFILES_LISTS}/dev_packages.txt); do
			if ! dpkg-query -W -f='${Status} ${Version}\n' ${i} | grep "^install ok" >/dev/null; then
        c_success "Package ${i} is already removed. Skipping..."
			else
				c_install "Removing package ${i} "
        sudo apt -y remove ${i}
			fi
		done
	else
		c_error "No Packages file found. Skipping package installation..."
	fi
}
#!/usr/bin/env bash
#Create python venv folder if none present
[[ ! -d "${HOME}/python_env" ]] && mkdir "${HOME}/python_env"
ENV_PATH="$HOME/python_env/"

read -e -p "
Do you wish to create $1 ? [Y/n] " YN

[[ $YN == "y" || $YN == "Y" || $YN == "" ]] && python3 -m venv $ENV_PATH/$1
#!/usr/bin/env bash
ENV_PATH="$HOME/python_env/$1/bin/activate"

read -e -p "
Do you wish to activate $1 ? [Y/n] " YN

[[ $YN == "y" || $YN == "Y" || $YN == "" ]] && bash --rcfile $ENV_PATH -i
#!/usr/bin/env bash
ENV_PATH="$HOME/python_env/"

read -e -p "
Do you wish to create $1 ? [Y/n] " YN

[[ $YN == "y" || $YN == "Y" || $YN == "" ]] && rm -rf $ENV_PATH/$1
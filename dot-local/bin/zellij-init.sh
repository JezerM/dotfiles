#!/bin/zsh

path+=("/opt/homebrew/bin/" "/usr/local/bin/")

zellij -l welcome
exec $SHELL

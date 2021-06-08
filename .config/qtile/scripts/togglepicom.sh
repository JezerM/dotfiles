#!/usr/bin/env bash

if [ -f $HOME/.bashadds ]; then
	. $HOME/.bashadds
fi

picom=$(pgrep picom)

if [ -z $picom ]; then
  picom --experimental-backends --config ~/.config/picom/picon.conf &
else
  pkill picom
fi

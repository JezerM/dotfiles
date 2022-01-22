#!/bin/env bash
set -euo pipefail

xset s 0
xset +dpms
xset dpms 0 0 0
xset r rate 500 35

function run {
  if ! pgrep -f $1 ;
  then
    echo $@
    $@&
  fi
}

run picom --experimental-backends --config ~/.config/picom/picom.conf -b
setxkbmap -layout latam,us -option caps:none
xmodmap ~/.Xmodmap
bash "$HOME/xidlelock.sh" &

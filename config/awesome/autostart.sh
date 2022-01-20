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

background="$HOME/Imágenes/gruvbox_street.png"
lockscreen="$HOME/Imágenes/Halifax_Sunset_by_Vlad_Drobinin.jpg"

run picom --experimental-backends --config ~/.config/picom/picom.conf -b
#feh --bg-fill $background &
#run feh-blur -d --blur 4 --darken 10
#run dunst
#run flashfocus
echo $lockscreen
#betterlockscreen -u $lockscreen &
setxkbmap -layout latam,us -option caps:none
xmodmap ~/.Xmodmap
#run dropbox start
#run redshift-gtk -m randr -l 12.15:-86.27 -t 6500:3500
#run light-locker
bash "$HOME/xidlelock.sh" &

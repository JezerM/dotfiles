#!/bin/bash
set -euo pipefail

# This are just some PATH exports 'cause picom had throwing me some errors... 
export PKG_CONFIG_PATH=/home/jezer/Descargas/xcb-util-xrm/:/usr/lib/x86_64-linux-gnu/pkgconfig/
export LD_LIBRARY_PATH=/home/linuxbrew/.linuxbrew/Cellar/libconfig/1.7.2/lib/:/home/linuxbrew/.linuxbrew/Cellar/pcre/8.44/lib/
export PATH=$PATH:/home/jezer/.local/bin/


xset s 0 0
xset dpms 0 0 0
xset r rate 600 35

function run {
  if ! pgrep -f $1 ;
  then
    $@&
  fi
}


run picom --experimental-backends --config ~/.config/picom/picon.conf
feh --bg-fill "$HOME/Imágenes/dnord4k_dark.png" &
run feh-blur -d
setxkbmap -layout latam &
run dropbox start
#run dunst
run flashfocus
run redshift-gtk -l 12.1518:-86.2711
key-mapper-control --command autoload &
betterlockscreen -u "$HOME/Imágenes/dnord4k_dark.png" &
bash "$HOME/xidlelock.sh" &

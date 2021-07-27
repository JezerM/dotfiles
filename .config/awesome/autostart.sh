#!/bin/bash
set -euo pipefail

# This are just some PATH exports 'cause picom had throwing me some errors... 
export PKG_CONFIG_PATH=/home/jezer/Descargas/xcb-util-xrm/:/usr/lib/x86_64-linux-gnu/pkgconfig/
export LD_LIBRARY_PATH=/home/linuxbrew/.linuxbrew/Cellar/libconfig/1.7.2/lib/:/home/linuxbrew/.linuxbrew/Cellar/pcre/8.44/lib/
export PATH=$PATH:/home/jezer/.local/bin/


xset s 0
xset +dpms
xset dpms 0 0 0
xset r rate 500 35

function run {
  if ! pgrep -f $1 ;
  then
    $@&
  fi
}

background="$HOME/Imágenes/gruvbox_street.png"
lockscreen="$HOME/Imágenes/Halifax_Sunset_by_Vlad_Drobinin.jpg"

run picom --experimental-backends --config ~/.config/picom/picom.conf
#feh --bg-fill $background &
#run feh-blur -d --blur 4 --darken 10
setxkbmap -layout latam
run dropbox start
#run dunst
run flashfocus
run redshift-gtk -m randr -l 12.15:-86.27 -t 6500:3500
#key-mapper-control --command autoload &
xmodmap ~/.Xmodmap
echo $lockscreen
betterlockscreen -u $lockscreen &
light-locker &
bash "$HOME/xidlelock.sh" &

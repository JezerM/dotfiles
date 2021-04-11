#!/bin/bash
set -euo pipefail

export PKG_CONFIG_PATH=/home/jezer/Descargas/xcb-util-xrm/:/usr/lib/x86_64-linux-gnu/pkgconfig/
export LD_LIBRARY_PATH=/home/linuxbrew/.linuxbrew/Cellar/libconfig/1.7.2/lib/:/home/linuxbrew/.linuxbrew/Cellar/pcre/8.44/lib/
export PATH=$PATH:/home/jezer/.local/bin/


xset s 0 0
xset dpms 0 0 0
xset r rate 600 35


picom --experimental-backends --config ~/.config/picom/picon.conf &
feh --bg-fill "~/Imágenes/dnord4k_dark.png" & 
feh-blur -d &
setxkbmap -layout latam &
dunst &
flashfocus &
redshift-gtk -l 12.1518:-86.2711 &
bash "/home/jezer/xidlelock.sh" &
dropbox start &
eww daemon &
sleep 3
eww open noneBar &


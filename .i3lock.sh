#!/bin/env bash

B='#00000000'  # blank
C='#ffffff22'  # clear ish
D='#81a1c1cc'  # default
T='#88c0d0ee'  # text
W='#bf616aee'  # wrong
V='#5e81acbb'  # verifying
L='#4c566aaa'  # inside

revert() {
  xset dpms 0 0 0
}
trap revert HUP INT TERM
xset +dpms dpms 10 10 10

i3lock \
-n \
--redraw-thread \
--color="#00000000" \
--insidevercolor=$C   \
--ringvercolor=$V     \
\
--insidewrongcolor=$C \
--ringwrongcolor=$W   \
\
--insidecolor=$L      \
--ringcolor=$D        \
--linecolor=$B        \
--separatorcolor=$D   \
\
--verifcolor=$T        \
--wrongcolor=$T        \
--timecolor=$T        \
--datecolor=$T        \
--layoutcolor=$T      \
--keyhlcolor=$W       \
--bshlcolor=$W        \
\
--screen 1            \
--blur 8              \
--clock               \
--indicator           \
--timestr="%I:%M:%S %p"  \
--datestr="%A, %d-%m-%Y" \
--keylayout 1         \
--radius 120 \
--ring-width 12 \
\
--pass-screen-keys \
--pass-volume-keys \
--pass-media-keys

revert


#--greetertext=$(whoami) \
#--greetersize=20 \
#--greetercolor=$T \
#--greeterpos x+w/2:y+h/2+150 \
#\
#--no-verify \

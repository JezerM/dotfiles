#!/usr/bin/env bash

# Only exported variables can be used within the timer's command.
export PRIMARY_DISPLAY="$(xrandr | awk '/ primary/{print $1}')"

timeToLock=$((15*60))
#timeToLock=$((10))
dim="bash ~/.lock.sh dim &"
reset="bash ~/.lock.sh reset"

# Run xidlehook
xidlehook \
  `# Don't lock when there's a fullscreen application` \
  --not-when-fullscreen \
  `# Don't lock when there's audio playing` \
  --not-when-audio \
  `# Dim screen` \
  --timer $timeToLock \
    "$dim" \
    "$reset" \
  `# Then, lock` \
  --timer 10 \
    "$reset && light-locker-command -l" \
    '' \
  `# Finally, suspend an hour after it locks` \
  --timer 3600 \
    'systemctl suspend' \
    '' \
  `# Socket` \
  --socket /tmp/xidlehook.sock

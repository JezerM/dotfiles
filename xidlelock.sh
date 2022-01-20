#!/usr/bin/env bash

if pgrep -f xidlehook; then
  echo "xidlehook running"
  pkill xidlehook
fi

# Only exported variables can be used within the timer's command.
export PRIMARY_DISPLAY="$(xrandr | awk '/ primary/{print $1}')"

timeToLock=$((15*60))
#timeToLock=$((10))

# Run xidlehook
xidlehook \
  `# Don't lock when there's a fullscreen application` \
  --not-when-fullscreen \
  `# Don't lock when there's audio playing` \
  --not-when-audio \
  `# Dim the screen after 60 seconds, undim if user becomes active` \
  --timer $timeToLock \
    'brightnessctl --save --quiet && brightnessctl s 10% --quiet' \
    'brightnessctl --restore --quiet' \
  `# Then, lock` \
  --timer 10 \
    "light-locker-command -l && brightnessctl --restore --quiet" \
    '' \
  `# Finally, suspend an hour after it locks` \
  --timer 3600 \
    'systemctl suspend' \
    '' \
  `# Socket` \
  --socket /tmp/xidlehook.sock

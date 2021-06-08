#!/usr/bin/env bash

# Only exported variables can be used within the timer's command.
export PRIMARY_DISPLAY="$(xrandr | awk '/ primary/{print $1}')"

timeToLock=$((10*60))
timeNotify=30

# Run xidlehook
xidlehook \
  `# Don't lock when there's a fullscreen application` \
  --not-when-fullscreen \
  `# Don't lock when there's audio playing` \
  --not-when-audio \
  `# Lock after 30 more seconds` \
  --timer $timeToLock \
    'betterlockscreen -l dimblur' \
    '' \
  `# Finally, suspend an hour after it locks` \
  --timer 3600 \
    'systemctl suspend' \
    '' \
  `# Socket` \
  --socket /tmp/xidlehook.sock

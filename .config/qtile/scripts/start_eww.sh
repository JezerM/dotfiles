#!/usr/bin/env bash

eww daemon &

exists=1

sleep 1

eww=$(pgrep eww)

while [ $exists == 1 ]; do
  if [ -z $eww ]; then
    :
  else
    exists=0
  fi
done

sleep 5

eww open noneBar

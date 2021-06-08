#!/usr/bin/env bash

value=5

mute() {
  pulsemixer --toggle-mute
}

up() {
  pulsemixer --max-volume 100
  if [[ $1 ]]; then
    pulsemixer --change-volume +$1
  else
    pulsemixer --change-volume +$value
  fi
}

down() {
  if [[ $1 ]] ; then
    pulsemixer --change-volume -$1
  else
    pulsemixer --change-volume -$value
  fi
}

setV() {
  pulsemixer --set-volume $1
}

main() {
  case $1 in
    up)
      up $2
      ;;
    down)
      down $2
      ;;
    mute)
      mute
      ;;
    set)
      setV $2
      ;; 
  esac
}

main $1 $2

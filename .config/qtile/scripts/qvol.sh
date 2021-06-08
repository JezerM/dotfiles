#!/usr/bin/env bash

value=5

mute() {
  pulsemixer --toggle-mute
}

up() {
  change=""
  if [[ $1 ]]; then
    change=$1
  else
    change=$value
  fi
  pulsemixer --change-volume +${change} --max-volume 100
}

down() {
  change=""
  if [[ $1 ]]; then
    change=$1
  else
    change=$value
  fi
  pulsemixer --change-volume -${change} --max-volume 100
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

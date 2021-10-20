#!/usr/bin/env bash

dim() {
  echo $BASHPID > /tmp/xidlelock-pid
  actual=$(xbacklight -get)
  echo "$actual" > /tmp/xbacklight-actual
  xbacklight -set 1 -time 10000 -steps 140
}

reset() {
  pid=$(< /tmp/xidlelock-pid)
  actual=$(< /tmp/xbacklight-actual)
  pkill -P $pid
  if [ -z $actual ]; then actual=50; fi
  xbacklight -set "$actual" -steps 10 &
}

case $1 in
  dim)
    dim
    ;;
  reset)
    reset
    ;;
esac

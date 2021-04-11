#!/usr/bin/env bash

bar="noneBar"
state=$(eww windows | grep $bar)

if [ "$state" == "*${bar}" ]; then
  eww close $bar
else
  eww open $bar
fi

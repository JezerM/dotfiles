#!/bin/zsh

path+=("/opt/homebrew/bin/" "/usr/local/bin/")

IFS=$'\n'

sessions=($(tmux list-sessions))
session_names=($(tmux list-sessions -F "#S"))

# Enable alternative screen buffer
echo -en "\e[?1049h"
echo -en "\e[H"

k=1

echo "Available tmux sessions:"
for i in "${sessions[@]}"; do
  echo "\e[1m$k\e[m - $i"
  ((k++))
done

echo -en "\n\n"

# Print help messages
echo -en "\e[2m- [string] to create a session with any name\e[m\n"
echo -en "\e[2m- Empty to create a new session\e[m\n"
echo -en "\e[2m- \"0\" to run default shell\e[m"

echo -en "\e[3A\e[G"

# Read input from user
echo -n "Choose: "
read -r input
echo

# Disable alternative screen buffer
echo -en "\e[?1049l"

if [[ $input == "" ]]; then
  tmux new-session
  exit "$?"
elif [[ $input == "0" ]]; then
  if [ -v SHELL ]; then
    $SHELL
    exit "$?"
  fi
  echo "No \$SHELL set"
  sleep 5
  exit 1
elif [[ $input =~ ^[0-9]+$ ]] && [[ $input -le ${#sessions[@]} ]]; then
  name="${session_names[input]}"
  tmux attach -t "$name"
  exit "$?"
else
  tmux new-session -s "$input"
  exit "$?"
fi

#!/usr/bin/env bash

basedir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

files=$(ls -a $basedir)

ignore=(
  "."
  ".."
  ".git"
  ".gitignore"
)
dorecursive=(
  ".config"
)

array_contains () { 
    local array="$1[@]"
    local seeking=$2
    local in=1
    for element in "${!array}"; do
        if [[ $element == "$seeking" ]]; then
            in=0
            break
        fi
    done
    return $in
}


recursive() {
  local recurDir=$1
  local recursiveFiles=$(ls -a "$basedir/$recurDir")
  echo "Trying to add the directory: $baseDir/$recurDir  to  $HOME/$recurDir/"
  if [ -d "$HOME/$recurDir" ]; then
    :
  else
    mkdir "$HOME/$recurDir/"
    echo "$HOME/$recurDir created"
  fi

  local c=0
  for fil in $recursiveFiles; do
    if [ -d "$HOME/$recurDir/$fil" ]; then
      continue
    fi
    c=1
    ln -s "$basedir/$recurDir/$fil" "$HOME/$recurDir/$fil"
    # echo "$basedir/$recurDir/$fil  to  $HOME/$recurDir/$fil"
    echo "$HOME/$recurDir/$fil added"
  done

  if [ $c == "0" ]; then
    echo "Nothing added to $HOME/$recurDir/"
  fi
}


for file in $files; do
  if $(array_contains ignore $file); then
    continue
  elif $(array_contains dorecursive $file); then
    recursive $file
    continue
  fi

  if [ -f "$HOME/$file" ]; then
    :
  else
    ln -s "$basedir/$file" "$HOME/$file"
    echo $file added
  fi
done

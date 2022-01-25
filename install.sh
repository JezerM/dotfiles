#!/usr/bin/env bash

basedir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

files=$(ls -a $basedir)

ignore=(
  "."
  ".."
  ".git"
  ".gitignore"
  "misc"
)
dorecursive=(
  "config"
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
  local targetDir=$1
  if [ "$targetDir" == "config" ]; then
    targetDir=".config"
  fi
  local recursiveFiles=$(ls -a "$basedir/$recurDir")
  echo "Trying to add the directory: $baseDir/$recurDir  to  $HOME/$targetDir/"
  if [ -d "$HOME/$targetDir" ]; then
    :
  else
    mkdir "$HOME/$targetDir/"
    echo "$HOME/$targetDir created"
  fi

  local c=0
  for fil in $recursiveFiles; do
    if [ -d "$HOME/$targetDir/$fil" ]; then
      continue
    fi
    c=1
    ln -sf "$basedir/$recurDir/$fil" "$HOME/$targetDir/$fil"
    # echo "$basedir/$recurDir/$fil  to  $HOME/$targetDir/$fil"
    echo "$HOME/$targetDir/$fil added"
  done

  if [ $c == "0" ]; then
    echo "Nothing added to $HOME/$targetDir/"
  fi
}

install_nvim() {
  # Taken from https://github.com/wbthomason/packer.nvim#quickstart
  echo "Installing packer.nvim..."
  if [ ! -d "$HOME/.local/share/nvim/site/pack/packer/start/packer.nvim" ]; then
    git clone --depth 1 https://github.com/wbthomason/packer.nvim\
      ~/.local/share/nvim/site/pack/packer/start/packer.nvim
  else
    echo "packer.nvim already installed"
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

install_nvim

# vim: expandtab

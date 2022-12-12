#!/usr/bin/env bash

projectLocation="$(dirname "$(readlink -f "$0")")"
projectHome="$projectLocation/configs/home"
projectDependencies="$projectLocation/dependencies"
homeDependencies="$HOME/.dotfiles-dependencies"
homeBackUp="$HOME/.dotfiles.bak"
userOverrides="$HOME/.dotfile-overrides"

mapfile -t homeFiles < <(ls -A "$projectHome")

usage() {
  local exitCode=$1

  if [[ -z $1 ]]; then
    local exitCode=2
  fi

  printf 'Usage %s:\n' "$0"
  printf '\t-c, --create  \t\t Create symlinks to the project configs\n'
  printf '\t-r, --restore \t\t Restore the original files\n'
  printf '\t-R, --restore-full \t Restore the original files and remove the %s directory\n' "$userOverrides"
  exit $exitCode
}

PARSED_ARGUMENTS=$(getopt -n manage-links -o chr --long create,help,restore -- "$@")
VALID_ARGUMENTS=$?
if [ "$VALID_ARGUMENTS" != "0" ]; then
  usage
fi

eval set -- "$PARSED_ARGUMENTS"
while :; do
  case "$1" in
  -c | --create)
    CREATE=1
    shift
    ;;
  -h | --help)
    usage 0
    shift
    ;;
  -r | --restore)
    RESTORE=1
    shift
    ;;
  -R | --restore-full)
    RESTORE=1
    REMOVE_OVERRIDES=1
    shift
    ;;
  --)
    shift
    break
    ;;
  *)
    echo "Unexpected option: $1"
    usage
    ;;
  esac
done

if [[ -v CREATE ]]; then
  # Create backup directory
  mkdir -p "$homeBackUp"
  # Create override directory
  mkdir -p "$userOverrides"

  for FILE in "${homeFiles[@]}"; do
    if [[ -L "$HOME/$FILE" ]] && [[ "$(readlink -f "$HOME/$FILE")" == "$projectHome/$FILE" ]]; then
      # Looks like this file has already been symlinked
      continue
    fi

    if [[ -f "$HOME/$FILE" ]]; then
      #  Backup any existing config
      mv "$HOME/$FILE" "$homeBackUp/$FILE"
    fi

    # Link file to home directory
    ln -s "$projectHome/$FILE" "$HOME/$FILE"
  done

  #  Link project dependencies
  ln -s "$projectDependencies" "$homeDependencies"
elif [[ -v RESTORE ]]; then
  for FILE in "${homeFiles[@]}"; do
    # When the file exists and is a link to our project, we can safely remove it
    if [[ -L "$HOME/$FILE" ]] && [[ "$(readlink -f "$HOME/$FILE")" == "$projectHome/$FILE" ]]; then
      rm "$HOME/$FILE"
    fi
  done

  if [[ -d "$homeBackUp" ]]; then
    mapfile -t backups < <(ls -A "$homeBackUp")
    if [[ -n ${backups[*]} ]]; then
      for FILE in "${backups[@]}"; do
        mv "$homeBackUp/$FILE" "$HOME"
      done

      rm -r "$homeBackUp"
    fi
  fi

  if [[ -v $REMOVE_OVERRIDES ]]; then
    rm -rf "$userOverrides"
  fi

  rm -r "$homeDependencies"
else
  usage
fi

echo "Now type \". $HOME/.bashrc\""

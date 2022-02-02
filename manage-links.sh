#!/usr/bin/env bash

set -x

projectLocation="$(dirname "$(readlink -f "$0")")"
projectHome="$projectLocation/configs/home"
projectDependencies="$projectLocation/dependencies"
homeDependencies="$HOME/.dotfiles-dependencies"
homeBackUp="$HOME/.dotfiles.bak"

homeFiles=(
    .bash_aliases
    .bash_ps # Depends on git-prompt
    .bash_ssh
    .bashrc
    .gitconfig
    .vimrc
)

# depFiles=(
#     git-prompt/.git-prompt.sh
# )

usage() {
  local exitCode=$1

  if [[ -z $1 ]]; then
    local exitCode=2
  fi

  printf 'Usage %s:\n' "$0"
  printf '\t\t-c, --create  \t Create the links\n'
  printf '\t\t-r, --restore \t Restore the original files\n'
  exit $exitCode
}

PARSED_ARGUMENTS=$(getopt -n manage-links  -o chr --long create,help,restore -- "$@")
VALID_ARGUMENTS=$?
if [ "$VALID_ARGUMENTS" != "0" ]; then
  usage
fi

eval set -- "$PARSED_ARGUMENTS"
while :
do
  case "$1" in
    -c | --create)    CREATE=1 ; shift ;;
    -h | --help)      usage 0; shift ;;
    -r | --restore)   RESTORE=1 ; shift ;;
    --) shift; break ;;
    *) echo "Unexpected option: $1"
       usage ;;
  esac
done

if [[ -v CREATE ]]; then
  for FILE in "${homeFiles[@]}"; do
    mkdir -p "$homeBackUp"

    if [[ -f "$HOME/$FILE" ]]; then
        mv "$HOME/$FILE" "$homeBackUp/$FILE"
    fi

    ln -s "$projectHome/$FILE" "$HOME/$FILE"
  done

  ln -s "$projectDependencies" "$homeDependencies"
elif [[ -v RESTORE ]]; then
  for FILE in "${homeFiles[@]}"; do
    # When the file exists and is a link to our project, we can safely remove it
    if [[ -f "$HOME/$FILE" ]] && [[ "$(readlink -f "$HOME/$FILE")" == $projectHome/$FILE ]]; then
      rm "$HOME/$FILE"
    fi
  done

  if [[ -d "$homeBackUp" ]]; then
    if [[ -n "$(ls -A "$homeBackUp")" ]]; then
      # shellcheck disable=SC2045
      for FILE in $(ls -A "$homeBackUp"); do
      mv "$homeBackUp/$FILE" "$HOME"
      done

      rm -r "$homeBackUp"
    fi
  fi

  rm -r "$homeDependencies"
else
  usage
fi

echo "Now type \". $HOME/.bashrc\""

#!/usr/bin/env bash

brew update
brew outdated
brew upgrade
bew autoremove --scrub
brew cleanup

# PurplProto's Dotfiles

Linux/MacOS dotfiles.

## Requirements

- [Chezmoi](https://www.chezmoi.io/install/)
- [1Password CLI](https://developer.1password.com/docs/cli/get-started/)
- [Zsh](https://github.com/ohmyzsh/ohmyzsh/wiki/Installing-ZSH#how-to-install-zsh-on-many-platforms)
  - Don't forget to `chsh`!
- [OhMyZsh](https://ohmyz.sh/#install)
- OhMyPosh
  - [Linux](https://ohmyposh.dev/docs/installation/linux)
  - [MacOS](https://ohmyposh.dev/docs/installation/macos)

## Quick usage

- Ensure you're logged into 1Password `op signin`
- Apply dotfiles `chezmoi init && chezmoi -v apply`

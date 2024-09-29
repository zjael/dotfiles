# Dotfiles

## Dependencies

* [Yabai](https://github.com/koekeishiya/yabai) window management utility
* [Skhd](https://github.com/koekeishiya/skhd) hotkey daemon

## Install

```bash
brew install stow
cd dotfiles
stow .
```

## Nice to have

Reduce the dock hide & unhide delay

```bash
defaults write com.apple.dock "autohide-delay" -float "0" && killall Dock
```

## Bundle/store homebrew packages

```bash
brew bundle dump --force --brews --casks --taps --mas --file=~/.dotfiles/Brewfile
```

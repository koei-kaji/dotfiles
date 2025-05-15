# dotfiles

To manage my custom dotfiles

## Prerequisites

- neovim
- zsh
- homebrew

## How to link dotfiles

```bash
chmod +x link_dotfiles.sh
./link_dotfiles.sh
```

## ~/.gitconfig

```
[core]
    pager = delta
[include]
  path = ~/.config/delta/themes/catppuccin/catppuccin.gitconfig
[delta]
  keep-plus-minus-markers = true
  navigate = true
  line-numbers = true
  features = catppuccin-macchiato
  minus-style = "#F38BA8 #44252A"   # テキスト色 背景色
  plus-style = "#A6E3A1 #2A4D34"    # テキスト色 背景色
```

## tmux plugins

```zsh
./clone_tmux_plugins.sh
```

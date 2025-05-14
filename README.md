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

## ~/.gitconfig の設定

以下を追記

### for lazygit

```
[core]
    pager = delta --dark --keep-plus-minus-markers
```

### for delta

```
[delta]
  line-numbers = true
  minus-style                   = syntax "#602a3a"
  minus-non-emph-style          = syntax "#602a3a"
  minus-emph-style              = syntax "#803f4f"
  minus-empty-line-marker-style = syntax "#602a3a"
  line-numbers-minus-style      = "#db4b4b"
  plus-style                    = syntax "#1a3449"
  plus-non-emph-style           = syntax "#1a3449"
  plus-emph-style               = syntax "#265566"
  plus-empty-line-marker-style  = syntax "#1a3449"
  line-numbers-plus-style       = "#4097aa"
  line-numbers-zero-style       = "#565f89"
```

## colorscheme

[folke/tokyonight.nvim: 🏙 A clean, dark Neovim theme written in Lua, with support for lsp, treesitter and lots of plugins. Includes additional themes for Kitty, Alacritty, iTerm and Fish.](https://github.com/folke/tokyonight.nvim)

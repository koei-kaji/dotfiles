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
    pager = delta --side-by-side
```

### for delta

```
[delta]
    line-mumbers = true
    minus-style                   = syntax "#37222c"
    minus-non-emph-style          = syntax "#37222c"
    minus-emph-style              = syntax "#713137"
    minus-empty-line-marker-style = syntax "#37222c"
    line-numbers-minus-style      = "#914c54"
    plus-style                    = syntax "#20303b"
    plus-non-emph-style           = syntax "#20303b"
    plus-emph-style               = syntax "#2c5a66"
    plus-empty-line-marker-style  = syntax "#20303b"
    line-numbers-plus-style       = "#449dab"
    line-numbers-zero-style       = "#3b4261"
```

## colorscheme

[folke/tokyonight.nvim: 🏙 A clean, dark Neovim theme written in Lua, with support for lsp, treesitter and lots of plugins. Includes additional themes for Kitty, Alacritty, iTerm and Fish.](https://github.com/folke/tokyonight.nvim)

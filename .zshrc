# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

eval "$(sheldon source)"

HISTFILE=~/zsh_history
HISTSIZE=100000
SAVEHIST=100000

alias vi="nvim"
alias vim="nvim"
alias view="nvim -R"

alias zshrc="vim ~/.zshrc"
alias alac="vim ~/.config/alacritty/alacritty.toml"
alias tmuxconf="vim ~/.config/tmux/tmux.conf"
alias initlua="vim ~/.config/nvim/init.lua"
alias lz="lazydocker"

alias gget='ghq get'
alias gcd='cd $(ghq list --full-path | peco)'
alias ghb='hub browse $(ghq list | peco | cut -d "/" -f 2,3)'
alias arc='open -a "Arc"'

setopt auto_pushd
setopt pushd_ignore_dups
setopt auto_cd
setopt hist_ignore_dups
setopt share_history
setopt inc_append_history
setopt noautomenu
setopt nomenucomplete

set -o vi
bindkey "jj" vi-cmd-mode

export VOLTA_HOME="$HOME/.volta"
export PATH="$VOLTA_HOME/bin:$PATH"

# go
export PATH="$HOME/go/bin:$PATH"

# direnv
export "$(direnv hook zsh)"

preexec() { print -Pn "\e]0;%1~\a" }

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

# History settings
HISTFILE=~/.zsh_history
HISTSIZE=100000
SAVEHIST=100000

# Load custom configurations
source ~/.config/zsh/options.zsh
source ~/.config/zsh/plugins.zsh
source ~/.config/zsh/environment.zsh
source ~/.config/zsh/aliases.zsh

preexec() { print -Pn "\e]0;%1~\a" }

# ZLE settings should be loaded at the end of the file
fh_widget() {
  local selected_command
  selected_command=$(([ -n "$ZSH_NAME" ] && fc -l 1 || history) | fzf +s --tac | sed -E 's/ *[0-9]*\*? *//' | sed -E 's/\\/\\\\/g')
  if [[ -n $selected_command ]]; then
    BUFFER=$selected_command
    CURSOR=${#BUFFER}
    zle redisplay
  fi
}
zle -N fh_widget
bindkey '^r' fh_widget

source ~/.config/zsh/plugins-interactive.zsh

# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

export PATH="/opt/homebrew/bin:$PATH"

# History settings
HISTFILE=~/.zsh_history
HISTSIZE=100000
SAVEHIST=100000

# Load custom configurations
source ~/.config/zsh/rare_tech.zsh
source ~/.config/zsh/options.zsh
source ~/.config/zsh/environment.zsh
source ~/.config/zsh/aliases.zsh
source ~/.config/zsh/secret_env.zsh


# Completion
autoload -Uz compinit && compinit
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Z}'
zstyle ':completion:*:*:make:*' tag-order 'targets'

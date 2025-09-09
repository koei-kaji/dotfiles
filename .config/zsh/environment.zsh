export PATH="$HOME/.local/bin:$PATH"

# fzf
export FZF_DEFAULT_OPTS='--layout reverse'
export FZF_DEFAULT_COMMAND='rg --files --hidden --glob "!**/.git/*"'

# editor
export EDITOR='nvim'
export VISUAL='nvim'

# go
export PATH="$HOME/go/bin:$PATH"

export LITELLM_COPILOT_KEY=$(cat "$XDG_CONFIG_HOME/litellm/github_copilot/access-token" 2>/dev/null)

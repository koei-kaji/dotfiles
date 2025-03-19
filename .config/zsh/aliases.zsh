alias vi="nvim"
alias vim="nvim"
alias view="nvim -R"

alias zshrc="vim ~/.zshrc"
alias wez="vim ~/.config/wezterm/wezterm.lua"
alias tmuxconf="vim ~/.config/tmux/tmux.conf"
alias initlua="vim ~/.config/nvim/init.lua"

alias cd="z"

alias ld="lazydocker"
alias ls="eza --icons=always"
alias ll="ls -l"
alias arc='open -a "Arc"'

alias gget='ghq get'
alias gcd='cd $(ghq list --full-path | peco)'
alias ghb='hub browse $(ghq list | peco | cut -d "/" -f 2,3)'

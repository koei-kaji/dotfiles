alias vi="nvim"
alias vim="nvim"
alias view="nvim -R"

alias zshrc="vim ~/.zshrc"
alias wez="vim ~/.config/wezterm/wezterm.lua"
alias tmuxconf="vim ~/.config/tmux/tmux.conf"
alias initlua="vim ~/.config/nvim/init.lua"

alias cd="z"
alias ls="eza --icons=always"
alias ll="ls -l"
alias path="echo $PATH | tr ':' '\n' | fzf"

alias ld="lazydocker"
alias lg="lazygit"
alias arc='open -a "Arc"'

alias gget='ghq get'
alias gcd='cd $(ghq root)/$(_ghq-fzf)'
alias gvi='cd $(ghq root)/$(_ghq-fzf) && vim .'
alias gcode='cd $(ghq root)/$(_ghq-fzf) && code .'
alias ghb="open \$(_ghq-fzf | awk '{print \"https://\"\$1}')"

function _ghq-fzf() {
  local src=$(ghq list | fzf --preview "bat --color=always --style=header,grid --line-range :80 $(ghq root)/{}/README.*")
  if [ -n "$src" ]; then
      echo $src
  fi
}
function ghmo() {
    local repo=$(_ghq-fzf)

    case "$repo" in
      *github*)
        open $(echo $repo | awk '{print "https://"$1"/pulls"}')
        ;;
      *gitlab*)
        open $(echo $repo | awk '{print "https://"$1"/-/merge_requests"}')
        ;;
      *)
        echo "No match"
        ;;
    esac
}
function ghmm() {
    local repo=$(_ghq-fzf)

    case "$repo" in
      *github*)
        open $(echo $repo | awk '{print "https://"$1"/pulls?q=is:pr+is:closed"}')
        ;;
      *gitlab*)
        open $(echo $repo | awk '{print "https://"$1"/-/merge_requests?scope=all&sort=merged_at_desc&state=merged"}')
        ;;
      *)
        echo "No match"
        ;;
    esac
}

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

alias gw='git worktree'
alias gget='ghq get'
alias gcd='cd $(ghq root)/$(_ghq-fzf)'
alias gvi='cd $(ghq root)/$(_ghq-fzf) && vim .'
alias gcode='cd $(ghq root)/$(_ghq-fzf) && code .'
alias ghb="open \$(_ghq-fzf | awk '{print \"https://\"\$1}')"

alias j2y='yq -p=json'
alias y2j="yq -o=json '.'"

alias serena='uvx --from git+https://github.com/oraios/serena serena'
alias cc='claude'

function y() {
	local tmp="$(mktemp -t "yazi-cwd.XXXXXX")" cwd
	yazi "$@" --cwd-file="$tmp"
	if cwd="$(command cat -- "$tmp")" && [ -n "$cwd" ] && [ "$cwd" != "$PWD" ]; then
		builtin cd -- "$cwd"
	fi
	rm -f -- "$tmp"
}

# Worktrunk
alias gwn='wt switch --create'
alias gwcd='wt switch'
alias gwp='wt switch ^'

function gwrm() {
  if [ "$#" -eq 0 ]; then
    echo "Usage: gwrm <branch-name>"
    return 1
  fi

  wt remove --foreground "$@"
}

function _ghq-fzf() {
  local src=$(ghq list | grep -v -- '---' | fzf --preview "bat --color=always --style=header,grid --line-range :80 $(ghq root)/{}/README.*")
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

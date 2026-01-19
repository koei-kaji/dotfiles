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

alias litellm='litellm --config ${XDG_CONFIG_HOME}/litellm/config.yaml --port 14000'
alias claude='tmux rename-window "claude" && command claude'
alias copilot='tmux rename-window "copilot" && command copilot'
alias gemini='tmux rename-window "gemini" && command gemini'

function y() {
	local tmp="$(mktemp -t "yazi-cwd.XXXXXX")" cwd
	yazi "$@" --cwd-file="$tmp"
	if cwd="$(command cat -- "$tmp")" && [ -n "$cwd" ] && [ "$cwd" != "$PWD" ]; then
		builtin cd -- "$cwd"
	fi
	rm -f -- "$tmp"
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

function gwa() {
  if [ -z "$1" ]; then
    echo "Usage: gwa <branch-name>"
    return 1
  fi

  local repo_dir=$(git rev-parse --show-toplevel)
  local repo_name=$(basename $repo_dir)
  local workpath="${repo_name}---$1"

  cd $repo_dir
  git worktree add ../${workpath} -b $1 && cd ../${workpath}

}

function gwcd() {
  local repo_dir=$(git rev-parse --show-toplevel 2>/dev/null)
  if [ $? -ne 0 ]; then
    echo "Error: Not in a git repository"
    return 1
  fi

  local worktree_info=$(git worktree list --porcelain)
  if [ -z "$worktree_info" ]; then
    echo "No worktrees found"
    return 1
  fi

  # basename, ブランチ名, パスの対応表を作成
  local worktree_map=$(echo "$worktree_info" | awk '
    /^worktree / { path = substr($0, 10) }
    /^branch / {
      branch = substr($0, 8)
      gsub("refs/heads/", "", branch)
      cmd = "basename " path
      cmd | getline basename
      close(cmd)
      print basename ":" branch ":" path
    }
  ')

  if [ -z "$worktree_map" ]; then
    echo "No worktrees with branches found"
    return 1
  fi

  # basenameのみを表示してfzfで選択
  local selected_basename=$(echo "$worktree_map" | cut -d':' -f1 | fzf --preview "
    worktree_info=\$(echo '$worktree_map' | grep '^{}:')
    worktree_path=\$(echo \"\$worktree_info\" | cut -d':' -f3-)
    current_branch=\$(echo \"\$worktree_info\" | cut -d':' -f2)

    if [ -n \"\$worktree_path\" ]; then
      cd \"\$worktree_path\" 2>/dev/null || exit 1

      # origin/main または origin/master を確認
      if git show-ref --verify --quiet refs/remotes/origin/main; then
        base_branch='origin/main'
      elif git show-ref --verify --quiet refs/remotes/origin/master; then
        base_branch='origin/master'
      else
        echo 'No origin/main or origin/master found'
        exit 1
      fi

      echo \"Branch: \$current_branch\"
      echo \"Diff against \$base_branch:\"
      echo \"======================================\"
      git diff \"\$base_branch\"...\$current_branch --color=always --stat
    fi
  ")

  if [ -n "$selected_basename" ]; then
    local selected_path=$(echo "$worktree_map" | grep "^${selected_basename}:" | cut -d':' -f3-)
    if [ -n "$selected_path" ]; then
      cd "$selected_path"
    fi
  fi
}

function gwrm() {
  local repo_dir=$(git rev-parse --show-toplevel 2>/dev/null)
  if [ $? -ne 0 ]; then
    echo "Error: Not in a git repository"
    return 1
  fi

  local worktree_info=$(git worktree list --porcelain)
  if [ -z "$worktree_info" ]; then
    echo "No worktrees found"
    return 1
  fi

  # ブランチ名とパスの対応表を作成（mainブランチは除外）
  local worktree_map=$(echo "$worktree_info" | awk '
    /^worktree / { path = substr($0, 10) }
    /^branch / {
      branch = substr($0, 8)
      if (branch != "refs/heads/main" && branch != "refs/heads/master") {
        gsub("refs/heads/", "", branch)
        cmd = "basename " path
        cmd | getline basename
        close(cmd)
        if (index(path, "---") > 0) {
          print basename ":" branch ":" path
        }
      }
    }
  ')

  if [ -z "$worktree_map" ]; then
    echo "No removable worktrees found (main/master branches are protected)"
    return 1
  fi

  # ブランチ名のみを表示してfzfで選択
  local selected_basename=$(echo "$worktree_map" | cut -d':' -f1 | fzf --prompt="Select worktree to remove: " --preview "
    worktree_info=\$(echo '$worktree_map' | grep '^{}:')
    worktree_path=\$(echo \"\$worktree_info\" | cut -d':' -f3-)
    current_branch=\$(echo \"\$worktree_info\" | cut -d':' -f2)

    if [ -n \"\$worktree_path\" ]; then
      cd \"\$worktree_path\" 2>/dev/null || exit 1

      # origin/main または origin/master を確認
      if git show-ref --verify --quiet refs/remotes/origin/main; then
        base_branch='origin/main'
      elif git show-ref --verify --quiet refs/remotes/origin/master; then
        base_branch='origin/master'
      else
        echo 'No origin/main or origin/master found'
        exit 1
      fi

      echo \"Branch: \$current_branch\"
      echo \"Path: \$worktree_path\"
      echo \"Diff against \$base_branch:\"
      echo \"======================================\"
      git diff \"\$base_branch\"...\$current_branch --color=always --stat
    fi
  ")

  if [ -n "$selected_basename" ]; then
    local selected_path=$(echo "$worktree_map" | grep "^${selected_basename}:" | cut -d':' -f3-)

    if [ -n "$selected_path" ]; then
      echo "Removing worktree: $selected_basename ($selected_path)"
      read "confirm?Are you sure? (y/N): "
      if [[ "$confirm" =~ ^[Yy]$ ]]; then
        git worktree remove "$selected_path"
        if [ $? -eq 0 ]; then
          echo "Successfully removed worktree: $selected_basename"
        else
          echo "Failed to remove worktree: $selected_basename"
        fi
      else
        echo "Cancelled"
      fi
    fi
  fi
}

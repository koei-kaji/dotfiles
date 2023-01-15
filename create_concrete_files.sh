cd `dirname $0`

# alacritty 
sed -e s@WHICH_TMUX@$(which tmux)@g ./templates/alacritty.tpl.yml > /tmp/alacritty.yml
sed -e s@WHICH_ZSH@$(which zsh)@g /tmp/alacritty.yml > ./.config/alacritty/alacritty.yml

# tmux
sed -e s@WHICH_ZSH@$(which zsh)@g ./templates/tmux.tpl.conf > /tmp/tmux.conf
if [ "$(uname)" == 'Darwin' ]; then
  # tmux
  sed -e s@COPY_COMMAND@pbcopy@g /tmp/tmux.conf > ./.config/tmux/tmux.conf
elif [ "$(uname)" == 'Linux' ]; then
  # tmux
  sed -e "s@COPY_COMMAND@xsel -i@g" /tmp/tmux.conf > ./.config/tmux/tmux.conf
else
  exit 1
fi

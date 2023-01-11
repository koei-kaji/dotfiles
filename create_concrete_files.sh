#!/bin/sh

cd `dirname $0`

# alacritty 
sed -e s@WHICH_TMUX@$(which tmux)@g ./templates/alacritty.tpl.yml > ./.config/alacritty/alacritty.yml

if [ "$(uname)" == 'Darwin' ]; then
  # tmux
  sed -e s@COPY_COMMAND@pbcopy@g ./templates/tmux.tpl.conf > ./.config/tmux/tmux.conf
elif [ "$(uname)" == 'Linux' ]; then
  # tmux
  sed -e s@COPY_COMMAND@xsel -i@g ./templates/tmux.tpl.conf > ./.config/tmux/tmux.conf
else
  exit 1
fi

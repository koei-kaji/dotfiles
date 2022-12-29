#!/bin/sh

targets='
.zshrc
.config
'

for target in ${targets}; do
  target_home=~/${target}
  target_pwd=${PWD}/${target}

  if [ -L ${target_home} ]; then
    echo "delete current symlink: $(ls -la ${target_home})"
    unlink ${target_home}
  else
    if [ -f ${target_home} ]; then
        echo "rename current file: ${target_home}"
      mv -i ${target_home} ${target_home}.pre-manage-dottargets
    fi

    if [ -d ${target_home} ]; then
      echo "rename current directory: ${target_home}"
      mv -i ${target_home} ${target_home}.pre-manage-dottargets
    fi
  fi

  ln -si ${target_pwd} ${target_home}

done


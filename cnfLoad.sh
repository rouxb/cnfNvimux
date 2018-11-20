#!/usr/bin/env bash
SCRIPTPATH="$( cd "$(dirname "$0")" ; pwd -P )"

### NVim config
nvim_config=$SCRIPTPATH/init.vim
nvim_trgt_path=~/.config/init.vim
vim_trgt_path=~/.vimrc
ln -i -s $nvim_config $nvim_trgt_path

### Tmux config
tmux_config=$SCRIPTPATH/tmux.conf
tmux_trgt_path=~/.tmux.conf
ln -i -s $tmux_config $tmux_trgt_path

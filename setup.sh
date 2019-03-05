#!/bin/bash

git submodule update --init

mkdir -p $HOME/.config/nvim
ln -sf $PWD/init.vim $HOME/.config/nvim/init.vim

ln -sf $PWD/.vimrc $HOME/.vimrc

ln -sf $PWD/deps/tmux/.tmux.conf $HOME/.tmux.conf
ln -sf $PWD/.tmux.conf.local $HOME/.tmux.conf.local

cp $PWD/deps/gdb-dashboard/.gdbinit $HOME/.gdbinit
sed -i "/set history save/a set history filename ~\/.gdb_history" $HOME/.gdbinit

ln -sf $PWD/.bashrc $HOME/.bashrc

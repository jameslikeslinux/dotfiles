#!/usr/bin/env zsh
#
# rename-window.tmux
#
# The built-in tmux rename-window command will gladly accept and give a window
# an empty name.  I want it to enable automatic-renaming in that case.
#

if [[ $1 == '' ]]; then
    tmux set-window-option automatic-rename on
else
    tmux rename-window "$1"
fi

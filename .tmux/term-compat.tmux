#!/usr/bin/env zsh
#
# term-compat.tmux
#
# Create a keybinding to send keys to set a compatible TERM for hosts which do
# not have my terminfo files
#

term=${TERM/tmux/screen}
term=${term/truecolor/256color}
term=${term%-powerline}

tmux send-keys "export TERM=${term}" Enter

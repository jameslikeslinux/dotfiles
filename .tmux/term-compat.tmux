#!/usr/bin/env zsh
#
# term-compat.tmux
# Send keys to set a compatible TERM for hosts which do not have my terminfo
#

term=${TERM/tmux/screen}
term=${term/truecolor/256color}
term=${term%-powerline}

tmux send-keys "export TERM=${term}; set -o vi; bind -m vi-insert \\C-l:clear-screen \\C-n:next-history \\C-p:previous-history" Enter

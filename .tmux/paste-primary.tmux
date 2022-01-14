#!/usr/bin/env zsh
#
# paste-primary.tmux
#
# Load the primary selection into a tmux buffer and then paste from it
#

tmux load-buffer -b primary <(xsel)
tmux paste-buffer -b primary -p

#!/usr/bin/env zsh
#
# reload-vim.tmux
#
# Send keys to vim to save the current session, quit, reload the terminal, then
# reload the vim session.  For switching between TERM types.
#

tmux send-keys Escape ':mks! ~/.vim/session.vim' Enter ':qa!' Enter
sleep 0.5       # give vim time to exit
tmux send-keys 'r' Enter 'vim -S ~/.vim/session.vim' Enter

#!/usr/bin/env zsh
#
# new-window.tmux
#
# Normally, when the tmux 'new-window' command is passed "-n ''", tmux will
# create an unnamed window.  I want it to create an automatically-named window
# instead.
#

typeset -a name
zparseopts -D -E n:=name
trimmed_name="$(xargs <<< "${name[2]}")"

if [[ $trimmed_name ]]; then
    tmux new-window -n "$trimmed_name" "$@"
else
    tmux new-window "$@"
fi

#!/usr/bin/env zsh
#
# env.tmux
#
# Configure variables to be updated in session environment when session is
# attached.  This is done in a guarded fashion to prevent the list from growing
# repetitively when the tmux configuration is re-sourced.
#

for var in DBUS_SESSION_BUS_ADDRESS; do
    if [[ ! $(tmux show -g update-environment) =~ "(^|\s)${var}(\s|\$)" ]]; then
        tmux set -ag update-environment " ${var}"
    fi
done

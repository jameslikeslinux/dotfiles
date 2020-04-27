#!/usr/bin/env zsh
#
# env.tmux
#
# Configure variables to be updated in session environment when session is
# attached.  This is done in a guarded fashion to prevent the list from growing
# repetitively when the tmux configuration is re-sourced.
#

for var in DBUS_SESSION_BUS_ADDRESS \
           SESSION_MANAGER \
           SWAYSOCK \
           WAYLAND_DISPLAY \
           GDK_DPI_SCALE \
           GDK_SCALE \
           QT_AUTO_SCREEN_SCALE_FACTOR \
           QT_FONT_DPI \
           QT_SCALE_FACTOR \
           XCURSOR_THEME \
           XCURSOR_SIZE
do
    if [[ ! $(tmux show -g update-environment) =~ "(^|\s|\")${var}(\"|\s|\$)" ]]; then
        tmux set -ag update-environment " ${var}"
    fi
done

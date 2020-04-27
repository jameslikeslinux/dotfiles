#!/usr/bin/env zsh
#
# reload-sway-xresources.zsh
# Plasma blows away the existing xrdb, so we have to reload it explicitly
#

if [[ $XDG_SESSION_TYPE == 'wayland' ]]; then
    xrdb -merge /etc/sway/Xresources
fi

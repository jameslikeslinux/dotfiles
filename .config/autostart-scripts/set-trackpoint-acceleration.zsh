#!/usr/bin/env zsh
#
# set-trackpoint-acceleration.zsh
# Plasma overrides the system trackpoint acceleration, so set it explicitly
#

if [[ $XDG_SESSION_TYPE == 'x11' ]]; then
    xinput set-prop 'TPPS/2 IBM TrackPoint' 'libinput Accel Speed' "$(awk '/TrackPoint/ { trackpoint = 1 } /AccelSpeed/ && trackpoint { print gensub(/"/, "", "g", $3) }' /etc/X11/xorg.conf.d/10-libinput.conf)"
fi

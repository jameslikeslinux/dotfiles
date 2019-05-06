#!/bin/zsh

xinput set-prop 'TPPS/2 IBM TrackPoint' 'libinput Accel Speed' "$(awk '/TrackPoint/ { trackpoint = 1 } /AccelSpeed/ && trackpoint { print gensub(/"/, "", "g", $3) }' /etc/X11/xorg.conf.d/10-libinput.conf)"

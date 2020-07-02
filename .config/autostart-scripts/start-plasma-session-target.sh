#!/bin/sh
#
# start-plasma-session-target.sh
# Start the systemd target responsible for triggering other graphical services
#

systemctl --user start plasma-session.target

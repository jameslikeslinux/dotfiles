#!/bin/bash
#
# start-graphical-session-target.sh
# Start the systemd target that controls graphical-session.target
#

systemctl --user restart plasma-session.target

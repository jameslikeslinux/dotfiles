#!/bin/bash
#
# stop-graphical-session-target.sh
# Stop the systemd target that controls graphical-session.target
#

systemctl --user stop plasma-session.target

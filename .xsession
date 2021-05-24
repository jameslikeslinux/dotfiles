#
# xsession
# Sourced by /usr/share/sddm/scripts/Xsession
#

$HOME/bin/reset-systemd-environment
systemctl --user restart x-session.target

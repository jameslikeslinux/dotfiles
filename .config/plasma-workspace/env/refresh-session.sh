#
# refresh-session.sh
# Clean up any lingering environment variables from a previous session
#

source "${HOME}/lib/session-vars.sh"
systemctl --user unset-environment "${SESSION_VARS[@]}"

# Cygwin SSHD runs as cyg_server which doesn't have a SHELL environment
# variable set, so it launches bash by default. Replace with the right shell.
[[ $SSH_CONNECTION ]] && SHELL=/bin/zsh exec $SHELL -l

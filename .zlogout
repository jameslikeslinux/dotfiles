# Reset color palette for Linux consoles
[[ $TERM == 'linux' && ! $SSH_CLIENT ]] && print -Pn '\e]R'

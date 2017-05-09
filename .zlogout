# Reset color palette for Linux consoles
[[ $TERM == 'linux' && ! $SSH_CONNECTION ]] && print -Pn '\e]R'

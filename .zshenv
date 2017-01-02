# Always use unicode
export LANG=en_US.UTF-8

# Set path
if [[ -e /etc/glue/restrict ]]; then
    # Glue does special stuff in bash/tcsh shells
    source ~/.bashrc
else
    typeset -U path
    for dir in /bin /sbin /usr/bin /usr/sbin /usr/local/bin /usr/local/sbin $HOME/bin $HOME/local/bin $HOME/.cabal/bin; do
        [[ -e $dir ]] && path=($dir $path)
    done
fi

# Editor is vim if it exists
if (( $+commands['vim'] )); then
    export EDITOR="vim"
else
    export EDITOR="vi"
fi

# Set some standard programs
export VISUAL=$EDITOR
export PAGER="less"

# Degrade shell on Solaris
if [[ $OSNAME = "solaris" && $TERM = *256color ]]; then
    export TERM=${TERM%-256color}
fi

# Load extra functions
typeset -U fpath
fpath=("$HOME/.zsh/functions" $fpath)

# Extra environmental variables
export DISTCC_DIR="/var/tmp/portage/.distcc/"

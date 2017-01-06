# Check for newer local version of zsh
autoload -U is-at-least
if ! is-at-least 5.2; then
    for zsh in $HOME/local/bin/zsh; do
        [[ -x $zsh ]] && exec $zsh
    done
fi

# Always use unicode
export LANG=en_US.UTF-8

# Set path
if [[ -e /etc/glue/restrict ]]; then
    # Glue does special stuff in bash/tcsh shells
    source ~/.bashrc
else
    typeset -U path
    for dir in /bin /sbin /usr/bin /usr/sbin /usr/local/bin /usr/local/sbin $HOME/bin $HOME/local/bin; do
        [[ -e $dir ]] && path=($dir $path)
    done
fi

# Load extra functions
typeset -U fpath
fpath=("$HOME/.zsh/functions" $fpath)

# Editor is vim if it exists
if [[ -x $(whence vim) ]]; then
    export EDITOR="vim"
else
    export EDITOR="vi"
fi

# Set some standard programs
export VISUAL=$EDITOR
export PAGER="less"

# Extra environmental variables
export DISTCC_DIR='/var/tmp/portage/.distcc/'
export TERMINFO="${HOME}/.terminfo"

# Enable X apps through sudo (along with env_keep)
export XAUTHORITY="${XAUTHORITY-$HOME/.Xauthority}"

# Glue polutes my shell
unset LESS LESSOPEN

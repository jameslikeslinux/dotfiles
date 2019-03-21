# Always use unicode except on pfSense
if [[ $HOST != 'router.mgmt.home' ]]; then
    export LANG=en_US.UTF-8
fi

# Set path
if [[ -e /etc/glue/restrict ]]; then
    # Glue does special stuff in bash/tcsh shells
    source ~/.bashrc
else
    typeset -U path
    for dir in /bin /sbin /usr/bin /usr/sbin /usr/local/bin /usr/local/sbin /usr/glue/bin /usr/glue/sbin $HOME/bin $HOME/local/bin; do
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

# Enable access to ssh-agent that may be running under systemd
# (I'd prefer to set this at the system level, where systemd is running, but
# haven't found a satisfactory way to do it.)
if [[ $SSH_AUTH_SOCK == '' && -S "${XDG_RUNTIME_DIR}/ssh-agent.socket" ]]; then
    export SSH_AUTH_SOCK="${XDG_RUNTIME_DIR}/ssh-agent.socket"
fi

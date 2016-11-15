# always use unicode
export LANG=en_US.UTF-8


# set path
if [[ -e /etc/glue/restrict ]]; then
    # glue does special stuff in bash/tcsh shells
    source ~/.bashrc
else
    typeset -U path
    for dir in /bin /sbin /usr/bin /usr/sbin /usr/local/bin /usr/local/sbin $HOME/bin $HOME/local/bin $HOME/.cabal/bin; do
        [[ -e $dir ]] && path=($dir $path)
    done
fi


# editor is vim if it exists
vim=$(whence vim)
if [[ -x $vim ]]; then
    export EDITOR="$vim -u $HOME/.vimrc"
else
    export EDITOR="vi"
fi


# set some standard programs
export VISUAL=$EDITOR
export PAGER="less"


# degrade shell on Solaris
if [[ $OSNAME = "solaris" && $TERM = *256color ]]; then
    export TERM=${TERM%-256color}
fi


# load extra functions
typeset -U fpath
fpath=("$HOME/.zsh/functions" $fpath)


# extra evironmental variables
export DISTCC_DIR="/var/tmp/portage/.distcc/"

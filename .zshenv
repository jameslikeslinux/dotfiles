# always use unicode
export LANG=en_US.UTF-8


# set path
if [[ -e /etc/glue ]]; then
    # glue does special stuff in bash/tcsh shells
    source ~/.bashrc
else
    typeset -U path
    for dir in /bin /sbin /usr/bin /usr/sbin /usr/local/bin /usr/local/sbin $HOME/bin; do
        [[ -e $dir ]] && path=($dir $path)
    done
fi


# editor is vim if it exists
vim=$(whence vim)
if [[ -x $vim ]]; then
    export EDITOR=$vim
else
    export EDITOR="vi"
fi

export VISUAL=$EDITOR
export PAGER="less"

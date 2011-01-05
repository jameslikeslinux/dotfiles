# set path
typeset -U path
for dir in /bin /sbin /usr/bin /usr/sbin /usr/sfw/bin /usr/ccs/bin /usr/gnu/bin  /usr/local/bin /usr/local/sbin /usr/local/texlive/2009/bin/i386-solaris /usr/local/texlive/2010/bin/i386-solaris /opt/SunStudioExpress/bin; do
    [[ -e $dir ]] && path=($dir $path)
done

# editor is vim if it exists
if which vim > /dev/null; then
    export EDITOR="vim"
else
    export EDITOR="vi"
fi

export PAGER="less"

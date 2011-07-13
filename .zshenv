# editor is vim if it exists
if [[ -x $(whence vim) ]]; then
    export EDITOR="vim"
else
    export EDITOR="vi"
fi

export PAGER="less"

if [[ "$HOST" = "builder" ]]; then
    export PKGBUILD_IPS_SERVER="http://nest:10003/"
else
    # set path
    typeset -U path
    for dir in /bin /sbin /usr/bin /usr/sbin /usr/gnu/bin /usr/ccs/bin /usr/local/bin /usr/local/sbin /usr/local/texlive/2009/bin/i386-solaris /usr/local/texlive/2010/bin/i386-solaris /opt/SunStudioExpress/bin; do
        [[ -e $dir ]] && path=($dir $path)
    done
fi

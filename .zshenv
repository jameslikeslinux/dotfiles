if [[ $HOST = "builder" ]]; then
    export PKGBUILD_IPS_SERVER="http://nest:10001/"
    export PATH=/usr/gcc/bin:$PATH
elif [[ -e /etc/glue ]]; then
    # glue does special stuff in bash/tcsh shells
    source ~/.bashrc
else
    # set path
    typeset -U path
    for dir in /bin /sbin /usr/bin /usr/sbin /usr/sfw/bin /usr/gnu/bin /opt/csw/bin /opt/csw/sbin /usr/local/bin /usr/local/sbin /usr/local/texlive/2009/bin/i386-solaris /usr/local/texlive/2010/bin/i386-solaris /opt/SunStudioExpress/bin; do
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

# settings for Debian packaging
export DEBFULLNAME="James Lee"
export DEBEMAIL="jlee@thestaticvoid.com"
export QUILT_PATCHES="debian/patches"

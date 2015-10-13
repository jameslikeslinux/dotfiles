# check for newer local version of zsh
autoload -U is-at-least
if ! is-at-least 5.0.5; then
    for zsh in $HOME/local/bin/zsh; do
        [[ -x $zsh ]] && exec $zsh
    done
fi


# /etc/zsh/zprofile overwrites stuff set in .zshenv
# this is kind of a hack, but not that big of a deal
[[ -e /etc/zsh/zprofile ]] && source $HOME/.zshenv


# history settings
HISTFILE=~/.histfile.$HOST
HISTSIZE=10000
SAVEHIST=10000
setopt append_history

if [[ ! -e $HISTFILE ]]; then
    touch $HISTFILE
    chmod 600 $HISTFILE
fi

if [[ ! -w $HISTFILE ]]; then
    echo
    echo "HISTFILE is not writable..."
    echo "Run \"s chown $USER:$(id -gn) $HISTFILE\" to fix."
    echo
fi


# restore default redirect behavior
setopt clobber


# enable emacs keybindings
bindkey -e


# split on slashes
WORDCHARS="${WORDCHARS:s@/@}"


# terminal specific settings
case $TERM in
    xterm*)
        bindkey "^[OH" beginning-of-line
        bindkey "^[[H" beginning-of-line
        bindkey "^[OF" end-of-line
        bindkey "^[[F" end-of-line
        bindkey "^[[3~" delete-char
        bindkey ";5D" backward-word
        bindkey ";5C" forward-word
        ;;

    screen)
        bindkey "^A" beginning-of-line
        bindkey "^[[1~" beginning-of-line
        bindkey "^E" end-of-line
        bindkey "^[[4~" end-of-line
        bindkey "^[[1;5D" backward-word
        bindkey "^[[1;5C" forward-word
        ;;

    linux)
        bindkey "^[[1~" beginning-of-line
        bindkey "^[[4~" end-of-line
        bindkey "^[[3~" delete-char
        ;;

    sun-color)
        bindkey "^[[214z" beginning-of-line
        bindkey "^[[220z" end-of-line
        bindkey "^?" delete-char
        ;;
esac

# show user name at prompt if not one of my usual ones
zstyle ':prompt:mine' hide-users '(jlee|jtl|root)'

# figure out if I'm running as a priviliged user
if [[ $EUID == 0 ]]; then
    zstyle ':prompt:mine' root true
fi

if [[ $OS == 'Windows_NT' && -w '/cygdrive/c' ]]; then
    zstyle ':prompt:mine' root true
fi

# figure out if I'm running with Glue admin rights
if [[ -x $(whence klist) ]] && klist 2>&1 | grep jtl/admin > /dev/null; then
    zstyle ':prompt:mine' admin true
fi

# fallback to flat appearance if using a stupid terminal
if [[ $TERM != *256color ]]; then
    zstyle ':prompt:mine' flat true
fi

# enable my command prompt
autoload -U promptinit && promptinit
prompt mine


# enable command autocompletion
autoload -U compinit && compinit -u


# color list autocompletion
if [[ -x $(whence dircolors) ]]; then
    eval $(dircolors)
    zstyle ':completion:*' list-colors ${(s.:.)LS_COLORS}
fi


# aliases
ls --help 2>&1 | grep -- '--color' > /dev/null && alias ls="ls --color"
alias vi="$EDITOR"
alias vim="vim -u $HOME/.vimrc.code"
alias vip="vim -u $HOME/.vimrc.ruby"
unalias cp 2>/dev/null
alias mv="mv -f"
alias rm="rm -f"
alias glue="ssh -qt stowe.umd.edu"
alias bigsnaps="zfs list -t snapshot -s used"


# simple privilege escalation
s() {
    if [[ $OS == 'Windows_NT' ]]; then
        if [[ $# -eq 0 ]]; then
            cygstart --action=runas mintty -
        else
            #cygstart --action=runas mintty -e "$SHELL -c \"$*\""
            print "Can't reliably run single commands as admin.  Use plain 's' instead."
            return 1
        fi
    elif [[ -e /etc/glue ]]; then
        # use 'su' instead of sudo on glue
        if [[ $# -eq 0 ]]; then
            su -m -c "$SHELL; kdestroy"
        else
            su -m -c "$SHELL -c \"$*\"; kdestroy"
        fi
    else
        sudo ${@:--s}
    fi
}
compdef s=sudo


# a better version of 'suafs'
unalias suafs 2>/dev/null
unalias a 2>/dev/null
a() {
    if [[ $# -eq 0 ]]; then
        pagsh -c "kinit jtl/admin && ($SHELL; kdestroy)"
    else
        pagsh -c "kinit jtl/admin && ($SHELL -c \"$*\"; kdestroy)"
    fi
}
compdef a=sudo


# sane mplayer defaults
play() {
    DISPLAY=:0 mplayer -af volnorm -cache 4096 -fs $@
}
compdef play=mplayer


# simplify chrooting
root() {
    if [[ $# != 1 ]]; then
        print "Usage: root PATH"
        return 1
    fi

    if [[ ! -d $1 || ! -d $1/boot || ! -d $1/dev || ! -d $1/proc || ! -d $1/run || ! -d $1/sys || ! -d $1/home || ! -d $1/root ]]; then
        print "$1 doesn't look like a root"
        return 2
    fi

    bootdev=$(awk '/ \/boot / {print $1}' /etc/fstab)
    print "Boot device is ${bootdev}"

    if mount | grep -q ' /boot '; then
        print "Unmounting /boot"
        umount /boot
    fi

    print "Mounting /boot, /dev, /proc, /run, and /sys inside root"
    mount $bootdev $1/boot
    mount -t proc proc $1/proc
    mount -o rbind /dev $1/dev
    mount -o rbind /run $1/run
    mount -o rbind /sys $1/sys

    print "Mounting home directories"
    mount -o rbind /home $1/home
    mount -o rbind /root $1/root

    # XXX check for and mount /app and /data

    print "Entering root"
    chroot $1

    print "Unmounting home directories"
    umount -l $1/home $1/root

    print "Unmounting /boot, /dev, /proc, /run, and /sys inside root"
    umount -l $1/boot $1/dev $1/proc $1/run $1/sys

    print "Remounting /boot"
    mount /boot
}


# set standard umask
umask 022


# enable X apps through sudo (along with env_keep)
export XAUTHORITY="${XAUTHORITY-$HOME/.Xauthority}"

# check for newer local version of zsh
autoload -U is-at-least
if ! is-at-least 5.0.5; then
    for zsh in $HOME/local/bin/zsh; do
        [[ -x $zsh ]] && exec $zsh
    done
fi


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


# figure out if I'm running with Glue admin rights
admin=""
if [[ -x $(whence klist) ]] && klist 2>&1 | grep jtl/admin > /dev/null; then
    admin="/admin"

    # set environmental variable for powerline-shell
    export ADMIN=1
else
    admin=""
    unset ADMIN
fi

source $HOME/.zsh/disambiguate.zsh

precmd() {
    disambiguate -k $(print -P "%~")
    export UNIQ_PWD=$REPLY

    powerline_mode=$([[ $TERM = *256color ]] && print patched || print flat)

    # set prompt using powerline-shell
    export PS1="$(python3 ~/.zsh/powerline-shell.py $? --shell zsh --mode ${powerline_mode} 2>/dev/null) "

    # set terminal title
    case $TERM in
        xterm*|screen)
            print -Pn "\e]0;%n${admin}@%m:${UNIQ_PWD}\a"
            ;;
    esac
}


# enable command autocompletion
autoload -U compinit && compinit


# color list autocompletion
if [[ -x $(whence dircolors) ]]; then
    eval $(dircolors)
    zstyle ':completion:*' list-colors ${(s.:.)LS_COLORS}
fi


# aliases
ls --color / > /dev/null 2>&1 && alias ls="ls --color"
alias vi="$EDITOR"
alias vim="vim -u $HOME/.vimrc.code"
unalias cp 2>/dev/null
alias mv="mv -f"
alias rm="rm -f"
alias glue="ssh -qt stowe.umd.edu"


# simple privilege escalation
s() {
    if [[ -e /etc/glue ]]; then
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


# set standard umask
umask 022


# enable X apps through sudo (along with env_keep)
export XAUTHORITY="${XAUTHORITY-$HOME/.Xauthority}"

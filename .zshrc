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

# enable emacs keybindings
bindkey -e

# split on slashes
WORDCHARS="${WORDCHARS:s@/@}"

# figure out if I'm running with Glue admin rights
admin=""
promptcolor="green"
if [[ -x $(whence klist) ]] && klist 2>&1 | grep jtl/admin > /dev/null; then
    admin="/admin"
    promptcolor="red"
fi

# terminal specific settings
case $TERM in
    xterm*)
        bindkey "^[OH" beginning-of-line
        bindkey "^[OF" end-of-line
        bindkey "^[[3~" delete-char
        bindkey ";5D" backward-word
        bindkey ";5C" forward-word

        # set terminal title
        precmd() { print -Pn "\e]0;%n${admin}@%m:%~\a" }
        ;;

    sun-color)
        bindkey "^[[214z" beginning-of-line
        bindkey "^[[220z" end-of-line
        bindkey "^?" delete-char
        ;;
esac

# set prompt: red for root; green for user
autoload -U colors && colors
PROMPT="%B%(!.%{$fg[red]%}root${admin}@%m.%{$fg[$promptcolor]%}%n${admin}@%m)%{$fg[blue]%} %~ %#%{$reset_color%}%b "

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
alias vpn="s openconnect -u jtl.oitmr --authgroup=UMapps --script=$HOME/bin/umd-networks vpn.umd.edu"
alias vpn-full="s openconnect -u jtl.oitmr --authgroup=UMapps --script=/etc/vpnc/vpnc-script vpn.umd.edu"
alias timer='s=0; while true; do clear; printf "%d:%02d" $((s / 60)) $((s++ % 60)); sleep 1; done'

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
        if sudo -V | grep "Sudo version 1.6" > /dev/null; then
            sudo ${@:--s}
        else
            sudo -E ${@:--s}
        fi
    fi
}
compdef s=sudo

# a better version of 'suafs'
unalias a 2>/dev/null
a() {
    if [[ $# -eq 0 ]]; then
        pagsh -c "kinit jtl/admin && ($SHELL; kdestroy)"
    else
        pagsh -c "kinit jtl/admin && ($SHELL -c \"$*\"; kdestroy)"
    fi
}
compdef a=sudo
unalias suafs 2>/dev/null

play() {
    DISPLAY=:0 mplayer -af volnorm -cache 4096 -fs $@
}
compdef play=mplayer

if [[ $HOST = "builder" && -z $CC ]]; then
    source /opt/dtbld/bin/env.sh
fi

# set standard umask
umask 022

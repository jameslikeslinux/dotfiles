# history settings
HISTFILE=~/.histfile.$HOST
HISTSIZE=10000
SAVEHIST=10000
setopt append_history

# enable emacs keybindings
bindkey -e

# split on slashes
WORDCHARS="${WORDCHARS:s@/@}"

# terminal specific settings
case $TERM in
    xterm*)
        bindkey "^[OH" beginning-of-line
        bindkey "^[OF" end-of-line
        bindkey "^[[3~" delete-char
        bindkey ";5D" backward-word
        bindkey ";5C" forward-word

        # set terminal title
        precmd() { print -Pn "\e]0;%n@%m:%~\a" }
        ;;

    sun-color)
        bindkey "^[[214z" beginning-of-line
        bindkey "^[[220z" end-of-line
        bindkey "^?" delete-char
        ;;
esac

if [[ -x $(whence klist) ]] && klist | grep jtl/admin > /dev/null; then
    admin=1
fi

# set prompt: red for root; green for user
autoload -U colors && colors
PROMPT="${admin:+(admin) }%B%(!.%{$fg[red]%}%m.%{$fg[green]%}%n@%m)%{$fg[blue]%} %~ %#%{$reset_color%}%b "

# enable command autocompletion
autoload -U compinit && compinit

# color list autocompletion
if [[ -x $(whence dircolors) ]]; then
    eval $(dircolors)
    zstyle ':completion:*' list-colors ${(s.:.)LS_COLORS}
fi

# aliases
ls --color / > /dev/null 2>&1 && alias ls="ls --color"
alias ll="ls -al"
#alias ld="ls -ld"
alias lt="ls -alrt"
alias vi="$EDITOR"
alias vim="vim -u $HOME/.vimrc.code"
alias rm="rm -f"

# simple privilege escalation
s() {
    if [[ -e /etc/glue ]]; then
        # use 'su' instead of sudo on glue
        if [[ $# -eq 0 ]]; then
            su -m
        else
            su -m -c "$*"
        fi
    else
        if sudo -V | grep "Sudo version 1.6" > /dev/null; then
            sudo ${@:--s}
        else
            sudo -E ${@:--s}
        fi
    fi
}

play() {
    DISPLAY=:0 mplayer -af volnorm -cache 4096 -fs $@
}

svn-show-eligible() {
    for rev in $(svn mergeinfo --show-revs eligible $@); do
        svn log -v -$rev $@
    done
}

if [[ $HOST = "builder" && -z $CC ]]; then
    source /opt/dtbld/bin/env.sh
fi

# set standard umask
umask 022

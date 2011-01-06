# history settings
HISTFILE=~/.histfile
HISTSIZE=1000
SAVEHIST=1000
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

# set prompt: red for root; green for user
autoload -U colors && colors
PROMPT="%B%(!.%{$fg[red]%}%m.%{$fg[green]%}%n@%m)%{$fg[blue]%} %~ %#%{$reset_color%}%b "

# enable command autocompletion
autoload -U compinit && compinit

# color list autocompletion
if [[ -x $(which dircolors) ]]; then
    eval $(dircolors)
    zstyle ':completion:*' list-colors ${(s.:.)LS_COLORS}
fi

# aliases
ls --color / > /dev/null 2>&1 && alias ls="ls --color"
alias ll="ls -al"
alias ld="ls -ld"
alias lt="ls -alrt"
alias vi="$EDITOR"

# simple privilege escalation
s() {
    if [[ -x $(which pfexec) && ! -e "/etc/jumpstart_release" ]]; then
        pfexec ${@:-$SHELL}
    elif [[ -x $(which sudo) ]]; then
        sudo ${@:--s}
    else 
        echo "Neither pfexec nor sudo are in your path." >&2
        return 1
    fi
}

# train myself away from 'pfexec' and 'sudo'
pfexec sudo() {
    echo "Use 's' instead." >&2
    return 1
}

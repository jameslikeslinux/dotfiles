# history settings
HISTFILE=~/.histfile
HISTSIZE=1000
SAVEHIST=1000
setopt append_history

# enable emacs keybindings
bindkey -e
bindkey ';5D' emacs-backward-word
bindkey ';5C' emacs-forward-word
WORDCHARS="${WORDCHARS:s@/@}"

# enable command autocompletion
autoload -U compinit && compinit

# set terminal title
case $TERM in
    xterm*)
        precmd() { print -Pn "\e]0;%n@%m:%~\a" }
        ;;
esac

# set prompt: red for root; green for user
autoload -U colors && colors
PROMPT="%B%(!.%{$fg[red]%}%m.%{$fg[green]%}%n@%m)%{$fg[blue]%} %~ %#%{$reset_color%}%b "

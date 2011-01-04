# history settings
HISTFILE=~/.histfile
HISTSIZE=1000
SAVEHIST=1000
setopt append_history

# enable vi keybindings
bindkey -v

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
setopt prompt_subst
PROMPT='%B%(!.%{$fg[red]%}%m.%{$fg[green]%}%n@%m)%{$fg[blue]%} %~ ${VIMODE:-%#}%{$reset_color%}%b '

# update prompt with the current vi mode
zle-line-init zle-keymap-select() {
    VIMODE="${${KEYMAP/vicmd/!}/(main|viins)/%#}"
    zle reset-prompt
}
zle -N zle-line-init
zle -N zle-keymap-select

# Check for newer local version of zsh
autoload -U is-at-least
if ! is-at-least 5.2; then
    for zsh in $HOME/local/bin/zsh; do
        [[ -x $zsh ]] && exec $zsh
    done
fi

# /etc/zsh/zprofile overwrites stuff set in .zshenv
# This is kind of a hack, but not that big of a deal
[[ -e /etc/zsh/zprofile ]] && source $HOME/.zshenv

# XXX: Rename histfile
if [[ -f ~/.histfile.$HOST -a ! -f ~/.history.$HOST ]]; then
    mv -f ~/.histfile.$HOST ~/.history.$HOST
elif [[ -f ~/.histfile.$HOST ]]; then
    rm -f ~/.histfile.$HOST
fi

# History settings
HISTFILE=~/.history.$HOST
HISTSIZE=10000
SAVEHIST=10000
setopt inc_append_history

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

# Restore default redirect behavior
setopt clobber

# Enable vi keybindings
bindkey -v

# Make mode switches faster
export KEYTIMEOUT=1

# Enable incremental history search
bindkey '^R' history-incremental-pattern-search-backward
bindkey -M vicmd '^R' history-incremental-pattern-search-backward
bindkey '^S' history-incremental-pattern-search-forward
bindkey -M vicmd '^S' history-incremental-pattern-search-forward
stty -ixon      # make ^S available to shell

# Show user name at prompt if not one of my usual ones
zstyle ':prompt:mine' hide-users '(james|jlee|jtl|root)'

# Figure out if I'm running as a priviliged user
if [[ $EUID == 0 || ($OS == 'Windows_NT' && -w '/cygdrive/c') ]]; then
    zstyle ':prompt:mine' root true
fi

# Figure out if I'm running with Glue admin rights
if [[ -x $(whence klist) ]] && klist 2>&1 | grep jtl/admin > /dev/null; then
    zstyle ':prompt:mine' admin true
fi

# Fallback to flat appearance if using a stupid terminal
if [[ $TERM != *256color ]]; then
    zstyle ':prompt:mine' flat true
fi

# Enable my command prompt
autoload -U promptinit && promptinit
prompt mine

# Enable command autocompletion
autoload -U compinit && compinit -u

# Color list autocompletion
if [[ -x $(whence dircolors) ]]; then
    eval $(dircolors)
    zstyle ':completion:*' list-colors ${(s.:.)LS_COLORS}
fi

# Aliases
ls --help 2>&1 | grep -- '--color' > /dev/null && alias ls="ls --color"
alias vi="$EDITOR"
unalias cp 2>/dev/null
alias mv="mv -f"
alias rm="rm -f"
alias glue="ssh -qt stowe.umd.edu"
alias bigsnaps="zfs list -t snapshot -s used"
unalias suafs 2>/dev/null
unalias a 2>/dev/null
compdef a=sudo
compdef s=sudo

# Set standard umask
umask 022

# Enable X apps through sudo (along with env_keep)
export XAUTHORITY="${XAUTHORITY-$HOME/.Xauthority}"

# Glue polutes my shell
unset LESS LESSOPEN

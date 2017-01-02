#
# Use system clipboard for copy/paste operations, if available
#
# See: http://zshwiki.org/home/zle/vi-mode
#

[[ -n $DISPLAY ]] && (( $+commands[xclip] )) && {
    function cutbuffer() {
        zle .$WIDGET
        echo $CUTBUFFER | xclip
    }

    zle_cut_widgets=(
        vi-change
        vi-change-eol
        vi-change-whole-line
        vi-delete
        vi-delete-char
        vi-kill-eol
        vi-substitute
        vi-yank
        vi-yank-eol
    )
    for widget in $zle_cut_widgets; do
        zle -N $widget cutbuffer
    done

    function putbuffer() {
        zle copy-region-as-kill "$(xclip -o)"
        zle .$WIDGET
    }

    zle_put_widgets=(
        vi-put-after
        vi-put-before
    )
    for widget in $zle_put_widgets; do
        zle -N $widget putbuffer
    done
}

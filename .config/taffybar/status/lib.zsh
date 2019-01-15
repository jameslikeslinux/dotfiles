STATUS_NAME="$(basename "$1" | tr 'a-z' 'A-Z')"
TAFFYBAR_NAME='taffybar-linux-x86_64.real'
STATE_NAME="_STATUS_${STATUS_NAME}_STATE"

get_state() {
    local state="$(xprop -name "$TAFFYBAR_NAME" "$STATE_NAME" | awk -F '"' '/=/ { print $2 }')"
    [[ $state == '' ]] && return 1
    print "$state"
}

set_state() {
    local state="$1"
    xprop -name "$TAFFYBAR_NAME" -f "$STATE_NAME" 8s -set "$STATE_NAME" "$state"
}


colorize() {
    local fg="$1"; shift
    local bg="$1"; shift

    print "<span fgcolor='$fg' bgcolor='$bg'>$@</span>"
}

fontawesome() {
    local glyph="$1"
    print "<span font='FontAwesome 5 Free Solid'>${glyph}</span>"
}

first_segment() {
    print "$(colorize '#282828' '#000000' '')$(colorize '#282828' '#282828' '█')$(colorize '#d8d8d8' '#282828' "$@ ")"
}

segment() {
    print "$(colorize '#000000' '#282828' '')$(colorize '#d8d8d8' '#282828' " $@ ")"
}

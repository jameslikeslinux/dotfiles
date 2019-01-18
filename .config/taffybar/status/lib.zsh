STATUS_NAME="$(basename "$1")"
TAFFYBAR_NAME='taffybar-linux-x86_64.real'
STATE_NAME="_STATUS_${STATUS_NAME:u}_STATE"
FIFO="/tmp/.status-${STATUS_NAME}.fifo"

delay() {
    sleep $1 &
    trap "kill $!" INT TERM
    wait; rc=$?
    trap - INT TERM
    return $rc
}

persistent_monitor() {
    while
        start_monitor "$@"
        (( ? <= 128 ))
    do
        delay 1 || break
    done
}

start_monitor() {
    trap "rm -f '$FIFO'" EXIT

    if [[ ! -p $FIFO ]]; then
        rm -f "$FIFO"
        mkfifo "$FIFO"
    fi

    # Run the monitor process in the background
    "$@" > "$FIFO" &

    # When terminated, kill the background process.  The background process may
    # be blocked waiting for something to open the FIFO, so use SIGKILL--these
    # monitor processes are nothing to worry about.
    trap "kill -9 $!" INT TERM
    wait; rc=$?
    trap - INT TERM

    return $rc
}

read_monitor() {
   if [[ -p $FIFO ]]; then
       read line < "$FIFO"
       print "$line"
   else
       delay 1
       return 1
   fi
}

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

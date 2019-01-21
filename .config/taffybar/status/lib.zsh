STATUS_NAME="$(basename "$1")"
TAFFYBAR_NAME='taffybar-linux-x86_64.real'
STATE_NAME="_STATUS_${STATUS_NAME:u}_STATE"
FIFO="/tmp/.status-${STATUS_NAME}.fifo"

# Make 'sleep' interruptible
delay() {
    local rc

    sleep $1 &
    trap "kill $!" INT TERM
    wait; rc=$?
    trap - INT TERM

    return $rc
}

start_monitor_loop() {
    while
        start_monitor "$@"
        (( ? <= 128 ))  # start_monitor was interrupted
    do
        delay 1 || break
    done
}

start_monitor() {
    local rc

    # Clean up after self
    trap 'rm -f "$FIFO"' EXIT

    if [[ ! -p $FIFO ]]; then
        rm -f "$FIFO"
        mkfifo -m 600 "$FIFO"
    fi

    # POSIX FIFOs are normally write only on this end, and attempts to open the
    # fifo block until a reader also opens the FIFO.  And, when the reader
    # closes the FIFO, any data in it is lost.  This special Linux behavior
    # (see fifo(7)) of opening the FIFO in read-write mode allows for writing
    # to it while no readers are available.  Additionally when readers close
    # the FIFO, any data they have not read is retained.  This makes this
    # option a nice, simple, if crude, form of 'reliable' message passing.
    # Reliable enough for this application.
    exec 4<>"$FIFO"

    # Run the monitor process in the background
    "$@" >&4 &

    # When terminated, kill the background process.  The background process may
    # be blocked waiting for something to open the FIFO, so use SIGKILL--these
    # monitor processes are nothing to worry about.
    trap "kill -9 $!" INT TERM
    wait; rc=$?
    trap - INT TERM

    return $rc
}

send_event() {
    if [[ -p $FIFO ]]; then
        print "$@" > "$FIFO"
    fi
}

get_event() {
   if [[ -p $FIFO ]]; then
       read -re < "$FIFO"
   else
       delay 1 && return 1
   fi
}

taffybar_id() {
    xprop -name "$TAFFYBAR_NAME" WM_CLIENT_LEADER | awk '{ print $5 }'
}

get_state() {
    local state taffybar_id="$(taffybar_id)"
    if [[ $taffybar_id ]]; then
        state="$(xprop -id "$taffybar_id" "$STATE_NAME" | awk -F '"' '/=/ { print $2 }')"
        [[ $state ]] || return 1
        print "$state"
    fi
}

set_state() {
    local state="$1" taffybar_id="$(taffybar_id)"
    if [[ $taffybar_id ]]; then
        xprop -id "$taffybar_id" -f "$STATE_NAME" 8s -set "$STATE_NAME" "$state"
    fi
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

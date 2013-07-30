#!/bin/sh

# Add passphraseless SSH key to agent
# (still useful for doing SSH agent forwarding)
/usr/bin/ssh-add < /dev/null

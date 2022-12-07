#!/usr/bin/env zsh
#
# Nest Rsync Wrapper
# Prevent access to anything but rsync to /nest/hosts
#

if [[ $SSH_ORIGINAL_COMMAND != 'rsync '*' . /nest/hosts/'* ]]; then
    print "Denied: ${SSH_ORIGINAL_COMMAND}" >&2
    exit 1
fi

exec "${(z)SSH_ORIGINAL_COMMAND}"

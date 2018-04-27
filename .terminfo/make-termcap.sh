#!/usr/bin/env bash
#
# make-termcap.sh
#
# Crudely make a FreeBSD-compatible termcap file
#

BASEDIR="$(readlink -f "$(dirname "$0")")"

find -L . -mindepth 2 -type f -exec basename {} \; | sort -u | while read term; do
    infocmp -Cr | sed "s/^.*|/${term}|/"
done > "${BASEDIR}/../.termcap"

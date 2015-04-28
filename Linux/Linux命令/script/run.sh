#!/usr/bin/env bash

. /etc/profile
. ~/.bash_profile

# run "cmd"
function run { cmd=${1:-""}; [ -n "$cmd" ] && { echo "$cmd"; script -c "$cmd" /dev/null; cmd=''; }; }

run "sh ./distcp.sh > ./log.txt 2>&1"

#!/usr/bin/env bash

if [ $# -le 0 ]; then
  echo "Usage: $0 password"
  exit 1
fi

pw=${1}

DIR=$(cd $(dirname "$0"); pwd)

. $DIR/config.sh

for node in $NODES ; do
  echo
  echo "add $node"
  echo "-----------------------------------------------"
  sh ./autossh.sh add $node "$pw "
  echo "-----------------------------------------------"
  echo
done


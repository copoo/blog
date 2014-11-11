#!/usr/bin/env bash

if [ $# -ne 1 ]; then
  echo "USAGE: $0 filename|dir";
  echo "eg.: $0 main.cpp";
  exit 1;
fi

DIR=$(cd $(dirname "$0"); pwd)

. $DIR/config.sh

for node in $NODES; do
  [ "$ME" == "$node" ] && continue
  same_to $node "$1"
done


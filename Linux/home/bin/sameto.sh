#!/usr/bin/env bash

if [ $# -ne 2 ]; then
  echo "USAGE: $0 host filename|dir";
  echo "eg.: $0 node2 main.cpp";
  exit 1;
fi

DIR=$(cd $(dirname "$0"); pwd)

. $DIR/config.sh

same_to $1 "$2"


#!/bin/sh

D=`cd $(dirname "$0"); pwd`

defaults=`which my_print_defaults`

mkdir -p bin
mkdir -p data
mkdir -p var
mkdir -p log

ln -sf -T $defaults $D/bin/my_print_defaults
#ln -sf -T /usr/libexec $D/libexec
ln -sf -T /usr/share $D/share
ln -sf -T /usr/bin/resolveip $D/bin/resolveip

mysql_install_db \
  --defaults-file=$D/my.cnf \
  --basedir=$D \
  --datadir=$D/data \
  --user=$USER

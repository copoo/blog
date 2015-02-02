#!/bin/sh

D=`cd $(dirname "$0"); pwd`

nohup \
mysqld_safe \
  --defaults-file=$D/my.cnf \
  --port=3307 \
  --basedir=$D \
  --datadir=$D/data \
  --log-error=$D/log/mysqld.log \
  --pid-file=$D/var/mysqld.pid \
  --socket=$D/var/mysql.sock \
  --user=$USER  >/dev/null 2>&1 &

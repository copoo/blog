#!/usr/bin/env bash

# zhaigy@ucweb.com 2013-11-26

# set repliction be to 2 for old data
# old data dir rule:
# 1. /mnt/hdfs/ssp/stat/*/day/pt=2013-01-01
# 2. /mnt/hdfs/ssp/user/*/*table/pt=2013-01-01

D=`cd $(dirname "$0"); pwd`
cd $D
SUDO='sudo -u hdfs'

# run "cmd"
function run { cmd=${1:-""}; [ -n "$cmd" ] && { echo "$cmd"; script -c "$cmd" /dev/null; cmd=''; }; }

# set_rep num dir
function set_rep { cmd="hdfs dfs -setrep -R $1 $2"; run "$SUDO $cmd"; }

d=${1:-32}

dt=`date -d "$d day ago" +"%Y-%m-%d"`
log_file="$D/set_rep.${dt}.log"

echo "set rep for $dt at `date +%H:%M:%S`" | tee -a $log_file

echo ":: for stat day ::" | tee -a $log_file
(set_rep 2 /mnt/hdfs/ssp/stat/*/day/pt=$dt) 2>&1 | tee -a $log_file

echo ":: for user *table ::" | tee -a $log_file
(set_rep 2 /mnt/hdfs/ssp/user/*/*table/pt=$dt) 2>&1 | tee -a $log_file 

find $D -name '*.log' -type f -ctime +10 -exec rm -f {} \;

#!/usr/bin/env bash

. /etc/profile
. ~/.bash_profile

#
#from=${1:?"必须设置拷贝源目录"}
#  to=${2:?"必须设置拷贝目标目录"}

dt=`date -d "-1 day" +"%Y/%m/%d"`
dt=${1:-"$dt"}; shift

echo $dt

sbs_dt=`date -d "$dt" +"%Y-%m-%d"`

nn_is_active() {
  local host="$1"
  local nn_service="$2"
  local stat=`ssh -t -p 9922 "$host" "sudo -u hdfs hdfs haadmin -getServiceState $nn_service;" | tr -d '\r'|tr -d '\n'`;
  if [[ "${stat}" == "active" ]]; then
    return 0
  else
    return 1
  fi
}

nn_active_service() {
  local host="$1"
  if nn_is_active $host "$2"; then
    echo "$3"
    return
  fi

  if nn_is_active $host "$4"; then
    echo "$5"
    return
  fi
}

from_nn=`nn_active_service vdc22 namenode552 vdc22 namenode362 vdc21`
#  to_nn=`nn_active_service wa03 nn1 wa01 nn2 wa03`
  to_nn=$from_nn

echo "from active nn is ["${from_nn:?"havn't active namenode"}"]"
echo "  to active nn is ["${to_nn:?"havn't active namenode"}"]"

distcp() {
  local from="$1"
    local to="$2"

  local retu="1"
  local count=0
  
  while [[ "$retu" != "0" ]]; do
    sudo -u hdfs \
    hadoop distcp \
      -i \
      -m 100 \
      -update \
      -skipcrccheck \
      webhdfs://${from_nn}:50070/$from \
      webhdfs://${to_nn}:50070/$to
    retu="$?"
    [[ "$retu" == "0" ]] && break;
    count=$[$count + 1]
    [[ $count -gt 3 ]] && exit 1;
  done

  sudo -u hdfs \
  hdfs dfs -touchz /$to/_SUCCESS
  sudo -u hdfs \
  hdfs dfs -chown -R uaewa:uaewa /user/uaewa/sbs
}

# imei 总表
from="mnt/hdfs/ssp/user/376/activetable/pt=${sbs_dt}"
  to="user/uaewa/sbs/mnt/hdfs/ssp/user/376/activetable/$dt"

#

sudo -u uaewa hdfs dfs -test -e /$to/_SUCCESS

if [[ "$?" != "0" ]]; then
  echo \
  distcp "$from" "$to"
fi

# sn 总表
from="mnt/hdfs/ssp/user/201/activetable/pt=${sbs_dt}"
  to="user/uaewa/sbs/mnt/hdfs/ssp/user/201/activetable/$dt"

if [[ "$?" != "0" ]]; then
  echo \
  distcp "$from" "$to"
fi

copy_id_map () {
  local from="mnt/hdfs/ssp/hivetable/3225/pt=2014-01-01"
  local sbs_dt=`ssh -t -p 9922 $from_nn "sudo -u hdfs hdfs dfs -stat '%y' /$from" | tr -d '\r'|tr -d '\n'|awk '{print $1}'`;
  
  echo "source file modification time is [$sbs_dt]"

  local dt=`date -d "$sbs_dt -1 day" +"%Y/%m/%d"`

  local to="user/uaewa/sbs/mnt/hdfs/ssp/hivetable/3225/$dt"

  echo "desc file is $to"
  echo -n "check $to "

  local exist=`ssh -t -p 9922 $to_nn "sudo -u hdfs hdfs dfs -test -e /$to" 2>/dev/null; if [[ $? -eq 0 ]]; then echo "OK"; else echo "FAIL"; fi | tr -d '\r' | tr -d '\n'`;

  echo "$exist"

  if [[ "$exist" == "OK" ]]; then
    echo "the lastest data has exists"
    return 0
  fi

  echo \
  distcp "$from" "$to"
}

copy_id_map


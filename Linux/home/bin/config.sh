#!/usr/bin/env bash
# coding=utf-8
# Author: zhaigy@ucweb.com
# Data  : 2014-08

if [ "X$__CONFIG__" == "X" ]; then
  __CONFIG__="true"

  ALL_NODES="mob1712 
  mob1725 
  mob1726 
  mob1727 
  mob1728 
  mob1736 
  mob1737 
  vdc08 
  vdc09 
  vdc10 
  vdc15 
  vdc21 
  vdc11 
  vdc16 
  vdc22 
  wa17  
  wa18  
  wa19  
  wa20  
  wa21  
  mob3023 
  kpi14 
  mob3024 
  mob3025 
  mob3026 
  mob3027 
  mob3028 
  mob3029 
  mob3030 
  mob3031 
  mob3032 
  wa01  
  wa02  
  wa03  
  wa04  
  wa05  
  wa06  
  wa07  
  wa08  
  wa09  
  wa10  
  wa11  
  wa12  
  wa13  
  wa14  
  wa15  
  wa16  
  kpi13 
  kpi25 
  kpi26 
  kpi27 
  kpi28 
  kpi63 
  kpi16 
  kpi17 
  kpi64 
  kpi65 
  vdc25 
  vdc26 
  vdc27 
  kpi18 
  kpi19 
  kpi66 
  kpi67 
  kpi68 
  kpi69 
  kpi70 
  kpi39 
  kpi40 
  kpi71 
  kpi72 
  kpi73 
  kpi74 
  kpi75 
  kpi41 
  kpi42 
  kpi76 
  kpi77 
  kpi78 
  kpi79 
  kpi80 
  kpi43 
  kpi44 
  kpi81 
  kpi82 
  kpi83 
  kpi84 
  kpi85 
  kpi45 
  kpi46 
  kpi86 
  kpi87 
  kpi88 
  kpi89 
  kpi90 
  kpi47 
  kpi48 
  kpi91 
  kpi92 
  kpi93 
  kpi94 
  kpi95 
  kpi49 
  kpi50 
  kpi96 
  kpi97 
  kpi51 
  kpi52"

  DIR=${DIR:-`cd $(dirname "$0"); pwd`}
  NODES=`cat $DIR/hosts|sed -e "/^#/d"`

  #NODES="$ALL_NODES"

  SSH_PORT=9922

  # --------------------------------------------------
  # no edit
  # --------------------------------------------------
  #SSH="ssh -o UserKnownHostsFile=/dev/null -o StrictHostKeyChecking=no -p $SSH_PORT" 
  SSH="ssh -o ConnectTimeout=2 -o ConnectionAttempts=2 -o PasswordAuthentication=no -o StrictHostKeyChecking=no -p $SSH_PORT" 
  # --------------------------------------------------
  # 基础设置
  # --------------------------------------------------
  shopt -s expand_aliases
  set -e

  # --------------------------------------------------
  # 基础变量
  # --------------------------------------------------
  if [ $0 != "bash" ]; then 
    AP=`basename ${0%.sh}`; 
  fi

  if [ `uname -m | sed -e 's/i.86/32/'` == '32' ]; then
    alias IS_32='true';
  else
    alias IS_32='false'
  fi

  ME=`hostname -s`
  #NOW_8_6=`date +"%Y%m%d_%H%M%S"`

  RSYNC="rsync -a --exclude=.svn --exclude=.git --exclude=logs -e \"$SSH\""

  # --------------------------------------------------
  # 别名
  # --------------------------------------------------
  #[ -z "$SSH_PORT" ] || { alias ssh="ssh -p $SSH_PORT"; alias scp="scp -P $SSH_PORT"; }
  alias wget="wget --no-check-certificate"; 
  # --------------------------------------------------
  # 函数
  # --------------------------------------------------
  now() { `date +"%Y%m%d_%H%M%S"`; }
  die() { [ $# -gt 0 ] && echo "$@"; if [ "X$OLD_DIR" != "X" ]; then cd $OLD_DIR; fi; exit -1; }
  var() { eval echo \$"$1"; }
  # 变量不存在或者为空即退出
  var_die() { [ "`var $1`" == "" ] && die "var $1 is not definded" ||:; }
  file_die() { if [ -e "$1" ]; then msg=${2:-"$1 is already exists"}; die "$msg"; fi }
  notfile_die() { if [ ! -e "$1" ]; then msg=${2:-"$1 is not exists"}; die "$msg"; fi }
  var_def() { [ "X$1" == "X" ] && true || false; } 

  # $0 cmd
  check_tool()
  {
    if alias $1 > /dev/null 2>&1 || [ -f "`which $1`" ]; then echo "$1 is exists";
    else die "$1 is not exists";
    fi
  }

  # $0 host source target
  # target is dir , abstract path
  rsync_to()
  {
    $SSH $1 "mkdir -p $3";
    cmd="$RSYNC \"$2\" \"$1:$3\""
    # echo "$cmd";
    echo "same to: $2 $1:$3";
    eval $cmd;
  }
  
  # $0 hosts source target 
  rsync_to_all() { for s in $1; do rsync_to $s $2 $3; done; }

  # $0 xmlfile name value
  xml_set() { sed -r "/<name>$2<\/name>/{ n; s#<value>.*</value>#<value>$3</value>#; }" -i $1; }
  find_tar() { find $D/tars -regex ".*/$1\(\.tar\)?\.gz" -printf "%f\n"; }

  # $0 host dir|file
  same_to()
  { 
    node=$1
    from="$2"
    to="$2"
    if [ -d "$from" ]; then
      #目录
      to=$(cd "$from/.."; pwd);
    elif [ -f "$from" ]; then
      #文件
      to=$(cd $(dirname "$from"); pwd);
    else
      echo "Unknown file[$2] type"
      return 1;
    fi
    rsync_to $node "$from" "$to"
  }

  # $0 host command
  one_do()
  {
    node=$1
    shift
    $SSH -t $node $" 
    [ -e /etc/profile ] && . /etc/profile; 
    [ -e $HOME/.bash_profile ] && . $HOME/.bash_profile; 
    [ -d $PWD ] && cd $PWD || cd;
    set -e; 
    ${@// /\\ }" 2>&1 | sed "s/^/$node: /"
  }

fi


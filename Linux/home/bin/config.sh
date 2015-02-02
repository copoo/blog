#!/usr/bin/env bash
# coding=utf-8
# Author: zhaigy@ucweb.com
# Data  : 2014-08

if [ "X$__CONFIG__" == "X" ]; then
  __CONFIG__="true"

  NODES="kpi16
	kpi17
	kpi18
	kpi19
	kpi25
	kpi26
	kpi27
	kpi28
	kpi63
	kpi64
	kpi65
	kpi66
	kpi67
	kpi68
	kpi69
	kpi70
	kpi71
	kpi72
	kpi73
	kpi74
	kpi75
	kpi76
	kpi77
	kpi78
	kpi79
	kpi80
	kpi81
	kpi82
	kpi83
	kpi84
	kpi85
	kpi86
	kpi87
	kpi88
	kpi89
	kpi90
	kpi91
	kpi92
	kpi93
	kpi94
	kpi95
	kpi96
	kpi97
	vdc21
	vdc22"

  SSH_PORT=9922

  # --------------------------------------------------
  # no edit
  # --------------------------------------------------
  #SSH="ssh -o UserKnownHostsFile=/dev/null -o StrictHostKeyChecking=no -p $SSH_PORT" 
  SSH="ssh -o ConnectTimeout=3 -o ConnectionAttempts=3 -o PasswordAuthentication=no -o StrictHostKeyChecking=no -p $SSH_PORT" 
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


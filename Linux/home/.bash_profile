# .bash_profile

# Get the aliases and functions
if [ -f ~/.bashrc ]; then
. ~/.bashrc
fi

export PS1="[\u@\h \t \w]"

# User specific environment and startup programs

PATH=$HOME/bin:$PATH
if [ -d $HOME/local ]; then
  for d in `ls $HOME/local`; do
    d=$HOME/local/$d
    if [ -d $d ]; then
      [ -d $d/bin ] && PATH=$d/bin:$PATH
      [ -d $d/sbin ] && PATH=$d/sbin:$PATH
    fi
  done
fi

export PATH

# Java environment
export JAVA_HOME=$HOME/local/jdk
export CLASSPATH=$JAVA_HOME/lib
export PATH=$JAVA_HOME/bin:$PATH

export ZK_HOME=$HOME/local/zookeeper
export ZK_BIN=$ZK_HOME/bin
export ZK_CONF_DIR=$ZK_HOME/conf
export PATH=$ZK_BIN:$PATH

# 编辑文件，增加如下内容
export HADOOP_HOME=$HOME/local/hadoop
export HADOOP_PREFIX=$HADOOP_HOME
export HADOOP_BIN=$HADOOP_HOME/bin
export HADOOP_CONF_DIR=$HADOOP_HOME/etc/hadoop
export PATH=$HADOOP_BIN:$PATH

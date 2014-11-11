#!/usr/bin/env bash
DIR=$(cd $(dirname "$0"); pwd)

. $DIR/config.sh

save_keys()
{
  #echo "Setup public key $1";
  ID=`hostid`;
  PUB=$(cat "$HOME/.ssh/id_rsa.pub");
  expect -c "
  set timeout 1;
  spawn ssh -p $SSH_PORT $USER@$1;
  expect \"(yes/no)?\" {send \"yes\n\"};
  expect \"password:\" {send \"$2\n\"} \"$\" {};
  exec sleep 1;
  send \"mkdir -p ~/.ssh\n\";
  send \"touch ~/.ssh/authorized_keys\n\";
  send \"echo $PUB | cat - ~/.ssh/authorized_keys | sort | uniq > /tmp/secure-keys\n\";
  send \"mv -f /tmp/secure-keys ~/.ssh/authorized_keys\n\";
  send \"touch ~/.ssh/.ID$ID\n\";
  send \"chmod 700 ~/.ssh\n\";
  send \"chmod 600 ~/.ssh/authorized_keys\n\";
  exec sleep 1;
  send \"exit\n\";
  expect";
}

keygen()
{
  expect -c "
  spawn ssh-keygen -t rsa;
  expect \"save the key\";
  send \"\n\";
  expect \"empty for no passphrase\" {send \"\n\"} \"Overwrite (y/n)?\" {send \"y\n\"};
  expect \"same passphrase again:\";
  send \"\n\";
  expect"
}

add()
{
  if [ ! -r "$HOME/.ssh/id_rsa.pub" ]; then
    keygen;
  fi;

  echo ">>>>>>>>>>>>>>>>>>> $1 >>>>>>>>>>>>>>>>>>>>";
  save_keys $1 $2;
}

clean()
{
    expect -c ";
    set timeout 1;
    spawn ssh -p $SSH_PORT $USER@$1;
    expect \"(yes/no)?\" {send \"yes\n\"};
    expect \"password:\" {send \"$2\n\"} \"$\" {};
    set timeout 3;
    send \"rm -rf ~/.ssh\n\";
    send \"exit\n\";
    expect";
}

usage()
{
  echo;
  echo "Usage:$0 add|clean host password";
  echo;
}

main()
{
  flag=$1 
  shift

  if [ "$flag" == "add" ]; then
    add $@;
  elif [ "$flag" == "clean" ]; then
    clean $@;
  else
    usage;
  fi
}

#====
main $*;

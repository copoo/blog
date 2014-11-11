#!/usr/bin/env bash
which git

[ $? ] || yum install -y git
[ $? ] && {
  git clone https://github.com/gmarik/vundle.git ~/.vim/bundle/vundle
}


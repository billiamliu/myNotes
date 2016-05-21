#!/bin/bash
PATHOGEN=https://tpo.pe/pathogen.vim
NERDTREE=https://github.com/scrooloose/nerdtree.git
AIRLINE=https://github.com/vim-airline/vim-airline
echo "Enter your name:"
read NAME
echo "Enter your email address:"
read EMAIL
echo "Hello $NAME at $EMAIL"
echo "------------"
echo "Begin init script to set up this linux instance"
sudo apt-get update
sudo apt-get install git
sudo apt-get install tmux
sudo apt-get install vim
git config --global user.name "$NAME"
git config --global user.email "$EMAIL"
mkdir -p ~/.vim/autoload ~/.vim/bundle && curl -LSso ~/.vim/autoload/pathogen.vim $PATHOGEN
git clone $NERDTREE ~/.vim/bundle/
git clone $AIRLINE ~/.vim/bundle/vim-airline
echo "Generating SSH key, run `ssh-add ~/.ssh/id_rsa` afterwards to add key to agent. The rest is all yours."
ssh-keygen -t rsa -b 4096 -C "$EMAIL"

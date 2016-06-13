#!/bin/bash
PATHOGEN=https://tpo.pe/pathogen.vim
NERDTREE=https://github.com/scrooloose/nerdtree.git
AIRLINE=https://github.com/vim-airline/vim-airline
ELIXIRURL=https://packages.erlang-solutions.com/erlang-solutions_1.0_all.deb
NODEURL=https://deb.nodesource.com/setup_6.x
VIMRC=https://github.com/billiamliu/myNotes/raw/master/configFiles/.vimrc
GITIGNORE=https://github.com/billiamliu/myNotes/raw/master/configFiles/.gitignore
SYNTASTIC=https://github.com/scrooloose/syntastic.git

echo ">>> Enter your name:"
read NAME
echo ">>> Enter your email address:"
read EMAIL
clear

echo ">>> Hello $NAME at $EMAIL"
echo ">>> (1/5) Install ssh-server? [y/n]"
read SERV
echo ">>> (2/5) Create passphrase for SSH key. Enter 'n' to skip"
read KEY
echo ">>> (3/5) Install node? [y/n]"
read NODE
echo ">>> (4/5) Install elixir? [y/n]"
read ELIXIR
echo ">>> (5/5) Install ruby? [y/n]"
read RUBY
echo -en '\n'
echo ">>> Begin init script to set up this linux instance"
echo "in 3..."
sleep 1
echo "in 2.."
sleep 1
echo "in 1."
sleep 1
echo ">>> All systems go."
echo -en '\n'

sudo apt-get update
sudo apt-get -y install git
sudo apt-get -y install tmux
sudo apt-get -y install vim

git config --global user.name "$NAME"
git config --global user.email "$EMAIL"
curl -L $GITIGNORE > ~/.gitignore

mkdir -p ~/.vim/autoload ~/.vim/bundle && curl -LSso ~/.vim/autoload/pathogen.vim $PATHOGEN
curl -L $VIMRC > ~/.vimrc
git clone $NERDTREE ~/.vim/bundle/
git clone $AIRLINE ~/.vim/bundle/vim-airline
git clone $SYNTASTIC ~/.vim/bundle/

if [ "$SERV" = "y" ] || [ "$SERV" = "Y" ]; then
  sudo apt-get -y install ssh-server
  sudo /etc/init.d/ssh restart
fi

if [ "$NODE" = "y" ] || [ "$NODE" = "Y" ]; then
  curl -sL $NODEURL | sudo -E bash -
  sudo apt-get -y install nodejs
  sudo ln -s /usr/bin/nodejs /usr/bin/node
  sudo npm install -g eslint
fi

if [ "$ELIXIR" = "y" ] || [ "$ELIXIR" = "Y" ]; then
  wget $ELIXIRURL && sudo dpkg -i erlang-solutions_1.0_all.deb
  sudo apt-get update
  sudo apt-get -y install esl-erlang
  sudo apt-get -y install elixir
  rm erlang-solutions_1.0_all.deb
fi

if [ "$RUBY" = "y" ] || [ "$RUBY" = "Y" ]; then
  sudo apt-get -y install ruby-full
fi

while [ $KEY -lt "n" ]
do
  echo -e '\n' | ssh-keygen -t rsa -N $KEY -b 4096 -C "$EMAIL"
  echo "almost done SSH, make sure to run 'eval \"$(ssh-agent -s)\"' & 'ssh-add ~/.ssh/id_rsa' and enter your passphrase"
done

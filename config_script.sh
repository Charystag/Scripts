#!/bin/bash
if [ "$2" == "" ]
then
	echo "Please enter your username and your email for git config"
	echo "Use the script as follows : ./path_to_script username email"
	exit 3
fi
cat <<GREETINGS
Welcome to the configuration script for your virtual (or not) machine
Before the script starts and you are ready to use the VM one warning
RTFM! Often the question your asking has been forecasted by the ones
who developped the tool you're now using and more often than not the
answer is in the doc.
Write an email to nsainton@student.42.fr in case of trouble.
Now I wish you the best programming experience
GREETINGS

sudo -s -- <<CONFIGURATION
apt install git
apt install curl
apt install pip
apt install zsh
apt install vim
CONFIGURATION
if [ -d $HOME/.oh-my-zsh ]
then
	echo "ZSH already exists"
	omz_switch="off"
else
	sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
	omz_switch="on"
fi
git config --global init.defaultBranch main
git config --global user.email $2
git config --global user.name $1
python3 -m pip install --upgrade pip setuptools
python3 -m pip install norminette
if [ $omz_switch == "on" ]
then
	echo $omz_switch
	echo "export \$PATH=\"\$HOME/.local/bin:\$PATH\"" >> $HOME/.zshrc
fi
cat <<VIMCONFIG > $HOME/.vimrc
filetype on
set autoindent
set tabstop=4
let g:user42 = 'nsainton'
let g:mail42 = 'nsainton@student.42.fr'
set number
VIMCONFIG

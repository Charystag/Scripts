#!/bin/bash
if [[ ! -f .fl ]]
then
	cat <<-GREETINGS
	Welcome to the configuration script for your virtual (or not) machine
	Before the script starts and you are ready to use the VM one warning
	RTFM! Often the question your asking has been forecasted by the ones
	who developped the tool you're now using and more often than not the
	answer is in the doc.
	Don't forget to upgrade your system to the latest version too
	Write an email to nsainton@student.42.fr in case of trouble.
	Now I wish you the best programming experience
	GREETINGS
	touch .fl
	exit
fi
if [ "$2" == "" ]
then
	echo "Please enter your username and your email for git config"
	echo "Use the script as follows : ./path_to_script username email"
	exit 3
fi

sudo -s -- <<CONFIGURATION
apt -y update
apt -y upgrade
apt -y install curl
apt -y install pip
apt -y install zsh
apt -y install vim
apt -y install valgrind
apt -y install bat
apt -y install clang
apt -y install libreadline
apt -y install libX11 libXext
CONFIGURATION
if [ $? != 0 ]
then
	echo unknown error, might be due to interaction
	exit 3
fi
lbin="$HOME/.local/bin"
ubin="/usr/bin"
mkdir -p $lbin
ln -s $ubin/batcat $lbin/bat
if [ -d $HOME/.oh-my-zsh ]
then
	echo "ZSH already exists"
	omz_switch="off"
else
	yes | sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
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
	echo "export PATH=\"\$HOME/.local/bin:\$PATH\"" >> $HOME/.zshrc
fi
cat <<VIMCONFIG > $HOME/.vimrc
filetype on
set autoindent
set tabstop=4
let g:user42 = 'nsainton'
let g:mail42 = 'nsainton@student.42.fr'
set number
VIMCONFIG

plugins_folder="$HOME/.vim/plugin"
stdheader="stdheader.vim"
if [ ! -f $plugins_folder/stdheader.vim ]
then
	mkdir -p $plugins_folder
	sh -c "$(curl -fsSL https://raw.githubusercontent.com/42Paris/42header/master/plugin/stdheader.vim -o $plugins_folder/$stdheader)"\
	&& echo $stdheader installed || echo Unknown error
fi

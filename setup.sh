#!/bin/bash


#############################################################################################################################################
# Copyright (C) 

# This program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.

# This program is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU General Public License for more details.

#  You should have received a copy of the GNU General Public License along with this program. If not, see http://www.gnu.org/licenses/.

#############################################################################################################################################


install_vim()
{
	vimIns=$(which vim)

	[[ ! "$vimIns" ]] && yes | sudo apt install vim 

	mkdir ~/.vim/ && cd ~/.vim/
	mkdir bundle/ && cd bundle/
	mkdir YouCompleteMe/
	git clone "https://github.com/oblitum/YouCompleteMe" ~/.vim/bundle/YouCompleteMe/
	cd
	yes | sudo apt install build-essential cmake
	yes | sudo apt install python-dev python3-dev
	cd ~/.vim/bundle/YouCompleteMe/
	git submodule update --init --recursive
	./install.py --clang-completer
	cd

	sudo apt install curl
	git clone https://github.com/VundleVim/Vundle.vim.git ~/.vim/bundle/Vundle.vim
	mkdir ycm_build && cd ycm_build/
	cmake -G "<generator>" . ~/.vim/bundle/YouCompleteMe/third_party/ycmd/\cpp

	cp $path/0desk_settings/software/.vimrc ~/
	cp $path/0desk_settings/software/.ycm_extra_conf.py ~/.vim/bundle/YouCompleteMe/third_party/ycmd/examples/
	cd
}

installClang()
{
	wget -O - https://apt.llvm.org/llvm-snapshot.gpg.key | sudo apt-key add -
	sudo apt-add-repository "deb http://apt.llvm.org/xenial/ llvm-toolchain-xenial-5.0 main"
	sudo apt update
	sudo apt install -y clang-5.0
}

prepareDesktop()
{
	installClang
	install_vim
}

Online=0
for i in $(ls /sys/class/net/ | grep -v lo)
do
	[[ $(cat /sys/class/net/$i/carrier) = 1 ]] && let OnLine=Online+1 
done
[ $OnLine ] &&  echo "Preparing Desktop..." && prepareDesktop  
! [ $Online ] && echo "No Internet Connection!" 


exit 0


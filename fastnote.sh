#!/bin/bash

home=$HOME/.fastnote

back() {
	echo -n "- press enter to return ~ "
	read
}

_reload() {
     if [ "$shell"=="bin/bash" ]; then
         source $HOME/.bashrc
     elif [ "$shell"=="bin/zsh" ]; then
         source $HOME/.zshrc
     fi
}



_help() {
	echo -e "\nusage : bash fastnote.sh"
	echo -e "args  :\n\t-i : install\n\t-h : displays this help\n"
	back	
}

#builds the '.fastnote' folder in $HOME, makes an alias for fastnote
initial() {
	if [ -d "$home" ];then
		echo "- fastnote is already installed !"
	else
		mkdir $home
		mkdir $home/notes
		cp fastnote.sh $home/
		if [ "$SHELL" == "bin/bash" ];then 
			echo -e "\nalias fnote=\"bash $home/fastnote.sh\"" >> $HOME/.bashrc
		else
			echo -e "\nalias fnote=\"bash $home/fastnote.sh\"" >> $HOME/.zshrc
		fi
		
		echo "- fastnote initialized !"
		_reload
		echo "- now just type 'fnote' to run the fastnote tool :)"
	fi
}

#opens a file with 'ntitle' name in 'vim' tool
new() {
	echo -n "- enter note title name : "
	read ntitle
	vim $home/notes/$ntitle
	back
}

#opens the 'ntitle' file if exists
open() {
	echo -n "- enter note title name : "
	read ntitle
	if [ -f "$home/notes/$ntitle" ];then
		vim $home/notes/$ntitle
	else
		echo "sorry, the note with this -> '$ntitle' title doesn't exists !"
	fi
	back
}

#runs 'rm' command on 'ntitle' file if exists
delete() {
	echo -n "- enter note title name : "
	read ntitle
	if [ -f "$home/notes/$ntitle" ];then
		rm $home/notes/$ntitle
		echo "- '$ntitle' successfully removed !"
	else
		echo "sorry, the note with this -> '$ntitle' title doesn't exists !"
	fi
	back
}

notes() {
	ls $HOME/.fastnote/notes
	back
}

rename() {
	echo -n "- enter note title name : "
	read ntitle
	if [ -f "$home/notes/$ntitle" ];then
		echo -n "- now enter new title : "
		read rtitle
		mv $home/notes/$ntitle $home/notes/$rtitle
		echo "- '$ntitle' successfully renamed to '$rtitle' !"	
	else
		echo "sorry, the note with this -> '$ntitle' title doesn't exists !"
	fi
	back
}

fastnote() {
	if [ -d $home ];then
		while [ 0 ]; do 
			clear
			echo -e "\t[ FAST NOTE ]"
			echo -e "   to exit just press enter\n\
			don't kid yourself :)\n"
			echo -e "[1]- new\t[2]- append"
			echo -e "[3]- read\t[4]- remove"
			echo -e "[5]- notes\t[6]- rename"
			echo -e "[7]- install\t[8]- help\n"

			echo -n "fastnote ~ "    
			read ope
			
			if [ "$ope" == "" ];then
				break	
			elif [ "$ope" == "1" ];then
				new
			elif [ "$ope" == "2" ];then
				open
			elif [ "$ope" == "3" ];then
				open
			elif [ "$ope" == "4" ];then
				delete
			elif [ "$ope" == "5" ];then
				notes
			elif [ "$ope" == "6" ];then
				rename
			elif [ "$ope" == "7" ];then
				initial	
				back
			elif [ "$ope" == "8" ];then
				_help
			fi
		done
	else
		echo "first install it : ./fastnote.sh -i"
	fi
}

if [ "$1" == "-i" ];then
       initial
elif [ "$1" == "-h" ];then
       _help	
else       
	fastnote
fi

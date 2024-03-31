#!/bin/bash

home=$HOME/.fastnote


back() {
	echo -n "- press enter to return ~ "
	read
}


#reload the shell
_reload() {
     if [ "$shell"=="bin/bash" ]; then
         source $HOME/.bashrc
     elif [ "$shell"=="bin/zsh" ]; then
         source $HOME/.zshrc
     fi
}


#display the help
_help() {
	echo -e "\nusage : bash fnote.sh"
	echo -e "args  :\n\t-i : install\n\t-h : displays this help\n"
	back
}


#builds the '.fastnote' folder in $HOME, makes an alias for fastnote
initial() {
	if [ -d "$home" ]
	then
		echo "[+] fastnote is already installed !"

	else
		mkdir $home
		mkdir $home/notes
		echo "# This file holds the default text editor for fastnote" >> $home/fnote_text_editor.conf
		echo "# To use your favorite text editor, change the following line." >> $home/fnote_text_editor.conf
		echo "default_text_editor=vi" >> $home/fnote_text_editor.conf
		cp fnote.sh $home/

		if [ "$SHELL" == "bin/bash" ]
		then
			echo -e "\nalias fnote=\"bash $home/fnote.sh\"" >> $HOME/.bashrc
		else
			echo -e "\nalias fnote=\"bash $home/fnote.sh\"" >> $HOME/.zshrc
		fi

		echo "- the default text editor is set to 'vi'."
		echo "- you can use your favorite text editor by changing fnote_text_editor.conf file."
		echo "- fnote_text_editor.conf is in $home/"
		echo "[+] fastnote is successfully initialized !"
		_reload
		echo "[+] now, just type 'fnote' to run the fastnote tool :)"
	fi
}


#opens a file with 'ntitle' name in 'text_editor'
new() {
	echo -n "- note title : "
	read ntitle
	$text_editor $home/notes/$ntitle
	back
}


#opens the 'ntitle' file if exists
open() {
	echo -n "- note title : "
	read ntitle
	if [ -f "$home/notes/$ntitle" ];then
		$text_editor $home/notes/$ntitle
	else
		echo "[!] '$ntitle' note doesn't exists !"
	fi
	back
}


#deletes 'ntitle' note
delete() {
	echo -n "- note title : "
	read ntitle
	if [ -f "$home/notes/$ntitle" ];then
		rm $home/notes/$ntitle
		echo "[+] '$ntitle' successfully removed !"
	else
		echo "[!] '$ntitle' note doesn't exists !"
	fi
	back
}


#returns a list of all the notes
notes() {
	ls $HOME/.fastnote/notes
	back
}


#to rename a note
rename() {
	echo -n "- note title : "
	read ntitle
	if [ -f "$home/notes/$ntitle" ];then
		echo -n "- new title : "
		read rtitle
		mv $home/notes/$ntitle $home/notes/$rtitle
		echo "[+] '$ntitle' is successfully renamed to '$rtitle' !"
	else
		echo "[!] '$ntitle' note doesn't exist !"
	fi
	back
}


fastnote() {
	while [ 0 ]; do
		clear
		echo -e "\t[ FAST NOTE ]"
		echo -e "   to exit just press enter\n"
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
}


if [ "$1" == "-i" ]
then
	initial
elif [ "$1" == "-h" ]
then
	_help
else
	if [ -d $home ]
	then
		if [ -f "$home/fnote_text_editor.conf" ]
		then
			ltn=$(awk "/default_text_editor/{ print NR; exit }" $home/fnote_text_editor.conf)
			echo $ltn
			text_editor=$(cat $home/fnote_text_editor.conf | sed "${ltn}q;d" | sed -r "s/\w*\=//")
			fastnote
		else
			echo "[!] $home/fnote_text_editor.conf not found !"
			echo "- run the fastnote with -i falg to fix the problem"
		fi
	else
		echo "- first install fastnote : ./fnote -i"
	fi
fi

#!/usr/bin/bash

:<<-'CONV_ADDRESS'
	This function takes a string representing an IP address with bytes in decimal
	base and outputs it in binary base.
	Example:
	Input : 127.0.0.1
	Output : 01111111.00000000.00000000.00000001
	CONV_ADDRESS
conv_address(){
	prompt="Please provide an ip address"
	err_string="Invalid ip address provided"
	echo "$prompt"
	read -r base_address
	if [ "$prompt" = "" ] ; then echo "Please provide an ip address" ; return 1 ; fi
	#if [ "$2" = "" ] ; then base_in=10 ; else base_in="$2" ; fi
	#if [ "$3" = "" ] ; then base_out=2 ; else base_out="$3" ; fi
	base_in=10;base_out=2
	IFS='.' read -ra address <<< "$base_address"
	if [ "${#address[@]}" -lt 1 ] ; then echo "No ip address found" ; return 2 ; fi
	declare -i i=0
	while [ "$i" -lt $((${#address[@]} - 1)) ]
	do
		# shellcheck disable=SC2046
		printf "%.8d." $(echo "ibase=$base_in;obase=$base_out;${address[$i]}" | bc)
		((++i))
	done
	# shellcheck disable=SC2046
	printf "%.8d\n" $(echo "ibase=$base_in;obase=$base_out;${address[$i]}" | bc)
	echo "back to main menu" ; choice
}

:<<-'MASK_TO_BIN'
	Takes a subnet mask of the form /x with x between 0 and 32 and outputs the binary
	representation of the mask.
	Example:
	Input : /28
	Output : 11111111.11111111.11111111.11110000
	MASK_TO_BIN
mask_to_bin(){
	prompt="Please provide a mask of the form /x with -1<x<33"
	err_string="Invalid mask provided"
	echo "$prompt"
	read -r mask_string
	if [ "$mask_string" = "" ] || [ "${mask_string:0:1}" != "/" ] ; then echo "$err_string" ; return 1 ; fi
	length=$((${#mask_string}-1))
	if [ "$length" -lt 1 ] ; then echo "$err_string" ; return 1 ; fi
	mask=""
	declare -i i=0
	while [ "$i" -lt "32" ]
	do
		if [ "$i" -lt "${mask_string:1:$length}" ] ; then dig='1' ; else dig='0' ; fi
		mask="$mask""$dig"
		(( ++i ))
		if [ $((i % 8)) -eq '0' ] && [ "$i" -ne "32" ] ; then mask="$mask"'.' ; fi
	done
	echo "$mask"
	echo "Back to main menu"
	choice
}

:<<-'MENU'
	Prints the main menu of the program
	MENU
menu(){
	printf "%-12b%b\n" "[1]" "For mask conversion from /x to binary"
	printf "%-12b%b\n" "[2]" "For mask conversion from binary to /x"
	printf "%-12b%b\n" "[3]" "For ip conversion from decimal to binary"
	printf "%-12b%b\n" "[q]" "To exit the program"
}

:<<-'CHOICE'
	Allows the user to choose their prefered option and to launch the right
	function
	CHOICE
choice(){
	#menu
	printf "%b\n" "Please choose a conversion option"
	while true
	do 
		menu
		read -rn 1 user_choice ; echo
		case "$user_choice" in ( [123] ) break ;; 
			[q] ) echo "Exiting..." ; exit 0 ;;
			* ) echo "Please select a true option" ;; esac
	done
	if [ "$user_choice" -eq "1" ] ; then mask_to_bin ; exit 0
	elif [ "$user_choice" -eq "2" ] ; then echo "Need to implement" ; exit 0
	else conv_address ; fi
}

main(){
	#if [ "$1" == "" ] ; then echo "Please provide data to convert" ; exit 1 ; fi
	#data="$1"
	choice
	#if [ "${data:0:1}" == "/" ] ; then mask_to_bin "$data" ; else conv_address "$data" ; fi
}

main

:<<'COMMENT'
IFS='.' read -ra bonjour <<< "$1"
cat <<< "$1"
echo $1
echo "${bonjour[@]}"
COMMENT

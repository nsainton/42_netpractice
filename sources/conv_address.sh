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
	#err_string="Invalid ip address provided"
	if [ "$1" = "" ]
	then echo "$prompt" ; read -r base_address
	else base_address="$1" ; fi
	if [ "$base_address" = "" ] ; then echo "Stop messin' with me bruv" ; exit 1 ; fi
	if [ "$2" = "" ] ; then base_in=10 ; else base_in="$2" ; fi
	if [ "$3" = "" ] ; then base_out=2 ; else base_out="$3" ; fi
	IFS='.' read -ra address <<< "$base_address"
	if [ "${#address[@]}" -lt 1 ] ; then echo "No ip address found" ; return 2 ; fi
	declare -i i=0
	while [ "$i" -lt $((${#address[@]} - 1)) ]
	do
		# shellcheck disable=SC2046
		printf "%.8d." $(echo "ibase=$base_in;obase=$base_out;${address[$i]}" | bc)
		(( ++i ))
	done
	# shellcheck disable=SC2046
	printf "%.8d\n" $(echo "ibase=$base_in;obase=$base_out;${address[$i]}" | bc)
}

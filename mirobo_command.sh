#!/bin/bash
path2=/vagrant_data/micom

rstart () {
	mirobo --ip 192.168.1.218 --token 354759454f4c6f446f74506b7a45616f start
	echo "$(date '+%D %T') CONDITION MET" >> /var/usage
}

rstop () {
	mirobo --ip 192.168.1.218 --token 354759454f4c6f446f74506b7a45616f home
}

rinfo () {
	echo "$(mirobo --ip 192.168.1.218 --token 354759454f4c6f446f74506b7a45616f)"
}

rlastarea () {
	echo "$1" | grep -P "Cleaned area:\s[0-9]*\." -o | grep -P "[0-9]*" -o
}

rlastbattery () {
	echo "$1" | grep -P "Battery:\s[0-9]+\s" -o | grep -P "[0-9]*" -o
}

rlaststate () {
	 echo "$1" | grep -P "State:\s.+" -o | grep -P "\b(\w+)$" -o
}

rcheckphones () {
	set -e
	ipregex='(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)'
	grep -Eo $ipregex  ${path2}/ipList | while read line ;
	do
	ping -c 4 -w 6 ${line} >> /dev/null && exit 1 || echo "${line} not connected" >> /var/log/syslog
	done
}
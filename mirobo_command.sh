#!/bin/bash
path2=/vagrant_data/micom

rstart () {
	mirobo --ip ${ip} --token ${token} start
	echo "$(date '+%D %T') CONDITION MET" >> /var/usage
}

rstop () {
	mirobo --ip ${ip} --token ${token} home
}

rinfo () {
	echo "$(mirobo --ip ${ip} --token ${token})"
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

#!/bin/bash

	set -e

	echo "...starting script..." >> /var/log/syslog
	echo "...evaluating state..." >> /var/log/syslog
	robot_info=$(rinfo)
	echo "${robot_info}" >> /var/log/syslog
	total_area=100
	min_battery=50
	# cancel if
	# phone's ip up\s
		rcheckphones && echo "...no phone connected..."
	# did clean today
		if (($(wc -l < /var/usage) > 2));
		then 
			echo "--> ...already cleaned today...!" >> /var/log/syslog
			return;
		else
			echo "...didn't cleaned today..." >> /var/log/syslog
		fi
	# state must be charging
		last_state=$(rlaststate rinfo)
		if [[ ${last_state} != "Charging" ]];
		then
			echo "--> ...robot is busy...${last_state}!" >> /var/log/syslog
			return;
		else
			echo "...robot is not busy..." >> /var/log/syslog
		fi
	# battery above 30%
		last_battery=$(rlastbattery rinfo)
		if ((${last_battery} < min_battery));
		then
			echo "--> ...battery is too low...!" >> /var/log/syslog
			return;
		else
			echo "...battery is good..." >> /var/log/syslog
		fi
	# then start clean if got here
		echo "...starting to clean..." >> /var/log/syslog
		rstart

#!/bin/bash

#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
#SensorLogs - Logging & Audit Script
#Designed to run as an ongoing background systemd service (suggestion - running as root will include process names in netstat output)
#Takes a bespoke snapshot of system information & refreshes at user-defined interval 
#Author - JORT
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

#--------------Variables--------------
declare refresh_timer=5 #default 5sec
#Set log location - default will pull user 1000 (often default system admin) as default value for home directory
StandardAdmin=$(sudo cat /etc/passwd | grep 1000 | awk -F':' '{ print $1 }')
	declare log="/home/$StandardAdmin/Sensors.log"
	touch $log
#-------------------------------------

#----------Functions------------------

#Basic system information
function GrabSysInfo () {
  echo "---------------------" >> $log
  echo "System Information:" >> $log
  echo "---------------------" >> $log
	echo "Hostname: $(hostname)" >> $log
	echo "Linux Version: $(uname -r)" >> $log
	echo "System Uptime: $(uptime -p)" >> $log
  echo "~~~~~~~~~~~~~~~~" >> $log
  echo "users logged in::" >>$log
  echo "~~~~~~~~~~~~~~~~" >> $log
	who >> $log
	
echo " " >>$log
}

# used by GrabThermals only if lmsensors is detected & installed
	function PrintThermals() {
		echo " "  >> $log
			sensors >> $log
		echo " "  >> $log
	}

#Thermal Logs (requires lmsensors - install & run to configure sensors before including this section)
function GrabThermals () {
	echo "================" >> $log
	echo "Thermal Sensors:" >> $log
	echo "================" >> $log
#quick sanity check for dependency:	
	SensorSanityCheck="$(which sensors)"
	if [ -z "$SensorSanityCheck" ]
	then	echo "Sensors unavaialable: please install and configure lmsensors via package manager for $(uname -o). Thank you" >> $log
	else	$(PrintThermals)
	fi
}

function PrintCurrentConnections () {
echo " " >>$log
	sudo netstat -pano | grep ESTABLISHED | awk '{print $4, $5, $7, $8, $9, $10}' > /tmp/ports.list
	sed -i 's/ /....../g' /tmp/ports.list && cat /tmp/ports.list >> $log
echo " " >>$log
}

#Network Check
function GrabNetworkInfo () {
echo " " >>$log
  echo "----------------------------" >> $log
  echo "   Network Connectivity:" >> $log
  echo "----------------------------" >> $log
	ifconfig >>$log #uses ifconfig to ensure compatibilty with older distro/kernel builds

echo " " >>$log
  echo "*******************" >> $log
  echo "ACTIVE CONNECTIONS:" >> $log
  echo "*******************" >> $log

#quick sanity check for dependency:	
	NetworkSanityCheck="$(which netstat)"
	if [ -z "$NetworkSanityCheck" ]
	then	echo "Sensors unavaialable: please install and configure lmsensors via package manager for $(uname -o). Thank you" >> $log
	else	$(PrintCurrentConnections)
	fi
}

#Check Filesystems
function GrabFileInfo () {
  echo "----------------------------" >> $log
  echo " Storage Capacity Detected:" >> $log
  echo "----------------------------" >> $log
	  df -hT >> $log

#uncomment to enable scans of specific directories - this will print the full size of contained subdirectories. By efault, this will scan all home directories.
#example: du -shc /home/kali/*  ←will print the size of each directory inside of /home/kali in a human-readable format
	echo "----------------------------" >> $log
	echo "__User-Defined Directory Sizes:__" >> $log
	echo " " >> $log
	echo -e "Size \t Directory" >>$log
		du -shc /home/$StandardAdmin/* >>$log
	echo "----------------------------" >>$log

echo " " >> $log
}

#Add any Custom Messages here:
function CustomBanners () {
	echo "****************" >> $log
	echo "Custom Messages:" >> $log
	echo "****************" >> $log

	echo "<your custom message here>" >> $log
	echo " " >> $log
	echo "Thank you for running SensorLogs -JORT" >> $log
}

#------------------Logging Script:-----------------------------------------

while true; do
	date > $log #ensures overwrite previous log entries
		echo "_______________________________________________________________" >> $log
	GrabSysInfo
		echo "_______________________________________________________________" >> $log
	GrabThermals
		echo "_______________________________________________________________" >> $log
	GrabNetworkInfo
		echo "_______________________________________________________________" >> $log
	GrabFileInfo
		echo "_______________________________________________________________" >> $log
	CustomBanners
		echo "_______________________________________________________________" >> $log

	sleep $refresh_timer

done

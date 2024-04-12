#! /bin/bash


#________JORT's manual backup script.____________
#Does what it says on the tin. Copies full directories (only updating new files) recursively

#------------------------------------------------
#**Notes**
#	>> Reads list of target directories for copying from a list - file sources.list is included with repo. 
#	>> Edit the sources.list contents to reflect directories to copy. There is no upper limit, delineate each new directory with a new line. By default, it contains the Documents & Downloads directory for user 1000.
# >> Log file defaults to home directory for user 1000 (often system admin). This can be changed by editing the variable log, found just before the copy commands
#------------------------------------------------



#_____________________________________________________
#__ENTER BACKUP DESTINATION BELOW (between quotes)____

destination=''

#...
#Did you enter a value for Destination (above)?



#_____________________________________________________
#_____________Variables_______________________________
StandardAdmin=$(sudo cat /etc/passwd | grep 1000 | awk -F':' '{ print $1 }')	#Grabs the typical "admin" user account as default
log="/home/$StandardAdmin/.backup.log"	#Edit to set custom location for log file
Sources="./sources.list"	#Edit the contents of sources.list to designate directories to copy.




#_______________________________________________________
#_______________**FUNCTIONS**___________________________
	#sanity check for a destination input
function Check4Destination () {
	if [ -z "$destination" ]
	then	echo "You did not set a destination directory. Please edit manual.bkup.sh to include a destination directory" > $log && exit 1
	fi
}

	#Creates a blank array, then populates it with each line from sources.list
function ReadSources () {
	 Sourcelist=()

	while IFS='' read -r line || [ -n "$line" ]; do
		Sourcelist+=("$line")
	done < "${Sources}"
}

	#Actual copy job:
function StartCopy () {
	for source in "${sourcelist[@]}"; do
	cp -Rriv -u --preserve=all "$source" "$destination" > $log
	done
}

	#Tag a timestamp to the end of the log file
function WrapUp () {
	echo "_______________________________________________________________________" >> $log
	echo " " >> $log
	echo "Succesfully backed up contents on: $(date)" >> $log
}




#_______________________________________________________
#_______________SCRIPT__________________________________
touch $log $sources
Check4Destination
ReadSources
StartCopy
WrapUp
exit 0
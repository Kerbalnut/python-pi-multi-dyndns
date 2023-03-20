#!/bin/bash

#Index: 
# 1. Information & Description:
# 2. Setup & Instructions:
#     2a. Dependences:
# 3. Parameters:
# 4. Functions:
# 5. Main:
#     1. Imports & set vars -------------------------------------------------------------------------------------
#     2. Create log file if it doesn't exist --------------------------------------------------------------------
#     3. 1st URL call: Get our Public IP ------------------------------------------------------------------------
#     4. 2nd URL call: Get NameSilo's IP for our domain name ----------------------------------------------------
#     5. Examine & Compare Responses ----------------------------------------------------------------------------
#     6. 3rd (possible) URL call: Set NameSilo's IP for our domain name -----------------------------------------
# 6. Footer:

# --------------------------------------------------------------------------------------------------------
# Information & Description:

# Clean-up log file for:
# /home/pi/dyndns/dyndns.py
# e.g.
# /home/pi/dyndns/dyndns.log

# /Information & Description
# --------------------------------------------------------------------------------------------------------
# Setup & Instructions:

# To copy this script to Raspberry Pi via PuTTY:
#pscp "%UserProfile%\Documents\Flash Drive updates\Pi-Hole DNS server\logcleanup.sh" pi@my.pi:/home/pi/dyndns/logcleanup.sh

# Make script executable:
# Note that to make a file executable, you must set the eXecutable bit, and for a shell script, the Readable bit must also be set:
#cd /home/pi/dyndns/
#ls -l
#chmod a+rx logcleanup.sh
#ls -l

# Permissions breakdown:
# drwxrwxrwx
# | |  |  |
# | |  |  others
# | |  group
# | user
# is directory?

# u  =  owner of the file (user)
# g  =  groups owner  (group)
# o  =  anyone else on the system (other)
# a  =  all

# + =  add permission
# - =  remove permission

# r  = read permission
# w  = write permission
# x  = execute permission

# To run this script: 
#/home/pi/dyndns/logcleanup.sh
#cd /home/pi/dyndns/
#./logcleanup.sh

# Schedule script to run automatically once every 2 weeks:
#crontab -l
#crontab -e
#0 0 */14 * * /home/pi/dyndns/logcleanup.sh
#crontab -l

# Schedule script to run automatically once every month:
#crontab -l
#crontab -e
#0 0 1 */1 * /home/pi/dyndns/logcleanup.sh
#crontab -l

# m h  dom mon dow   command

# * * * * *  command to execute
# - - - - -
# ¦ ¦ ¦ ¦ ¦
# ¦ ¦ ¦ ¦ ¦
# ¦ ¦ ¦ ¦ +----- day of week (0 - 7) (0 to 6 are Sunday to Saturday, or use names; 7 is Sunday, the same as 0)
# ¦ ¦ ¦ +---------- month (1 - 12)
# ¦ ¦ +--------------- day of month (1 - 31)
# ¦ +-------------------- hour (0 - 23)
# +------------------------- min (0 - 59)

# /Setup & Instructions
# --------------------------------------------------------------------------------------------------------
# Parameters:

CURRENT_LOGFILE_PATH="/home/pi/dyndns/dyndns.log"

#ARCHIVE_LOGFILE_PATH="/home/pi/dyndns/dyndns-LastTwoWeeks.log"
#ARCHIVE_LOGFILE_PATH="/home/pi/dyndns/dyndns-LastMonth.log"
ARCHIVE_LOGFILE_PATH="/home/pi/dyndns/dyndns_OLD.log"

# /Parameters
# --------------------------------------------------------------------------------------------------------
# Functions:

#!/bin/bash
# init
function pause(){
	# e.g.
	# pause 'Press [Enter] key to continue...'
	# https://www.cyberciti.biz/tips/linux-unix-pause-command.html
	# read -p "Press [Enter] key to start backup..."
	#read -p "$*"
	read -p "Press [Enter] key to continue..."
}

function AppendLogFooter(){
	ARCHIVE_LOGFILE_PATH=$1
	shift;
	#shift; shift;
	# Having shifted once, the rest is now comments ...
	COMMENTS=$@
	# Append footer message to archive log file:
	echo $'\n'"Wrapping-up archive log file: $ARCHIVE_LOGFILE_PATH"
	#CURRENT_TIMESTAMP=`date --iso-8601=ns`
	CURRENT_TIMESTAMP=`date --rfc-3339=seconds`
	echo "Current date/time: $CURRENT_TIMESTAMP"
	echo "--------------------------------------------------------------------------------" >> $ARCHIVE_LOGFILE_PATH
	echo $'\n' >> $ARCHIVE_LOGFILE_PATH
	echo "--------------------------------------------------------------------------------" >> $ARCHIVE_LOGFILE_PATH
	echo "Archived:" $CURRENT_TIMESTAMP $'\n' >> $ARCHIVE_LOGFILE_PATH
	if [ -v $COMMENTS ]; then
		# Var is sets.
		echo $'\n' >> $ARCHIVE_LOGFILE_PATH
		echo "Archive message:" $COMMENTS $'\n' >> $ARCHIVE_LOGFILE_PATH
	fi
	echo $'\n' >> $ARCHIVE_LOGFILE_PATH
}

# /Functions
# --------------------------------------------------------------------------------------------------------
# Main:

# https://www.shellscript.sh/

# Delete archive log file:
printf "\nDeleting archive log file (if exists):\n"
echo $ARCHIVE_LOGFILE_PATH
if [ -f $ARCHIVE_LOGFILE_PATH ]; then
	# File exists.
	echo "Deleting file..."
	rm $ARCHIVE_LOGFILE_PATH
else
	# File does not exist.
	echo "File does not exist."
fi

# Copy current log file to archive position:
echo $'\n'"Copying current log file to archive position:"
echo current: $CURRENT_LOGFILE_PATH
echo archive: $ARCHIVE_LOGFILE_PATH
cp $CURRENT_LOGFILE_PATH $ARCHIVE_LOGFILE_PATH

# Append footer message to archive log file:
AppendLogFooter $ARCHIVE_LOGFILE_PATH
# Capture value returned by last command
echo "Current timestamp value is: $CURRENT_TIMESTAMP"

#echo $'\n'"Wrapping-up archive log file:"
##CURRENT_TIMESTAMP=`date --iso-8601=ns`
#CURRENT_TIMESTAMP=`date --rfc-3339=seconds`
#echo "Current date/time: $CURRENT_TIMESTAMP"
#echo "--------------------------------------------------------------------------------" >> $ARCHIVE_LOGFILE_PATH
#echo $'\n' >> $ARCHIVE_LOGFILE_PATH
#echo "--------------------------------------------------------------------------------" >> $ARCHIVE_LOGFILE_PATH
#echo "Archived:" $CURRENT_TIMESTAMP $'\n' >> $ARCHIVE_LOGFILE_PATH
#echo $'\n' >> $ARCHIVE_LOGFILE_PATH

# Delete current log file:
echo $'\n'"Deleting current log file:"
echo $CURRENT_LOGFILE_PATH
rm $CURRENT_LOGFILE_PATH

# /Main
# --------------------------------------------------------------------------------------------------------
# Footer:

echo "End of script."
echo $'\n'
#pause

# /Footer
# --------------------------------------------------------------------------------------------------------




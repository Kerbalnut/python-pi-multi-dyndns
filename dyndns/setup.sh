#!/bin/bash

# Shell script for installing 'dyndns.py' Dynamic DNS updates Python script

# --------------------------------------------------------------------------------------------------------

# Simple instructions:
# (Only after params file(s) have been created & setup, etc.)

# 1. Make this script executable:
#sudo chmod +x setup.sh

# 2. Run this script:
#sudo -i ./setup.sh
#. ./setup.sh

# --------------------------------------------------------------------------------------------------------

# Full instructions:

# Read all the instructions below first before executing this script.

# Overview: 
# A) Manually edit param/scp script files:
# B) Create 'dyndns' directory on the remote host:
# C) Copy files from local machine into newly created directory, with scp/scripts:
# D) Run this script on remote host to automate the rest of setup, or run the remaining commands manually:
# The Automatic steps: (this script will do these automatically)
# - Install any required dependency packages (apt packages and python modules via pip)
#    - (will not update any packages, only install any that are missing)
# - Test scripts and params files are working
# - Set permissions and cron jobs for scheduled automatic execution
#    - (dyndns.py and logcleanup.sh)

# --------------------------------------------------------------------------------------------------------

# First time setup instructions:

# All of these steps must be done manually.
# A) Manually edit param/scp script files:
# B) Create 'dyndns' directory on the remote host:
# C) Copy files from local machine into newly created directory, with scp/scripts:
# D) Execute this script on remote host to automate the rest of setup, or run the remaining commands manually:

# A) Manually edit param/scp script files:

# 1. Go into the dyndns/params folder first, and make a copy of each TEMPLATE file for each domain service you want to use.
#    - Remove the '_TEMPLATE' suffix from the filename when you make a copy. E.g. 'paramsGoDaddy_TEMPLATE.py' should become 'paramsGoDaddy.py'
#    - Edit each copied file with the specfic details for your account & domain name. You'll have to generate API keys for this, it's pretty simple to do once you find the right page on the website. Site-specific instructions will be in the comments of each params file.

# 2. Setup scp scripts for copying files back-and-forth.
# If you want to use the included PowerShell 'scp.ps1' script for copying these files back-and-forth with scp between your Windows and Linux machines, open scp.ps1 in an editor like PowerShell ISE or Vscode, and edit the Param() block at the top of the script. See the comments section at the top of this file for more info. (If all of this is still confusing to you, I'd recommend getting vscode for editing powershell (.ps1) and python (.py) and shell (.sh) scripts side-by-side. With vscode, you can even execute powershell code line-by-line within the editor.)

# B) Create 'dyndns' directory on the remote host:

# Simple instructions:

# 1. SSH into the remote raspberry pi/linux system.
# 2. Make a new directory named 'dyndns' in your home folder, to scp copy these files into later.
#        - mkdir dyndns
#        - (Or whatever you want to call this directory, or where-ever you want to put it.)

# Detailed instructions:

# 1. SSH into the remote raspberry pi/linux system. 
#        - (If you need help with this, there are many guides online. The basics are, make sure SSH server daemon is properly setup on the remote host, and for a local Windows SSH client PuTTY is some great software.)

# 2. Make a new directory named 'dyndns' in your home folder, to scp copy these files into later.
# After you have SSH'd into the remote machine and have a command line prompt, make a new directory called 'dyndns' in your user's home folder (the folder you probably landed in after SSH'ing in).

# For help doing this and navigating with the command line, see some sample commands below:
# print working directory
#pwd

# change directory to user's home folder (~): (Normally after logging in via SSH, you'll land in this folder automatically, so this is usually unnecessary. Tilde (~) character is a shortcut to this path.)
#cd ~

# list files & folders in a -long format:
#ls -l

# Check if the directory 'dyndns' does not already exist. And if it does not, make the directory with mkdir:
#mkdir dyndns

# If no errors appeared and you got a new line, the folder is now created and ready to copy files into! If you want, you can still double-check that it exists with commands like ls, navigate into it with cd, and see the full path with pwd.
#ls -l
#cd dyndns
#pwd
#cd ..
#pwd

# C) Copy files from local machine into newly created directory, with scp/scripts:

# 3. After the 'dyndns' folder is created on the target machine, copy the contents of 'dyndns' on your local machine over to it using any scp method of your choice. 
#    - Recommended: If you're on Windows, use the included PowerShell script in this repo 'scp.ps1'.
#        - Remember to edit the Param() block at the top of the script first to match the details of your remote host.
#        - For more detailed info, see the top help section of the 'scp.ps1' script.
#    - pscp.exe: a command-line scp tool that comes with PuTTY for Windows.
#        - Example commands:
#        -        cmd.exe \> pscp -r "%UserProfile%\Documents\GitHub\python-pi-multi-dyndns\dyndns\*" pi@10.210.69.42:/home/pi/dyndns/
#        - powershell.exe \> pscp -r "$env:USERPROFILE\Documents\GitHub\python-pi-multi-dyndns\dyndns\*" pi@10.210.69.42:/home/pi/dyndns/

# D) Execute this script on remote host to automate the rest of setup, or run the remaining commands manually:

# All the files we need should now be copied into the 'dyndns' folder on the remote host. We still need to update the permissions of the files to make them executable, and set up cron jobs to automatically execute the scripts on a regular schedule.
# However, because we have the setup.sh script now on the device, we can use it for the remaining setup commands. We just need to make it executable, and execute it.

# 1. Make this script executable:
#sudo chmod +x setup.sh

# 2. Run this script:
#sudo -i ./setup.sh
#. ./setup.sh

# If you want to do these steps manually, see the section below.

# Remainging actions: 
#    - Install dependencies. (apt packages like python, pip, and bc; and python modules using pip)
#    - Set permissions and cron jobs for automatic execution.

# --------------------------------------------------------------------------------------------------------

# Summary of the actions of this script:

# If running these manually, make sure to update them appropriately where applicable.

# Install apt dependencies:

#sudo apt install bc
#sudo apt install python2.7
#sudo apt install pip
#sudo apt install python-pip
#sudo apt install python3
#sudo apt install python3.7
#sudo apt install python3-pip

# (Reboot here if any python packages had to be installed)

# Install pip packages (python modules):

#sudo pip install "requests"
#sudo pip install "pif"
#sudo pip install "pygodaddy"

# Grant scripts executable permission:

#sudo chmod +x dyndns.py
#sudo chmod +x logcleanup.sh

# Create cron job entries to execute them on a schedule:

#crontab -l
#crontab -e

# Something like:

#23 * * * * python2.7 /home/pi/dyndns/dyndns.py
#0 0 1 * * /home/pi/dyndns/logcleanup.sh

# Done!

# Test the scripts by running them. Check the logs after about an hour to see if 'dyndns.py' is working, and after the first of next month check if there's a new '_LASTMONTH.log' log file made by 'logcleanup.sh'.

#python2.7 ./dyndns.py

# Test log cleanup script:

#./logcleanup.sh

# --------------------------------------------------------------------------------------------------------

# Automatic execution:
# (same steps as above, but automated!)

# Parameters:

# Set as name of user profile you want to install this project into
MAIN_USER_NAME="pi"

# Set as "True" or "False" string
INSTALL_PYTHON3="True"

# Install log name:
INSTALL_LOG="setup.log"

# --------------------------------------------------------------------------------------------------------
# Define functions

addlog()
{
	TAG=$1
	shift;
	# Shift input position once, and all the rest is the log message.
	MSG=$@
	
	# Install log name:
	INSTALL_LOG=$INSTALL_LOG
	
	# Check if log file exists, create it if it doesn't
	if [ ! -e "$INSTALL_LOG" ]; then
		echo "Log file does not exsit, creating: $INSTALL_LOG"
		DATETIMESTAMP=$(date -d @$(date -u +%s))
		echo "Install log created: $DATETIMESTAMP" > $INSTALL_LOG
		echo "=================================================" >> $INSTALL_LOG
	fi
	
	# Append message to log:
	echo "[$TAG]: $MSG" >> $INSTALL_LOG
}

loadcolors()
{
	# How to use:
	#loadcolors
	#loadcolors "True" # Prints an example list of every color combo
	
	# This function loads color code variables.
	# For example:
	#echo -e "I ${RED}love${NOCOLOR} Linux"
	#printf "I ${RED}love${NOCOLOR} Linux\n"
	#printf "${ORANGE_BKG}Warning${NOCOLOR_BKG} There is a problem.\n"
	#source ./lib/colors.sh
	. ./lib/colors.sh 
	loadcolors
}
loadcolors
#loadcolors "True"

# --------------------------------------------------------------------------------------------------------

# Start new log file:

DATETIMESTAMP=$(date -d @$(date -u +%s))
addlog "NEWLOG" "-------------------------------------------------"
addlog "TIMESTAMP" "Logged in as '$USER' starting new logging operation: $DATETIMESTAMP"

# --------------------------------------------------------------------------------------------------------

# Make sure Python is installed and packages are up-to-date:

printf "\n1. Updating Raspbian.\n"

printf "\nsudo apt-get update\n"
#read -s -p "Press ENTER key to continue... "
USER_INPUT="No escape"
while [ "$USER_INPUT" != "y" ] && [ "$USER_INPUT" != "n" ] && [ "$USER_INPUT" != "Y" ] && [ "$USER_INPUT" != "N" ]; do
	read -p "Run command? [Y/N]: " USER_INPUT
done

if [ $USER_INPUT == "y" ] || [ $USER_INPUT == "Y" ]; then
	addlog "UPDATE" "Updating apt-get sources: sudo apt-get update"
	sudo apt-get update
else
	addlog "SKIPPED" "Command was skipped by user: sudo apt-get update"
	printf "Skipping...\n"
fi

# Install Python, pip, and required modules:

printf "\n2. Installing required packages.\n"

# Define Function to check if apt or pip packages are installed and install them.
PIP_PKGS=$(pip list)
#printf "$PIP_PKGS\n"
checkpkg()
{
	TYPE=$1
	PKGNAME=$2
	
	# Load ANSI color codes from separate function:
	loadcolors
	
	# Error test to make sure either APT or PIP is selected
	if [ $TYPE != "APT" ] && [ $TYPE != "PIP" ] && [ $TYPE != "PIP3" ]; then
		#echo -e "${RED}ERROR${NOCOLOR}: Package type not selected as either APT or PIP"
		printf "${RED}ERROR${NOCOLOR}: Package type not selected as either APT or PIP\n"
		return
	fi
	
	# Check if package is already installed:
	if [ "$TYPE" = "APT" ]; then
		#RESULTS=$(sudo apt list --installed | grep -i ^$PKGNAME/)
		RESULTS=$(sudo apt list --installed 2> /dev/null | grep -i ^$PKGNAME/)
	elif [ "$TYPE" = "PIP" ]; then
		#RESULTS=$(pip list | grep -i ^$PKGNAME)
		RESULTS=$(printf "$PIP_PKGS\n" | grep -i ^$PKGNAME)
	elif [ "$TYPE" = "PIP3" ]; then
		#RESULTS=$(pip list | grep -i ^$PKGNAME)
		RESULTS=$(printf "$PIP_PKGS\n" | grep -i ^$PKGNAME)
	fi
	
	# If package is not installed, install it:
	if [ -z "$RESULTS" ]; then
		#echo "\$RESULTS var for $PKGNAME is empty, package not installed"
		NEW_INSTALLED="True"
		if [ "$TYPE" = "APT" ]; then
			#echo -e "${WHITE}[${YELLOW}APT${WHITE}][${RED}$PKGNAME${WHITE}]${NOCOLOR} package is not installed"
			printf "${WHITE}[${YELLOW}APT${WHITE}][${RED}$PKGNAME${WHITE}]${NOCOLOR} package is not installed\n"
			printf "Installing $PKGNAME with apt...\n"
			printf "sudo apt install $PKGNAME\n"
			addlog "INSTALL" "Running install command: sudo apt install $PKGNAME"
			#sudo apt install $PKGNAME
		elif [ "$TYPE" = "PIP" ]; then
			#echo -e "${WHITE}[${BLUE}PIP${WHITE}][${RED}$PKGNAME${WHITE}]${NOCOLOR} package is not installed"
			printf "${WHITE}[${BLUE}PIP${WHITE}][${RED}$PKGNAME${WHITE}]${NOCOLOR} package is not installed\n"
			printf "Installing $PKGNAME with pip...\n"
			printf "sudo pip install $PKGNAME\n"
			addlog "INSTALL" "Running install command: sudo pip install $PKGNAME"
			#sudo pip install $PKGNAME
		elif [ "$TYPE" = "PIP3" ]; then
			#echo -e "${WHITE}[${BLUE}PIP${WHITE}][${RED}$PKGNAME${WHITE}]${NOCOLOR} package is not installed"
			printf "${WHITE}[${GREEN}PIP3${WHITE}][${RED}$PKGNAME${WHITE}]${NOCOLOR} package is not installed\n"
			printf "Installing $PKGNAME with pip...\n"
			printf "sudo pip install $PKGNAME\n"
			addlog "INSTALL" "Running install command: sudo python3 -m pip install $PKGNAME"
			#sudo python3 -m pip install $PKGNAME
		fi
		return
	else
		#echo "\$RESULTS var for $PKGNAME is NOT empty, package already installed"
		if [ "$TYPE" = "APT" ]; then
			#echo -e "${WHITE}[${YELLOW}APT${WHITE}][${GREEN}Installed${WHITE}]${NOCOLOR}: $PKGNAME"
			printf "${WHITE}[${YELLOW}APT${WHITE}][${GREEN}Installed${WHITE}]${NOCOLOR}: $PKGNAME\n"
			addlog "SKIPPED" "apt package already installed: $PKGNAME"
		elif [ "$TYPE" = "PIP" ]; then
			#echo -e "${WHITE}[${BLUE}PIP${WHITE}][${GREEN}Installed${WHITE}]${NOCOLOR}: $PKGNAME"
			printf "${WHITE}[${BLUE}PIP${WHITE}][${GREEN}Installed${WHITE}]${NOCOLOR}: $PKGNAME\n"
			addlog "SKIPPED" "pip package already installed: $PKGNAME"
		elif [ "$TYPE" = "PIP3" ]; then
			#echo -e "${WHITE}[${BLUE}PIP${WHITE}][${GREEN}Installed${WHITE}]${NOCOLOR}: $PKGNAME"
			printf "${WHITE}[${GREEN}PIP3${WHITE}][${GREEN}Installed${WHITE}]${NOCOLOR}: $PKGNAME\n"
			addlog "SKIPPED" "pip (python3) package already installed: $PKGNAME"
		fi
		return
	fi
	#checkpkg_return=$?
}
#/checkpkg()

NEW_INSTALLED="False"
echo "Installing APT packages:"
checkpkg APT "bc"
checkpkg APT "python2.7"
checkpkg APT "pip"
checkpkg APT "python-pip"
if [ $INSTALL_PYTHON3 = "True" ]; then
	checkpkg APT "python3"
	checkpkg APT "python3.7"
	checkpkg APT "python3-pip"
fi

if [ -f /var/run/reboot-required ] || [ $NEW_INSTALLED = "True" ]; then
	printf "\n"
	if [ -f /var/run/reboot-required ]; then
		#echo -e "${RED}Reboot required detected.${NOCOLOR}"
		printf "${RED}Reboot required detected.${NOCOLOR}\n"
		addlog "REBOOT" "Reboot required detected."
	fi
	if [ $NEW_INSTALLED = "True" ]; then
		#echo -e "A restart is ${YELLOW}HIGHLY RECOMMENDED${NOCOLOR} after new (Python) software has been installed, and before installing any new pip (Python) packages up next."
		printf "A restart is ${YELLOW}RECOMMENDED${NOCOLOR} after new (Python) software has been installed, and before installing any new pip (Python) packages up next.\n"
	fi
	echo "You must run this script again after booting back up to complete all setup commands."
	
	USER_INPUT="No escape"
	while [ "$USER_INPUT" != "y" ] && [ "$USER_INPUT" != "n" ]; do
		echo "Restart now? [y/n]:"
		read USER_INPUT
	done
	
	if [ "$USER_INPUT" = "y" ]; then
		addlog "REBOOT" "Reboot operation approved by user: sudo reboot now"
		DATETIMESTAMP=$(date -d @$(date -u +%s))
		addlog "TIMESTAMP" "$DATETIMESTAMP"
		sudo reboot now
	else
		addlog "SKIPPED" "Reboot reqest rejected by user."
	fi
fi

# Setup Python:
echo "Setting up Python:"
#http://vivithemage.com/2018/09/17/namesilo-dns-update-via-python-script-and-cron-job-on-pfsense/
# Now if you are like me, and use pfsense, you have to install a module, which you can do by running these commands in shell:
#echo "python2.7 -m ensurepip"
#python2.7 -m ensurepip
#echo "python2.7 -m pip install -upgrade pip"
#python2.7 -m pip install -upgrade pip

# Check that required pip packages are installed

echo "Installing pip packages:"
checkpkg PIP "requests"
checkpkg PIP "pif"
#checkpkg PIP "pygodaddy" # No longer needed, I used API calls instead of this module.
if [ $INSTALL_PYTHON3 = "True" ]; then
	checkpkg PIP3 "requests"
	checkpkg PIP3 "pif"
fi

# If you no longer need the python modules, you can remove them using:

#sudo pip3 uninstall
#sudo pip uninstall

# --------------------------------------------------------------------------------------------------------

# Set execution permissions for scripts:

# --------------------------------------------------------------------------------------------------------

# Permissions breakdown / cheatsheet:
#
# link count of a file, or the number of contained directory entries for a directory
#            | 
#            | owner
#            |   | group
#            |   |   |   size
#            |   |   |    |    date/time
#            |   |   |    |  last modified:
#            |   |   |    |        |      
#            |   |   |    |        |     file/dir name
#            |   |   |    |    ____|_____    |
#            |   |   |    |   /          \   |
# drwxrwxrwx 2 root mail 4096 Dec  3  2009 mail
# |\ /\ /\ /
# | |  |  |
# | |  |  others permissions
# | |  group permissions
# | user permissions
# is directory

# u  :  owner of the file (user)
# g  :  groups owner  (group)
# o  :  anyone else on the system (other)
# a  :  all

# +  :  add permission
# -  :  remove permission
# =  :  set permissions (can add and remove permissions)

# r  :  read permission (4)
# w  :  write permission (2)
# x  :  execute permission (1)
# -  :  no permissions (0)

# Octal format (0-7), expanded:

# 7  :  read, write, and execute (4 + 2 + 1)
# 6  :  read and write (4 + 2)
# 5  :  read and execute (4 + 1)
# 4  :  read
# 3  :  execute and write (1 + 2)

#          |  User    Group   Others |
# ---------+--------+-------+--------+
# Symbolic |  rwx     rw-     r--    |
#          |                         |
# Binary   |  111     110     100    |
#          |                         |
#          |  4+2+1   4+2+0   4+0+0  |
#          |                         |
# Octal    |  7       6       4      |
# ---------+--------+-------+--------+

# Examples of reading permissions with `ls -l`:
# -rw-r--r-- 1 pi   pi   7731 Jan 24 02:06 setup.sh
# There is no 'd' in the first position of the permissions string, so this is definitely a file and not a directory.
# The next 3 characters 'rw-' indicate the file owner 'pi' has read and write permissions, but no execution permissions.
# The 3 places after that are for group permissions, but in this case the group 'pi' is set the same as the owner 'pi'.
# The last 3 characters 'r--' shows that others only have read permissions.

# drwxrwxr-x 2 root mail 4096 Dec  3  2009 mail
# The 'd' shows this is a directory, owned by 'root' and group of 'mail'.
# The next 2 sections of 3 characters are both 'rwx', indicating both the owner and group have read, write, and execute permissions.
# The last 3 characters 'r-x' is for others and shows they only have read and execute permissions.

# Examples of changing permissions with `chmod`:
# sudo chmod +x dyndns.py
# Adds execution permissions to the 'dyndns.py' file.
# `sudo` is used to elevate a command with priviledged execution, usually required for changing security permissions.

# sudo chmod u=rw,og=r new_file.txt
# Sets user (owner) with read and write permissions, and set others and groups with read permissions.
# If user already had execution permission for new_file.txt, this command will remove it.
# And same goes for other and groups, if they had write or execution permissions, this command removes them.

# sudo chmod 755 test.txt
# This command uses the numeric octal (0-7) permissions format. Execute = 1, write = 2, read = 4, and the remaining combinations of different permissions are calculated by adding their values together.
# The 3 digits still represent the owner's, group's, and other's permissions, same order as before.
# The first digit for the user/owner is 7, representing read, write, and execute permissions (4 + 2 + 1)
# The next 2 digits are both 5 for read and execute (4 + 1) permissions, applying to group and others respectively.

# Changing file ownership:
# sudo chown [user_name] [file_name]

# Changing file's group:
# sudo chgrp [group_name] [file_name]

# Change a file's owner and group at the same time:
# sudo chown [newowner]:[newgroup] [file or directory]

# Create a new group:
# sudo groupadd [groupname]

# List all groups:
# getent group

# Get a specific group:
# getent group | grep [groupname]

# Setting default permissions (umask):
# The default permission for new files created depends upon the umask value.
# Umask works by restricting what permissions are given to a file when it is created by a new program.
# This is set in the /etc/profile or /etc/bashrc for all users, but can be changed in the users ~/.bashrc
# The umask should be set as a inverse mask of the permissions required.
# For example the umask of 077 will mean that the group and all users have no permission.

# http://www.penguintutor.com/raspberrypi/file-permissions-reference
# https://phoenixnap.com/kb/linux-file-permissions

# --------------------------------------------------------------------------------------------------------

printf "\n3. Set execution permissions for scripts to run.\n"

addlog "PERMISSIONS" "Adding execution permission: sudo chmod +x dyndns.py"
echo "sudo chmod +x dyndns.py"
sudo chmod +x dyndns.py
addlog "PERMISSIONS" "Adding execution permission: sudo chmod +x logcleanup.sh"
echo "sudo chmod +x logcleanup.sh"
sudo chmod +x logcleanup.sh
addlog "PERMISSIONS" "Adding execution permission: sudo chmod +x ./lib/rand.sh"
echo "sudo chmod +x ./lib/rand.sh"
sudo chmod +x ./lib/rand.sh

# --------------------------------------------------------------------------------------------------------

printf "\n4. Checking params folder is setup properly.\n"
# Exclude __init__.py and any file with _TEMPLATE suffix. Any other file with a .py or .pyc extension should could as a valid params folder.

#printf "\n Search dir:\n"
SEARCH_DIR="./params"
PARAM_FILES=()
for entry in "$SEARCH_DIR"/*; do
	PASS="True"
	if [[ $entry == *__init__.py* ]]; then
		PASS="False"
	fi
	if [[ $entry == *_TEMPLATE* ]]; then
		PASS="False"
	fi
	if [ "$PASS" = "True" ]; then
		#echo "$entry"
		PARAM_FILES+=($entry)
	fi
done

#printf "\n Filter dir:\n"
PY_FILES=()
PYC_FILES=()
for i in "${PARAM_FILES[@]}"; do
	#echo "$i"
	if [[ $i == *.py ]]; then
		#echo "Added to PY"
		PY_FILES+=($i)
	fi
	if [[ $i == *.pyc ]]; then
		#echo "ADDED to .PYC list"
		PYC_FILES+=($i)
	fi
done

PY_FILE_EXISTS="False"
if [ -v PY_FILES ]; then 
	PY_FILE_EXISTS="True"
else 
	PY_FILE_EXISTS="False"
fi

PYC_FILE_EXISTS="False"
if [ -v PYC_FILES ]; then 
	PYC_FILE_EXISTS="True"
else 
	PYC_FILE_EXISTS="False"
fi

if [ $PY_FILE_EXISTS != "True" ] && [ $PYC_FILE_EXISTS != "True" ]; then
	addlog "WARNING" "No configured 'params' files detected."
	printf "\nWARNING: No configured parameter files detected! \nPlease make sure the $SEARCH_DIR/ directory contains \nat least one params .py script, without _TEMPLATE in the filename.\nTo set up a params file with your account details, make a copy of one of the _TEMPLATE.py files, but without the text \"_TEMPLATE\" in the new name. Edit the file to find more detailed instructions on how to set the variables with your account information.\n"
	printf "\nThese are the only files currently in $SEARCH_DIR/:\n"
	Listing=(`ls -1Q $SEARCH_DIR/`)
	printf "%s\n" "${Listing[@]}"
	printf "\nPress Ctrl-C now to cancel this script.\n"
	read -p "Press ENTER key to continue... "
else
	if [ $PY_FILE_EXISTS = "True" ]; then
		printf "\n.py files:\n"
		printf "%s\n" "${PY_FILES[@]}"
	fi
	if [ $PYC_FILE_EXISTS = "True" ]; then
		printf "\n.pyc files:\n"
		printf "%s\n" "${PYC_FILES[@]}"
	fi
fi

# --------------------------------------------------------------------------------------------------------

printf "\n5. Testing script(s) execution.\n"

CUR_DIR=$(pwd)
DYNDNS_PATH="$CUR_DIR/dyndns.py"
LOGCLEAN_PATH="$CUR_DIR/logcleanup.sh"

hrule()
{
	printf "\n${YELLOW}====================${NOCOLOR}\n"
}

printf "\nTesting Dynamic DNS script:\npython $DYNDNS_PATH\n"
#read -p "Press ENTER key to continue... "
hrule
addlog "TESTING" "Testing Dynamic DNS script execution: python $DYNDNS_PATH"
python $DYNDNS_PATH
hrule
printf "End of testing Dyn DNS python script.\n"

printf "\nTesting log cleanup script:\n$LOGCLEAN_PATH\n"
read -p "Press ENTER key to continue... "
hrule
addlog "TESTING" "Testing log cleanup script execution: $LOGCLEAN_PATH"
#$LOGCLEAN_PATH
hrule
printf "End of testing log cleanup shell script.\n"

# --------------------------------------------------------------------------------------------------------

# Setup DynDNS cron jobs:

# --------------------------------------------------------------------------------------------------------

# Cron jobs cheatsheet / Running scripts automatically on a schedule:
# https://raspberrytips.com/schedule-task-raspberry-pi/

# The layout for a cron entry is made up of six components:
# minute, hour, day of month, month, day of week, and the command to be executed.

# m h dom mon dow   command
# | |  /  /   /
# | | |  /   /
# | | | |   /
# | | | |  /
# * * * * *  command to execute
# ¦ ¦ ¦ ¦ ¦
# ¦ ¦ ¦ ¦ ¦
# ¦ ¦ ¦ ¦ +----- day of week (0 - 6) (0 to 6 are Sunday to Saturday, (Non-standard) 7 also works as Sunday)
# ¦ ¦ ¦ +---------- month (1 - 12)
# ¦ ¦ +--------------- day of month (1 - 31)
# ¦ +-------------------- hour (0 - 23)
# +------------------------- min (0 - 59)

#  *  :  any value
#  ,  :  value list separator
#  -  :  range of values
#  /  :  step values

# Examples:

# m h dom mon dow   command

# 0 0 * * *  /home/pi/backup.sh
# will run the backup.sh script every day at midnight

# 0 6,12 * * * /home/pi/backup.sh
# will run every day at 6am and noon only

# 0 */2 * * * /home/pi/backup.sh
# will run every 2hours (so 0, 2, 4, 6, ...)

# 0 3 * * 1-5 /home/pi/backup.sh
# runs at 3am every day, but will NOT run on weekend (Saturday/Sunday)

# 23 0-20/2 * * *
# "At minute 23 past every 2nd hour from 0 through 20.""
#https://crontab.guru/#23_0-20/2_*_*_*

# 0 0 1 */1 * /home/pi/dyndns/logcleanup.sh
# runs at midnight on the 1st of every month

# @reboot /home/pi/backup.sh
# (non-standard) will run at every boot

# View scheduled tasks:

#crontab -l

# Editing crontab
# Run crontab with the -e flag to edit the cron table:

#crontab -e

# Select an editor
# The first time you run crontab you'll be prompted to select an editor
# If you are not sure which one to use, choose nano by pressing Enter.

# Check that cronjobs are running:

# On a default installation the cron jobs get logged to

# /var/log/syslog

# You can see just cron jobs in that logfile by running

#grep CRON /var/log/syslog

# --------------------------------------------------------------------------------------------------------

printf "\n6. Configuring cron jobs for scheduled script execution:\n"

pickrandmin()
{
	# This function will pick a random minute value from 0-59.
	#source ./lib/rand.sh
	. ./lib/rand.sh 
	pickrandommin
}
#pickrandmin

removecronjob()
{
	#Example: removecronjob dyndns.sh
	#Example: removecronjob /home/pi/dyndns/dyndns.sh
	SCRIPT_NAME=$1
	CRONYJOB=$(crontab -l | grep $SCRIPT_NAME)
	if [ "$CRONYJOB" != "" ]; then
		printf "$CRONYJOB\n"
		USER_INPUT="No escape"
		while [ "$USER_INPUT" != "y" ] && [ "$USER_INPUT" != "n" ]; do
			echo "Delete cron job(s)? [y/n]:"
			read USER_INPUT
		done
		if [ "$USER_INPUT" = "y" ]; then
			addlog "CRON" "Removing cron job line: $CRONYJOB"
			#sed -i "/$USER_INPUT/d" filename
			crontab -l | grep -v "$SCRIPT_NAME" | crontab -
		fi
	fi
}

addcronjob()
{
	#Example: addcronjob $MAIN_USER_NAME 0 0 1 */1 * /home/pi/dyndns/logcleanup.sh
	CRONJOB_INPUT_NAME=$1
	shift;
	# Shift input position once, and all the rest is now a cron job line.
	WET_HOT_CRON_LINE=$@
	echo "Adding cron line: $CRONJOB_INPUT_NAME"
	echo "$WET_HOT_CRON_LINE"
	read -s -p "Press ENTER key to continue... "
	addlog "CRON" "Adding cron line: $CRONJOB_INPUT_NAME"
	#(crontab -l 2>/dev/null; echo "$WET_HOT_CRON_LINE") | crontab -
	(crontab -u $CRONJOB_INPUT_NAME -l 2>/dev/null; echo "$WET_HOT_CRON_LINE") | crontab -
	unset CRONJOB_INPUT_NAME
}

showcronjobs()
{
	#Example: showcronjobs
	CRONJOB_INPUT_NAME=$1
	printf "\n"
	USER_INPUT="No escape"
	while [ "$USER_INPUT" != "y" ] && [ "$USER_INPUT" != "n" ]; do
		printf "Show all current cron job(s)? [y/n]:"
		read USER_INPUT
	done
	if [ "$USER_INPUT" = "y" ]; then
		if [ -v CRONJOB_INPUT_NAME ]; then
			printf "crontab -u $CRONJOB_INPUT_NAME -l\n"
			CRONJOBLIST=$(crontab -u $CRONJOB_INPUT_NAME -l)
		else
			printf "crontab -l\n"
			CRONJOBLIST=$(crontab -l)
		fi
		printf "$CRONJOBLIST\n"
	fi
	unset CRONJOB_INPUT_NAME
}

cronfreqmenu()
{
	printf "\nSelect how frequently the Dynamic DNS script should run:\n"
	echo " 0 - Once every two hours"
	echo " 1 - Once per hour (Recommended)"
	echo " 2 - Twice per hour"
	echo " 3 - Once every fifteen minutes"
	echo " 4 - Once every ten minutes (Non standard! May not work with every cron.)"
	echo " 5 - Once every five minutes (Non standard! May not work with every cron.)"
	echo " 6 - Enter custom cron tab string"
}

minselecttxt()
{
	printf "\n(NOTE: When scheduling cron tasks, you can offset the minute of the hour for when this job will execute. Setting this with a random value instead of 0 will avoid hitting servers at peak times like at the top of the hour.)\n\n"
	printf "Please select a minute value:\n"
	#echo " 0 - Random Minute Value Generator (RECOMMENDED)"
	#echo " 1 - Enter a minute value 0-59"
	#echo " 2 - Go Back"
}

#showcronjobs
showcronjobs $MAIN_USER_NAME

cronfreqmenu
USER_INPUT=99
#until [[ $USER_INPUT -ge 0 ]] && [[ $USER_INPUT -le 6 ]] && [[ ! -z "$USER_INPUT" ]]; do
until [[ $USER_INPUT -ge 0 ]] && [[ $USER_INPUT -le 6 ]] && [[ "$USER_INPUT" =~ ^[0-9]+$ ]]; do
	read -p "Choose option [0-6]: " USER_INPUT
done

if [ $USER_INPUT -ge 0 ] && [ $USER_INPUT -le 1 ]; then
	MIN_INPUT=99
	while ! [[ "$MIN_INPUT" -ge 0 && "$MIN_INPUT" -le 3 ]]; do
		if [ $USER_INPUT -eq 0 ]; then
			addlog "SELECTION" "User chose to have Dynamic DNS run Once per two hours."
			printf "\nOnce per two hours selected.\n"
		elif [ $USER_INPUT -eq 1 ]; then
			addlog "SELECTION" "User chose to have Dynamic DNS run Once per hour."
			printf "\nOnce per hour selected.\n"
		fi
		minselecttxt
		printf " 0 - Random Minute Value Generator (Recommended)\n"
		printf " 1 - Enter a minute value 0-59\n"
		MIN_GAMEOVER_INPUT=99
		#if [ -v "$PICKEDMIN" ]; then
		if [ -v PICKEDMIN ]; then
			printf " 2 - Accept pick: %.2d\n" $PICKEDMIN
			while ! [[ "$MIN_GAMEOVER_INPUT" -ge 0 && "$MIN_GAMEOVER_INPUT" -le 2 ]]; do
				read -p "Choose option [0-2]: " MIN_GAMEOVER_INPUT
			done
		else
			while ! [[ "$MIN_GAMEOVER_INPUT" -ge 0 && "$MIN_GAMEOVER_INPUT" -le 1 ]]; do
				read -p "Choose option [0-1]: " MIN_GAMEOVER_INPUT
			done
		fi
		
		if [ "$MIN_GAMEOVER_INPUT" -eq 0 ]; then
			pickrandmin
			PICKEDMIN=$RANDOMMIN
			MIN_INPUT=99
		elif [ "$MIN_GAMEOVER_INPUT" -eq 1 ]; then
			PICKEDMIN=99
			while ! [[ $PICKEDMIN -ge 0 && $PICKEDMIN -le 59 ]]; do
				read -p "Enter minute value [0-59]: " PICKEDMIN
			done
			MIN_INPUT=99
		elif [ "$MIN_GAMEOVER_INPUT" -eq 2 ]; then
			break
		fi
	done
	if [ $USER_INPUT -eq 0 ]; then
		#printf "Once per two hours selected.\n\n"
		CRON_SCHED="$PICKEDMIN */2 * * *"
	elif [ $USER_INPUT -eq 1 ]; then
		#printf "Once per hour selected.\n\n"
		CRON_SCHED="$PICKEDMIN * * * *"
	fi
	CRON_STRING="$CRON_SCHED python $DYNDNS_PATH"
elif [ $USER_INPUT -eq 2 ]; then
	addlog "SELECTION" "User chose to have Dynamic DNS run Twice per hour."
	CRON_SCHED="0,30 * * * *"
	CRON_STRING="$CRON_SCHED python $DYNDNS_PATH"
elif [ $USER_INPUT -eq 3 ]; then
	addlog "SELECTION" "User chose to have Dynamic DNS run Once every fifteen minutes."
	CRON_SCHED="0,15,30,45 * * * *"
	CRON_STRING="$CRON_SCHED python $DYNDNS_PATH"
elif [ $USER_INPUT -eq 4 ]; then
	addlog "SELECTION" "User chose to have Dynamic DNS run Once every ten minutes."
	CRON_SCHED="0/10 * * * *"
	#CRON_SCHED="0,10,20,30,40,50 * * * *"
	CRON_STRING="$CRON_SCHED python $DYNDNS_PATH"
elif [ $USER_INPUT -eq 5 ]; then
	addlog "SELECTION" "User chose to have Dynamic DNS run Once every five minutes."
	CRON_SCHED="0/5 * * * *"
	#CRON_SCHED="0,5,10,15,20,25,30,35,45,50,55 * * * *"
	CRON_STRING="$CRON_SCHED python $DYNDNS_PATH"
elif [ $USER_INPUT -eq 6 ]; then
	addlog "SELECTION" "User chose to enter a custom cron string for when to have Dynamic DNS run."
	echo "Enter custom cron string: (do not include file path)"
	echo "m h dom mon dow   $DYNDNS_PATH"
	echo "For example:"
	echo "0 * * * *         (once every hour, at the zero minute mark)"
	echo "0,30 * * * *      (once every half hour, at zero minutes and thirty)"
	echo "0 */2 * * *       (once every two hours, at zero minute mark)"
	echo "0/10 * * * *      (once every 10 minutes)"
	ACCEPTED_STR="No escape"
	while [ $ACCEPTED_STR != "True" ]; do
		read -p "Enter a valid cron schedule string: " CRON_SCHED
		printf "\nAccept this value? $CRON_SCHED $DYNDNS_PATH\n\n"
		read -p "Are you sure? [y/n]: " ACCEPTED_STR
		if [ $ACCEPTED_STR = "y" ]; then
			ACCEPTED_STR="True"
			break
		elif [ $ACCEPTED_STR = "n" ]; then
			ACCEPTED_STR="False"
			continue
		fi
	done
	CRON_STRING="$CRON_SCHED python $DYNDNS_PATH"
fi

printf "Remove old job if it exists before adding new one:\n$DYNDNS_PATH\n"
removecronjob $DYNDNS_PATH

addcronjob $MAIN_USER_NAME "$CRON_STRING"

logcleanupfreqmenu()
{
	printf "\n\nThe log cleanup script will save the last log file as _OLD or _LAST. And if a file already exists with that name, it will be deleted first. So the oldest data that will be retained is up to double how often the log cleanup script is run.\n"
	printf "\n\nSelect how frequently the Log Cleanup script should run:\n"
	echo " 0 - Once every two weeks (on the 1st and the 15th of every month)"
	echo " 1 - Once per month (Recommended)"
	echo " 2 - Once every 2 months"
	echo " 3 - Once every 3 months"
	echo " 4 - Enter custom cron tab string"
}

logcleanupfreqmenu
USER_INPUT=99
#until [[ $USER_INPUT -ge 0 ]] && [[ $USER_INPUT -le 4 ]] && [[ ! -z "$USER_INPUT" ]]; do
until [[ $USER_INPUT -ge 0 ]] && [[ $USER_INPUT -le 4 ]] && [[ "$USER_INPUT" =~ ^[0-9]+$ ]]; do
	read -p "Choose option [0-4]: " USER_INPUT
done

# Switch block:
case $USER_INPUT in
	0)
		addlog "SELECTION" "User chose to have the log cleanup script run Once every two weeks (on the 1st and the 15th of every month)."
		CRON_SCHED="0 0 1,15 * *"
		CRON_STRING="$CRON_SCHED $LOGCLEAN_PATH"
		;;
	1)
		addlog "SELECTION" "User chose to have the log cleanup script run Once per month."
		CRON_SCHED="0 0 1 * *"
		CRON_STRING="$CRON_SCHED $LOGCLEAN_PATH"
		;;
	2)
		addlog "SELECTION" "User chose to have the log cleanup script run Once every 2 months."
		CRON_SCHED="0 0 1 */2 *"
		CRON_STRING="$CRON_SCHED $LOGCLEAN_PATH"
		;;
	3)
		addlog "SELECTION" "User chose to have the log cleanup script run Once every 3 months."
		CRON_SCHED="0 0 1 */3 *"
		CRON_STRING="$CRON_SCHED $LOGCLEAN_PATH"
		;;
	4)
		addlog "SELECTION" "User chose to enter a custom cron string for when to have the log cleanup script run."
		echo "Enter custom cron string: (do not include file path)"
		echo "m h dom mon dow   $LOGCLEAN_PATH"
		echo "For example:"
		echo "0 0 1,15 * *      (twice per month, on the 1st and 15th)"
		echo "0 0 1 * *         (once a month, on the 1st at midnight)"
		echo "0 0 1 */2 *       (once every 2 months, on the 1st at midnight)"
		echo "0 0 1 */3 *       (once every 3 months, on the 1st at midnight)"
		ACCEPTED_STR="No escape"
		while [ $ACCEPTED_STR != "True" ]; do
			read -p "Enter a valid cron schedule string: " CRON_SCHED
			printf "\nAccept this value? $CRON_SCHED $LOGCLEAN_PATH\n\n"
			read -p "Are you sure? [y/n]: " ACCEPTED_STR
			if [ $ACCEPTED_STR = "y" ]; then
				ACCEPTED_STR="True"
				break
			elif [ $ACCEPTED_STR = "n" ]; then
				ACCEPTED_STR="False"
				continue
			fi
		done
		CRON_STRING="$CRON_SCHED $LOGCLEAN_PATH"
		;;
	*)
		printf "Default option."
		;;
esac
#/case $USER_INPUT

printf "Remove old job if it exists before adding new one:\n$LOGCLEAN_PATH\n"
removecronjob $LOGCLEAN_PATH

addcronjob $MAIN_USER_NAME "$CRON_STRING"

#showcronjobs
showcronjobs $MAIN_USER_NAME

printf "\n7. End of setup script.\n"
DATETIMESTAMP=$(date -d @$(date -u +%s))
addlog "TIMESTAMP" "End of setup script reached: $DATETIMESTAMP"
if [ -f /var/run/reboot-required ]; then
	#echo -e "${RED}Reboot required detected.${NOCOLOR}"
	printf "${RED}Reboot required detected.${NOCOLOR}\n"
	addlog "REBOOT" "Reboot required detected."
fi

USER_INPUT="No escape"
while [ "$USER_INPUT" != "y" ] && [ "$USER_INPUT" != "n" ]; do
	echo "Restart now? [y/n]:"
	read USER_INPUT
done

if [ "$USER_INPUT" = "y" ]; then
	addlog "REBOOT" "Reboot operation approved by user: sudo reboot now"
	DATETIMESTAMP=$(date -d @$(date -u +%s))
	addlog "TIMESTAMP" "$DATETIMESTAMP"
	sudo reboot now
else
	addlog "SKIPPED" "Reboot reqest rejected by user."
fi

# --------------------------------------------------------------------------------------------------------



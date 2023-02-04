
# --------------------------------------------------------------------------------------------------------

# Shell script for installing 'dyndns.py' Dynamic DNS updates Python script

# Read all the instructions below first before executing this script.

# Overview:
# The Manual steps:
# - Manually edit param files
# - Create 'dyndns' directory on the remote host via SSH
# - Copy these files into newly created dir with scp
# The Automatic steps: (this script will do these automatically)
# - Install any required dependency packages (apt packages and python modules via pip)
#    - (will not update any packages, only install any that are missing)
# - Set permissions and cron jobs for scheduled automatic execution
#    - (dyndns.py and logcleanup.sh)

# Complete manual steps are also provided at the end of these instructions

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

# Remainging actions: 
#    - Install dependencies. (apt packages like python, pip, and bc; and python modules using pip)
#    - Set permissions and cron jobs for automatic execution.

# All the files we need should now be copied into the 'dyndns' folder on the remote host. We still need to update the permissions of the files to make them executable, and set up cron jobs to automatically execute the scripts on a regular schedule.
# However, because we have the setup.sh script now on the device, we can use it for the remaining setup commands. We just need to make it executable, and execute it.

# 1. Make this script executable:
#sudo chmod +x setup.sh

# 2. Run this script:
#sudo -i /home/pi/dyndns/test.sh

# If you want to do these steps manually, see the section below.

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

#23 */1 * * * python2.7 /home/pi/dyndns/dyndns.py
#0 0 1 */1 * /home/pi/dyndns/logcleanup.sh

# Done!

# Test the scripts by running them. Check the logs after about an hour to see if 'dyndns.py' is working, and after the first of next month check if there's a new '_LASTMONTH.log' log file made by 'logcleanup.sh'.

# --------------------------------------------------------------------------------------------------------

# Automatic execution:
# (same steps as above, but automated!)

# Parameters:



# Logging functions:
addlog()
{
	TAG=$1
	
	
}

loadcolors()
{
	#loadcolors
	#loadcolors "True" # Prints an example list of every color combo
	
	TEST_ALL_COLORS=$1
	
	RED='\033[0;31m'    #'0;31' is Red's ANSI color code
	GREEN='\033[0;32m'  #'0;32' is Green's ANSI color code
	YELLOW='\033[1;32m' #'1;32' is Yellow's ANSI color code
	BLUE='\033[0;34m'   #'0;34' is Blue's ANSI color code
	WHITE='\033[1;37m'  #'1;37' is White's ANSI color code
	NOCOLOR='\033[0m'
	
	# Example:
	#echo -e "I ${RED}love${NOCOLOR} Linux"
	#printf "I ${RED}love${NOCOLOR} Linux\n"
	
	# Whenever you use any special escape sequence like '\n', '\t', or these escape sequences for colors with the echo command, make sure to use the "-e" flag.
	
	#https://linuxhandbook.com/change-echo-output-color/
	
	# These are ANSI color codes generated by concatenating a prefix of '\033[' + one of the color codes below + 'm'.
	
	# Black        0;30     Dark Gray     1;30
	# Red          0;31     Light Red     1;31
	# Green        0;32     Light Green   1;32
	# Brown/Orange 0;33     Yellow        1;33
	# Blue         0;34     Light Blue    1;34
	# Purple       0;35     Light Purple  1;35
	# Cyan         0;36     Light Cyan    1;36
	# Light Gray   0;37     White         1;37
	
	# For more info see
	#https://stackoverflow.com/questions/4842424/list-of-ansi-color-escape-sequences
	
	# Foregrand & Background color:
	
	#echo -e "\033[38;5;208mpeach\033[0;00m"
	# Taking apart this command: \033[38;5;208m
	
	# The \033 is the escape code. The [38; directs command to the foreground. If you want to change the background color instead, use [48; instead. The 5; is just a piece of the sequence that changes color. And the most important part, 208m, selects the actual color.
	
	#RED_FOREG='\033[38;0;31m'    #'0;31' is Red's ANSI color code
	#GREEN_FOREG='\033[38;0;32m'  #'0;32' is Green's ANSI color code
	YELLOW_FOREG='\033[38;1;32m' #'1;32' is Yellow's ANSI color code
	#BLUE_FOREG='\033[38;0;34m'   #'0;34' is Blue's ANSI color code
	WHITE_FOREG='\033[38;1;37m'  #'1;37' is White's ANSI color code
	#BLACK_FOREG='\033[38;0;30m'  #'0;30' is Black's ANSI color code
	DARKGRAY_FOREG='\033[38;1;30m'
	#LIGHTGRAY_FOREG='\033[38;0;37m'
	#NOCOLOR_FOREG='\033[38;0m'
	
	#RED_BKG='\033[48;0;31m'    #'0;31' is Red's ANSI color code
	#GREEN_BKG='\033[48;0;32m'  #'0;32' is Green's ANSI color code
	#YELLOW_BKG='\033[48;1;32m' #'1;32' is Yellow's ANSI color code
	#BLUE_BKG='\033[48;0;34m'   #'0;34' is Blue's ANSI color code
	#WHITE_BKG='\033[48;1;37m'  #'1;37' is White's ANSI color code
	#BLACK_BKG='\033[48;0;30m'  #'0;30' is Black's ANSI color code
	#DARKGRAY_BKG='\033[48;1;30m'
	#LIGHTGRAY_BKG='\033[48;0;37m'
	#NOCOLOR_BKG='\033[48;0m'
	
	# Foregrand & Background color:
	
	#https://opensource.com/article/19/9/linux-terminal-colors
	
	# Color 		Foreground 	Background
	# Black 		\033[30m 	\033[40m
	# Red 			\033[31m 	\033[41m
	# Green 		\033[32m 	\033[42m
	# Orange 		\033[33m 	\033[43m
	# Blue 			\033[34m 	\033[44m
	# Magenta 		\033[35m 	\033[45m
	# Cyan 			\033[36m 	\033[46m
	# Light gray 	\033[37m 	\033[47m
	# default 		\033[39m 	\033[49m
	
	# There are some additional colors available for the background:
	# Color 		Background
	# Dark gray 	\033[100m
	# Light red 	\033[101m
	# Light green 	\033[102m
	# Yellow 		\033[103m
	# Light blue 	\033[104m
	# Light purple 	\033[105m
	# Teal 			\033[106m
	# White 		\033[107m
	
	RED_FOREG='\033[31m'
	GREEN_FOREG='\033[32m'
	#YELLOW_FOREG='\033[38;1;32m' #'1;32' is Yellow's ANSI color code
	BLUE_FOREG='\033[34m'
	#WHITE_FOREG='\033[38;1;37m'  #'1;37' is White's ANSI color code
	BLACK_FOREG='\033[30m'
	#DARKGRAY_FOREG='\033[38;1;30m'
	LIGHTGRAY_FOREG='\033[37m'
	ORANGE_FOREG='\033[33m'
	MAGENTA_FOREG='\033[35m'
	CYAN_FOREG='\033[36m'
	NOCOLOR_FOREG='\033[39m'
	
	RED_BKG='\033[41m'
	GREEN_BKG='\033[42m'
	YELLOW_BKG='\033[103m'
	BLUE_BKG='\033[44m'
	WHITE_BKG='\033[107m'
	BLACK_BKG='\033[40m'
	DARKGRAY_BKG='\033[100m'
	LIGHTGRAY_BKG='\033[47m'
	ORANGE_BKG='\033[43m'
	MAGENTA_BKG='\033[45m'
	CYAN_BKG='\033[46m'
	NOCOLOR_BKG='\033[49m'
	
	LIGHT_RED_BKG='\033[101m'
	LIGHT_GREEN_BKG='\033[102m'
	LIGHT_BLUE_BKG='\033[104m'
	LIGHT_PURPLE_BKG='\033[105m'
	TEAL_BKG='\033[106m'
	
	if [ "$TEST_ALL_COLORS" = "True" ]; then
		BACKGROUNDCOLORS=$(compgen -A variable | grep _BKG)
		FOREGROUNDCOLORS=$(compgen -A variable | grep _FOREG)
		BACKGROUNDCOLORS=($BACKGROUNDCOLORS)
		FOREGROUNDCOLORS=($FOREGROUNDCOLORS)
		
		#for i in "${BACKGROUNDCOLORS[@]}"; do echo "Testing array list item: $i"; done
		printf "\nTesting all color combos:\n"
		for i in "${BACKGROUNDCOLORS[@]}"; do
			printf "${NOCOLOR_FOREG}${NOCOLOR_BKG}${NOCOLOR}\n$i:\n"
			BACKCOLOR=${!i}
			for j in "${FOREGROUNDCOLORS[@]}"; do
				FORECOLOR=${!j}
				printf "${BACKCOLOR}${FORECOLOR} %s-%s ${NOCOLOR_FOREG}${NOCOLOR_BKG}" $i $j
			done
		done
	fi
}

# --------------------------------------------------------------------------------------------------------

# Make sure Python is installed and packages are up-to-date:

printf "\n1. Updating Raspbian.\n"

printf "\nsudo apt-get update\n"
#read -s -p "Press ENTER key to continue... "
#sudo apt-get update

# Install Python, pip, and required modules:

printf "\n2. Installing required packages.\n"

# Function to check if apt or pip packages are installed and install them.
checkpkg()
{
	TYPE=$1
	PKGNAME=$2
	
	# Load ANSI color codes from separate function:
	loadcolors
	
	# Error test to make sure either APT or PIP is selected
	if [ $TYPE != "APT" ] && [ $TYPE != "PIP" ]; then
		#echo -e "${RED}ERROR${NOCOLOR}: Package type not selected as either APT or PIP"
		printf "${RED}ERROR${NOCOLOR}: Package type not selected as either APT or PIP\n"
		return
	fi
	
	# Check if package is already installed:
	if [ "$TYPE"=="APT" ]; then
		#RESULTS=$(sudo apt list --installed | grep -i ^$PKGNAME/)
		RESULTS=$(sudo apt list --installed 2> /dev/null | grep -i ^$PKGNAME/)
	elif [ "$TYPE"=="PIP" ]; then
		RESULTS=$(pip list | grep -i ^$PKGNAME)
	fi
	
	# If package is not installed, install it:
	if [ -z "$RESULTS" ]; then
		#echo "\$RESULTS var for $PKGNAME is empty, package not installed"
		NEW_INSTALLED="True"
		if [ "$TYPE" == "APT" ]; then
			#echo -e "${WHITE}[${YELLOW}APT${WHITE}][${RED}$PKGNAME${WHITE}]${NOCOLOR} package is not installed"
			printf "${WHITE}[${YELLOW}APT${WHITE}][${RED}$PKGNAME${WHITE}]${NOCOLOR} package is not installed\n"
			printf "Installing $PKGNAME with apt...\nsudo apt install $PKGNAME\n"
			#sudo apt install $PKGNAME
		elif [ "$TYPE" == "PIP" ]; then
			#echo -e "${WHITE}[${BLUE}PIP${WHITE}][${RED}$PKGNAME${WHITE}]${NOCOLOR} package is not installed"
			printf "${WHITE}[${BLUE}PIP${WHITE}][${RED}$PKGNAME${WHITE}]${NOCOLOR} package is not installed\n"
			printf "Installing $PKGNAME with pip...\nsudo pip install $PKGNAME\n"
			#sudo pip install $PKGNAME
		fi
		return
	else
		#echo "\$RESULTS var for $PKGNAME is NOT empty, package already installed"
		if [ "$TYPE"=="APT" ]; then
			#echo -e "${WHITE}[${YELLOW}APT${WHITE}][${GREEN}Installed${WHITE}]${NOCOLOR}: $PKGNAME"
			printf "${WHITE}[${YELLOW}APT${WHITE}][${GREEN}Installed${WHITE}]${NOCOLOR}: $PKGNAME\n"
		elif [ "$TYPE"=="PIP" ]; then
			#echo -e "${WHITE}[${BLUE}PIP${WHITE}][${GREEN}Installed${WHITE}]${NOCOLOR}: $PKGNAME"
			printf "${WHITE}[${BLUE}PIP${WHITE}][${GREEN}Installed${WHITE}]${NOCOLOR}: $PKGNAME\n"
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
checkpkg APT "python3"
checkpkg APT "python3.7"
checkpkg APT "python3-pip"

if [ -f /var/run/reboot-required ] || [ $NEW_INSTALLED=="True" ]; then
	if [ -f /var/run/reboot-required ]; then
		#echo -e "${RED}Reboot required detected.${NOCOLOR}"
		printf "${RED}Reboot required detected.${NOCOLOR}\n"
	fi
	if [ $NEW_INSTALLED=="True" ]; then
		#echo -e "A restart is ${YELLOW}HIGHLY RECOMMENDED${NOCOLOR} after new (Python) software has been installed, and before installing any new pip (Python) packages up next."
		printf "A restart is ${YELLOW}RECOMMENDED${NOCOLOR} after new (Python) software has been installed, and before installing any new pip (Python) packages up next.\n"
	fi
	echo "You must run this script again after booting back up to complete all setup commands."
	
	USER_INPUT="No escape"
	while [ "$USER_INPUT" != "y" ] && [ "$USER_INPUT" != "n" ]; do
		echo "Restart now? [y/n]:"
		read USER_INPUT
	done
	
	if [ "$USER_INPUT"=="y" ]; then
		sudo reboot now
	fi
fi

# Check that required pip packages are installed

echo "Installing pip packages:"
checkpkg PIP "requests"
checkpkg PIP "pif"
checkpkg PIP "pygodaddy"

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

###sudo chmod +x dyndns.py
###sudo chmod +x logcleanup.sh
###sudo chmod +x rand.sh

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

# Add a scheduled task


# Check that cronjobs are running:

# On a default installation the cron jobs get logged to

# /var/log/syslog

# You can see just cron jobs in that logfile by running

#grep CRON /var/log/syslog

# --------------------------------------------------------------------------------------------------------

pickrandmin()
{
	# This function will pick a random minute value from 0-59.
	#source ./rand.sh
	. ./rand.sh 
	pickrandommin
}
#pickrandmin

removecronjob()
{
	#Example: removecronjob dyndns.sh
	SCRIPT_NAME=$1
	CRONYJOB=$(crontab -l | grep $SCRIPT_NAME)
	echo $CRONYJOB
	USER_INPUT="No escape"
	while [ "$USER_INPUT" != "y" ] && [ "$USER_INPUT" != "n" ]; do
		echo "Delete cron job(s)? [y/n]:"
		read USER_INPUT
	done
	if [ "$USER_INPUT" != "y" ]; then
		#sed -i "/$USER_INPUT/d" filename
		crontab -l | grep -v "$SCRIPT_NAME" | crontab -
	fi
}

addcronjob()
{
	#Example: addcronjob 0 0 1 */1 * /home/pi/dyndns/logcleanup.sh
	WET_HOT_CRON_LINE=$@
	(crontab -l ; echo "$WET_HOT_CRON_LINE") | crontab -
}

cronfreqmenu()
{
	printf "\n\nSelect how frequently the Dynamic DNS script should run:\n"
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
	printf "\nWhen scheduling cron tasks, you can offset the minute of the hour for when this job will execute. Setting this with a random value will avoid hitting servers at peak times like at the top of the hour.\n\n"
	printf "Please select a minute value:\n"
	#echo " 0 - Random Minute Value Generator (RECOMMENDED)"
	#echo " 1 - Enter a minute value 0-59"
	#echo " 2 - Go Back"
}

minselect()
{
	
	if [ $USER_INPUT -eq 0 ]; then
		printf ""
	elif [ $USER_INPUT -eq 1 ]; then
		printf ""
	fi
	minselecttxt
	echo " 0 - Random Minute Value Generator (Recommended)"
	echo " 1 - Enter a minute value 0-59"
	MIN_INPUT="No escape"
	while ! [[ $MIN_INPUT -ge 0 && $MIN_INPUT -le 2 ]]; do
	read -p "Choose option [0-2]: " MIN_INPUT
		if [ $MIN_INPUT -eq 0 ]; then
			pickrandmin
			PICKEDMIN=$RANDOMMIN
			minselecttxt
			printf " 0 - Random Minute Value Generator (Recommended)"
			printf " 1 - Enter a minute value 0-59"
			if [ -v $RANDOMMIN ]; then
				printf " 2 - Accept pick: '%.2d'" $PICKEDMIN
			fi
			MIN_GAMEOVER_INPUT="No escape"
			while ! [[ $MIN_GAMEOVER_INPUT -ge 0 && $MIN_GAMEOVER_INPUT -le 3 ]]; do
				read -p "Choose option [0-2]: " MIN_GAMEOVER_INPUT
				if [ $MIN_GAMEOVER_INPUT -eq 0 ]; then
					
				fi
			done
		elif [ $MIN_INPUT -eq 1 ]; then
			
		elif [ $MIN_INPUT -eq 2 ]; then
			
		fi
		
	done
	
}

minselect()
{
	PICKEDMIN=$RANDOMMIN
	minselecttxt
	echo " 0 - Random Minute Value Generator (Recommended)"
	echo " 1 - Enter a minute value 0-59"
	if [ -v $RANDOMMIN ]; then
		printf " 2 - Accept pick: '%.2d'" $PICKEDMIN
	fi
	MIN_INPUT="No escape"
	while ! [[ $MIN_INPUT -ge 0 && $MIN_INPUT -le 2 ]]; do
	read -p "Choose option [0-2]: " MIN_INPUT
		if [ $MIN_INPUT -eq 0 ]; then
			pickrandmin
		elif [ $MIN_INPUT -eq 1 ]; then
			
		elif [ $MIN_INPUT -eq 2 ]; then
			
		fi
		
	done
	
}

cronfreqmenu
USER_INPUT="No escape"
while ! [[ $USER_INPUT -ge 0 && $USER_INPUT -le 6 ]]; do
	read -p "Choose option [0-6]: " USER_INPUT
	if [ $USER_INPUT -ge 0 ] && [ $USER_INPUT -le 1 ]]; then
		if [ $USER_INPUT -eq 0 ]; then
			printf ""
		elif [ $USER_INPUT -eq 1 ]; then
			printf ""
		fi
		minselecttxt
		echo " 0 - Random Minute Value Generator (Recommended)"
		echo " 1 - Enter a minute value 0-59"
		MIN_INPUT="No escape"
		while [ $MIN_INPUT -ge 0 ] && [ $MIN_INPUT -le 2 ]; do
		read -p "Choose option [0-2]: " MIN_INPUT
			if [ $MIN_INPUT -eq 0 ]; then
				pickrandmin
				PICKEDMIN=$RANDOMMIN
				minselecttxt
				
				if [ -v $ENDGAMERAND ]; then
					printf " 2 - Accept pick: %.2d" $PICKEDMIN
				fi
				
				printf " 0 - Random Minute Value Generator (Recommended)"
				printf " 1 - Enter a minute value 0-59"
				
				MIN_GAMEOVER_INPUT="No escape"
				while [ $MIN_GAMEOVER_INPUT -ge 0 ] && [ $MIN_GAMEOVER_INPUT -le 3 ]; do
					read -p "Choose option [0-2]: " MIN_GAMEOVER_INPUT
					if [ $MIN_GAMEOVER_INPUT -eq 0 ]; then
						
					fi
				done
			elif [ $MIN_INPUT -eq 1 ]; then
				
			elif [ $MIN_INPUT -eq 2 ]; then
				
			fi
			
		done
		
	elif [ $USER_INPUT -eq 2 ]; then
		CRON_SCHED="0,30 * * * *"
		CRON_STRING=""
	elif [ $USER_INPUT -eq 3 ]; then
		CRON_SCHED="0,15,30,45 * * * *"
		CRON_STRING=""
	elif [ $USER_INPUT -eq 4 ]; then
		CRON_SCHED="0/10 * * * *"
		CRON_STRING=""
	elif [ $USER_INPUT -eq 5 ]; then
		CRON_SCHED="0/5 * * * *"
		CRON_STRING=""
	elif [ $USER_INPUT -eq 6 ]; then
		
	fi
done






# m h  dom mon dow   command

# Run dynamic-DNS update script every 1 hour (on the 23rd minute) for PDA.com via NameSilo.com API

###23 */1 * * * python2.7 /home/pi/dyndns/dyndns-NameSilo.py

# Run clean-up script for dyndns-NameSilo.py logs, once a month
###0 0 1 */1 * /home/pi/dyndns/dyndns-NameSilo-LogCleanup.sh








# --------------------------------------------------------------------------------------------------------

# Test python script:

###python2.7 /home/pi/dyndns/dyndns.py

# Test log cleanup script:

###/home/pi/dyndns/logcleanup.sh








# --------------------------------------------------------------------------------------------------------

#http://vivithemage.com/2018/09/17/namesilo-dns-update-via-python-script-and-cron-job-on-pfsense/

# Now if you are like me, and use pfsense, you have to install a module, which you can do by running these commands in shell:
# python2.7 -m ensurepip
# python2.7 -m pip install requests
# python2.7 -m pip install –upgrade pip

# Once you run that, chmod +x your .py script and you are good to go to add the script to a cronjob. I added it via the pfsense cron gui:
# */5 	* 	* 	* 	* 	root 	/usr/local/bin/python2.7 /usr/local/namesilo_update.py

# DO make sure it's in a directory you can run as the user, and modify permissions to make sure.

# I am using namesilo for my DNS, and they've got a solid little API system for stuff you can do to modify your DNS entries. So I use it as a poor mans dynamic DNS at home. For whatever reason though, their rrid changes every time you do an update, so you need to modify the URL to include the new rrid, which you pull from a dnsupdate api call. Thanks to a coworkers python skills, he wrote me this up, works great. Will only run the API call to update if the IP has changed. There are few things you must change for your own information though, and that is:

# DOMAIN.TLDS (example: vivithemage.com) – there are 3 places to change this, line 7, 19, and line 39.
# APIKEY (you get this from namesilo when you generate your API key) – there is one spot to change this, in line 39.
# SUBDOMAIN (example: home) – there is one spot to change this, line 39.
# SUB.DOMAIN.TLDS (example: home.vivithemage.com) – there are 3 spots to change this, line 26, 27 and 28.

# --------------------------------------------------------------------------------------------------------






# --------------------------------------------------------------------------------------------------------



# https://www.pythonforbeginners.com/files/reading-and-writing-files-in-python


# Open, write to file, close file:

#file = open("testfile.txt","w") 
 
#file.write("Hello World") 
#file.write("This is our new text file") 
#file.write("and this is another line.") 
#file.write("Why? Because we can.") 
 
#file.close() 

# Mode:

# Including a mode argument is optional because a default value of 'r' will be assumed if it is omitted. The 'r' value stands for read mode, which is just one of many. 

# The modes are: 

#     'r' – Read mode which is used when the file is only being read 
#     'w' – Write mode which is used to edit and write new information to the file (any existing files with the same name will be erased when this mode is activated) 
#     'a' – Appending mode, which is used to add new data to the end of the file; that is new information is automatically amended to the end 
#     'r+' – Special read and write mode, which is used to handle both actions when working with a file 

# Python - Check if files exists, & create blank file if it doesn't.

# Get current file name:




# Check if file exists:

#os.path.isfile(path)

#OurLogFile = os.path.isfile(path)

# Append to file:

# To append a file: 

#fh = open("hello.txt", "a") 
#fh.write("We Meet Again World") 
#fh.close 



# --------------------------------------------------------------------------------------------------------




#!/bin/bash

loadcolors()
{
	#loadcolors
	#loadcolors "True" # Prints an example list of every color combo
	
	TEST_ALL_COLORS=$1
	
	RED='\033[0;31m'    #'0;31' is Red's ANSI color code
	GREEN='\033[0;32m'  #'0;32' is Green's ANSI color code
	YELLOW='\033[1;33m' #'1;33' is Yellow's ANSI color code
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
loadcolors

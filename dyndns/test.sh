#!/bin/bash

####>>>!/bin/sh###
####>>>!/bin/bash###
####>>>!/usr/bin/env bash


# ____    __    _  _  ____  _____  __  __    _  _  __    __    __  __  ____   
#(  _ \  /__\  ( \( )(  _ \(  _  )(  \/  )  ( \/ )/__\  (  )  (  )(  )( ___)  
# )   / /(__)\  )  (  )(_) ))(_)(  )    (    \  //(__)\  )(__  )(__)(  )__)   
#(_)\_)(__)(__)(_)\_)(____/(_____)(_/\/\_)    \/(__)(__)(____)(______)(____)  
#  ___  ____  _  _  ____  ____    __   ____  _____  ____                      
# / __)( ___)( \( )( ___)(  _ \  /__\ (_  _)(  _  )(  _ \                     
#( (_-. )__)  )  (  )__)  )   / /(__)\  )(   )(_)(  )   /                     
# \___/(____)(_)\_)(____)(_)\_)(__)(__)(__) (_____)(_)\_)                     



#
#      _____
#     |.---.|
#     ||___||
#     |+  .'|
#     | _ _ |
#jgs  |_____/
#

splasharttest()
{
	echo "      _____ "
	echo "     |.---.|"
	echo "     ||___||"
	echo "     |+  .'|"
	echo "     | _ _ |"
	echo "jgs  |_____/"
}

#splasharttest
#read -p "Press Enter to continue"

pickrandommin()
{
	# This function will pick a random minute value from 0-59.
	
	# RANDOM is an internal bash command that returns a pseudo-random 15-bit integer in the range 0 – 32767.
	#https://www.geeksforgeeks.org/random-shell-variable-in-linux-with-examples/
	# To enhance the randomization process, the random variable can be seeded with an initial value which can be the time in epoch, the process ID of the current shell, etc.
	
	# Syntax to use time in epoch to initialize the generator:
	RANDOM=$(date +%s)
	
	# Syntax to use process ID of the current shell to initialze the generator:
	RANDOM=$$ #PID of shell is stored in $$ variable
	
	# Generating random integer when the upper limit is given
	
	# Consider that you want to generate a random integer within Y (where Y is not included):
	#R=$(($RANDOM%Y))
	#echo $(($RANDOM%10)) #This will display a random integer between 0 and 9.
	#echo $(($RANDOM%11)) #This will display a random integer between 0 and 10.
	
	RANDOMMIN=$(($RANDOM%60))
	
	#Precision modifier
	#You can use the precision modifier (.) dot to specify a minimum number of digits to be displayed with %d, %u, %o, %x. It adds zero padding on the left of the value.
	#abhishek@handbook:~$ printf "Roll Number: %.5d\n" 23
	#Roll Number: 00023
	
	SEED_METHOD_TOGGLE=0
	seedrandom()
	{
		seedrandmethod1()
		{
			# Syntax to use time in epoch to initialize the generator:
			RANDOM=$(date +%s)
		}
		seedrandmethod2()
		{
			# Syntax to use process ID of the current shell to initialze the generator:
			RANDOM=$$ #PID of shell is stored in $$ variable
		}
		
		if [ $SEED_METHOD_TOGGLE -eq 0 ]; then
			seedrandmethod1
			seedrandmethod2
			SEED_METHOD_TOGGLE=1
		elif [ $SEED_METHOD_TOGGLE -eq 1 ]; then
			seedrandmethod1
			SEED_METHOD_TOGGLE=2
		elif [ $SEED_METHOD_TOGGLE -eq 2 ]; then
			seedrandmethod2
			SEED_METHOD_TOGGLE=1
		else
			SEED_METHOD_TOGGLE=0
		fi
	}
	#/seedrandom function
	
	splashstart()
	{
		echo ""
		if [ "$PROPLAYER" = "True" ]; then
			DIFFICULTY_TRUE_STR="(*)"
			DIFFICULTY_FALSE_STR="( )"
			
			if [ $DIFFICULTY -ge 1 ]; then DFFCLTY_1_LBL=$DIFFICULTY_TRUE_STR ; else DFFCLTY_1_LBL=$DIFFICULTY_FALSE_STR ; fi
			if [ $DIFFICULTY -ge 2 ]; then DFFCLTY_2_LBL=$DIFFICULTY_TRUE_STR ; else DFFCLTY_2_LBL=$DIFFICULTY_FALSE_STR ; fi
			if [ $DIFFICULTY -ge 3 ]; then DFFCLTY_3_LBL=$DIFFICULTY_TRUE_STR ; else DFFCLTY_3_LBL=$DIFFICULTY_FALSE_STR ; fi
			if [ $DIFFICULTY -ge 4 ]; then DFFCLTY_4_LBL=$DIFFICULTY_TRUE_STR ; else DFFCLTY_4_LBL=$DIFFICULTY_FALSE_STR ; fi
			if [ $DIFFICULTY -ge 5 ]; then DFFCLTY_5_LBL=$DIFFICULTY_TRUE_STR ; else DFFCLTY_5_LBL=$DIFFICULTY_FALSE_STR ; fi
			
			#printf "  Achievements: 00/10      ||___||                           \n" $ACHIEVEMENTS_UNLOCKED $MAX_ACHIEVEMENTS
			printf " ____    __    _  _  ____  _____  __  __    _  _  __    __   \n"
			printf "(  _ \  /__\  ( \( )(  _ \(  _  )(  \/  )  ( \/ )/__\  (  )  \n"
			printf " )   / /(__)\  )  (  )(_) ))(_)(  )    (    \  //(__)\  )(__ \n"
			printf "(_)\_)(__)(__)(_)\_)(____/(_____)(_/\/\_)    \/(__)(__)(____)\n"
			printf "    ___  ____  _  _  ____  ____    __   ____  _____  ____    \n"
			printf "   / __)( ___)( \( )( ___)(  _ \  /__\ (_  _)(  _  )(  _ \   \n"
			printf "  ( (_-. )__)  )  (  )__)  )   / /(__)\  )(   )(_)(  )   /   \n"
			printf "   \___/(____)(_)\_)(____)(_)\_)(__)(__)(__) (_____)(_)\_)   \n"
			printf "                            _____     PP Mode: ON        jgs \n"
			printf "  Games played: %3s        |.---.|                           \n" $GAMESPLAYED
			printf "  Achievements: %2s/%.2d      ||___|| Difficulty: %s%s%s%s%s\n" $ACHIEVEMENTS_UNLOCKED $MAX_ACHIEVEMENTS "$DFFCLTY_1_LBL" "$DFFCLTY_2_LBL" "$DFFCLTY_3_LBL" "$DFFCLTY_4_LBL" "$DFFCLTY_5_LBL"
			printf "                           |+  .'|                           \n"
			printf "                           | _ _ |                           \n"
			printf "                           |_____/                           \n"
			printf "     Welcome to the Random Minute Value Generator game!      \n"
			printf "                    Pick any number 0-59                     \n"
			printf "HOW-TO PLAY: Once game starts, press ANY key to pick a value.\n"
		else
			echo " ____    __    _  _  ____  _____  __  __    _  _  __    __   "
			echo "(  _ \  /__\  ( \( )(  _ \(  _  )(  \/  )  ( \/ )/__\  (  )  "
			echo " )   / /(__)\  )  (  )(_) ))(_)(  )    (    \  //(__)\  )(__ "
			echo "(_)\_)(__)(__)(_)\_)(____/(_____)(_/\/\_)    \/(__)(__)(____)"
			echo "    ___  ____  _  _  ____  ____    __   ____  _____  ____    "
			echo "   / __)( ___)( \( )( ___)(  _ \  /__\ (_  _)(  _  )(  _ \   "
			echo "  ( (_-. )__)  )  (  )__)  )   / /(__)\  )(   )(_)(  )   /   "
			echo "   \___/(____)(_)\_)(____)(_)\_)(__)(__)(__) (_____)(_)\_)   "
			echo "                            _____                        jgs "
			echo "                           |.---.|                           "
			echo "                           ||___||                           "
			echo "                           |+  .'|                           "
			echo "                           | _ _ |                           "
			echo "                           |_____/                           "
			echo "     Welcome to the Random Minute Value Generator game!      "
			echo "                    Pick any number 0-59                     "
			echo "HOW-TO PLAY: Once game starts, press ANY key to pick a value."
		fi
	}
	#/splashstart function
	
	splashwinner()
	{
		echo ""
		if [ "$PROPLAYER" = "True" ]; then
			echo "         __      __.__                           ._.         "
			echo "        /  \    /  \__| ____   ____   ___________| |         "
			echo "        \   \/\/   /  |/    \ /    \_/ __ \_  __ \ |         "
			echo "         \        /|  |   |  \   |  \  ___/|  | \/\|         "
			echo "    /\    \__/\  / |__|___|  /___|  /\___  >__|   __         "
			echo "   /  \        \/          \/     \/     \/       \/         "
			echo "   |PP|                                                      "
			echo "   \__/      CONGRATULATIONS, YOU'RE A WINRAR!!!             "
		else
			#echo ""
			#echo "           _________ _        _        _______  _______  _   "
			#echo "  |\     /|\__   __/( (    /|( (    /|(  ____ \(  ____ )( )  "
			#echo "  | )   ( |   ) (   |  \  ( ||  \  ( || (    \/| (    )|| |  "
			#echo "  | | _ | |   | |   |   \ | ||   \ | || (__    | (____)|| |  "
			#echo "  | |( )| |   | |   | (\ \) || (\ \) ||  __)   |     __)| |  "
			#echo "  | || || |   | |   | | \   || | \   || (      | (\ (   (_)  "
			#echo "  | () () |___) (___| )  \  || )  \  || (____/\| ) \ \__ _   "
			#echo "  (_______)\_______/|/    )_)|/    )_)(_______/|/   \__/(_)  "
			echo "         __      __.__                           ._.         "
			echo "        /  \    /  \__| ____   ____   ___________| |         "
			echo "        \   \/\/   /  |/    \ /    \_/ __ \_  __ \ |         "
			echo "         \        /|  |   |  \   |  \  ___/|  | \/\|         "
			echo "          \__/\  / |__|___|  /___|  /\___  >__|   __         "
			echo "               \/          \/     \/     \/       \/         "
			echo "                                                             "
			echo "             CONGRATULATIONS, YOU'RE A WINRAR!!!             "
			#echo "            CONGRADJULATIONS, YOU'RE A WINRAR!!!             "
		fi
	}
	#/splashwinner function
	
	splashproplayer()
	{
		#echo "__________________         ______ _                       "
		#echo "| ___ \ ___ \ ___ \        | ___ \ |                      "
		#echo "| |_/ / |_/ / |_/ / __ ___ | |_/ / | __ _ _   _  ___ _ __ "
		#echo "|  __/|  __/|  __/ '__/ _ \|  __/| |/ _` | | | |/ _ \ '__|"
		#echo "| |   | |   | |  | | | (_) | |   | | (_| | |_| |  __/ |   "
		#echo "\_|   \_|   \_|  |_|  \___/\_|   |_|\__,_|\__, |\___|_|   "
		#echo "                                           __/ |          "
		#echo "                                          |___/           "
		
		printf "__________________         ______ _                        \n"
		printf "| ___ \ ___ \ ___ \        | ___ \ |                       \n"
		printf "| |_/ / |_/ / |_/ / __ ___ | |_/ / | __ _ _   _  ___ _ __  \n"
		printf "|  __/|  __/|  __/ '__/ _ \|  __/| |/ _\` | | | |/ _ \ '__| \n"
		printf "| |   | |   | |  | | | (_) | |   | | (_| | |_| |  __/ |    \n"
		printf "\_|   \_|   \_|  |_|  \___/\_|   |_|\__,_|\__, |\___|_|    \n"
		printf "                                           __/ |           \n"
		printf "                                          |___/            \n"
		printf "                  ProPlayer mode unlocked!                 \n"
		printf "                      (PP for short!)                      \n"
		printf "                                                           \n"
		printf "   This mode becomes unlocked by gaining Achievements by   \n"
		printf "     picking numbers with special messages, or after a     \n"
		printf "     certain number of games have been played. You can     \n"
		printf "   also toggle this mode on/off by typing in the special   \n"
		#printf "         code, 'PP' on the selection menu screen!          \n"
		printf "    code 'PP' on the selection menu screen, even for a     \n"
		printf "                      brand new game!                      \n"
		printf "\n"
		read -s -p "Press ENTER key to continue... "
		printf "\n"
	}
	#/splashproplayer function
	
	splashtemp()
	{
		echo " ____    __    _  _  ____  _____  __  __    _  _  __    __   "
		echo "(  _ \  /__\  ( \( )(  _ \(  _  )(  \/  )  ( \/ )/__\  (  )  "
		echo " )   / /(__)\  )  (  )(_) ))(_)(  )    (    \  //(__)\  )(__ "
		echo "(_)\_)(__)(__)(_)\_)(____/(_____)(_/\/\_)    \/(__)(__)(____)"
		echo "    ___  ____  _  _  ____  ____    __   ____  _____  ____    "
		echo "   / __)( ___)( \( )( ___)(  _ \  /__\ (_  _)(  _  )(  _ \   "
		echo "  ( (_-. )__)  )  (  )__)  )   / /(__)\  )(   )(_)(  )   /   "
		echo "   \___/(____)(_)\_)(____)(_)\_)(__)(__)(__) (_____)(_)\_)   "
		echo "                            _____                        jgs "
		echo "                           |.---.|                           "
		echo "                           ||___||                           "
		echo "                           |+  .'|                           "
		echo "                           | _ _ |                           "
		echo "                           |_____/                           "
		echo "     Welcome to the Random Minute Value Generator game!      "
		echo "HOW-TO PLAY: Once game starts, press ANY key to pick a value."
		echo "           _________ _        _        _______  _______  _   "
		echo "  |\     /|\__   __/( (    /|( (    /|(  ____ \(  ____ )( )  "
		echo "  | )   ( |   ) (   |  \  ( ||  \  ( || (    \/| (    )|| |  "
		echo "  | | _ | |   | |   |   \ | ||   \ | || (__    | (____)|| |  "
		echo "  | |( )| |   | |   | (\ \) || (\ \) ||  __)   |     __)| |  "
		echo "  | || || |   | |   | | \   || | \   || (      | (\ (   (_)  "
		echo "  | () () |___) (___| )  \  || )  \  || (____/\| ) \ \__ _   "
		echo "  (_______)\_______/|/    )_)|/    )_)(_______/|/   \__/(_)  "
		echo "         __      __.__                           ._.         "
		echo "        /  \    /  \__| ____   ____   ___________| |         "
		echo "        \   \/\/   /  |/    \ /    \_/ __ \_  __ \ |         "
		echo "         \        /|  |   |  \   |  \  ___/|  | \/\|         "
		echo "          \__/\  / |__|___|  /___|  /\___  >__|   __         "
		echo "               \/          \/     \/     \/       \/         "
		echo "                                                             "
		echo "             CONGRATULATIONS, YOU'RE A WINRAR!!!             "
		#echo "            CONGRADJULATIONS, YOU'RE A WINRAR!!!             "
		echo "You picked the number:  00    --  What a H00T!               "
		echo "You picked the number:  00    --  Must think you're special! "
		echo "You picked the number:  00    --  I love a good #2.          "
		echo "You picked the number:  00    --  If I had a nickel...($0.00)"
		echo "You picked the number:  00    --  ..This magic 8-ball sucks! "
		echo "You picked the number:  00    --  Number 9?                  "
		echo "You picked the number:  00    --  Hey, Nineteen!             "
		echo "You picked the number:  00    --  But what was the question??"
		echo "You picked the number:  00    --  Fleventy 5                 "
		echo "You picked the number:  00    --  Mad MAX!!!                 "
		
		echo "You picked the number:  00    --  -Wait, AGAIN?!?!?          "
		echo "You picked the number:  00    --  -Wait, AGAIN?!?!?  (x2)    "
		echo "You picked the number:  00    --  Wait, sorry actually 00 won"
		echo "You picked the number:  00    --  beers on the wall, 00 beers"
		
		echo "You picked the number:  00    --  I think you could do better"
		echo "You picked the number:  00    --  My STARS!                  "
		echo "You picked the number:  00    --  In hex code it's 'B00B5'   "
		echo "You picked the number:  00    --  ...Oh MY!                  "
		echo "You picked the number:  00    --  How swell!!                "
		echo "You picked the number:  00    --  Look at YOU! *wink*wink*   "
		echo "You picked the number:  00    --  You know what that means!  "
		echo "You picked the number:  00    --  HURRAY!!!  <@;P            "
		echo "You picked the number:  00    --  It's your lucky day!!      "
		echo "You picked the number:  00    --  Let's PAR-TAY!!            "
		echo "You picked the number:  00    --  CONGRADJUL- ...CONGRATS!   "
		echo "You picked the number:  00    --  My favorite!               "
		echo "You picked the number:  00    --  Would you look at that!    "
		echo "You picked the number:  00    --  You don't say!             "
		echo "You picked the number:  00    --  Yer darn tootin'!          "
		echo "You picked the number:  00    --  Too slow!                  "
		echo "You picked the number:  00    --  That's what she said.      "
		echo "You picked the number:  00    --  BINGO!                     "
		echo "You picked the number:  00    --  So close!                  "
		echo "You picked the number:  00    --  Well? Do you like it?      "
		echo "You picked the number:  00    --  Go YOU!!                   "
		echo "You picked the number:  00    --  What a steal!              "
		echo "You picked the number:  00    --  Boy, you sure can pick 'em!"
		
	}
	#/splashtemp function
	
	commentarypicker()
	{
		NUMPICK=$1
		REPAINT_COMMENT=$2
		
		# Special number messages:
		if [ $NUMPICK -eq $LASTPICK ]; then
			if [ "$ACHMT_REPEAT" != "True" ]; then
				ACHIEVEMENT_UNLOCKED="True"
			fi
			if [ "$REPAINT_COMMENT" = "No-repaint" ] && [ "$ACHMT_REPEAT" != "True" ]; then
				((ACHIEVEMENTS_UNLOCKED+=1))
			fi
			ACHMT_REPEAT="True"
			#echo "You picked the number:  00    --  -Wait, AGAIN?!?!?  (x2)    "
			#printf "You picked the number:  %.2d    --  -Wait, AGAIN?!?!?  (x2)    \n" $NUMPICK
			#printf "You picked the number:  %.2d    --  -Wait, AGAIN?!?!?  (x$REPEATCOUNT)    \n" $NUMPICK
			#printf "You picked the number:  %.2d    --  AGAIN?!?!?  (x$REPEATCOUNT)           \n" $NUMPICK
			#printf "You picked the number:  %.2d    --  AGAIN?!?!?  (%sx)           \n" $NUMPICK $REPEATCOUNT
			printf "You picked the number:  %.2d    --  Wait, AGAIN?!?!?  (%sx)     \n" $NUMPICK $REPEATCOUNT
			return
		elif [ $NUMPICK -eq 0 ]; then
			if [ "$ACHMT_0" != "True" ]; then
				ACHIEVEMENT_UNLOCKED="True"
			fi
			if [ "$REPAINT_COMMENT" = "No-repaint" ] && [ "$ACHMT_0" != "True" ]; then
				((ACHIEVEMENTS_UNLOCKED+=1))
			fi
			ACHMT_0="True"
			#echo "You picked the number:  00    --  What a H00T!               "
			printf "You picked the number:  %.2d    --  What a H00T!               \n" $NUMPICK
			return
		elif [ $NUMPICK -eq 1 ]; then
			if [ "$ACHMT_1" != "True" ]; then
				ACHIEVEMENT_UNLOCKED="True"
			fi
			if [ "$REPAINT_COMMENT" = "No-repaint" ] && [ "$ACHMT_1" != "True" ]; then
				((ACHIEVEMENTS_UNLOCKED+=1))
			fi
			ACHMT_1="True"
			#echo "You picked the number:  00    --  Must think you're special! "
			printf "You picked the number:  %.2d    --  Must think you're special! \n" $NUMPICK
			return
		elif [ $NUMPICK -eq 2 ]; then
			if [ "$ACHMT_2" != "True" ]; then
				ACHIEVEMENT_UNLOCKED="True"
			fi
			if [ "$REPAINT_COMMENT" = "No-repaint" ] && [ "$ACHMT_2" != "True" ]; then
				((ACHIEVEMENTS_UNLOCKED+=1))
			fi
			ACHMT_2="True"
			#echo "You picked the number:  00    --  I love a good #2.          "
			printf "You picked the number:  %2s    --  I love a good #2.          \n" $NUMPICK
			return
		elif [ $NUMPICK -eq 5 ]; then
			if [ "$ACHMT_5" != "True" ]; then
				ACHIEVEMENT_UNLOCKED="True"
			fi
			if [ "$REPAINT_COMMENT" = "No-repaint" ]; then
				if [ "$ACHMT_5" != "True" ]; then
					((ACHIEVEMENTS_UNLOCKED+=1))
				fi
				((NICKELS+=1))
			fi
			ACHMT_5="True"
			MONEY=`echo "$NICKELS * 0.05" | bc`
			#echo "You picked the number:  00    --  If I had a nickel...($0.00)"
			#printf "You picked the number:  %.2d    --  If I had a nickel...($0.00)\n" $NUMPICK
			printf "You picked the number:  %.2d    --  If I had a nickel...(\$%1.2f)\n" $NUMPICK $MONEY
			return
		elif [ $NUMPICK -eq 9 ]; then
			if [ "$ACHMT_9" != "True" ]; then
				ACHIEVEMENT_UNLOCKED="True"
			fi
			if [ "$REPAINT_COMMENT" = "No-repaint" ] && [ "$ACHMT_9" != "True" ]; then
				((ACHIEVEMENTS_UNLOCKED+=1))
			fi
			ACHMT_9="True"
			#echo "You picked the number:  00    --  Number 9?                  "
			printf "You picked the number:  %2s    --  Number 9?                  \n" $NUMPICK
			return
		elif [ $NUMPICK -eq 19 ]; then
			if [ "$ACHMT_19" != "True" ]; then
				ACHIEVEMENT_UNLOCKED="True"
			fi
			if [ "$REPAINT_COMMENT" = "No-repaint" ] && [ "$ACHMT_19" != "True" ]; then
				((ACHIEVEMENTS_UNLOCKED+=1))
			fi
			ACHMT_19="True"
			#echo "You picked the number:  00    --  Hey, Nineteen!             "
			printf "You picked the number:  %2s    --  Hey, Nineteen!             \n" $NUMPICK
			return
		elif [ $NUMPICK -eq 42 ]; then
			if [ "$ACHMT_42" != "True" ]; then
				ACHIEVEMENT_UNLOCKED="True"
			fi
			if [ "$REPAINT_COMMENT" = "No-repaint" ] && [ "$ACHMT_42" != "True" ]; then
				((ACHIEVEMENTS_UNLOCKED+=1))
			fi
			ACHMT_42="True"
			#echo "You picked the number:  00    --  But what was the question??"
			printf "You picked the number:  %2s    --  But what was the question??\n" $NUMPICK
			return
		elif [ $NUMPICK -eq 55 ]; then
			if [ "$ACHMT_55" != "True" ]; then
				ACHIEVEMENT_UNLOCKED="True"
			fi
			if [ "$REPAINT_COMMENT" = "No-repaint" ] && [ "$ACHMT_55" != "True" ]; then
				((ACHIEVEMENTS_UNLOCKED+=1))
			fi
			ACHMT_55="True"
			#echo "You picked the number:  00    --  Fleventy 5                 "
			printf "You picked the number:  %2s    --  Fleventy 5                 \n" $NUMPICK
			return
		elif [ $NUMPICK -eq 59 ]; then
			if [ "$ACHMT_59" != "True" ]; then
				ACHIEVEMENT_UNLOCKED="True"
			fi
			if [ "$REPAINT_COMMENT" = "No-repaint" ] && [ "$ACHMT_59" != "True" ]; then
				((ACHIEVEMENTS_UNLOCKED+=1))
			fi
			ACHMT_59="True"
			#echo "You picked the number:  00    --  Mad MAX!!!                 "
			printf "You picked the number:  %2s    --  Mad MAX!!!                 \n" $NUMPICK
			return
		else
			# All other (non-special) number messages, randomly picked:
			# (That's right, not ALL numbers are special!)
			
			# To set MAX_OPTIONS, manually count out total amount of random comment options in the case/switch block below. DO NOT include the S options, count those separately for the MAX_S_OPTIONS var.
			MAX_OPTIONS=25
			MAX_S_OPTIONS=3
			# "Positive comments" list is used to exclude any comments that are too cheeky or too outwardly a joke from being selected in the first few games.
			POSITIVE_COMMENTS=( 2 4 5 6 7 8 9 10 11 12 13 14 15 18 20 21 24 25 )
			
			if [ "$REPAINT_COMMENT" = "No-repaint" ]; then
				# Loop init:
				MAX_ORIG_OPTIONS=$MAX_OPTIONS
				((MAX_OPTIONS+=$MAX_S_OPTIONS))
				LAST_SELECTED="$COMMENTSELECT"
				SELECTION_APPROVED="False"
				iteration=0
				# Loop to randomly pick a comment, but one within the rules:
				while [ "$SELECTION_APPROVED" = "False" ]; do
					((iteration+=1))
					#echo "Loop $iteration"
					
					if [ $RSEED -ge $RSEED_FREQ ]; then
						RSEED=0
						# Seed the RANDOM function/var every once in a while to enhance it's randomness.
						seedrandom
					else
						((RSEED+=1))
					fi
					# Calling the $RANDOM var with suffix %$INT ($INT as an integer) will generate a random integer from 0 up to (but not including) INT.
					COMMENTSELECT=$(($RANDOM%$MAX_OPTIONS))
					# Here we shift the whole selection index forward one. We purposely started the index of comments in the case/switch block below at 1, and the MAX_OPTIONS var (above) as the count of comments starting at 1. So when calling $RANDOM directly above it will output between 0 and (MAX_OPTIONS minus 1), so if we now shift the whole result value forward by one, we have a perfect match to our index down below.
					((COMMENTSELECT+=1))
					
					# Make sure we don't pick the same comment that was just shown to the user on last run.
					if [[ $COMMENTSELECT = $LAST_SELECTED ]]; then
						# Re-roll!
						#echo "Re-roll for same comment as used last time!"
						SELECTION_APPROVED="False"
						continue
					fi
					
					# Evaluate all non-S options:
					if [ $COMMENTSELECT -le $MAX_ORIG_OPTIONS ]; then
						#echo "Evaluating non-S options."
						# Re-roll if we land on a non-positive (too cheeky) comment within the first x games:
						if [ $GAMESPLAYED -le 3 ]; then
							ON_APPR_LIST="False"
							for i in "${POSITIVE_COMMENTS[@]}"; do
								#echo "Testing array list item: $i"
								if [ $i -eq $COMMENTSELECT ]; then
									ON_APPR_LIST="True"
								fi
							done
							if ! [ $ON_APPR_LIST = "True" ] ; then
								# If we went through that whole list and the selected comment didn't get flagged as approved, time to abort and re-roll
								#echo "Re-roll for early-game non-positive comment not on the approved list! ($COMMENTSELECT)"
								continue
							else
								SELECTION_APPROVED="True"
								break;
							fi
						#else
						#	echo "NOTICE!: Random comment options have passed positive comments point! ($COMMENTSELECT)"
						fi
						#/Positive comments early game
					fi
					
					# Adjust selection string for S options:
					if [ $COMMENTSELECT -gt $MAX_ORIG_OPTIONS ]; then
						SELECTION_STR="$(($COMMENTSELECT-$MAX_ORIG_OPTIONS))s"
						COMMENTSELECT="$SELECTION_STR"
					else
						# Convert the data type to a string regardless, to match.
						COMMENTSELECT="$COMMENTSELECT"
					fi
					
					#echo "NOTICE!: Entering S options Zone!!! ($COMMENTSELECT)"
					
					# S options exceptions:
					
					# 1s: when doing the "whoops wrong number" joke, it's more funny if the 10's digit is the same. For example, "37! Wait no, sorry, I meant 38!" is a bit funnier than "39! Wait no, I meant 40!". People don't generally make that kind of mistake between two numbers in a different 10s digit, they're too obviously different.
					if [ "$COMMENTSELECT" = "1s" ]; then
						# Filter out non-positive comments for first few rounds:
						if [ $GAMESPLAYED -le 3 ]; then continue; fi;
						# Filter out numbers with zeros and nines as the 1st digit
						SINGLE_DIG=$NUMPICK
						# Remove 10's digit:
						if [ $NUMPICK -gt 9 ]; then
							while [ $SINGLE_DIG -gt 9 ]; do
								((SINGLE_DIG-=10))
							done
						fi
						# Now check if the 1st digit is a 0 or a 9:
						if [ $SINGLE_DIG -eq 0 ] || [ $SINGLE_DIG -eq 9 ] ; then
							# No go. Re-roll
							#echo "Re-roll b/c wrong number gag ($COMMENTSELECT) has wrong single digit number. ($NUMPICK)"
							continue
						fi
					fi
					
					# 2s: the 'bottles of beer on the wall' song sounds weird when the count is less than a few dozen
					if [ "$COMMENTSELECT" = "2s" ]; then
						# Filter out non-positive comments for first few rounds:
						if [ $GAMESPLAYED -le 3 ]; then continue; fi;
						# if it's not greater than the teens, then...
						if ! [ $NUMPICK -gt 21 ]; then
							# Re-roll for a different choice:
							#echo "Re-roll b/c number for beer bottles comment ($COMMENTSELECT) being too low. ($NUMPICK)"
							continue
						fi
					fi
					
					# 3s: the 'magic 8-ball' joke was supposed to be more funny when you've landed on a random number. But if you actually land on 8 it's a bit ironic, so maybe unlock an achievement or something?
					if [ "$COMMENTSELECT" = "3s" ]; then
						# Filter out non-positive comments for first few rounds:
						if [ $GAMESPLAYED -le 3 ]; then continue; fi;
					fi
					
					# Winnar! Every part of this loop should abort & restart it with a `continue` command if the chosen selection isn't good. If we make all the way to the end of the loop here and no tests aborted it, it must be good, even if it wasn't explicitly marked as so yet.
					#echo "FINALLY!!! Reached end of loop, approving whatever selection we had: $COMMENTSELECT"
					SELECTION_APPROVED="True"
					break;
				done
				#/while do loop for randomly selecting a comment
			else
				# Repeat the exact same last comment if REPAINT_COMMENT var is set to an index key instead of "No-repaint"
				COMMENTSELECT=$REPAINT_COMMENT
			fi
			
			# Switch block for choosing a comment:
			# The S in certain options stands for "special" :)
			case $COMMENTSELECT in
					"1s")
							WRONG_NUMBER=$NUMPICK
							((WRONG_NUMBER+=1))
							#printf "You picked the number:  %2s    --  Wait, sorry actually 00 won\n" $NUMPICK
							printf "You picked the number:  %2s    --  Wait, sorry actually %s won\n" $NUMPICK $WRONG_NUMBER
							;;
					"2s")
							MINUS_ONE_BEER=$NUMPICK
							((MINUS_ONE_BEER-=1))
							printf "You picked the number:  %2s    --  beers on the wall, %s beers\n" $NUMPICK $MINUS_ONE_BEER
							;;
					"3s")
							printf "You picked the number:  %2s    --  ..This magic 8-ball sucks! \n" $NUMPICK
							#if [ $NUMPICK -eq 8 ]; then
								#8 = ironic
							#fi
							;;
					"1")
							printf "You picked the number:  %2s    --  I think you could do better\n" $NUMPICK
							;;
					"2")
							printf "You picked the number:  %2s    --  My STARS!                  \n" $NUMPICK
							#printf "You picked the number:  %2s    --  My Stars!                  \n" $NUMPICK
							#positive
							;;
					"3")
							printf "You picked the number:  %2s    --  In hex code it's 'B00B5'   \n" $NUMPICK
							;;
					"4")
							printf "You picked the number:  %2s    --  ...Oh MY!                  \n" $NUMPICK
							#positive
							;;
					"5")
							printf "You picked the number:  %2s    --  How swell!!                \n" $NUMPICK
							#positive
							;;
					"6")
							printf "You picked the number:  %2s    --  Look at YOU! *wink*wink*   \n" $NUMPICK
							#positive
							;;
					"7")
							printf "You picked the number:  %2s    --  You know what that means!  \n" $NUMPICK
							#positive
							;;
					"8")
							printf "You picked the number:  %2s    --  HURRAY!!!  *<@;-D          \n" $NUMPICK
							#positive
							;;
					"9")
							printf "You picked the number:  %2s    --  It's your lucky day!!      \n" $NUMPICK
							#positive
							#7 = true
							#13 = ironic
							;;
					"10")
							printf "You picked the number:  %2s    --  Let's PAR-TAY!!            \n" $NUMPICK
							#positive
							;;
					"11")
							printf "You picked the number:  %2s    --  CONGRADJUL- ...CONGRATS!   \n" $NUMPICK
							#positive
							;;
					"12")
							printf "You picked the number:  %2s    --  My favorite!               \n" $NUMPICK
							#positive
							#13 = ironic
							;;
					"13")
							printf "You picked the number:  %2s    --  Would you look at that!    \n" $NUMPICK
							#positive
							;;
					"14")
							printf "You picked the number:  %2s    --  You don't say!             \n" $NUMPICK
							#positive
							;;
					"15")
							printf "You picked the number:  %2s    --  Yer darn tootin'!          \n" $NUMPICK
							#positive
							;;
					"16")
							printf "You picked the number:  %2s    --  Too slow!                  \n" $NUMPICK
							;;
					"17")
							printf "You picked the number:  %2s    --  That's what she said.      \n" $NUMPICK
							;;
					"18")
							printf "You picked the number:  %2s    --  BINGO!                     \n" $NUMPICK
							#positive
							;;
					"19")
							printf "You picked the number:  %2s    --  So close!                  \n" $NUMPICK
							;;
					"20")
							printf "You picked the number:  %2s    --  Well? Do you like it?      \n" $NUMPICK
							#positive
							;;
					"21")
							printf "You picked the number:  %2s    --  Go YOU!!                   \n" $NUMPICK
							#positive
							;;
					"22")
							printf "You picked the number:  %2s    --  What a steal!              \n" $NUMPICK
							;;
					"23")
							printf "You picked the number:  %2s    --  Boy, you sure can pick 'em!\n" $NUMPICK
							;;
					"24")
							printf "You picked the number:  %2s    --  Hot Dog!                   \n" $NUMPICK
							#positive
							;;
					"25")
							printf "You picked the number:  %2s    --  Fancy that!                \n" $NUMPICK
							#positive
							;;
			esac
			#/case $COMMENTSELECT block
			
			
			
		fi
		
	}
	#/commentarypicker function
	
	countdowntimer()
	{
		GAMENUM=$1
		DIFFICULTY=$2
		
		normaltimer()
		{
			x=6
			while [ $x -gt 0 ]; do
				((x-=1))
				#echo -n -e "\rStarting game in...   $x   "
				printf "\rStarting game in...   $x   "
				#printf "\rStarting game in...   5   "
				#printf "\rStarting game in...   0   "
				#printf "\r                     G0!  "
				#printf "\r                     GO!  "
				sleep 0.9
			done
			if [ "$zerooption" = "True" ]; then
				printf "\r                     G0!  "
			else
				printf "\r                     GO!  "
			fi
			#printf "\r                     GO!  "
			sleep 0.5
			printf "\r                           "
		}
		countuptimer()
		{
			x=4
			while [ $x -lt 10 ]; do
				((x+=1))
				printf "\rStarting game in...  %2s   " $x
				sleep 0.9
			done
			printf "\r                     G0!  "
			sleep 0.5
			printf "\r                          "
		}
		negativetimer()
		{
			x=6
			while [ $x -ge -10 ]; do
				((x-=1))
				printf "\rStarting game in... %3s   " $x
				if [ $x -eq -11 ]; then
					sleep 0.5
				else
					sleep 0.9
				fi
			done
			printf "\rStarting game in... -10   " $x
			sleep 1.7
			printf "\r                          "
			sleep 1
			printf "\r                     G0!  "
			sleep 0.5
			printf "\r                          "
		}
		slowtimerone()
		{
			printf "\rStarting game in...   5   "
			sleep 0.9
			printf "\rStarting game in...   4   "
			sleep 0.9
			printf "\rStarting game in...   3   "
			sleep 4.5
			printf "\rStarting game in...   2   "
			sleep 1.7
			printf "\rStarting game in...   1   "
			sleep 0.1
			printf "\rStarting game in...   0   "
			sleep 0.1
			printf "\r                     G0!  "
			sleep 0.2
			printf "\r                          "
		}
		slowtimertwo()
		{
			printf "\rStarting game in...   5   "
			sleep 0.9
			printf "\rStarting game in...   4   "
			sleep 3.5
			printf "\rStarting game in...   3   "
			sleep 0.1
			printf "\rStarting game in...   2   "
			sleep 0.1
			printf "\rStarting game in...   1   "
			sleep 0.1
			printf "\rStarting game in...   0   "
			sleep 0.1
			printf "\r                     G0!  "
			sleep 0.2
			printf "\r                          "
		}
		slowtimerthree()
		{
			printf "\rStarting game in...   5   "
			sleep 2.5
			printf "\rStarting game in...   4   "
			sleep 0.1
			printf "\rStarting game in...   3   "
			sleep 0.1
			printf "\rStarting game in...   2   "
			sleep 2
			printf "\rStarting game in...   1   "
			sleep 0.1
			printf "\rStarting game in...   0   "
			sleep 0.9
			printf "\r                     G0!  "
			sleep 0.3
			printf "\r                          "
		}
		slowtimerfinal()
		{
			printf "\rStarting game in...   5   "
			sleep 2.7
			printf "\rStarting game in...   4   "
			sleep 0.1
			printf "\rStarting game in...   3   "
			sleep 0.1
			printf "\rStarting game in...   2   "
			sleep 0.1
			printf "\rStarting game in...   1   "
			sleep 0.1
			printf "\rStarting game in...   0   "
			sleep 0.1
			printf "\r                     G0!  "
			sleep 0.1
			printf "\r                          "
		}
		fadeouttimer()
		{
			printf "\rStarting game in...   5   "
			sleep 0.9
			printf "\rSta ting  ame  n..    5   "
			sleep 0.9
			printf "\r ta ti g  am   n .    5   "
			sleep 0.9
			printf "\r     i    am     .    5   "
			sleep 0.9
			printf "\r                      5   "
			sleep 0.9
			printf "\r                      0   "
			sleep 0.7
			printf "\r                     G0!  "
			sleep 0.4
			printf "\r                          "
		}
		fadeouttimertwo()
		{
			printf "\rStarting game in...   5   "
			sleep 0.9
			printf "\rS arting game in. .   4   "
			sleep 0.9
			printf "\r  a tin  g me  n. .   3   "
			sleep 0.9
			printf "\r  a   n     e  n.     2   "
			sleep 0.9
			printf "\r      n     e         1   "
			sleep 0.9
			printf "\r                      0   "
			sleep 0.9
			printf "\r                     G0!  "
			sleep 0.5
			printf "\r                          "
		}
		capsfadetimer()
		{
			printf "\rStarting game in...   5   "
			sleep 0.9
			printf "\rStarTIng gAme iN...   4   "
			sleep 0.9
			printf "\rsTarTInG GAme iN...   3   "
			sleep 0.9
			printf "\rStArTING GAmE IN...   2   "
			sleep 0.9
			printf "\rSTARTING GAME IN...   1   "
			sleep 0.9
			printf "\rSTARTING GAME IN...   0   "
			sleep 0.9
			printf "\r                     G0!  "
			sleep 0.5
			printf "\r                          "
		}
		distortedtimerone()
		{
			printf "\rStarting game in...  05   "
			sleep 0.9
			printf "\rStarting game in...  F4   "
			sleep 0.9
			printf "\rStarting game in...  6B-EA"
			sleep 0.9
			printf "\rStarting game in...    -A2"
			sleep 0.9
			printf "\rStarting game in...  0A-  "
			sleep 0.9
			printf "\rStarting game in...  00   "
			sleep 0.9
			printf "\r                     G0!  "
			sleep 0.4
			printf "\r                          "
		}
		distortedtimertwo()
		{
			printf "\rStarting game in...   5   "
			sleep 0.9
			printf "\rStarting game in...  5A   "
			sleep 0.9
			printf "\rStarting game in... F5    "
			sleep 0.9
			printf "\rStarting game in...0x---2A"
			sleep 0.9
			printf "\r0xant1ng game ln.80  __   "
			sleep 0.9
			printf "\r_ a t _g g me _n. .  0A ! "
			sleep 0.9
			printf "\r                     G0!  "
			sleep 0.3
			printf "\r                          "
		}
		distortedtimerthree()
		{
			printf "\rStarting game in...   5   "
			sleep 0.9
			printf "\rStarFAng game in...  F5   "
			sleep 0.9
			printf "\r6tarFAng0game in.2.  5A  8"
			sleep 0.9
			printf "\rD6a0FAng0gam11in.2.1 26  8"
			sleep 0.9
			printf "\r26a0FAng0gam11in.246 851A2"
			sleep 0.9
			printf "\r861FAA21B742811B2210C98AFE"
			sleep 0.9
			#printf "\r+SN3^i..zv5\A4tm'Rh1DqeLHU"
			printf "\r+SN3^i..zv5\\A4tm'Rh1DqeLHU"
			sleep 0.5
			printf "\r                          "
			sleep 2.7
			if [ "$SHORTTIMERVER" != "Yes" ]; then
				if [ "$DISTTIMERTHREEDIR" = "Up" ]; then
					printf "\rStarting game in...  99   "
					sleep 0.6
					x=98
					while [ $x -lt 112 ]; do
						((x+=1))
						printf "\rStarting game in... %3s   " $x
						sleep 1
					done
				else
					printf "\rStarting game in...  99   "
					sleep 0.6
					x=100
					while [ $x -ge 88 ]; do
						((x-=1))
						printf "\rStarting game in...  %2s   " $x
						sleep 1
					done
				fi
				sleep 1
				#printf "\r=1J@CHG9,uRu*Uu50`@\E3VAJL"
				printf "\r=1J@CHG9,uRu*Uu50\`@\\\E3VAJL"
				sleep 0.6
				printf "\r                          "
				sleep 2
			fi
			printf "\r                     G0!  "
			sleep 0.4
			printf "\r                          "
		}
		distortedtimerglitch()
		{
			printf "\rStarting game in...   5   "
			sleep 0.9
			printf "\rStarting game in...   4   "
			sleep 0.9
			printf "\rStarting game in...   3   "
			sleep 0.9
			printf "\rStarting game in...   2   "
			sleep 0.2
			printf "\r+SNr^i.gzga\\\\A4t.'Rh1 D2eHU"
			sleep 0.2
			printf "\rStarting game in...   2   "
			sleep 0.6
			printf "\rStarting game in...   1   "
			sleep 0.9
			printf "\rStarting game in...   0   "
			sleep 0.9
			printf "\r                     G0!  "
			sleep 0.4
			printf "\r                          "
		}
		binarytimer()
		{
			#87654321
			#    8421
			#     000
			#     101 = 5
			printf "\rStarting game in... 101   "
			sleep 0.9
			printf "\rStarting game in... 100   "
			sleep 0.9
			printf "\rStarting game in... 011   "
			sleep 0.9
			printf "\rStarting game in... 010   "
			sleep 0.9
			printf "\rStarting game in... 001   "
			sleep 0.9
			printf "\rStarting game in... 000   "
			sleep 0.9
			printf "\r                     G0!  "
			sleep 0.9
			printf "\r                          "
		}
		endofdaystimer()
		{
			echo "Helloworld"
			
			
			
			
			#     (                      )
			#     |\    _,--------._    / |
			#     | `.,'            `. /  |
			#     `  '              ,-'   '
			#      \/_         _   (     /
			#     (,-.`.    ,',-.`. `__,'
			#      |/#\ ),-','#\`= ,'.` |
			#      `._/)  -'.\_,'   ) ))|
			#      /  (_.)\     .   -'//
			#     (  /\____/\    ) )`'\
			#      \ |V----V||  ' ,    \
			#       |`- -- -'   ,'   \  \      _____
			#___    |         .'    \ \  `._,-'     `-
			#   `.__,`---^---'       \ ` -'
			#      -.______  \ . /  ______,-
			#              `.     ,'            ap
			
			DEM01="     (                      )            "
			DEM02="     |\    _,--------._    / |           "
			DEM03="     | \`.,'            \`. /  |           "
			DEM04="     \`  '              ,-'   '           "
			DEM05="      \/_         _   (     /            "
			DEM06="     (,-.\`.    ,',-.\`. \`__,'             "
			DEM07="      |/#\\ ),-','#\\\`= ,'.\` |             "
			DEM08="      \`._/)  -'.\_,'   ) ))|             "
			DEM09="      /  (_.)\     .   -'//              "
			DEM10="     (  /\____/\    ) )\`'\               "
			DEM11="      \ |V----V||  ' ,    \              "
			DEM12="       |\`- -- -'   ,'   \  \      _____  "
			DEM13="___    |         .'    \ \  \`._,-'     \`-"
			DEM14="   \`.__,\`---^---'       \ \` -'           "
			DEM15="      -.______  \ . /  ______,-          "
			DEM16="              \`.     ,'            ap    "
			
			
			printf '%s\n' "$DEM01"
			printf '%s\n' "$DEM02"
			printf '%s\n' "$DEM03"
			printf '%s\n' "$DEM04"
			printf '%s\n' "$DEM05"
			printf '%s\n' "$DEM06"
			printf '%s\n' "$DEM07"
			printf '%s\n' "$DEM08"
			printf '%s\n' "$DEM09"
			printf '%s\n' "$DEM10"
			printf '%s\n' "$DEM11"
			printf '%s\n' "$DEM12"
			printf '%s\n' "$DEM13"
			printf '%s\n' "$DEM14"
			printf '%s\n' "$DEM15"
			printf '%s\n' "$DEM16"
			
			
			
			sleep 0.3
			
			
			
		}
		
		if [ $GAMENUM -lt 2 ]; then
			zerooption="False"
			normaltimer
		elif [ $GAMENUM -eq 2 ]; then
			zerooption="True"
			normaltimer
		elif [ $GAMENUM -eq 3 ]; then
			slowtimerone
		elif [ $GAMENUM -eq 4 ]; then
			countuptimer
		elif [ $GAMENUM -eq 5 ]; then
			negativetimer
		elif [ $GAMENUM -eq 6 ]; then
			fadeouttimertwo
		elif [ $GAMENUM -eq 7 ]; then
			slowtimertwo
		elif [ $GAMENUM -eq 8 ]; then
			distortedtimerone
		elif [ $GAMENUM -eq 9 ]; then
			fadeouttimer
		elif [ $GAMENUM -eq 10 ]; then
			slowtimerthree
		elif [ $GAMENUM -eq 11 ]; then
			capsfadetimer
		elif [ $GAMENUM -eq 12 ]; then
			distortedtimertwo
		elif [ $GAMENUM -eq 13 ]; then
			DISTTIMERTHREEDIR="Down"
			SHORTTIMERVER="No"
			distortedtimerthree
		elif [ $GAMENUM -eq 14 ]; then
			distortedtimerglitch
		elif [ $GAMENUM -eq 15 ]; then
			DISTTIMERTHREEDIR="Up"
			SHORTTIMERVER="No"
			distortedtimerthree
		elif [ $GAMENUM -ge 16 ]; then
			MAX_CHOICES=8
			FACTOR_INT=5
			MAX_END_OPS=$(((($MAX_CHOICES-1)*$FACTOR_INT)+1))
			# MAX_END_OPS= To calculate this value, and the values for the if block below:
			# MAX_CHOICES=(number of different alt countdowns to pick from in case block below)
			# FACTOR_INT=(however many times more likely you want an alt countdown to be picked over the standard one)
			# ((MAX_CHOICES-1) * FACTOR_INT) + 1
			# E.g. There's 5 countdown sequences including the default/normal one to pick from, and I want the non-standard ones to occur 5 times more often than the standard one:
			# ((5-1) * 5) + 1 = 21
			# ((6-1) * 5) + 1 = 26
			
			#if [ -v $ENDGAMERAND ]; then
			#	ENDGAMERAND=$(($RANDOM%$MAX_END_OPS))
			#fi
			#LAST_END_RAND=$ENDGAMERAND
			#while [ $LAST_END_RAND -eq $ENDGAMERAND ]; do
			#	ENDGAMERAND=$(($RANDOM%$MAX_END_OPS))
			#done
			
			if [ -v $CHOICE_INDEX ]; then
				CHOICE_INDEX=$(($RANDOM%$MAX_CHOICES))
			fi
			LAST_CHOICE=$CHOICE_INDEX
			i=0
			while [ $LAST_CHOICE -eq $CHOICE_INDEX ]; do
				((i+=1))
				ENDGAMERAND=$(($RANDOM%$MAX_END_OPS))
				# The if block:
				if [ $ENDGAMERAND -ge 0 ] && [ $ENDGAMERAND -le 4 ]; then
					CHOICE_INDEX=1
				elif [ $ENDGAMERAND -ge 5 ] && [ $ENDGAMERAND -le 9 ]; then
					CHOICE_INDEX=2
				elif [ $ENDGAMERAND -ge 10 ] && [ $ENDGAMERAND -le 14 ]; then
					CHOICE_INDEX=3
				elif [ $ENDGAMERAND -ge 15 ] && [ $ENDGAMERAND -le 19 ]; then
					CHOICE_INDEX=4
				elif [ $ENDGAMERAND -ge 20 ] && [ $ENDGAMERAND -le 24 ]; then
					CHOICE_INDEX=5
				elif [ $ENDGAMERAND -ge 25 ] && [ $ENDGAMERAND -le 29 ]; then
					CHOICE_INDEX=6
				elif [ $ENDGAMERAND -ge 30 ] && [ $ENDGAMERAND -le 34 ]; then
					CHOICE_INDEX=7
				else
					# The standard/normal countdown timer:
					CHOICE_INDEX=8
				fi
				#echo "$i: $LAST_CHOICE != new choice $CHOICE_INDEX    ($ENDGAMERAND)"
			done
			case $CHOICE_INDEX in
					"1")
							slowtimerfinal
							;;
					"2")
							capsfadetimer
							;;
					"3")
							fadeouttimer
							;;
					"4")
							fadeouttimertwo
							;;
					"5")
							SHORTTIMERVER="Yes"
							distortedtimerthree
							;;
					"6")
							binarytimer
							;;
					"7")
							distortedtimerglitch
							;;
					"8")
							# The standard/normal countdown timer:
							CHOICE_INDEX=5
							BINARYRANDOM=$(($RANDOM%2))
							if [ $BINARYRANDOM -eq 0 ]; then
								zerooption="False"
							else
								zerooption="True"
							fi
							normaltimer
							;;
			esac
			
		else
			BINARYRANDOM=$(($RANDOM%2))
			if [ $BINARYRANDOM -eq 0 ]; then
				zerooption="False"
			else
				zerooption="True"
			fi
			normaltimer
		fi
		
		
		
	}
	#/countdowntimer function
	
	endofdaystimertest()
	{
		
		#     (                      )
		#     |\    _,--------._    / |
		#     | `.,'            `. /  |
		#     `  '              ,-'   '
		#      \/_         _   (     /
		#     (,-.`.    ,',-.`. `__,'
		#      |/#\ ),-','#\`= ,'.` |
		#      `._/)  -'.\_,'   ) ))|
		#      /  (_.)\     .   -'//
		#     (  /\____/\    ) )`'\
		#      \ |V----V||  ' ,    \
		#       |`- -- -'   ,'   \  \      _____
		#___    |         .'    \ \  `._,-'     `-
		#   `.__,`---^---'       \ ` -'
		#      -.______  \ . /  ______,-
		#              `.     ,'            ap
		
		DEM01="     (                      )            "
		DEM_LENGTH=${#DEM01}
		DEM02="     |\    _,--------._    / |           "
		DEM03="     | \`.,'            \`. /  |           "
		DEM04="     \`  '              ,-'   '           "
		DEM05="      \/_         _   (     /            "
		DEM06="     (,-.\`.    ,',-.\`. \`__,'             "
		DEM07="      |/#\\ ),-','#\\\`= ,'.\` |             "
		DEM08="      \`._/)  -'.\_,'   ) ))|             "
		DEM09="      /  (_.)\     .   -'//              "
		DEM10="     (  /\____/\    ) )\`'\               "
		DEM11="      \ |V----V||  ' ,    \              "
		DEM12="       |\`- -- -'   ,'   \  \      _____  "
		DEM13="___    |         .'    \ \  \`._,-'     \`-"
		DEM14="   \`.__,\`---^---'       \ \` -'           "
		DEM15="      -.______  \ . /  ______,-          "
		DEM16="              \`.     ,'            ap    "
		
		printf '%s\n' "$DEM01"
		printf '%s\n' "$DEM02"
		printf '%s\n' "$DEM03"
		printf '%s\n' "$DEM04"
		printf '%s\n' "$DEM05"
		printf '%s\n' "$DEM06"
		printf '%s\n' "$DEM07"
		printf '%s\n' "$DEM08"
		printf '%s\n' "$DEM09"
		printf '%s\n' "$DEM10"
		printf '%s\n' "$DEM11"
		printf '%s\n' "$DEM12"
		printf '%s\n' "$DEM13"
		printf '%s\n' "$DEM14"
		printf '%s\n' "$DEM15"
		printf '%s\n' "$DEM16"
		
		sleep 0.3
		
		genrandomchar()
		{
			CHARS_COUNT=$1
			
			# Generate a random character, and print it
			
			lowercase_alphabet="abcdefghijklmnopqrsttuvwxyz"
			UPPERCASE_ALPHABET="ABCDEFGHIJKLMNOPQRSTTUVWXYZ"
			all_numbers="0123456789"
			#special_chars="booyah"
			special_chars="@^-_=+?.<>,':"
			
			available_chars="${lowercase_alphabet}${all_numbers}${UPPERCASE_ALPHABET}${special_chars}"
			
			#echo "$available_chars"
			
			i=0
			while [ $i -le $CHARS_COUNT ]; do
				((i+=1))
				#https://stackoverflow.com/questions/32484504/using-random-to-generate-a-random-string-in-bash
				# ${chars:offset:length} selects the character(s) at position offset, i.e. 0 - length($chars) in our case.
				#echo -n "${available_chars:RANDOM%${#available_chars}:1}"
				printf "${available_chars:RANDOM%${#available_chars}:1}"
				sleep 0.005
			done
		}
		
		
		
		
		
		TERMINAL_WIDTH=`tput cols`
		PADDING=$(($TERMINAL_WIDTH - $DEM_LENGTH))
		SIDE_PADDING=$(($PADDING / 2))
		REMAINDER=`echo "var=$PADDING;var%=2;var" | bc`
		#PADDING=$((($SIDE_PADDING * 2) + $REMAINDER))
		
		printf "\n"
		
		echo "one line:"
		genrandomchar $(($TERMINAL_WIDTH - 1))
		echo "End of line"
		
		printf "\n\n"
		
		TWO_LINES=$((($TERMINAL_WIDTH * 2) - 1))
		
		echo "two line:"
		genrandomchar $TWO_LINES
		echo "End of line"
		
		printf "\n\n"
		
		THREE_LINES=$((($TERMINAL_WIDTH * 3) - 1))
		
		echo "three line:"
		genrandomchar $THREE_LINES
		echo "End of line"
		
		
		
		
		
		
		
		printf "\n\n"
		printf "three line:"
		
		printf "\r"
		THREE_LINES=$((($TERMINAL_WIDTH * 3) - 1))
		genrandomchar $THREE_LINES
		echo "End of line"
		
		
		
		
		
		
		
		
		
		
	}
	#/endofdaystimertest function
	
	endofdaystimertest
	
	choiceoptionstext()
	{
		#ACHIEVEMENT_UNLOCKED="False"
		#ACHIEVEMENT_UNLOCKED="True"
		
		#echo "                                                             "
		#echo "             CONGRATULATIONS, YOU'RE A WINRAR!!!             "
		#echo "You picked the number:  00    --  What a H00T!               "
		#echo "You picked the number:  00    --  Must think you're special! "
		#echo "You picked the number:  00    --  I love a good #2.          "
		#echo "You picked the number:  00    --  If I had a nickel...($0.00)"
		#echo "You picked the number:  00    --  ..This magic 8-ball sucks! "
		#echo "You picked the number:  00    --  Number 9?                  "
		#echo "You picked the number:  00    --  Hey, Nineteen!             "
		#echo " - [A] Continue            (*) -  Achievement Unlocked!      "
		#echo " - [B] Try Again    - [Y] Achievements"
		#echo " - [A] Continue"
		#echo " - [B] Try Again    - [Y] Achievements"
		
		if [ "$ACHIEVEMENT_UNLOCKED" = "True" ]; then
			echo " - [A] Continue            (*) -  Achievement Unlocked!      "
		else
			echo " - [A] Continue"
		fi
		if [ "$PROPLAYER" = "True" ]; then
			echo " - [B] Try Again    - [Y] Achievements"
		else
			echo " - [B] Try Again"
		fi
	}
	#/choiceoptionstext function
	
	splashachievementsmenu()
	{
		
		METHOD=0
		
		#echo "                                                             "
		#echo "             CONGRATULATIONS, YOU'RE A WINRAR!!!             "
		#echo "You picked the number:  00    --  What a H00T!               "
		#echo "You picked the number:  00    --  Must think you're special! "
		#echo "You picked the number:  00    --  I love a good #2.          "
		#echo "You picked the number:  00    --  If I had a nickel...($0.00)"
		#echo "You picked the number:  00    --  ..This magic 8-ball sucks! "
		#echo "You picked the number:  00    --  Number 9?                  "
		#echo "You picked the number:  00    --  Hey, Nineteen!             "
		#echo " - [A] Continue            (*) -  Achievement Unlocked!      "
		
		if [ $METHOD -eq 1 ]; then
			#echo "   _____         .__    .__                                          __          "
			#echo "  /  _  \   ____ |  |__ |__| _______  __ ____   _____   ____   _____/  |_  ______"
			#echo " /  /_\  \_/ ___\|  |  \|  |/ __ \  \/ // __ \ /     \_/ __ \ /    \   __\/  ___/"
			#echo "/    |    \  \___|   Y  \  \  ___/\   /\  ___/|  Y Y  \  ___/|   |  \  |  \___ \ "
			#echo "\____|__  /\___  >___|  /__|\___  >\_/  \___  >__|_|  /\___  >___|  /__| /____  >"
			#echo "        \/     \/     \/        \/          \/      \/     \/     \/          \/ "
			
			#echo "   _____         .__    .__                                   "
			#echo "  /  _  \   ____ |  |__ |__| _______  __ ____   _____   ____  "
			#echo " /  /_\  \_/ ___\|  |  \|  |/ __ \  \/ // __ \ /     \_/ __ \ "
			#echo "/    |    \  \___|   Y  \  \  ___/\   /\  ___/|  Y Y  \  ___/ "
			#echo "\____|__  /\___  >___|  /__|\___  >\_/  \___  >__|_|  /\___  >"
			#echo "        \/     \/     \/        \/          \/      \/     \/ "
			#echo "                 __                                           "
			#echo "           _____/  |_  ______                                 "
			#echo "  ______  /    \   __\/  ___/                                 "
			#echo " /_____/ |   |  \  |  \___ \                                  "
			#echo "         |___|  /__| /____  >                                 "
			#echo "              \/          \/                                  "
			
			echo "   _____         .__    .__                                   "
			echo "  /  _  \   ____ |  |__ |__| _______  __ ____   _____   ____  "
			echo " /  /_\  \_/ ___\|  |  \|  |/ __ \  \/ // __ \ /     \_/ __ \ "
			echo "/    |    \  \___|   Y  \  \  ___/\   /\  ___/|  Y Y  \  ___/ "
			echo "\____|__  /\___  >___|  /__|\___  >\_/  \___  >__|_|  /\___  >"
			echo "        \/     \/__   \/        \/          \/      \/     \/ "
			echo "           _____/  |_  ______                                 "
			echo "  ______  /    \   __\/  ___/                                 "
			echo " /_____/ |   |  \  |  \___ \                                  "
			echo "         |___|  /__| /____  >                                 "
			echo "              \/          \/                                  "
		fi
		
		if [ $METHOD -eq 2 ]; then
			#echo "   __    ___  _   _  ____  ____  _  _  ____  __  __  ____  _  _  ____  ___ "
			#echo "  /__\  / __)( )_( )(_  _)( ___)( \/ )( ___)(  \/  )( ___)( \( )(_  _)/ __)"
			#echo " /(__)\( (__  ) _ (  _)(_  )__)  \  /  )__)  )    (  )__)  )  (   )(  \__ \"
			#echo "(__)(__)\___)(_) (_)(____)(____)  \/  (____)(_/\/\_)(____)(_)\_) (__) (___/"
			
			#echo "   __    ___  _   _  ____  ____  _  _  ____  __  __  ____  _  _  ____  ___ "
			#echo "  /__\  / __)( )_( )(_  _)( ___)( \/ )( ___)(  \/  )( ___)( \( )(_  _)/ __)"
			#echo " /(__)\( (__  ) _ (  _)(_  )__)  \  /  )__)  )    (  )__)  )  (   )(  \__ \\"
			#echo "(__)(__)\___)(_) (_)(____)(____)  \/  (____)(_/\/\_)(____)(_)\_) (__) (___/"
			
			echo "   __    ___  _   _  ____  ____  _  _  ____  __  __  ____     "
			echo "  /__\  / __)( )_( )(_  _)( ___)( \/ )( ___)(  \/  )( ___)    "
			echo " /(__)\( (__  ) _ (  _)(_  )__)  \  /  )__)  )    (  )__)     "
			echo "(__)(__)\___)(_) (_)(____)(____)  \/  (____)(_/\/\_)(____)    "
			echo "     _  _  ____  ___                                          "
			echo " ___( \( )(_  _)/ __)                                         "
			echo "(___))  (   )(  \__ \                                         "
			echo "    (_)\_) (__) (___/                                         "
		fi
		
		if [ $METHOD -eq 3 ]; then
			#echo "               _     _                                     _       "
			#echo "     /\       | |   (_)                                   | |      "
			#echo "    /  \   ___| |__  _  _____   _____ _ __ ___   ___ _ __ | |_ ___ "
			#echo "   / /\ \ / __| '_ \| |/ _ \ \ / / _ \ '_ ` _ \ / _ \ '_ \| __/ __|"
			#echo "  / ____ \ (__| | | | |  __/\ V /  __/ | | | | |  __/ | | | |_\__ \"
			#echo " /_/    \_\___|_| |_|_|\___| \_/ \___|_| |_| |_|\___|_| |_|\__|___/"
			
			printf '%s\n' "               _     _                                     _       "
			printf '%s\n' "     /\       | |   (_)                                   | |      "
			printf '%s\n' "    /  \   ___| |__  _  _____   _____ _ __ ___   ___ _ __ | |_ ___ "
			printf '%s\n' "   / /\ \ / __| '_ \| |/ _ \ \ / / _ \ '_ \` _ \ / _ \ '_ \| __/ __|"
			printf '%s\n' "  / ____ \ (__| | | | |  __/\ V /  __/ | | | | |  __/ | | | |_\__ \\"
			printf '%s\n' " /_/    \_\___|_| |_|_|\___| \_/ \___|_| |_| |_|\___|_| |_|\__|___/"
			
			#printf '%s\n' "               _     _                                     "
			#printf '%s\n' "     /\       | |   (_)                                    "
			#printf '%s\n' "    /  \   ___| |__  _  _____   _____ _ __ ___   ___ _ __  "
			#printf '%s\n' "   / /\ \ / __| '_ \| |/ _ \ \ / / _ \ '_ ` _ \ / _ \ '_ \ "
			#printf '%s\n' "  / ____ \ (__| | | | |  __/\ V /  __/ | | | | |  __/ | | |"
			#printf '%s\n' " /_/    \_\___|_| |_|_|\___| \_/ \___|_| |_| |_|\___|_| |_|"
			#printf '%s\n' "        | |                                                "
			#printf '%s\n' "  ______| |_ ___                                           "
			#printf '%s\n' " |______| __/ __|                                          "
			#printf '%s\n' "        | |_\__ \                                          "
			#printf '%s\n' "         \__|___/                                          "
			
			printf '%s\n' "               _     _                                      "
			printf '%s\n' "     /\       | |   (_)                                     "
			printf '%s\n' "    /  \   ___| |__  _  _____   _____ _ __ ___   ___ _ __   "
			printf '%s\n' "   / /\ \ / __| '_ \| |/ _ \ \ / / _ \ '_ \` _ \ / _ \ '_ \ "
			printf '%s\n' "  / ____ \ (__| | | | |  __/\ V /  __/ | | | | |  __/ | | | "
			printf '%s\n' " /_/    \_\___|_| |_|_|\___| \_/ \___|_| |_| |_|\___|_| |_| "
			printf '%s\n' "        | |                                                 "
			printf '%s\n' "  ______| |_ ___                                            "
			printf '%s\n' " |______| __/ __|                                           "
			printf '%s\n' "        | |_\__ \                                           "
			printf '%s\n' "         \__|___/                                           "
		fi
		
		#echo "You picked the number:  00    --  ..This magic 8-ball sucks! "
		#echo "You picked the number:  00    --  Number 9?                  "
		#echo "You picked the number:  00    --  Hey, Nineteen!             "
		#echo " - [A] Continue            (*) -  Achievement Unlocked!      "
		#echo " - [B] Try Again    - [Y] Achievements"
		#echo " - [A] Continue"
		#echo " - [B] Try Again    - [Y] Achievements"
		
		#echo "   _____         .__    .__                                   "
		#echo "  /  _  \   ____ |  |__ |__| _______  __ ____   _____   ____  "
		#echo " /  /_\  \_/ ___\|  |  \|  |/ __ \  \/ // __ \ /     \_/ __ \ "
		#echo "/    |    \  \___|   Y  \  \  ___/\   /\  ___/|  Y Y  \  ___/ "
		#echo "\____|__  /\___  >___|  /__|\___  >\_/  \___  >__|_|  /\___  >"
		#echo "        \/     \/__   \/        \/          \/      \/     \/ "
		#echo "           _____/  |_  ______                                 "
		#echo "  ______  /    \   __\/  ___/                                 "
		#echo " /_____/ |   |  \  |  \___ \                                  "
		#echo "         |___|  /__| /____  >                                 "
		#echo "              \/          \/                                  "
		
		#echo "   _____         .__    .__                                   "
		#echo "  /  _  \   ____ |  |__ |__| _______  __ ____   _____   ____  "
		#echo " /  /_\  \_/ ___\|  |  \|  |/ __ \  \/ // __ \ /     \_/ __ \ "
		#echo "/    |    \  \___|   Y  \  \  ___/\   /\  ___/|  Y Y  \  ___/ "
		#echo "\____|__  /\___  >___|  /__|\___  >\_/  \___  >__|_|  /\___  >"
		#echo "        \/     \/__   \/        \/          \/      \/     \/ "
		#echo "           _____/  |_  ______                                 "
		#echo "  ______  /    \   __\/  ___/      Games Played:      000     "
		#echo " /_____/ |   |  \  |  \___ \       Time Played:  00:00:00     "
		#echo "         |___|  /__| /____  >      Achievements Unlocked:     "
		#echo "              \/          \/               00/10              "
		#echo "   (*) AGAIN?? - Pick same number in a row (Max chain: 00x)   "
		#echo "   (*) AGAIN?!?!? (Max: 00x)   "
		#echo "   (*) AGAIN?!?!? (Max: 00x)      (*) AGAIN?!?!? (Max: 00x)   "
		#echo "   (*) 00 -- What a H00T!      "
		#echo " (*) Must think you're special!"
		#echo "   (*) 01 -- Must think you're special!"
		#echo "   (*) Must think you're special!"
		#echo "   (*) I love a good #2."
		#echo "   (*)  2 -- I love a good #2. "
		#echo "   (*) If I had a nickel...($0.00)"
		#echo " (*) If I had a nickel..($0.00)"
		#echo "   (*)  9 -- Number 9?         "
		#echo "   (*) 19 -- Hey, Nineteen!    "
		#echo "   (*) 42 -- But what was the question??"
		#echo " (*) But what was the question?"
		#echo "   (*) 55 -- Fleventy 5        "
		#echo "   (*) 59 -- Mad MAX!!!        "
		
		#printf "You picked the number:  %.2d    --  Wait, AGAIN?!?!?  (%sx)     \n" $NUMPICK $REPEATCOUNT
		#printf "You picked the number:  %.2d    --  What a H00T!               \n" $NUMPICK
		#printf "You picked the number:  %.2d    --  Must think you're special! \n" $NUMPICK
		#printf "You picked the number:  %2s    --  I love a good #2.          \n" $NUMPICK
		#printf "You picked the number:  %.2d    --  If I had a nickel...(\$%1.2f)\n" $NUMPICK $MONEY
		#printf "You picked the number:  %2s    --  Number 9?                  \n" $NUMPICK
		#printf "You picked the number:  %2s    --  Hey, Nineteen!             \n" $NUMPICK
		#printf "You picked the number:  %2s    --  But what was the question??\n" $NUMPICK
		#printf "You picked the number:  %2s    --  Fleventy 5                 \n" $NUMPICK
		#printf "You picked the number:  %2s    --  Mad MAX!!!                 \n" $NUMPICK
		
		
		ACH_MENU="No escape"
		while [ "$ACH_MENU" != "b" ]; do
			
			duration=$SECONDS
			#echo "$(($duration / 60)) minutes and $(($duration % 60)) seconds elapsed."
			#echo "$(($duration / 3600)) hours, $((($duration / 60) % 60)) minutes and $(($duration % 60)) seconds elapsed."
			HRS=$(($duration / 3600))
			MINS=$((($duration / 60) % 60))
			SECS=$(($duration % 60))
			
			DIFFICULTY_TRUE_STR="(*)"
			DIFFICULTY_FALSE_STR="( )"
			
			if [ $DIFFICULTY -ge 1 ]; then DFFCLTY_1_LBL=$DIFFICULTY_TRUE_STR ; else DFFCLTY_1_LBL=$DIFFICULTY_FALSE_STR ; fi
			if [ $DIFFICULTY -ge 2 ]; then DFFCLTY_2_LBL=$DIFFICULTY_TRUE_STR ; else DFFCLTY_2_LBL=$DIFFICULTY_FALSE_STR ; fi
			if [ $DIFFICULTY -ge 3 ]; then DFFCLTY_3_LBL=$DIFFICULTY_TRUE_STR ; else DFFCLTY_3_LBL=$DIFFICULTY_FALSE_STR ; fi
			if [ $DIFFICULTY -ge 4 ]; then DFFCLTY_4_LBL=$DIFFICULTY_TRUE_STR ; else DFFCLTY_4_LBL=$DIFFICULTY_FALSE_STR ; fi
			if [ $DIFFICULTY -ge 5 ]; then DFFCLTY_5_LBL=$DIFFICULTY_TRUE_STR ; else DFFCLTY_5_LBL=$DIFFICULTY_FALSE_STR ; fi
			
			#printf "   _____         .__    .__                                   \n"
			#printf "  /  _  \   ____ |  |__ |__| _______  __ ____   _____   ____  \n"
			#printf " /  /_\  \_/ ___\|  |  \|  |/ __ \  \/ // __ \ /     \_/ __ \ \n"
			#printf "/    |    \  \___|   Y  \  \  ___/\   /\  ___/|  Y Y  \  ___/ \n"
			#printf "\____|__  /\___  >___|  /__|\___  >\_/  \___  >__|_|  /\___  >\n"
			#printf "        \/     \/__   \/        \/          \/      \/     \/ \n"
			#printf "           _____/  |_  ______                                 \n"
			#printf "  ______  /    \   __\/  ___/      Games Played:      %.3d     \n" $GAMESPLAYED
			#printf " /_____/ |   |  \  |  \___ \       Time Played:  %.2d:%.2d:%.2d     \n" $HRS $MINS $SECS
			#printf "         |___|  /__| /____  >      Achievements Unlocked:     \n"
			##printf "              \/          \/               00/10              \n"
			#printf "              \/          \/               %2s/%.2d              \n" $ACHIEVEMENTS_UNLOCKED $MAX_ACHIEVEMENTS
			##printf " /_____/ |   |  \  |  \___ \       Time Played:  00:00:00     \n"
			
			
			printf "   _____         .__    .__                                   \n"
			printf "  /  _  \   ____ |  |__ |__| _______  __ ____   _____   ____  \n"
			printf " /  /_\  \_/ ___\|  |  \|  |/ __ \  \/ // __ \ /     \_/ __ \ \n"
			printf "/    |    \  \___|   Y  \  \  ___/\   /\  ___/|  Y Y  \  ___/ \n"
			printf "\____|__  /\___  >___|  /__|\___  >\_/  \___  >__|_|  /\___  >\n"
			printf "        \/     \/__   \/        \/          \/      \/     \/ \n"
			printf "           _____/  |_  ______                                 \n"
			printf "  ______  /    \   __\/  ___/      Games Played:      %.3d     \n" $GAMESPLAYED
			printf " /_____/ |   |  \  |  \___ \       Time Played:  %.2d:%.2d:%.2d     \n" $HRS $MINS $SECS
			printf "         |___|  /__| /____  >      Difficulty: %s%s%s%s%s\n" "$DFFCLTY_1_LBL" "$DFFCLTY_2_LBL" "$DFFCLTY_3_LBL" "$DFFCLTY_4_LBL" "$DFFCLTY_5_LBL"
			#printf "         |___|  /__| /____  >      Difficulty: ( )( )( )( )( )\n"
			printf "              \/          \/                                  \n"
			#printf "              \/          \/               %2s/%.2d              \n" $ACHIEVEMENTS_UNLOCKED $MAX_ACHIEVEMENTS
			printf "                Achievements Unlocked: %2s/%.2d               \n" $ACHIEVEMENTS_UNLOCKED $MAX_ACHIEVEMENTS
			#printf " /_____/ |   |  \  |  \___ \       Time Played:  00:00:00     \n"
			
			#ACHMT_IRONIC="True"
			#ACHMT_IRONIC="False"
			
			TRUESTRING="(*)"
			FALSESRTING="( )"
			
			#TRUESTRING="dXb"
			#FALSESRTING="d b"
			#
			#ACHMT_IRONIC_STR=$TRUESTRING
			#ACHMT_IRONIC_STR=$FALSESRTING
			#
			#echo "$ACHMT_IRONIC_STR"
			
			
			if [ $ACHMT_REPEAT = "True" ]; then ACHMT_REPEAT_STR=$TRUESTRING ; else ACHMT_REPEAT_STR=$FALSESRTING ; fi
			if [ $ACHMT_0 = "True" ]; then ACHMT_0_STR=$TRUESTRING ; else ACHMT_0_STR=$FALSESRTING ; fi
			if [ $ACHMT_1 = "True" ]; then ACHMT_1_STR=$TRUESTRING ; else ACHMT_1_STR=$FALSESRTING ; fi
			if [ $ACHMT_2 = "True" ]; then ACHMT_2_STR=$TRUESTRING ; else ACHMT_2_STR=$FALSESRTING ; fi
			if [ $ACHMT_5 = "True" ]; then ACHMT_5_STR=$TRUESTRING ; else ACHMT_5_STR=$FALSESRTING ; fi
			if [ $ACHMT_9 = "True" ]; then ACHMT_9_STR=$TRUESTRING ; else ACHMT_9_STR=$FALSESRTING ; fi
			if [ $ACHMT_19 = "True" ]; then ACHMT_19_STR=$TRUESTRING ; else ACHMT_19_STR=$FALSESRTING ; fi
			if [ $ACHMT_42 = "True" ]; then ACHMT_42_STR=$TRUESTRING ; else ACHMT_42_STR=$FALSESRTING ; fi
			if [ $ACHMT_55 = "True" ]; then ACHMT_55_STR=$TRUESTRING ; else ACHMT_55_STR=$FALSESRTING ; fi
			if [ $ACHMT_59 = "True" ]; then ACHMT_59_STR=$TRUESTRING ; else ACHMT_59_STR=$FALSESRTING ; fi
			if [ $ACHMT_IRONIC = "True" ]; then ACHMT_IRONIC_STR="$TRUESTRING"; else ACHMT_IRONIC_STR="$FALSESRTING"; fi
			
			MONEY=`echo "$NICKELS * 0.05" | bc`
			
			#echo "   (*) AGAIN?? - Pick same number in a row (Max chain: 00x)   "
			#echo "   (*) 00 - What a H00T!          (*)  2 - I love a good #2.  "
			#echo "   (*) 01 - Must think you're special!                        "
			#echo "          (*) 05 - If I had a nickel... (00 nickels, $0.00)   "
			#echo "   (*)  9 - Number 9?             (*) 19 - Hey, Nineteen!     "
			#echo "             (*) 42 - But what was the question??             "
			#echo "   (*) 55 - Fleventy 5            (*) 59 - Mad MAX!!!         "
			#echo "   (*) XX - Oh, the irony! (Get an ironic msg based on pick)  "
			
			
			printf "   %s AGAIN?? - Pick same number in a row (Max chain: %2sx)   \n" "$ACHMT_REPEAT_STR" $MAX_REPEATS
			printf "   %s 00 - What a H00T!          %s  2 - I love a good #2.  \n" "$ACHMT_0_STR" "$ACHMT_2_STR"
			printf "   %s 01 - Must think you're special!                        \n" "$ACHMT_1_STR"
			if [ $NICKELS -eq 1 ]; then
				printf "          %s 05 - If I had a nickel... (%2s nickel, \$%1.2f)    \n" "$ACHMT_5_STR" $NICKELS $MONEY
			else
				printf "          %s 05 - If I had a nickel... (%2s nickels, \$%1.2f)   \n" "$ACHMT_5_STR" $NICKELS $MONEY
			fi
			printf "   %s  9 - Number 9?             %s 19 - Hey, Nineteen!     \n" "$ACHMT_9_STR" "$ACHMT_19_STR"
			printf "             %s 42 - But what was the question??             \n" "$ACHMT_42_STR"
			printf "   %s 55 - Fleventy 5            %s 59 - Mad MAX!!!          \n" "$ACHMT_55_STR" "$ACHMT_59_STR"
			printf "   %s XX - Oh, the irony! (Get an ironic msg based on pick)  \n" "$ACHMT_IRONIC_STR"
			
			printf "\n"
			#echo " - [A] Continue            (*) -  Achievement Unlocked!      "
			#echo " - [B] Try Again    - [Y] Achievements"
			#echo " - [A] Continue"
			echo " - [B] Back         - [?] ProPlayer Info"
			
			read -p "Select [b/?]: " ACH_MENU
			if [ "$ACH_MENU" = "?" ]; then
				splashproplayer
			fi
		done
		
	}
	#/splashachievementsmenu function
	
	setdifficulty()
	{
		if [ $GAMESPLAYED -le 2 ]; then
			DIFFICULTY=0
		elif [ $GAMESPLAYED -gt 2 ] && [ $GAMESPLAYED -le 5 ]; then
			DIFFICULTY=1
		elif [ $GAMESPLAYED -gt 5 ] && [ $GAMESPLAYED -le 8 ]; then
			DIFFICULTY=2
		elif [ $GAMESPLAYED -gt 8 ] && [ $GAMESPLAYED -le 11 ]; then
			DIFFICULTY=3
		elif [ $GAMESPLAYED -gt 11 ] && [ $GAMESPLAYED -le 14 ]; then
			DIFFICULTY=4
		elif [ $GAMESPLAYED -gt 14 ]; then
			DIFFICULTY=5
		fi
	}
	#/setdifficulty function
	
	
	
	
	# Testing commentarypicker:
	#RSEED=0
	#RSEED_FREQ=60
	#RANDOMMIN=98
	#GAMESPLAYED=0
	#NICKELS=0
	#NOREPAINTCOMMENT="No-repaint"
	#REPEATCOUNT=0
	#LASTPICK=99
	#for i in {0..59}
	#do
	#	commentarypicker $i $NOREPAINTCOMMENT
	#done
	#
	#for i in {0..10}
	#do
	#	LASTPICK=$i
	#	
	#	if [ $i -eq $LASTPICK ]; then
	#		if [ $REPEATCOUNT -gt 1 ]; then
	#			((REPEATCOUNT+=1))
	#		else
	#			REPEATCOUNT=2
	#		fi
	#	else
	#		REPEATCOUNT=0
	#	fi
	#	commentarypicker $i $NOREPAINTCOMMENT
	#done
	#
	#for i in {0..10}
	#do
	#	commentarypicker 5 $NOREPAINTCOMMENT
	#done
	#
	#splashachievementsmenu
	
	
	# Main loop init vars:
	SECONDS=0 # This is a bash builtin variable that tracks the number of seconds that have passed since the shell was started.
	KEEPPLAYING='b'
	LASTPICK=99
	RANDOMMIN=98
	REPEATCOUNT=0
	MAX_REPEATS=0
	GAMESPLAYED=0
	LAST_COMMENT_INDEX=0
	DIFFICULTY=0
	RSEED=0
	RSEED_FREQ=35 # After calling the RANDOM var to get a new random value, the RSEED var in this script will be incremented. Once RSEED passes this frequency limit value, a new seed value will be provided to RANDOM to enhance it's randomness by calling the 'seedrandom' function. (And RSEED will be reset to 0). Changing this value changes how often the RANDOM var gets refreshed with new seed values.
	NICKELS=0
	COMMENTSELECT="New game"
	LAST_SELECTED="No selection"
	PROPLAYER="False"
	PP_MANUAL="False"
	NOREPAINTCOMMENT="No-repaint"
	ACHIEVEMENT_UNLOCKED="False"
	MAX_ACHIEVEMENTS=11
	ACHIEVEMENTS_UNLOCKED=0
	ACHMT_REPEAT="False"
	ACHMT_0="False"
	ACHMT_1="False"
	ACHMT_2="False"
	ACHMT_5="False"
	ACHMT_9="False"
	ACHMT_19="False"
	ACHMT_42="False"
	ACHMT_55="False"
	ACHMT_59="False"
	ACHMT_IRONIC="False"
	
	
	#countdowntimer 14 $DIFFICULTY
	
	# Main game loop:
	while [ "$KEEPPLAYING" = "b" ]; do
		# Start game:
		setdifficulty
		splashstart
		echo ""
		read -s -p "Press ENTER key to START! "
		((GAMESPLAYED+=1))
		setdifficulty
		
		# Countdown timer:
		countdowntimer $GAMESPLAYED $DIFFICULTY
		#x=6
		#while [ $x -gt 0 ]; do
		#	((x-=1))
		#	printf "\rStarting game in...  $x   "
		#	#echo -n -e "\rStarting game in...  $x   "
		#	sleep 0.9
		#done
		#printf "\r                   GO!   "
		#sleep 0.5
		#printf "\r                         "
		
		# Loop init:
		LASTPICK=$RANDOMMIN
		MSG="Pick a random value. HURRY!!"
		unset REPLY
		# Random number generator loop:
		while [ -v $REPLY ]; do
			if [ $RSEED -ge $RSEED_FREQ ]; then
				RSEED=0
				# Seed the RANDOM function/var every once in a while to enhance it's randomness.
				seedrandom
			else
				((RSEED+=1))
			fi
			RANDOMMIN=$(($RANDOM%60))
			printf "\r$MSG  %.2d " $RANDOMMIN
			#echo -n -e "\r$MSG  $RANDOMMIN "
			# Note: When no string is provided for as a var name for 'read' command to update, it will update the REPLY var automatically instead.
			#read -s -n1 -t1
			if [ $DIFFICULTY -le 1 ]; then
				read -s -n1 -t0.5
			elif [ $DIFFICULTY -eq 2 ]; then
				read -s -n1 -t0.4
			elif [ $DIFFICULTY -eq 3 ]; then
				read -s -n1 -t0.3
			elif [ $DIFFICULTY -eq 4 ]; then
				read -s -n1 -t0.2
			elif [ $DIFFICULTY -eq 5 ]; then
				BINARYRANDOM=$(($RANDOM%2))
				if [ $BINARYRANDOM -eq 0 ]; then
					read -s -n1 -t0.5
				else
					read -s -n1 -t0.2
				fi
			fi
		done
		# Loop over:
		if [ $RANDOMMIN -eq $LASTPICK ]; then
			if [ $REPEATCOUNT -gt 1 ]; then
				((REPEATCOUNT+=1))
			else
				REPEATCOUNT=2
			fi
			if [ $REPEATCOUNT -gt $MAX_REPEATS ]; then
				MAX_REPEATS=$REPEATCOUNT
			fi
		else
			REPEATCOUNT=0
		fi
		
		# Game over loop init:
		ACHIEVEMENT_UNLOCKED="False"
		splashwinner
		echo ""
		#commentarypicker $RANDOMMIN "No-repaint"
		commentarypicker $RANDOMMIN $NOREPAINTCOMMENT
		#printf "\nYou picked the number:  $RANDOMMIN\n"
		# Set ProPlayer mode:
		if [ $ACHIEVEMENTS_UNLOCKED -ge 1 ] && [ $GAMESPLAYED -gt 1 ] && [ "$PP_MANUAL" = "False" ]; then
			PROPLAYER="True"
		fi
		if [ $ACHIEVEMENTS_UNLOCKED -ge 2 ] && [ "$PP_MANUAL" = "False" ]; then
			PROPLAYER="True"
		fi
		if [ $GAMESPLAYED -gt 4 ] && [ "$PP_MANUAL" = "False" ]; then
			PROPLAYER="True"
		fi
		choiceoptionstext
		# Game over loop:
		KEEPPLAYING="No escape"
		while [ "$KEEPPLAYING" != "a" ] && [ "$KEEPPLAYING" != "b" ]; do
			# If the user is a ProPlayer and presses 'y' for Achievements, show the Achievements menu:
			if [ "$PROPLAYER" = "True" ] && [ "$KEEPPLAYING" = "y" ]; then
				splashachievementsmenu
				splashwinner
				echo ""
				commentarypicker $RANDOMMIN $COMMENTSELECT
				choiceoptionstext
			fi
			# If the user enters 'PP' make them into a ProPlayer status, and show the Achievements menu:
			if [ "$KEEPPLAYING" = "PP" ]; then
				if [ "$PROPLAYER" != "True" ]; then
					PROPLAYER="True"
					splashwinner
					echo ""
					commentarypicker $RANDOMMIN $COMMENTSELECT
					choiceoptionstext
				else
					PROPLAYER="False"
					PP_MANUAL="True"
					splashwinner
					echo ""
					commentarypicker $RANDOMMIN $COMMENTSELECT
					choiceoptionstext
				fi
			fi
			
			# Users with 'ProPlayer' status will also have the additional option of 'y' for Achievements menu:
			if [ "$PROPLAYER" = "True" ]; then
				read -p "Accept the pick? [a/b/y]: " KEEPPLAYING
			else
				#echo "[a/b]:"
				read -p "Accept the pick? [a/b]: " KEEPPLAYING
			fi
		done
		
		#echo -e "\nDone with loop. \$RANDOMMIN : $RANDOMMIN - 1\n"
		#read -p "Press Enter to continue"
		#unset REPLY
		
		
	done
	
	
	
	
	
	
	
}

pickrandommin

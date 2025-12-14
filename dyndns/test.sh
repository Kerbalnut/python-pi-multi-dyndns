#!/usr/bin/bash 


firstString="I love Lasagna and Bacon"
secondString="Sausage"

echo "$firstString"
echo "$secondString"

echo "${firstString/Lasagna/"$secondString"}"



#WET_HOT_CRON_LINE=$@
WET_HOT_CRON_LINE='0 0 1 * * /home/pi/dyndns/logcleanup.sh'

echo "$WET_HOT_CRON_LINE"

ESC_PRINT_STRING="${WET_HOT_CRON_LINE/'*'/'\*'}"

echo "$ESC_PRINT_STRING"

ESC_PRINT_STRING="${WET_HOT_CRON_LINE//'*'/'\*'}"

echo "$ESC_PRINT_STRING"




scriptname=`basename "$0"`
echo "$scriptname"

scriptname=`basename "$0" .sh`
echo "$scriptname"

echo "$scriptname.log"

SCRIPTNAME=`basename "$0" .sh`
INSTALL_LOG="$SCRIPTNAME.log"

echo "1 MY INSTALL LOG: $INSTALL_LOG"

SCRIPTNAME=`basename "$BASH_SOURCE" .sh`
INSTALL_LOG="$SCRIPTNAME.log"

echo "2 MY INSTALL LOG: $INSTALL_LOG"






echo "# path to me --------------->  ${0}     "
echo "# parent path -------------->  ${0%/*}  "
echo "# my name ------------------>  ${0##*/} "
echo

echo "$(basename $BASH_SOURCE)"

echo "Logged in as '$USER'"

INSTALL_PYTHON3="True"

if [ $INSTALL_PYTHON3 = "True" ]; then
	echo 'Set explicitly as true'
fi

if [[ -z "$INSTALL_PYTHON3" ]]; then
	echo 'Is not set!'
fi

echo "End of loop 1."

if [ $INSTALL_PYTHON3 = "True" ]; then
	echo 'Set explicitly as true/not set!'
fi

echo "End of loop 2."




USER_INPUT=99
until [[ $USER_INPUT -ge 0 ]] && [[ $USER_INPUT -le 6 ]] && [[ ! -z "$USER_INPUT" ]]; do
	read -p "Choose option [0-6]: " USER_INPUT
done

echo "End of loop 1."




USER_INPUT=99
until [[ $USER_INPUT -ge 0 ]] && [[ $USER_INPUT -le 6 ]] && [[ "$USER_INPUT" =~ ^[0-9]+$ ]]; do
	read -p "Choose option [0-6]: " USER_INPUT
done


echo "End of loop 2."


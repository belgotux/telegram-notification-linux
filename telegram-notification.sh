#!/bin/bash
# Auteur : Belgotux
# Site : www.monlinux.net
# Licence : GNU V3
# Version : 1.0
# First Date : 13/12/2022

if [ -e $(dirname $0)/$(basename $0 .sh).conf ] ; then
	. $(dirname $0)/$(basename $0 .sh).conf
elif [ -e /usr/local/etc/$(basename $0 .sh).conf ] ; then
  . /usr/local/etc/$(basename $0 .sh).conf
else
	echo "Can't find configuration file $(basename $0 .sh).conf in $(dirname $0) or in /usr/local/etc" 1>&2
	exit 1
fi

#send push notification with Telegram
# $1 message
# $2 title
# $3 emoji
function sendTelegram {
	#replace default mesg
	if  [ "$2" != "" ] && [ "$3" != "" ]  ; then
		local textTelegram=$(echo -e "$3 $HOSTNAME $3 $2\n$1")
	elif [ "$2" != "" ] ; then
		local textTelegram=$(echo -e "$HOSTNAME - $2 \n$1")
	else
		local textTelegram="$3$HOSTNAME : $1"
	fi
	#var verification
	if [ "$providerApi" == "" ] || [ "$accessToken" == "" ] ; then
		echo "Can't send notification without complete variables for Telegram" 1>&2
		addLog "Can't send notification without complete variables for Telegram"
		return 1
	fi
	
	tempfile=$(mktemp --suffix '.telegram-notification')
	curl -s -o "$tempfile" --data "chat_id=${chatID}" --data "text=${textTelegram}" "${providerApi}/bot${accessToken}/sendMessage"
	returnCurl=$?
	if [ $returnCurl -ne 0 ] ; then cat $tempfile ; fi
	rm $tempfile
	return $?
}

function help() {
	echo "Usage :"
	echo "  $0 [-t \"title\"] -m \"message with space\" [-w|-c]"
	echo "  echo \"message with space\" | $0 [-t \"title\"] [-w|-c]"
	echo "Message is mandatory, input or -m"
	echo "Options :"
	echo "  -t for a title"
	echo "  -w add a emoji warning icon"
	echo "  -c add a emoji critical icon"
}

# add to log
function addLog() {
	if [ "$logfile" == "" ] ; then
		echo "Can't write to log !" 1>&2
		return 1
	else
		echo "$(date +'%a %d %H:%M:%S') $1" >> $logfile
		return $?
	fi
}

#simple letter for option, add : for argument
while getopts "hm:t:wc" Option ; do
  case "${Option}" in
	t)  title=$OPTARG;;
	m)  message=$OPTARG;;
	w)  warning=1;;
	c)  critique=1;;
	h)	help
			exit 0;;
	?)  help
			exit 1;;
  esac
done

shift $((OPTIND-1))
#if no message arg, need stdin
if [ -z "${message}" ]; then
    message="$(< /dev/stdin)"
fi

#warning emoji
if [ -z "${critique}" ] && [ ! -z "${warning}" ] ; then
	# echo "warn"
	emoji=$(echo -e "\xE2\x9A\xA0")
# critic emoji
elif [ ! -z "${critique}" ] ; then
  # echo "crit"
  emoji=$(echo -e "\xF0\x9F\x94\xA5")
fi

# echo "$title"
# echo "$message"

sendTelegram "$message" "$title" "$emoji"

exit $?
#!/bin/bash

## Script to list most recent files in specific directory 
## (var SOURCEDIR) and pick one to download with rsync to 
## specific directory (var TARGETDIR)
##
## Requires bash ver >= 4 for read -p command
## 

RED='\033[0;31m'
CYAN='\033[0;36m'
YELLOW='\033[0;33m'
NC='\033[0m' # No Color

SOURCEDIR=farligm@a.tetov.se:/home/farligm/v/rtorrent.data
TARGETDIR=/Volumes/JUDITH/Deaddrop/

downloadSelection=()

finished=false

while ! $finished ; do
	
	read -e -p "How many recent files would you like to see? [20] " tail
	
	if [[ "$tail" == "" ]] ; then
		tail=20
		finished=true
	elif [[ "$tail" =~ ^[0-9]+$ ]] ; then 
		finished=true
	else
		echo "Sorry integers only"
	fi
	
done

echo -e "\n${RED}$tail${NC} newest files in of ${CYAN}$SOURCEDIR${NC}\n"

oldIFS=$IFS							# Back up IFS
IFS='
'									# Change how new line is read

# Get file list from server. Yes, I have read http://mywiki.wooledge.org/ParsingLs
fileList=($(ssh -qt farligm@a.tetov.se "/bin/ls -1tr ~/v/rtorrent.data | tail -n$tail"))

IFS=$oldIFS							# Reset IFS

j=1									# j is the users choice, starts at 1
for i in "${fileList[@]}" ; do		# in contrast to the array

	if (( $j < 10 ))					# Tidier row (extra whitespace when <10)
	then
		echo -e " ${YELLOW}$j.${NC} $i"
	else
		echo -e "${YELLOW}$j.${NC} $i"
	fi
	
	((j++))
	
done

echo

finished=false

u=0

while ! $finished ; do

	read -e -p "Enter index of files to download, q when finished: " fileChoice
	
	if [[ "$fileChoice" = "q" ]] ; then
		finished=true
	elif ! [[ "$fileChoice" =~ ^[0-9]+$ ]] ; then
		echo "Sorry integers only"
	elif (( $fileChoice > $tail || $fileChoice < 1 ))
	then
		echo "Number needs to be between 1 and $tail"
	else
		((fileChoice--)) 					# Account for zero index in array
		downloadSelection[$u]=$fileChoice
		((u++))
	fi
	
done

# https://stackoverflow.com/questions/15520339/how-to-remove-carriage-return-and-newline-from-a-variable-in-shell-script

for z in "${downloadSelection[@]}" ; do	
		
	toDownload="$(echo ${fileList[$z]} | tr -d '\r')"
	echo $toDownload
	
	/usr/local/bin/rsync -rvze 'ssh -q' "$SOURCEDIR/'$toDownload'" --progress $TARGETDIR
	
done

exit 0

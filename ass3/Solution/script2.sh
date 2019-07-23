#!/bin/sh

prev=""			#variable that stores previous data
while true		#infinite loop
do
	wget -qO data http://static.cricinfo.com/rss/livescores.xml
	sleep 10
	file=`grep "$1" "data"`
	if [ $? != 0 ]	#checks if there is any error
	then
		continue
	fi
	a=` grep "$1" "data" | tail -n1 | grep -o ">.*<" | grep -o "[^> <]*" ` 
	rm livescores.xml* 2>/dev/null	
	if [ "$a" != "$prev" ] #check if score is changed
	then
		notify-send "$a"  #send notification
		prev="$a"	#update prev
	fi
done
#!/bin/sh
#Taking input line by line
IFS=$'\n' a=$(cat $1)
for f in $a
do
	#separate filename, permission and destination using ' '
    line=()
    IFS=' '
    for i in $f
    do
        line+=($i)
    done
    pos=`expr index "$line[0]" \.` 
    type=${line[0]:pos}
    IFS="," read -ra per <<< "${line[1]}" #separated permissions by',' 
    cnt=0
    #updating cnt using binary values of respective permissions
    for i in ${per[@]} 
    do
    	first="$(echo $i | head -c 1)"
    	if [ $first = "R" ]
    	then
    		((cnt+=4))
    	elif [ $first = "W" ]
    	then
    		((cnt+=2))
    	elif [ $first = "E" ]
    	then 
    		((cnt+=1))
    	fi
    done


    last="$(echo ${line[2]} | tail -c 2)"
 	#If '/' is not present in end of path name then include it.
    if [ $last != "/" ]
    then
    	line[2]="${line[2]}/"
    fi
    #Checked category of files and place them in their destination directory.
    #If directory doesn't exist then create it.
    if file ${line[0]} | grep ":.*archive.*\|:.*shared.*object.*\|:.*library.*" > /dev/null
    then
        line[2]="${line[2]}lib"
        file="${line[2]}/${line[0]}"
        if [ ! -d "${line[2]}" ]
        then
            mkdir ${line[2]}
        fi
        cp "${line[0]}"  "$file"
    elif [ $type = "so" -o $type = "la" ]
    then
    	line[2]="${line[2]}lib"
    	file="${line[2]}/${line[0]}"
    	if [ ! -d "${line[2]}" ]
    	then
    		mkdir ${line[2]}
    	fi
    	cp "${line[0]}"  "$file"
    elif file ${line[0]} | grep ":.*PDF.*" > /dev/null
   	then
    	line[2]="${line[2]}doc"
    	file="${line[2]}/${line[0]}"
    	if [ ! -d "${line[2]}" ]
    	then
    		mkdir ${line[2]}
    	fi
    	cp "${line[0]}"  "$file"
    elif file ${line[0]} | grep ":.*executable.*" > /dev/null 
    then
    	line[2]="${line[2]}bin"
    	file="${line[2]}/${line[0]}"
    	if [ ! -d "${line[2]}" ]
    	then
    		mkdir ${line[2]}
    	fi
    	cp "${line[0]}"  "$file"
    else
    	line[2]="${line[2]}include"
    	file="${line[2]}/${line[0]}"
    	if [ ! -d "${line[2]}" ]
    	then
    		mkdir ${line[2]}
    	fi
    	cp "${line[0]}"  "$file"
    fi
    #Changing permissions by chmod
    chmod $cnt"00" "$file"
done


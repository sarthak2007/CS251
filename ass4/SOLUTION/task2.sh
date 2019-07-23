#!/bin/bash


if [[ $# == 0 ]]
then
	echo "Please input the file address as parameter"
	exit
fi

touch debugger.gdb

#disabling user interaction
echo "set pagination off" > debugger.gdb

#A variable storing command input
a="
command
i r
c
end
"

#Adding breaks and there respective command executions linked
echo "b add $a" >> debugger.gdb
echo "b sub $a" >> debugger.gdb
echo "b mpy $a" >> debugger.gdb
echo "b div $a" >> debugger.gdb

#Run the debugger with input
echo "run $1" >> debugger.gdb

#To quit
echo "q" >> debugger.gdb

#run the debugger and print registers values at entry of functions
if [[ -e executable ]]
then
	
	gdb executable -x debugger.gdb

	echo "

	Process completed successfully

	"
else
	echo "gdb run failed, executable doesn't exist"
fi



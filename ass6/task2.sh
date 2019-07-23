#!/bin/bash


#------------------------------------------------------  INPUT ERROR HANDLING --------------------------------------------------------#

# Checking if the user entered 2 parameters or not
if [ $# != 2 ] 
then
	echo "Please enter path of .c file and test case input file"
	exit
fi

cfile=""
testcases=""

# Checking if the user entered a valid c-source file as one of the argument
# If yes then store it in cfile variable
if file $1 | grep -Ei ".*:.*c.*program.*text|.*:.*C.*SOURCE.*" > /dev/null
then
	cfile=$1
	testcases=$2
elif file $2 | grep -Ei ".*:.*c.*program.*text|.*:.*C.*SOURCE.*" > /dev/null
then
	cfile=$2
	testcases=$1
else 
	echo "You haven't entered C source file"
	exit
fi

# Check if the test cases file exist
if [ ! -e $testcases ]
then
	echo "Your testCases file '$testcases' doesn't exist"
	exit
fi

#------------------------------------------------------  INPUT ERROR HANDLING END --------------------------------------------------------#


# In case the c-file is in some other directory
# To ensure that everything is in one directory
cp $cfile ./task2.c

# Creating Hidden-log files
touch .compilation.log .output.log funcTime.csv
touch timePerTestCase.csv timeNet.csv

echo "testcase,Time,Func" > timePerTestCase.csv
echo "testcase,Time,Func" > timeNet.csv

# Compiler c file ensuring proper optimizations as required by gprof
gcc -pg -o task2 task2.c 2> .compilation.log

# To handle Errors thrown out by gcc
if [ $? != 0 ]
then 
	echo "Compilation error!"
	exit
fi

#Temporary variable to solve problem of first gmon.sum made
flag=0
i=0
# Execute file again and again for all the testcases to get a net output over all test cases in .c.gcov file.
while IFS= read -r testcase || [[ -n "$testcase" ]]; do
	./task2 $testcase >> .output.log 
	((i++))
	gprof -b -p task2 gmon.out | tr -s " " | awk -v t="$i" '{if(NR>5) print t","$3","$7}' >> timePerTestCase.csv

	# To create the first gmon.sum file
	if [[ $flag == 0 ]] 
	then
		gprof -b -s task2 gmon.out
		cp gmon.out gmon.sum
		flag=1
	else
		# Profiling and summarising output
		gprof -b -s task2 gmon.out gmon.sum
	fi

done < "$testcases"

gprof -b -p task2 gmon.sum | tr -s " " | awk -v t="$i" '{if(NR>5) print t","$3","$7}' >> timeNet.csv




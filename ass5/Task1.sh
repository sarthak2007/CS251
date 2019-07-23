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
if file $1 | grep -Ei ".*:.*c.*program.*text|.*:.*C.*source.*text" > /dev/null
then
	cfile=$1
	testcases=$2
elif file $2 | grep -Ei ".*:.*c.*program.*text|.*:.*C.*source.*text" > /dev/null
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
# To ensure that .gcda .gcno are in the same file as c-source file 
cp $cfile ./myfile.c

# Creating Hidden-log files
touch .compilation.log .gcov.log .output.log

# Compiler c file ensuring proper optimizations as required by gcov
gcc -fprofile-arcs -ftest-coverage myfile.c -o task1 2> .compilation.log

# To handle Errors thrown out by gcc
if [ $? != 0 ]
then 
	echo "Compilation error!"
	exit
fi

# Execute file again and again for all the testcases to get a net output over all test cases in .c.gcov file.
while IFS= read -r testcase || [[ -n "$testcase" ]]; do
	./task1 $testcase >> .output.log 
	gcov -b myfile.c >> .gcov.log
done < "$testcases"

# Grep the line_number and execution frequency and put then in a csv file.
# Also grepping the not-executed lines and changed their count from ## to 0
grep -Eo "^[ ]*[0-9]+:[ ]*[0-9]+:|^[ ]*[#]+:[ ]*[0-9]+:" myfile.c.gcov | tr ":" " " | awk '{if($1 == "#####") $1=0; print $2","$1;}' > execution_frequency.csv

# Grep the BIAS of branch 0 (averaged over all test cases)
grep -E -B 1 "^[ ]*branch[ ]*0[ ]*taken[ ]*[0-9]*%" myfile.c.gcov | awk '{if(NR%3 == 1) print $2; if(NR%3 == 2) print $4;}' | awk 'NR%2{printf $0;next;}1'| tr -d "%" | tr ":" "," > branch0_bias.csv






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

touch branch0_bias.csv
echo "test,line,bias" > branch0_bias.csv

i=0
# Execute file again and again for all the testcases to get a net output over all test cases in .c.gcov file.
while IFS= read -r testcase || [[ -n "$testcase" ]]; do
    let i=i+1
	./task1 $testcase >> .output.log 
	gcov -b myfile.c >> .gcov.log
    # Grep the BIAS of branch 0 
    grep -E -B 1 "^[ ]*branch[ ]*0[ ]*taken[ ]*[0-9]*%" myfile.c.gcov | awk '{if(NR%3 == 1) print $2; if(NR%3 == 2) print $4;}' | awk 'NR%2{printf $0;next;}1'| tr -d "%" | tr ":" ","| awk -v t="$i" '{print t","$1 }'>> branch0_bias.csv
    rm myfile.gcda myfile.c.gcov
done < "$testcases"

touch RTask1.R 

echo "data = read.csv('branch0_bias.csv')
library(ggplot2)
ggplot(data, aes(x=line,y=bias,color=factor(test))) + geom_line() + geom_point() + facet_wrap(~test) 
ggplot(data, aes(x=line,y=bias,fill=factor(test))) + geom_bar(stat='identity') + facet_wrap(~test)
" > RTask1.R

Rscript RTask1.R 






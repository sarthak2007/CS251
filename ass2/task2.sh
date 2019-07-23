#!/bin/bash

touch process.txt files.txt
ps -e | grep -Ea "([0-9] /usr/bin)|([0-9] /bin)" | tr -s " " | sed "s/^[ \t]*//" | cut -d " " -f 1,4 > process.txt
 
ls -l /bin | grep -Eav "total" | tr -s " " | cut -d " " -f 1,2,9 | awk '$3="/bin/"$3' > files.txt
ls -l /usr/bin | tr -s " " | grep -Eav "total" | cut -d " " -f 1,2,9 | awk '$3="/usr/bin/"$3' >> files.txt

touch newfile.txt
touch newprocess.txt

sort -k 3,3 files.txt > newfile.txt
sort -k 2,2 process.txt > newprocess.txt

rm files.txt process.txt

touch output2.txt
join -1 2 -2 3 newprocess.txt newfile.txt | tr " " "," > output2.txt

rm newfile.txt newprocess.txt
#!/bin/sh

ls -l /usr/bin | tr -s " " | cut -d ' ' -f1,2,9 | awk '$3="/usr/bin/"$3' > files.txt  
ls -l /bin | tr -s " " | cut -d ' ' -f1,2,9 | awk '$3="/bin/"$3' >> files.txt

ps -eaux | grep -Ea "([0-9] /usr/bin)|([0-9] /bin)" |  tr -s " " | cut -d ' ' -f2,11 > process.txt

sort -k 2,2 process.txt > newprocess.txt
sort -k 3,3 files.txt > newfiles.txt

join -1 2 -2 3 newprocess.txt newfiles.txt | tr -s '[:blank:]' ',' > output2.txt

rm process.txt newprocess.txt newfiles.txt files.txt




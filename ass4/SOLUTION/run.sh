#!/bin/bash

#Create object files
gcc -c add.c sub.c 

#Create static library combining both add.o and sub.o
ar sr libas.a add.o sub.o

#Create dynamic library combining both mpy.c and div.c
gcc -shared -fPIC mpy.c div.c -o libmd.so

#Get the current directory address
address=`pwd`

#Now create executable linking it with static library and dynamic library
gcc -g  ass4_1.c libas.a "$address/libmd.so" -o executable



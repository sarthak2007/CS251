Problems we faced and steps we took
-----------------------------------

1. I couldn't "ls" in "asgn" directory
  
   - Checked directory permission. 
   - It didn't gave read permission to any so I gave user the read permission.

   				chmod u+r asgn

 2. Tried to execute run_me but Permission denied.
   
   - Saw its permission by

   					 ls -l

   - Found that it is a soft link and the link has all permissions.
   - Checked the permission of the hidden file in bin 

   					(ls -al)

   - It didn't had execute permission.
   - Gave it execute permision

   				chmod u+x .run_me

 3. Tried executing run_me now, It showed me that output directory not found.

 	- Created a output directory in asgn. 

 					mkdir output


 Finally executed run_me and found this code.html in output directory.
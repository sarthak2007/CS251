#include <stdio.h>
#include "method.h"			//All functions declarations in this header file

int main(int argc, char **argv)
{
	//Terminater program if file address not provided
	if (argc == 1)
	{
		printf("Please run the executable with input file name as argument\n");
		return 0;
	}

	//Define a file pointer
	FILE *fptr;
	fptr = fopen(argv[1],"r");

	//If file is not opening
	if(fptr == NULL)
	{
		printf("Failed to open %s\n",argv[1]);
		return 0;
	}


	long double n1,n2;
	char op;

	//Until End of file
	while(!feof(fptr))
	{
		fscanf(fptr,"%Lf %c %Lf\n",&n1,&op,&n2);
		
		//Based on operation - Call the respective functions
		switch(op)
		{
			case '+': printf("%Lf\n",add(n1,n2));
					  break;
			case '-': printf("%Lf\n",sub(n1,n2));
					  break;
			case '*': printf("%Lf\n",mpy(n1,n2));
					  break;
			case '/': printf("%Lf\n",div(n1,n2));
					  break;
			default: printf("Line input not recognized\n");
					  break;
		}
		

	}

	return 0;
}
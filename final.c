#include <stdio.h>
#include <stdlib.h>
#include <stdbool.h>

void array(int x[])
{
	int i, n;

	for(i = 0; i < 10; i++)
	{
		scanf("%d", &n);
		x[i] = n;
	}
}

void print(int x[])
{
	int i;

	for(i = 0; i < 10; i++)
	{
		printf("array_x[%d] = %d\n", i, x[i]);
	}
}

void search(int x[])
{
	int i, n;
	bool entered;

	printf("\nEnter search value: ");
	scanf("%d", &n);

	for(i = 0; i < 10; i++)
	{
		if( x[i] == n )
		{
			printf("array_x[%d] = %d\n", i, x[i]);
			entered = true;
		}
	}
	if( entered == false ) 
	{
		printf("That value does not exist in the array!\n");
	}
}

int main(void)
{
	int x[10];

	array(x);
	print(x);
	search(x);	
}






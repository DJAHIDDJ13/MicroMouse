#include "q_learning.h"
#define alpha 0.1
#define gamma 1
	
int posi=1,posj=1;



// Set Qmaze (X, Y) cell value
void set_Qmaze_cell(struct QMAZE Qmaze, char value, int x, int y) {
   Qmaze.Qmaze[x*2+1][y*2+1]=value;
}

// Set the X and Y cell value
void break_Qmaze_Cell_Walls(struct QMAZE Qmaze, int x, int y, bool top, bool bottom, bool left, bool right) {
   if(top && x>0)	
      Qmaze.Qmaze[x*2][y*2+1]=' ';
   if(bottom && x<(Qmaze.Qsize-1)/2-1)
      Qmaze.Qmaze[x*2+2][y*2+1]=' ';
   if(left && y>0)
      Qmaze.Qmaze[x*2+1][y*2]=' ';
   if(right && y<(Qmaze.Qsize-1)/2-1)
      Qmaze.Qmaze[x*2+1][y*2+2]=' ';
}


// Init a Qmaze from a given size
struct QMAZE init_Qmaze(int size)
{
   struct QMAZE initial_maze;
   initial_maze.QRowCol = size;
   initial_maze.Qsize = initial_maze.QRowCol*2+1;
   initial_maze.Qmaze = (char**)calloc(initial_maze.Qsize , sizeof(char*));
   initial_maze.StartX = 0;
   initial_maze.StartY = 0;
   initial_maze.GoalX = initial_maze.QRowCol - 1;
   initial_maze.GoalY = initial_maze.QRowCol - 1;

   for(int i=0;i<initial_maze.Qsize; i++)
      initial_maze.Qmaze[i]=(char*)calloc(initial_maze.Qsize ,sizeof(char));
   for(int i=0;i<initial_maze.Qsize; i++)
   {
      for(int j=0;j<initial_maze.Qsize; j++)
      {
         if(i%2==0) { initial_maze.Qmaze[i][j]='_';    }
         else if(j%2==0) { initial_maze.Qmaze[i][j]='|'; }
         else { initial_maze.Qmaze[i][j]=' '; }
      }  
   }
    // Set Start and Goal Position 
   set_Qmaze_cell(initial_maze,'*',initial_maze.StartX, initial_maze.StartY);
   set_Qmaze_cell(initial_maze,'G',initial_maze.GoalX, initial_maze.GoalY);

   	//initialize Q and reward matrix
	initial_maze.rValues=(cell**)calloc(initial_maze.QRowCol,sizeof(cell*));
	initial_maze.qValues=(cell**)calloc(initial_maze.QRowCol,sizeof(cell*));

	for(int i=0;i<initial_maze.QRowCol;i++)
	{
			initial_maze.rValues[i]=(cell*)calloc(initial_maze.QRowCol,sizeof(cell));
			initial_maze.qValues[i]=(cell*)calloc(initial_maze.QRowCol,sizeof(cell));
			for(int j=0;j<initial_maze.QRowCol;j++)
			{
				initial_maze.rValues[i][j].directions=(double*)calloc(4,sizeof(double));
				for(int k=0;k<4;k++) 
				{
					initial_maze.rValues[i][j].directions[k]=-0.01;
				}

				initial_maze.qValues[i][j].directions=(double*)calloc(4,sizeof(double));
			}
	}
   return initial_maze;
}


// Print Qmaze physical maze to the console
void print_Qmaze(struct QMAZE maze)
{
   for(int i=0;i<maze.Qsize;i++) {
      for(int j=0;j<maze.Qsize;j++) {
         printf("%2c",maze.Qmaze[i][j]);
      }
      printf("\n");
   }
}

// Print Qmaze to the console
void print_QTable(struct QMAZE maze)
{
    for(int i=0;i<maze.QRowCol;i++)
	{
		for(int j=0;j<maze.QRowCol;j++)
		{   
			printf("(%d,%d) : ",i,j);
			printf("Haut : %lf | ",maze.qValues[i][j].directions[0]);
			printf("Droite : %lf | ",maze.qValues[i][j].directions[1]);
			printf("Bas : %lf | ",maze.qValues[i][j].directions[2]);
			printf("Gauche : %lf | ",maze.qValues[i][j].directions[3]);
		    printf("\n");
		}
		
	}
}


/*******************************************************************/
//move to the cell at given direction
void move(int direction, struct QMAZE Qmaze)
{
	switch(direction)
	{
		// TOP
		case 0:
			if(Qmaze.Qmaze[posi-1][posj]==' ') {
				Qmaze.Qmaze[posi-2][posj]=Qmaze.Qmaze[posi][posj];
				Qmaze.Qmaze[posi][posj]=' ';
				posi-=2;
			}
			break;

		// RIGHT
		case 1:
			if(Qmaze.Qmaze[posi][posj+1]==' ') {
				Qmaze.Qmaze[posi][posj+2]=Qmaze.Qmaze[posi][posj];
				Qmaze.Qmaze[posi][posj]=' ';
				posj+=2;
			}
			break;
	    // BOTTOM		
		case 2:
			if(Qmaze.Qmaze[posi+1][posj]==' ')
			{
				Qmaze.Qmaze[posi+2][posj]=Qmaze.Qmaze[posi][posj];
				Qmaze.Qmaze[posi][posj]=' ';
				posi+=2;
			}
			break;

		// LEFT
		case 3:
			if(Qmaze.Qmaze[posi][posj-1]==' ')
			{
				Qmaze.Qmaze[posi][posj-2]=Qmaze.Qmaze[posi][posj];
				Qmaze.Qmaze[posi][posj]=' ';
				posj-=2;
			}
			break;
	}
}

int bestDirection(int *direction, struct QMAZE Qmaze)//find bestDirection by using q values
{
	int count=0,tempDirs[4];
	double max=-10000;
	for(int i=0;i<4;i++)
	{
		if(Qmaze.qValues[posi/2][posj/2].directions[i]>max)
		{
			if(i==0 && Qmaze.Qmaze[posi-1][posj]==' ')//North
				{max=Qmaze.qValues[posi/2][posj/2].directions[i];tempDirs[0]=i;count=1;}
			else if(i==1 && Qmaze.Qmaze[posi][posj+1]==' ')//East
				{max=Qmaze.qValues[posi/2][posj/2].directions[i];tempDirs[0]=i;count=1;}
			else if(i==2 && Qmaze.Qmaze[posi+1][posj]==' ')//South
				{max=Qmaze.qValues[posi/2][posj/2].directions[i];tempDirs[0]=i;count=1;}
			else if(i==3 && Qmaze.Qmaze[posi][posj-1]==' ')//West
				{max=Qmaze.qValues[posi/2][posj/2].directions[i];tempDirs[0]=i;count=1;}
		}
		else if(Qmaze.qValues[posi/2][posj/2].directions[i]==max)
		{
			tempDirs[count]=i;
			count++;
		}
	}
	//if there is more than 1 direction at same value, choose random
	*direction=tempDirs[rand()%count];
	return max;
}

void restart(struct QMAZE Qmaze)
{
	posi=posj=1;
	Qmaze.Qmaze[posi][posj]='*';
	Qmaze.Qmaze[Qmaze.Qsize-2][Qmaze.Qsize-2]='G';
}

void printSleepClear(int sleepMS, struct QMAZE Qmaze)
{
	print_Qmaze(Qmaze);
	usleep(50*sleepMS);
	system("clear");
}

void qLearning(struct QMAZE Qmaze)
{
	int direction,tempI,tempJ,tempDir,tempCount;
	double max;

	//rewards to the finish
	if(Qmaze.Qmaze[Qmaze.Qsize-2][Qmaze.Qsize-3]==' ')
		Qmaze.rValues[Qmaze.QRowCol-1][Qmaze.QRowCol-2].directions[1]=100000;
	if(Qmaze.Qmaze[Qmaze.Qsize-3][Qmaze.Qsize-2]==' ')
		Qmaze.rValues[Qmaze.QRowCol-2][Qmaze.QRowCol-1].directions[2]=100000;
	
	int count=0,countTotal=0;
	int limit=4*Qmaze.QRowCol;
	printSleepClear(500, Qmaze);
	do
	{
		max=bestDirection(&direction, Qmaze);
		tempI=posi;
		tempJ=posj;

		tempDir=direction;
		move(direction, Qmaze);
		max=bestDirection(&direction, Qmaze);
		Qmaze.qValues[tempI/2][tempJ/2].directions[tempDir]+=(alpha*(Qmaze.rValues[tempI/2][tempJ/2].directions[tempDir]+gamma*(max-Qmaze.qValues[tempI/2][tempJ/2].directions[tempDir])));
		
		printSleepClear(100, Qmaze);
		count++;
		if(posi==Qmaze.Qsize-2 && posj==Qmaze.Qsize-2)
		{
			printf("#%d Move:%d\n",countTotal+1,count);
			printSleepClear(999, Qmaze);
			tempCount=count;
			count=0;
			countTotal++;
			if(countTotal!=limit)
				restart(Qmaze);
		}
	}
	while(countTotal<limit); //while contidion = max restart time
	printf("#%d Move:%d\n",countTotal,tempCount);
	print_Qmaze(Qmaze);
}


// Return a path in Queu form using a QTablered
Queue_XY QLPath(struct QMAZE Qmaze) {

	int i=0, j=0;
	double top, bottom, left, right;
	Queue_XY queue = initQueue_XY();
    pushQueue_XY(&queue, createOddpair_XY(Qmaze.StartX, Qmaze.StartY, 1));

   while ( !(i == Qmaze.GoalX && j == Qmaze.GoalY) ) {

   	top = Qmaze.qValues[i][j].directions[0];
   	right = Qmaze.qValues[i][j].directions[1];
   	bottom = Qmaze.qValues[i][j].directions[2];
   	left = Qmaze.qValues[i][j].directions[3];

   	
   	// We go up
   	if(top >= right && top >= bottom && top >= left) { 
   		if ( i - 1 < 0 ) {
   			printf("Index out of bond : %d\n", i-1);
   			exit(-1);
   		}
   		else { i--; }
   	}

    // We go down
   	else if(bottom >= right && bottom >= top && bottom >= left ) {
   		if ( i + 1 >= Qmaze.QRowCol ) {
   			printf("Index out of bond : %d\n", i+1);
   			exit(-1);
   		}
   		else { i++; }
   	}

   	// We go right
   	else if(right >= bottom && right >= top && right >= left ) {
   		if ( j + 1 >= Qmaze.QRowCol ) {
   			printf("Index out of bond : %d\n", j+1);
   			exit(-1);
   		}
   		else { j++; }
   	}

   	// We go left
   	else if(left >= right && left >= top && left >= bottom ) {
   		if ( j - 1 < 0 ) {
   			printf("Index out of bond : %d\n", j-1);
   			exit(-1);
   		}
   		else { j--; }
   	}

   	pushQueue_XY(&queue, createOddpair_XY(i, j, 1));

   }

   return queue;
}



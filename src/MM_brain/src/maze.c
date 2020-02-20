/*! 
   \file flood_fill_test.c
   \author MMteam

   
   \brief This file contains the implementation
   		  of the different primitives definded 
   		  Defined in maze.h. 
   
   \see maze.h

   \date 2020
*/
#include <maze.h>

/* Initialize a maze of size N*N */
struct Maze initMaze(int N) {
	struct Maze maze;

	maze.size = N;

	maze.maze = (struct Box* ) malloc(N * N * sizeof(struct Box));

	return maze;
}

/* Create a box with (OX, OY) coordinates in the maze */
struct Box createBox(int OX, int OY, int* wallIndicator) {
	struct Box box;

	box.OX 	  = OX;
	box.OY 	  = OY;
	box.value = 256;
	memcpy(box.wallIndicator, wallIndicator, sizeof(int) * 4);

	return box;
}

/* Insert a box with (OX, OY) coordinates in the maze */
int insertBox(struct Box box, struct Maze maze) {
	int OX = box.OX;
	int OY = box.OY;
	int size = maze.size;

	if(OX >= size || OY >= size)  {
		fprintf(stderr, "dbg: entering %s %d\n", __FUNCTION__, __LINE__);
		return -1;
	}

	maze.maze[OY*size+OX] = box;

	return 0;
}

/* Check if the x-th side of a box is occupied by a wall */
bool X_TH_wallCheck(int x, struct Box box) {
	if(x >= 4) {
		fprintf(stderr, "dbg: entering %s %d\n", __FUNCTION__, __LINE__);
		return false;		
	}

	/* This function return true if the x-th side of 
	   the box is occupied by a wall false otherwise */
	return (box.wallIndicator[x] == 1) ? true : false;
}

/* Display a maze */
void displayMaze(struct Maze maze) {	
	for(int y = 0; y < maze.size; y++) {
		for(int x = 0; x < maze.size; x++) {
			printf("%d ", maze.maze[y*maze.size+x].value);
		}
		printf("\n");
	}
}

/* String box to logical box */
struct Box convertStringBox(int OX, int OY, char* displayM, int size) {
	struct Box box;
	int wallIndicator[4] = {0, 0, 0, 0};
	
	int x = OX*3;
	int y = OY*3;
	
	// Top side
	if(displayM[y*size+x] == '#' && displayM[y*size+(x+1)] == '#' && displayM[y*size+(x+2)] == '#')
		wallIndicator[BOX_TOP_SIDE] = 1;

	// Left side
	if(displayM[(y+1)*size+x] == '#')
		wallIndicator[BOX_LEFT_SIDE] = 1;

	// Right side
	if(displayM[(y+1)*size+(x+2)] == '#')
		wallIndicator[BOX_RIGHT_SIDE] = 1;

	// Bottom side
	if(displayM[(y+2)*size+(x+1)] == '#')
		wallIndicator[BOX_BOTTOM_SIDE] = 1;

	box = createBox(OX, OY, wallIndicator);

	return box;
}

/* String maze to logical maze */
struct Maze convertStringMaze(char* displayM, int size) {
	struct Maze maze;

	if(displayM != NULL) {
		maze = initMaze(size/3);

		for(int y = 0; y < maze.size; y++) {
			for(int x = 0; x < maze.size; x++) {
				insertBox(convertStringBox(x, y, displayM, size), maze);
			}
		}
	}

	return maze;
}

/* Parse string maze from a file */
char* parseMaze(const char* file, int* size) {
	FILE* fp;
	char* displayM;
	char value;

	if(file == NULL){
		fprintf(stderr, "dbg: entering %s %d\n", __FUNCTION__, __LINE__);
		exit(0);
	}

	fp = fopen(file, "r+");

	if(fp == NULL){
		printf("learn:invalide file entering %s %d\n", __FUNCTION__, __LINE__);
		exit(0);
	}
	
	fscanf(fp, "size = %d\n", size);
	displayM = (char *) malloc((*size) * (*size) * sizeof(char));

	for(int i = 0; i < *size; i++) {
		for(int j = 0; j < *size; j++) {
			if(j != *size-1)
				fscanf(fp, "%c", &value);
			else
				fscanf(fp, "%c\n", &value);
			displayM[i*(*size)+j] = value;
		}
	}

	fclose(fp);
	return displayM;
}

/* Free the memory occupied by a maze */
void freeMaze(struct Maze* maze) {
	maze->size = 0;
	free(maze->maze);
}
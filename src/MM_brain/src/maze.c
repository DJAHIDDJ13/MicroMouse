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
struct Maze initMaze(int16_t N) {
	struct Maze maze;

	maze.size = N;

	maze.maze = (struct Box* ) malloc(N * N * sizeof(struct Box));

	return maze;
}

/* Create a box with (OX, OY) coordinates in the maze */
struct Box createBox(int16_t OX, int16_t OY, bool* wallIndicator) {
	struct Box box;

	box.OX 	  = OX;
	box.OY 	  = OY;
	box.value = -1;
	memcpy(box.wallIndicator, wallIndicator, sizeof(bool) * 4);

	return box;
}

/* Insert a box with (OX, OY) coordinates in the maze */
int insertBox(struct Box box, struct Maze maze) {
	int16_t OX = box.OX;
	int16_t OY = box.OY;
	int16_t size = maze.size;

	if(OX >= size || OY >= size)  {
		fprintf(stderr, "insertBox: entering %s %d\n", __FUNCTION__, __LINE__);
		return -1;
	}

	maze.maze[OY*size+OX] = box;

	return 0;
}

/* Check if the x-th side of a box is occupied by a wall */
bool X_TH_wallCheck(int8_t x, struct Box box) {
	if(x >= 4) {
		fprintf(stderr, "X_TH_wallCheck: entering %s %d\n", __FUNCTION__, __LINE__);
		return false;		
	}

	/* This function return true if the x-th side of 
	   the box is occupied by a wall false otherwise */
	return box.wallIndicator[x];
}

/* Get the neighbour who have the min value */
struct Box minValueNeighbour(struct Maze maze, int16_t OX, int16_t OY) {
	struct Box* boxs = maze.maze;

	if(boxs == NULL) {
		printf("flooFill:invalide file entering %s %d\n", __FUNCTION__, __LINE__);
		exit(0);
	}
	
	int16_t size = maze.size;
	struct Box box = boxs[OY*size+OX];
	box.value = INT16_MAX;

	//Top neighbour
	if((OY-1 >= 0) && !X_TH_wallCheck(BOX_TOP_SIDE, boxs[OY*size+OX]) 
		&& boxs[(OY-1)*size+OX].value < box.value) {

		box.OX = OX;
		box.OY = OY-1;
		box.value = boxs[(OY-1)*size+OX].value;
	}

	//Bottom neighbour
	if((OY+1 < size) && !X_TH_wallCheck(BOX_BOTTOM_SIDE, boxs[OY*size+OX]) 
		&& boxs[(OY+1)*size+OX].value < box.value) {
		
		box.OX = OX;
		box.OY = OY+1;
		box.value = boxs[(OY+1)*size+OX].value;
	}

	//Left neighbour
	if((OX-1 >= 0) && !X_TH_wallCheck(BOX_LEFT_SIDE, boxs[OY*size+OX]) 
		&& boxs[OY*size+(OX-1)].value < box.value) {
		
		box.OX = OX-1;
		box.OY = OY;
		box.value = boxs[OY*size+(OX-1)].value;
	}

	//Right neighbour
	if((OX+1 < size) && !X_TH_wallCheck(BOX_RIGHT_SIDE, boxs[OY*size+OX]) 
		&& boxs[OY*size+(OX+1)].value < box.value) {
		
		box.OX = OX+1;
		box.OY = OY;
		box.value = boxs[OY*size+(OX+1)].value;
	}

	return box;
}

/* Display a maze */
void displayMaze(struct Maze maze) {	
	for(int16_t y = 0; y < maze.size; y++) {
		for(int16_t x = 0; x < maze.size; x++) {
			printf("%d\t", maze.maze[y*maze.size+x].value);
		}
		printf("\n");
	}
}

/* Free the memory occupied by a maze */
void freeMaze(struct Maze* maze) {
	maze->size = 0;
	free(maze->maze);
}
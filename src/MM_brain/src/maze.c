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
/*!
   \file maze.h
   \author MMteam


   \brief Header file to describe the logical maze.

   \details This header file contains the data structures
   			that will structure our logical maze.
   			Also some functions to manipulate the maze.

   \date 2020
*/
#ifndef MAZE_H

#define MAZE_H

#include <stdio.h>
#include <stdlib.h>
#include <stdint.h>
#include <box.h>

/*        Structure representing the maze        */
struct Maze {

   int16_t 	size; 		/*		 Maze size		*/

   struct  Box* maze;  	/* Our maze is supposed
						   		to exist in the form
						   		of a table 		*/
};

/* Here some primitives for the above structures */
/* --------------------------------------------- */

/* Initialize a maze of size N */
struct Maze initMaze(int16_t N);

void initFFMaze(struct Maze maze);

struct Box get_box(struct Maze maze, int16_t OX, int16_t OY);

/* Insert a box with (OX, OY) coordinates in the maze */
int insertBox(struct Box box, struct Maze maze);

/* Get the neighbour who have the min value */
struct Box minValueNeighbour(struct Maze maze, int16_t OX, int16_t OY);

/* Display a maze */
void displayMaze(struct Maze maze, bool displayValue);

/* Free the memory occupied by a maze */
void freeMaze(struct Maze* maze);

#endif

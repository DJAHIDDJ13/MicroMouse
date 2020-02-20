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
#include <stdbool.h>
#include <string.h>
#include <math.h>

/* Marcos to to index the four sides of a maze box */
#define BOX_LEFT_SIDE		0 /* Left side index   */
#define BOX_TOP_SIDE		1 /* Top side index    */
#define BOX_RIGHT_SIDE		2 /* Right side index  */
#define BOX_BOTTOM_SIDE		3 /* bottom side index */

/*    Structure representing a Box of the maze    */
struct Box {
	
	/* Our orthonormal mark
	   o ----> x
	   |
	   |
	   v
	   y
	*/  

	int OX; 			  /* The abscissa of the box 
							      in the maze     */
	
	int OY; 			  /* The ordinate of the box  
							      in the maze     */
	
	int wallIndicator[4]; /* Used to find out if the 
							x-th side of the square 
							is occupied by a wall */

	int value;			  /* The value of the case */

};

/*        Structure representing the maze        */
struct Maze {

	int 	size; 		/*		 Maze size		*/

	struct  Box* maze;  /* Our maze is supposed 
						   to exist in the form 
						   		of a table 		*/
};

/* Here some primitives for the above structures */
/* --------------------------------------------- */

/* Initialize a maze of size N */
struct Maze initMaze(int N);

/* Create a box with (OX, OY) coordinates in the maze */
struct Box createBox(int OX, int OY, int wallIndicator[]);

/* Insert a box with (OX, OY) coordinates in the maze */
int insertBox(struct Box box, struct Maze maze);

/* Check if the x-th side of a box is occupied by a wall */
bool X_TH_wallCheck(int x, struct Box box);

/* Display a maze */
void displayMaze(struct Maze maze);

/* String box to logical box */
struct Box convertStringBox(int OX, int OY, char* displayM, int size);

/* String maze to logical maze */
struct Maze convertStringMaze(char* displayM, int size);

/* Parse string maze from a file */
char* parseMaze(const char* file, int* size);

/* Free the memory occupied by a maze */
void freeMaze(struct Maze* maze);

#endif
/*!
   \file box.h
   \author MMteam


   \brief Header file to describe the logical box.

   \details This header file contains the data structures
   			that will structure our logical box.
   			Also some functions to manipulate the box.

   \date 2020
*/
#ifndef BOX_H

#define BOX_H

#include <stdio.h>
#include <stdlib.h>
#include <stdint.h>
#include <stdbool.h>

enum wall_indicator{
    NoneIndicator = 0, 
    LeftIndicator = 1, 
    RightIndicator = 2, 
    TopIndicator = 4, 
    BottomIndicator = 8
};

#define ADD_INDICATOR(X, Y) ((X) | (Y))
#define REMOVE_INDICATOR(X, Y) ((X) & ~(Y))
#define GET_LEFT(X) ((X) & 1)
#define GET_RIGHT(X) ((X) & 2)
#define GET_TOP(X) ((X) & 4)
#define GET_BOTTOM(X) ((X) & 8)

/*    Structure representing a Box of the maze    */
struct Box {
   /* Our orthonormal mark
      o ----> x
      |
      |
      v
      y
   */

   int16_t OX; 			  /* The abscissa of the box
							      in the maze     */

   int16_t OY; 			  /* The ordinate of the box
							      in the maze     */

   int16_t wallIndicator;  /* Used to find out if the
								x-th side of the square
								is occupied by a wall */

   int16_t value;			  /* The value of the case */

};

/* Here some primitives for the above structures */
/* --------------------------------------------- */

/* Create a box with (wallIndicator) as a indicator for the walls of this box */
struct Box createBox(int16_t OX, int16_t OY, int16_t wallIndicator);

/* Display a box */
void displayBox(struct Box box);

/* Create wallIndicator using booleans */
int16_t createWallIndicator(bool top, bool bottom, bool left, bool right);

#endif

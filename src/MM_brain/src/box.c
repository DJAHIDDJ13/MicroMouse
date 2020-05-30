/*!
   \file box.c
   \author MMteam


   \brief This file contains the implementation
   		  of the different primitives definded
   		  Defined in box.h.

   \see box.h

   \date 2020
*/
#include <box.h>

/* Create a box with (wallIndicator) as a indicator for the walls of this box */
struct Box createBox(int16_t OX, int16_t OY, int16_t wallIndicator)
{
   struct Box box;

   box.OX 	  = OX;
   box.OY 	  = OY;

   box.value = -1;
   box.wallIndicator = wallIndicator;

   return box;
}

/* Display a box */
void displayBox(struct Box box)
{
   printf("(wallIndicator = %d, value = %d)\n", box.wallIndicator, box.value);
}

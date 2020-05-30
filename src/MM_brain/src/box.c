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

/* Create wallIndicator using booleans */
int16_t createWallIndicator(bool top, bool bottom, bool left, bool right)
{
   int16_t wallIndicator = NoneIndicator;

   if(top)
      wallIndicator = ADD_INDICATOR(wallIndicator, TopIndicator);
   if(bottom)
      wallIndicator = ADD_INDICATOR(wallIndicator, BottomIndicator);
   if(left)
      wallIndicator = ADD_INDICATOR(wallIndicator, LeftIndicator);
   if(right)
      wallIndicator = ADD_INDICATOR(wallIndicator, RightIndicator);

   return wallIndicator;
}

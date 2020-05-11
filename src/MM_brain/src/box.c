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

/* Check the access for the left box*/
bool left_access_check(struct Box box)
{
   int16_t WI = box.wallIndicator;

   return WI != -1 && WI != -5 && WI != -9 &&
          WI != -13 && WI != -14 && WI != -11 &&
          WI != -8 && WI != -16 && WI != -15;
}

/* Check the access for the top box*/
bool top_access_check(struct Box box)
{
   int16_t WI = box.wallIndicator;

   return WI != -13 && WI != -2 && WI != -10 &&
          WI != -14 && WI != -7 && WI != -8 &&
          WI != -12 && WI != -16;
}

/* Check the access for the rigth box*/
bool right_access_check(struct Box box)
{
   int16_t WI = box.wallIndicator;

   return WI != -9 && WI != -13 && WI != -6 &&
          WI != -3 && WI != -7 && WI != -11 &&
          WI != -12 && WI != -16 && WI != -15;
}

/* Check the access for the bottom box*/
bool bottom_access_check(struct Box box)
{
   int16_t WI = box.wallIndicator;

   return WI != -5 && WI != -6 && WI != -10 &&
          WI != -14 && WI != -4 && WI != -12 &&
          WI != -16 && WI != -15;
}

/* Display a box */
void displayBox(struct Box box)
{
   printf("(wallIndicator = %d, value = %d)\n", box.wallIndicator, box.value);
}

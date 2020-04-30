/*!
   \file brain.c
   \author MMteam


   \brief This file contains the implementation
   		  of the different MM brain function
   		  such as flood fill algorithm.

   \see brain.h

   \date 2020
*/

#include <brain.h>

/* Fill a case of the maze with a color */
void fill(struct Maze maze, int16_t OX, int16_t OY, int16_t color)
{
   int16_t size = maze.size;

   if((OX < 0 || OX >= size) || (OY < 0 || OY >= size)) {
      printf("fill:invalide file entering %s %d\n", __FUNCTION__, __LINE__);
      exit(0);
   }

   maze.maze[OY * size + OX].value = color;
}

/* Push the destination boxs of the maze to the queue */
void pushDestinationBoxs(Queue_XY* queue, int16_t OX, int16_t OY, bool cellNumber)
{
   struct oddpair_XY XY;

   if(queue == NULL) {
      printf("flooFill:invalide file entering %s %d\n", __FUNCTION__, __LINE__);
      exit(0);
   }

   if(!cellNumber) {
      XY = createOddpair_XY(OX, OY, 0);
      pushQueue_XY(queue, XY);
   } else {
      XY = createOddpair_XY(OX, OY, 0);
      pushQueue_XY(queue, XY);


      XY = createOddpair_XY(OX + 1, OY, 0);
      pushQueue_XY(queue, XY);


      XY = createOddpair_XY(OX, OY + 1, 0);
      pushQueue_XY(queue, XY);

      XY = createOddpair_XY(OX + 1, OY + 1, 0);
      pushQueue_XY(queue, XY);
   }
}

/*---- The FloodFill algorithm ----*/
/* Imagine you pour water into the destination of the maze( which is the four center cells surrounded by 7 walls).
   The water will first flow to the cell immediately outside the destination cells. And then to it’s immediately
   accessible neighboring cells. Similarly, water will flow along the paths in the maze, eventually reaching the
   starting position of the mouse. */

/* Flood fill algorithm */
void floodFill(struct Maze maze, int16_t OX, int16_t OY, bool cellDestinationNumber)
{
   struct oddpair_XY XY;

   struct Box* boxs = maze.maze;
   int16_t size = maze.size;

   if(boxs == NULL) {
      printf("flooFill:invalide file entering %s %d\n", __FUNCTION__, __LINE__);
      exit(0);
   }

   int16_t colorMaze = 0;

   Queue_XY queue = initQueue_XY();

   pushDestinationBoxs(&queue, OX, OY, cellDestinationNumber);

   uint8_t sign = 0;

   while(!emptyQueue_XY(queue)) {
      XY = summitQueue_XY(queue);
      popQueue_XY(&queue);

      if(XY.sign != sign) {
         sign = XY.sign;
         colorMaze++;
      }

      fill(maze, XY.OX, XY.OY, colorMaze);

      //Top neighbour, check if ther is no wall
      if(top_access_check(boxs[(XY.OY)*size + XY.OX])
            && boxs[(XY.OY - 1)*size + XY.OX].value == -1 && boxs[(XY.OY - 1)*size + XY.OX].value != -2) {

         pushQueue_XY(&queue, createOddpair_XY(XY.OX, XY.OY - 1, 1 - XY.sign));
         boxs[(XY.OY - 1)*size + XY.OX].value = -2;
      }

      //Bottom neighbour, check if ther is no wall
      if(bottom_access_check(boxs[(XY.OY)*size + XY.OX])
            && boxs[(XY.OY + 1)*size + XY.OX].value == -1 && boxs[(XY.OY + 1)*size + XY.OX].value != -2) {

         pushQueue_XY(&queue, createOddpair_XY(XY.OX, XY.OY + 1, 1 - XY.sign));
         boxs[(XY.OY + 1)*size + XY.OX].value = -2;
      }

      //Left neighbour, check if ther is no wall
      if(left_access_check(boxs[XY.OY * size + (XY.OX)])
            && boxs[XY.OY * size + (XY.OX - 1)].value == -1 && boxs[XY.OY * size + (XY.OX - 1)].value != -2) {

         pushQueue_XY(&queue, createOddpair_XY(XY.OX - 1, XY.OY, 1 - XY.sign));
         boxs[XY.OY * size + (XY.OX - 1)].value = -2;
      }

      //Right neighbour, check if ther is no wall
      if(right_access_check(boxs[XY.OY * size + (XY.OX)])
            && boxs[XY.OY * size + (XY.OX + 1)].value == -1 && boxs[XY.OY * size + (XY.OX + 1)].value != -2) {
         pushQueue_XY(&queue, createOddpair_XY(XY.OX + 1, XY.OY, 1 - XY.sign));
         boxs[XY.OY * size + (XY.OX + 1)].value = -2;
      }
   }

   freeQueue_XY(&queue);
}

/* Backward flood fill algorithm */
Queue_XY backwardFloodFill(struct Maze maze, int16_t OX, int16_t OY)
{

   struct Box* boxs = maze.maze;
   int16_t size = maze.size;

   if(boxs == NULL) {
      printf("flooFill:invalide file entering %s %d\n", __FUNCTION__, __LINE__);
      exit(0);
   }

   Queue_XY queue = initQueue_XY();
   struct Box box = boxs[OY * size + OX];
   pushQueue_XY(&queue, createOddpair_XY(OX, OY, 1));

   while (box.value != 0) {
      box = minValueNeighbour(maze, OX, OY);

      if(box.value == INT16_MAX) {
         break;
      }

      pushQueue_XY(&queue, createOddpair_XY(box.OX, box.OY, 1));

      OX = box.OX;
      OY = box.OY;
   }

   return queue;
}

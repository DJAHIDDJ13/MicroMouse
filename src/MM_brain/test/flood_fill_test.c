/*! 
   \file flood_fill_test.c
   \author MMteam
   \brief Main test for the flood fill algorithm.
   
   \warning Attention don't forget to free the 
            memory occupied by the structures.
   \date 2020
*/
#include <stdio.h>
#include <stdint.h>
#include <flood_fill.h>

struct Maze createMaze() {
   /* # # # # # # # # # # # # 
      #   #                 #
      # # #                 #
      #           # # # #   # 
      #           #     #   #
      #           #     # # #
      #     #     #         # 
      #     #     #         #
      #     # # # #         #
      #                     # 
      #                     #
      # # # # # # # # # # # #
   */
   struct Maze maze = initMaze(4);

   //Box 1
   insertBox(createBox(0, 0, createWallIndicator(true, true, true, true)), maze);

   //Box 2
   insertBox(createBox(1, 0, createWallIndicator(true, false, true, false)), maze);

   //Box 3
   insertBox(createBox(2, 0, createWallIndicator(true, true, false, false)), maze);

   //Box 4
   insertBox(createBox(3, 0, createWallIndicator(true, false, false, true)), maze);

   //Box 5
   insertBox(createBox(0, 1, createWallIndicator(true, false, true, false)), maze);

   //Box 6
   insertBox(createBox(1, 1, createWallIndicator(false, false, false, true)), maze);

   //Box 7
   insertBox(createBox(2, 1, createWallIndicator(true, false, true, true)), maze);

   //Box 8
   insertBox(createBox(3, 1, createWallIndicator(false, true, true, true)), maze);

   //Box 9
   insertBox(createBox(0, 2, createWallIndicator(false, false, true, true)), maze);

   //Box 10
   insertBox(createBox(1, 2, createWallIndicator(false, true, true, true)), maze);

   //Box 11
   insertBox(createBox(2, 2, createWallIndicator(false, false, true, false)), maze);

   //Box 12
   insertBox(createBox(3, 2, createWallIndicator(true, false, false, true)), maze);

   //Box 13
   insertBox(createBox(0, 3, createWallIndicator(false, true, true, false)), maze);

   //Box 14
   insertBox(createBox(1, 3, createWallIndicator(true, true, false, false)), maze);

   //Box 15
   insertBox(createBox(2, 3, createWallIndicator(false, true, false, false)), maze);

   //Box 16
   insertBox(createBox(3, 3, createWallIndicator(false, true, false, true)), maze);
   
   return maze;
}

int main(int argc, char **argv) {

   struct Maze logicalMaze = createMaze();
   displayMaze(logicalMaze);

   printf("\n---------------\n\n");

   //One destination cell
   floodFill(logicalMaze, 2, 2);
   displayMaze(logicalMaze);

   Queue_XY path = backwardFloodFill(logicalMaze, 3, 1);

   printf("\nPath for the MM :\n");
   printQueue_XY(path);
   
   freeMaze(&logicalMaze);
   freeQueue_XY(&path);

   return 0;
}

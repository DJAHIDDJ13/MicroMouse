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
   insertBox(createBox(0, 0, -16), maze);

   //Box 2
   insertBox(createBox(1, 0, -8), maze);

   //Box 3
   insertBox(createBox(2, 0, -10), maze);

   //Box 4
   insertBox(createBox(3, 0, -7), maze);

   //Box 5
   insertBox(createBox(0, 1, -8), maze);

   //Box 6
   insertBox(createBox(1, 1, -3), maze);

   //Box 7
   insertBox(createBox(2, 1, -13), maze);

   //Box 8
   insertBox(createBox(3, 1, -15), maze);

   //Box 9
   insertBox(createBox(0, 2, -11), maze);

   //Box 10
   insertBox(createBox(1, 2, -15), maze);

   //Box 11
   insertBox(createBox(2, 2, -1), maze);

   //Box 12
   insertBox(createBox(3, 2, -7), maze);

   //Box 13
   insertBox(createBox(0, 3, -5), maze);

   //Box 14
   insertBox(createBox(1, 3, -10), maze);

   //Box 15
   insertBox(createBox(2, 3, -4), maze);

   //Box 16
   insertBox(createBox(3, 3, -6), maze);
   
   return maze;
}

int main(int argc, char **argv) {

   struct Maze logicalMaze = createMaze();
   displayMaze(logicalMaze);

   printf("\n---------------\n\n");

   //One destination cell
   floodFill(logicalMaze, 2, 2, false);
   displayMaze(logicalMaze);

   Queue_XY path = backwardFloodFill(logicalMaze, 3, 1);

   printf("\nPath for the MM :\n");
   printQueue_XY(path);
   
   freeMaze(&logicalMaze);
   freeQueue_XY(&path);

   return 0;
}

/*! 
   \file q_learning_test.c
   \author MMteam
   \brief Main test for the Q learning algorithm.
   \date 2020
*/

#include <stdio.h>
#include <stdint.h>
#include <q_learning.h>


struct Maze createMaze() {
   /* # # # # # # # # # # # # 
      #   #                 #
      # # #       # # #     #
      # # #       # # # #   # 
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

   // TOP, BOTTOM, LEFT, RIGHT
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
   insertBox(createBox(2, 2, createWallIndicator(true, false, true, false)), maze);

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

   // Maze 1
   /*
   struct QMAZE test1 = init_Qmaze(4);
   break_Qmaze_Cell_Walls(test1, 0,1, false, true, true, true);
   break_Qmaze_Cell_Walls(test1, 1,1, true, true, false, true);
   break_Qmaze_Cell_Walls(test1, 1,2, true, true, false, false);
   break_Qmaze_Cell_Walls(test1, 1,3, true, false, false, true);
   break_Qmaze_Cell_Walls(test1, 2,0, true, false, true, false);
   break_Qmaze_Cell_Walls(test1, 2,1, false, true, false, false);
   break_Qmaze_Cell_Walls(test1, 2,3, false, false, true, true);
   break_Qmaze_Cell_Walls(test1, 3,1, false, true, false, true);
   break_Qmaze_Cell_Walls(test1, 3,2, true, false, false, false);


   qLearning(test1);
   printQueue_XY(QLPath(test1));
   print_QTable(test1);
   print_Qmaze(test1);
   */


   struct Maze logicalMaze = createMaze();
   struct QMAZE test = logical_to_Qmaze(logicalMaze);
   add_Qmaze_Cell_Walls(test, 1,1, false, false, true, false);
   add_Qmaze_Cell_Walls(test, 2,0, false, true, false, false);


   qLearning(test);
   printQueue_XY(QLPath(test));
   print_QTable(test);


   freeMaze(&logicalMaze);

   return 0;
}

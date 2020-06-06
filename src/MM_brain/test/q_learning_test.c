/*! 
   \file q_learning_test.c
   \author MMteam
   \brief Main test for the Q learning algorithm.
   \date 2020
*/

#include <stdio.h>
#include <stdint.h>
#include <q_learning.h>

/*********************/
// Amine Agrane code //
/*********************/



void displayMazeWallsVal(struct Maze maze)
{
   for(int16_t y = 0; y < maze.size; y++) {
      for(int16_t x = 0; x < maze.size; x++) {
         printf("%d\t", maze.maze[y * maze.size + x].wallIndicator);
      }

      printf("\n");
   }
}


struct QMAZE logical_to_Qmaze(struct Maze logicalmaze )
{
   struct QMAZE Qmaze = init_Qmaze(logicalmaze.size);
   int currentWallIndicator = 0;
   bool top,  bottom,  left,  right;
   for(int i=0;i<logicalmaze.size;i++) 
   {
      for(int j=0;j<logicalmaze.size;j++) 
      {
         currentWallIndicator = logicalmaze.maze[j*logicalmaze.size+i].wallIndicator;
         top = GET_TOP(currentWallIndicator) == 4;
         bottom = GET_BOTTOM(currentWallIndicator) == 8;
         left = GET_LEFT(currentWallIndicator) == 1;
         right = GET_RIGHT(currentWallIndicator) == 2;
         /*printf("wall indic %d   ",currentWallIndicator);
         printf("|top %d  ",GET_TOP(currentWallIndicator));
         printf("|bottom %d  ",GET_BOTTOM(currentWallIndicator));
         printf("|left %d  ",GET_LEFT(currentWallIndicator));
         printf("|right %d  ",GET_RIGHT(currentWallIndicator));*/

         printf("wall indic %d   ",currentWallIndicator);
         printf("|top %d  ",top);
         printf("|bottom %d  ",bottom);
         printf("|left %d  ",left);
         printf("|right %d  ", right);

         printf("\n");
         break_Qmaze_Cell_Walls(Qmaze,j, i, !top, !bottom, !left, !right); 
         //set_Qmaze_cell(Qmaze,'X',i,j);
      }
     //printf("\n");
   }
   return Qmaze;
}
/* Display a maze physical structure*/




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

   // Partie originelle de q_learning.c
   struct QMAZE initial_maze = init_Qmaze(4);
   break_Qmaze_Cell_Walls(initial_maze, 0,0, true, true, true, true);
   break_Qmaze_Cell_Walls(initial_maze, 1,0, false, true, false, true);
   break_Qmaze_Cell_Walls(initial_maze, 2,0, true, false, true, true);
   break_Qmaze_Cell_Walls(initial_maze, 2,1, true, true, true, true);
   break_Qmaze_Cell_Walls(initial_maze, 2,2, true, true, true, true);
   break_Qmaze_Cell_Walls(initial_maze, 2,3, true, true, false, false);
   break_Qmaze_Cell_Walls(initial_maze, 3,3, true, true, false, false);


  // qLearning(initial_maze);
  // print_QTable(initial_maze);
  // print_Qmaze(initial_maze);
   struct Maze logicalMaze = createMaze();
   struct QMAZE test = logical_to_Qmaze(logicalMaze);
   break_Qmaze_Cell_Walls(test, 0,0, false, false, false, true);
   qLearning(test);
   print_QTable(test);

   printQueue_XY(QLPath(test));
   freeMaze(&logicalMaze);

   return 0;
}

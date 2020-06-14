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
   struct Maze maze = {.maze = NULL};
   maze = initMaze(maze.maze, 4);

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

   struct Maze logical_maze = createMaze();
   struct QMAZE test = init_Qmaze(logical_maze.size, 3, 3);
   print_Qmaze(test);
   update_maze(test, logical_maze, 3,3);
   break_Qmaze_Cell_Walls(test, 0,0, false, false, true, false);
   
   //add_Qmaze_Cell_Walls(test, 1,1, false, false, true, false);
   //add_Qmaze_Cell_Walls(test, 2,0, false, true, false, false);
   print_Qmaze(test);

   int limit=6*test.QRowCol;
   int countTotal = 0;

   struct Box box = {0};

   do
   {
      //vote_for_walls(status, &logical_maze, vote_table, 6);
      //test = logical_to_Qmaze(logical_maze);
      qLearning(test, &box);
      //update_control(&status, box, 0);

      // we reach goal
      if(box.OY == test.GoalX && box.OX == test.GoalY)
      {
         printSleepClear(999, test);
         countTotal++;
         if(countTotal!=limit)
            restart(test, &box);
      }      
   } while(countTotal<limit); //while contidion = max restart time

   Queue_XY path = QLPath(test);

   print_Qmaze(test);

   printQueue_XY(path);
   print_QTable(test);

   freeQueue_XY(&path);
   freeMaze(&logical_maze);

   return 0;
}

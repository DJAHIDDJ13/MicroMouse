#include <stdio.h>
#include <stdint.h>
#include <q_learning.h>


void printSleepClear2(int sleepMS, struct QMAZE Qmaze)
{
   print_Qmaze(Qmaze);
   usleep(25*sleepMS);
   system("clear");
}

struct Maze createMaze() {
   struct Maze maze = {.maze = NULL};
   maze = initMaze(maze.maze, 4);
   // TOP, BOTTOM, LEFT, RIGHT
   insertBox(createBox(0, 0, createWallIndicator(true, true, true, true)), maze);
   insertBox(createBox(1, 0, createWallIndicator(true, false, true, false)), maze);
   insertBox(createBox(2, 0, createWallIndicator(true, true, false, false)), maze);
   insertBox(createBox(3, 0, createWallIndicator(true, false, false, true)), maze);
   insertBox(createBox(0, 1, createWallIndicator(true, false, true, false)), maze);
   insertBox(createBox(1, 1, createWallIndicator(false, false, false, true)), maze);
   insertBox(createBox(2, 1, createWallIndicator(true, false, true, true)), maze);
   insertBox(createBox(3, 1, createWallIndicator(false, true, true, true)), maze);
   insertBox(createBox(0, 2, createWallIndicator(false, false, true, true)), maze);
   insertBox(createBox(1, 2, createWallIndicator(false, true, true, true)), maze);
   insertBox(createBox(2, 2, createWallIndicator(true, false, true, false)), maze);
   insertBox(createBox(3, 2, createWallIndicator(true, false, false, true)), maze);
   insertBox(createBox(0, 3, createWallIndicator(false, true, true, false)), maze);
   insertBox(createBox(1, 3, createWallIndicator(true, true, false, false)), maze);
   insertBox(createBox(2, 3, createWallIndicator(false, true, false, false)), maze);
   insertBox(createBox(3, 3, createWallIndicator(false, true, false, true)), maze);

   return maze;
}



int main(int argc, char **argv) {

   // logical and Qmaze 
   struct Maze logical_maze = createMaze();
   struct QMAZE test = init_Qmaze(logical_maze.size);
   test = update_maze(test, logical_maze);


   int limit=6*test.QRowCol;
   int countTotal = 0;
   struct Box box = {0};

   do
   {
      printf("(%d,%d) \n",box.OY, box.OX);
      qLearning(test, &box);
      printSleepClear2(100, test);

      // WE REACH GOAL
      if(box.OY == test.GoalX && box.OX == test.GoalY)
      {
         printSleepClear2(100, test);
         countTotal++;
         if(countTotal!=limit)
            restart(test, &box);
      }      
   } 
   while(countTotal<limit);


   // Get path, print Qtable and rValues
   Queue_XY path = QLPath(test);
   printQueue_XY(path);
   print_QTable(test);
   printf("\n\n");
   print_RValues(test);

   // free structs
   freeQueue_XY(&path);
   freeMaze(&logical_maze);

   return 0;
}

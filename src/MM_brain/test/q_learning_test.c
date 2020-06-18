#include <stdio.h>
#include <stdint.h>
#include <q_learning.h>


void printSleepClear2(int sleepMS, struct QMAZE Qmaze)
{
   print_Qmaze(Qmaze);
   usleep(10*sleepMS);
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

struct QMAZE maze_exemple_1() {
   struct Maze logical_maze = createMaze();
   struct QMAZE test = init_Qmaze(logical_maze.size);
   test.GoalX = 3; test.GoalY=3;
   test = update_maze(test, logical_maze);
   freeMaze(&logical_maze);
   return test;
}


struct QMAZE maze_exemple_2() {
   struct Maze logical_maze = createMaze();
   struct QMAZE test = init_Qmaze(logical_maze.size);
   test.GoalX = 3; test.GoalY=3;
   test = update_maze(test, logical_maze);
   add_Qmaze_Cell_Walls(test, 3, 2, false, true, false, false);
   add_Qmaze_Cell_Walls(test, 3, 1, true, false, false, false);
   add_Qmaze_Cell_Walls(test, 2, 3, false, false, false, true);
   break_Qmaze_Cell_Walls(test, 1, 3, false, false, true, true);
   freeMaze(&logical_maze);
   return test;
}



struct QMAZE maze_exemple_3() {

   struct QMAZE test = init_Qmaze(7);

   // column 0
   break_Qmaze_Cell_Walls(test, 1, 0, true, true, true, true);
   break_Qmaze_Cell_Walls(test, 2, 0, true, true, true, true);
   break_Qmaze_Cell_Walls(test, 3, 0, true, true, false  , false);
   break_Qmaze_Cell_Walls(test, 4, 0, false, true, false  , false);
   break_Qmaze_Cell_Walls(test, 5, 0, true, false, false  , false);
   break_Qmaze_Cell_Walls(test, 6, 0, true, true, true  , true);

   // column 1
   break_Qmaze_Cell_Walls(test, 0, 1, true, true, true, false);
   break_Qmaze_Cell_Walls(test, 1, 1, true, false, true, true);
   break_Qmaze_Cell_Walls(test, 2, 1, true, false, false  , true);
   break_Qmaze_Cell_Walls(test, 3, 1, false, true, false  , true);
   break_Qmaze_Cell_Walls(test, 4, 1, false, false, true  , true);
   break_Qmaze_Cell_Walls(test, 5, 1, true, false, false  , false);
   break_Qmaze_Cell_Walls(test, 6, 1, false, false, false  , false);

   // column 2
   break_Qmaze_Cell_Walls(test, 0, 2, false, true, false, true);
   break_Qmaze_Cell_Walls(test, 1, 2, false, true, true, false);
   break_Qmaze_Cell_Walls(test, 2, 2, true, true, false  , false);
   break_Qmaze_Cell_Walls(test, 3, 2, false, false, true  , true);
   break_Qmaze_Cell_Walls(test, 4, 2, true, false, true  , false);
   break_Qmaze_Cell_Walls(test, 5, 2, true, true, false  , false);
   break_Qmaze_Cell_Walls(test, 6, 2, false, true, false  , true);

   // column 3
   break_Qmaze_Cell_Walls(test, 0, 3, false, true, false, true);
   break_Qmaze_Cell_Walls(test, 1, 3, false, true, false, true);
   break_Qmaze_Cell_Walls(test, 2, 3, false, true, true  , true);
   break_Qmaze_Cell_Walls(test, 3, 3, true, false, true  , false);
   break_Qmaze_Cell_Walls(test, 4, 3, true, false, false  , false);
   break_Qmaze_Cell_Walls(test, 5, 3, false, false, true  , true);
   break_Qmaze_Cell_Walls(test, 6, 3, true, true, false  , true);


   // column 4
   break_Qmaze_Cell_Walls(test, 0, 4, false, true, false, true);
   break_Qmaze_Cell_Walls(test, 1, 4, false, true, false, true);
   break_Qmaze_Cell_Walls(test, 2, 4, false, false, true  , true);
   break_Qmaze_Cell_Walls(test, 3, 4, true, true, false  , false);
   break_Qmaze_Cell_Walls(test, 4, 4, false, true, true  , false);
   break_Qmaze_Cell_Walls(test, 5, 4, true, true, false  , false);
   break_Qmaze_Cell_Walls(test, 6, 4, false, true, false  , true);


   // column 5
   break_Qmaze_Cell_Walls(test, 0, 5, false, true, false, true);
   break_Qmaze_Cell_Walls(test, 1, 5, false, false, true, true);
   break_Qmaze_Cell_Walls(test, 2, 5, true, true, false  , false);
   break_Qmaze_Cell_Walls(test, 3, 5, false, false, true  , true);
   break_Qmaze_Cell_Walls(test, 4, 5, true, false, false  , true);
   break_Qmaze_Cell_Walls(test, 5, 5, false, false, true  , true);
   break_Qmaze_Cell_Walls(test, 6, 5, true, false, false  , true);


   // column 6
   break_Qmaze_Cell_Walls(test, 0, 6, false, false, true, true);
   break_Qmaze_Cell_Walls(test, 1, 6, true, false, true, false);
   break_Qmaze_Cell_Walls(test, 2, 6, true, false, true  , true);
   break_Qmaze_Cell_Walls(test, 3, 6, true, false, true  , false);
   break_Qmaze_Cell_Walls(test, 4, 6, true, false, true  , false);
   break_Qmaze_Cell_Walls(test, 5, 6, true, false, true  , false);
   break_Qmaze_Cell_Walls(test, 6, 6, true, false, true  , false);

   return test;
}


int main(int argc, char **argv) {

   // logical and Qmaze 
   struct QMAZE test = maze_exemple_3();




   int limit=7*test.QRowCol;
   int countTotal = 0;
   struct Box box = {0};

   do
   {
      printf("countTotal : %d/%d\n", countTotal, limit);
      printf("(%d,%d) \n",box.OY, box.OX);
      qLearning(test, &box);
      printSleepClear2(100, test);

      // WE REACH GOAL
      if(box.OY == test.GoalX && box.OX == test.GoalY) 
      {
         // First time reaching goal 
         if(countTotal == 0)  {  
            Reward(test, 0,0, 10000000);
            Reward(test, 0,1,  0.01);
            Reward(test, 0,-1, 0.01);
            Reward(test, 1,0,  0.01);
            Reward(test, -1,0, 0.01);

            //reward(test);  

         }
         printSleepClear2(100, test);
         countTotal++;
         if(countTotal!=limit)
            restart(test, &box);
      }      
   } 
   while(countTotal<limit);


   // Get path, print Qtable and rValues
   Queue_XY path = QLPath(test);
   printf("Maze struct : \n");
   print_Qmaze(test);
   printf("Optimal path : \n");
   printQueue_XY(path);
   printf("Q-Table path : \n");
   print_QTable(test);
   printf("Reward values path: \n");
   print_RValues(test);


   // free structs
   freeQueue_XY(&path);


   return 0;
}

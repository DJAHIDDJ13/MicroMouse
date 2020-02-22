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
#include <brain.h>

struct Maze createMaze() {
   struct Maze maze = initMaze(4);
   
   //Box 1
   bool wallIndicator_Box[4] = {true,true,true,true};
   insertBox(createBox(0, 0, wallIndicator_Box), maze);

   //Box 2
   memcpy(wallIndicator_Box, (bool [4]){true,true,false,false}, 4*sizeof(bool));
   insertBox(createBox(1, 0, wallIndicator_Box), maze);

   //Box 3
   memcpy(wallIndicator_Box, (bool [4]){false,true,false,true}, 4*sizeof(bool));
   insertBox(createBox(2, 0, wallIndicator_Box), maze);

   //Box 4
   memcpy(wallIndicator_Box, (bool [4]){false,true,true,false}, 4*sizeof(bool));
   insertBox(createBox(3, 0, wallIndicator_Box), maze);

   //Box 5
   memcpy(wallIndicator_Box, (bool [4]){true,true,false,false}, 4*sizeof(bool));
   insertBox(createBox(0, 1, wallIndicator_Box), maze);
   
   //Box 6
   memcpy(wallIndicator_Box, (bool [4]){false,false,true,false}, 4*sizeof(bool));
   insertBox(createBox(1, 1, wallIndicator_Box), maze);
   
   //Box 7
   memcpy(wallIndicator_Box, (bool [4]){true,true,true,false}, 4*sizeof(bool));
   insertBox(createBox(2, 1, wallIndicator_Box), maze);

   //Box 8
   memcpy(wallIndicator_Box, (bool [4]){true,false,true,true}, 4*sizeof(bool));
   insertBox(createBox(3, 1, wallIndicator_Box), maze);

   //Box 9
   memcpy(wallIndicator_Box, (bool [4]){true,false,true,false}, 4*sizeof(bool));
   insertBox(createBox(0, 2, wallIndicator_Box), maze);

   //Box 10
   memcpy(wallIndicator_Box, (bool [4]){true,false,true,true}, 4*sizeof(bool));
   insertBox(createBox(1, 2, wallIndicator_Box), maze);
   
   //Box 11
   memcpy(wallIndicator_Box, (bool [4]){true,false,false,false}, 4*sizeof(bool));
   insertBox(createBox(2, 2, wallIndicator_Box), maze);

   //Box 12
   memcpy(wallIndicator_Box, (bool [4]){false,true,true,false}, 4*sizeof(bool));
   insertBox(createBox(3, 2, wallIndicator_Box), maze);
   
   //Box 13
   memcpy(wallIndicator_Box, (bool [4]){true,false,false,true}, 4*sizeof(bool));
   insertBox(createBox(0, 3, wallIndicator_Box), maze);
   
   //Box 14
   memcpy(wallIndicator_Box, (bool [4]){false,true,false,true}, 4*sizeof(bool));
   insertBox(createBox(1, 3, wallIndicator_Box), maze);

   //Box 15
   memcpy(wallIndicator_Box, (bool [4]){false,false,false,true}, 4*sizeof(bool));
   insertBox(createBox(2, 3, wallIndicator_Box), maze);

   //Box 16
   memcpy(wallIndicator_Box, (bool [4]){false,false,true,true}, 4*sizeof(bool));
   insertBox(createBox(3, 3, wallIndicator_Box), maze);
   
   return maze;
}

int main(int argc, char **argv) {   

   struct Maze logicalMaze = createMaze();
   displayMaze(logicalMaze);

   printf("\n---------------\n\n");

   flooFill(logicalMaze, 2, 2);
   displayMaze(logicalMaze);

   freeMaze(&logicalMaze);

   return 0;
}
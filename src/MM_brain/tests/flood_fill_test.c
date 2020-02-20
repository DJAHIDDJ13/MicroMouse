/*! 
   \file flood_fill_test.c
   \author MMteam

   
   \brief Main test for the flood fill algorithm. 
   
   \warning Attention don't forget to free the 
            memory occupied by the structures.

   \date 2020
*/
#include <stdio.h>
#include <brain.h>

int main(int argc, char **argv) {   
   
   if(argc == 1){
      fprintf(stderr, "main: invalid argument!\n");
      printf("usage: %s [maze_file] ..\n", argv[0]);
      return -1;
   }

   char* file = argv[1];

   int size;
   char* charMaze = parseMaze(file, &size);

   for(int y = 0; y < size; y++) {
      for(int x = 0; x < size; x++) {
         printf("%c", charMaze[y*size+x]);
      }
      printf("\n");
   }

   printf("\n---------------\n\n");

   struct Maze logicalMaze = convertStringMaze(charMaze, size);
   displayMaze(logicalMaze);

   if(charMaze)
      free(charMaze);
   freeMaze(&logicalMaze);

   return 0;
}
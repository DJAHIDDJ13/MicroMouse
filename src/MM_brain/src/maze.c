/*!
   \file maze.c
   \author MMteam


   \brief This file contains the implementation
   		  of the different primitives definded
   		  Defined in maze.h.

   \see maze.h

   \date 2020
*/
#include <maze.h>

/* Initialize a maze of size N*N */
struct Maze initMaze(struct Box *boxes, int16_t N)
{
   struct Maze maze;
   int x = 0, y = 0;
   maze.size = N;

   maze.maze = (struct Box* ) realloc(boxes, N * N * sizeof(struct Box));

   for (y = 0; y < N; y++) {
      for (x = 0; x < N; x++) {
         maze.maze[y*N+x].OX = x;
         maze.maze[y*N+x].OY = y;

         maze.maze[y*N+x].wallIndicator = 0;
         if (y == 0 && x >= 0 && x < N) 
            maze.maze[y*N+x].wallIndicator = ADD_INDICATOR(maze.maze[y*N+x].wallIndicator, TopIndicator);
         if (y == N-1 && x >= 0 && x < N) 
            maze.maze[y*N+x].wallIndicator = ADD_INDICATOR(maze.maze[y*N+x].wallIndicator, BottomIndicator);
         if (x == 0 && y >= 0 && y < N) 
            maze.maze[y*N+x].wallIndicator = ADD_INDICATOR(maze.maze[y*N+x].wallIndicator, LeftIndicator);
         if (x == N-1 && y >= 0 && y < N) 
            maze.maze[y*N+x].wallIndicator = ADD_INDICATOR(maze.maze[y*N+x].wallIndicator, RightIndicator);
         maze.maze[y*N+x].value = -1;
         maze.maze[y*N+x].visited = false;
      }
   }
   maze.maze[0].wallIndicator = ADD_INDICATOR(maze.maze[0].wallIndicator, RightIndicator);
   maze.maze[1].wallIndicator = ADD_INDICATOR(maze.maze[1].wallIndicator, LeftIndicator);
   maze.maze[0].visited = true;

   return maze;
}

void initFFMaze(struct Maze maze) {
   int x = 0, y = 0;
   int N = maze.size;

   for (y = 0; y < N; y++) {
      for (x = 0; x < N; x++) {
         maze.maze[y*N+x].value = -1;
      }
   }
}

struct Box get_box(struct Maze maze, int16_t OX, int16_t OY) {
   return maze.maze[OY*maze.size+OX];
}

/* Insert a box with (OX, OY) coordinates in the maze */
int insertBox(struct Box box, struct Maze maze)
{
   int16_t OX = box.OX;
   int16_t OY = box.OY;
   int16_t size = maze.size;

   if(OX < 0 || OY < 0 || OX >= size || OY >= size)  {
      fprintf(stderr, "insertBox: entering %s %d\n", __FUNCTION__, __LINE__);
      return -1;
   }

   box.visited = maze.maze[OY * size + OX].visited;
   maze.maze[OY * size + OX] = box;

   return 0;
}

/* Get the neighbour who have the min value */
struct Box minValueNeighbour(struct Maze maze, int16_t OX, int16_t OY)
{
   struct Box* boxs = maze.maze;

   if(boxs == NULL) {
      printf("flooFill:invalide file entering %s %d\n", __FUNCTION__, __LINE__);
      exit(0);
   }

   int16_t size = maze.size;
   struct Box box = boxs[OY * size + OX];
   struct Box box_visited = boxs[OY * size + OX];
   bool no_visited = false;

   box.value = INT16_MAX;

   //Top neighbour
   if((OY - 1 >= 0) && GET_TOP(boxs[OY * size + OX].wallIndicator) == 0
         && boxs[(OY - 1)*size + OX].value <= box.value) {

      box.OX = OX;
      box.OY = OY - 1;
      box.value = boxs[(OY - 1) * size + OX].value;

      if(!boxs[(OY - 1)*size + OX].visited) {
         box_visited = box;
         no_visited = true;
      }
   }

   //Bottom neighbour
   if((OY + 1 < size) && GET_BOTTOM(boxs[OY * size + OX].wallIndicator) == 0
         && boxs[(OY + 1)*size + OX].value <= box.value) {

      box.OX = OX;
      box.OY = OY + 1;
      box.value = boxs[(OY + 1) * size + OX].value;

      if(!boxs[(OY + 1)*size + OX].visited) {
         box_visited = box;
         no_visited = true;
      }
   }

   //Left neighbour
   if((OX - 1 >= 0) && GET_LEFT(boxs[OY * size + OX].wallIndicator) == 0
         && boxs[OY * size + (OX - 1)].value <= box.value) {

      box.OX = OX - 1;
      box.OY = OY;
      box.value = boxs[OY * size + (OX - 1)].value;

      if(!boxs[OY * size + (OX -1)].visited) {
         box_visited = box;
         no_visited = true;
      }
   }

   //Right neighbour
   if((OX + 1 < size) && GET_RIGHT(boxs[OY * size + OX].wallIndicator) == 0
         && boxs[OY * size + (OX + 1)].value <= box.value) {

      box.OX = OX + 1;
      box.OY = OY;
      box.value = boxs[OY * size + (OX + 1)].value;

      if(!boxs[OY * size + (OX + 1)].visited) {
         box_visited = box;
         no_visited = true;
      }
   }

   return (no_visited) ? box_visited : box;
}

/* Display a maze */
void displayMaze(struct Maze maze, bool displayValue)
{
   for(int16_t y = 0; y < maze.size; y++) {
      for(int16_t x = 0; x < maze.size; x++) {

         if(displayValue)
            printf("%d\t", maze.maze[y * maze.size + x].value);
         else {
            if(y >= 1) {
               printf("%c", GET_LEFT(maze.maze[(y-1) * maze.size + x].wallIndicator) ? '|' : ' ');
            } else {
               printf(" ");
            }

            printf("%c", GET_TOP(maze.maze[y * maze.size + x].wallIndicator) ? '_' : ' ');
         }
      }

      printf("\n");
   }

   printf("###################\n");
}

/* Free the memory occupied by a maze */
void freeMaze(struct Maze* maze)
{
   maze->size = 0;
   free(maze->maze);
}

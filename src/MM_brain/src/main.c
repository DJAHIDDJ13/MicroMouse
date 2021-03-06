#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>
#include <string.h>
#include <errno.h>
#include <sys/types.h>
#include <sys/stat.h>
#include <signal.h>
#include <time.h>

#include "box.h"
#include "flood_fill.h"
#include "q_learning.h"
#include "control.h"
#include "maze.h"
#include "position.h"
#include "communication.h"
#include "queue.h"
#include "utils.h"
#include "cell_estim.h"

/* GLOBAL VARIABLES */
RX_Message rx_msg;
TX_Message tx_msg;
SensorData sensor_data;
HeaderData header_data;

enum MM_MODE {MAPPING, BACK_TO_START, FAST_RUN, STOP} mm_mode;

int main(int argc, char const *argv[])
{
   log_message("INFO", "Listener", "run", "Starting listener...");
   log_message("INFO", "Writer", "run", "Starting writer...");
   set_starting_time();
   create_fifo();

   int init_width = 4;

   int **vote_table = NULL;
   vote_table = init_vote_array(vote_table, init_width);

   struct Maze logical_maze = {.maze = NULL};
   logical_maze = initMaze(logical_maze.maze, init_width);

   // Qmaze Var
   struct QMAZE qmaze = init_Qmaze(logical_maze.size);

   struct Micromouse status = {0};
   struct Box box = {0};

   int limit = 6 * init_width;
   int countTotal = 0;

   mm_mode = MAPPING;
   status.nav_alg = FLOOD_FILL;

   Queue_XY path;

   int X_target, Y_target;
   int setPosition = 0;

   while(1) {
      read_fifo(&rx_msg);
      format_rx_data_mm(rx_msg, &status);

      if(setPosition == 1) {
         status.prev_enc[0] = status.sensor_data.encoders[0];
         status.prev_enc[1] = status.sensor_data.encoders[1];
         status.sensor_data.gyro.ypr.z = 0;
         setPosition = 0;
      }

      switch(rx_msg.flag) {

      case HEADER_FLAG:
         mm_mode = MAPPING;
         init_cell(&status);
         X_target = status.header_data.target_x;
         Y_target = status.header_data.target_y;
         logical_maze = initMaze(logical_maze.maze,
                                 status.header_data.maze_height / status.header_data.box_height);
         vote_table = init_vote_array(vote_table,
                                      (int)(status.header_data.maze_width / status.header_data.box_width));

         limit = 6 * logical_maze.size;
         countTotal = 0;
         
         qmaze = init_Qmaze(logical_maze.size);

         break;

      case SENSOR_FLAG:
         update_cell(&status);
         vote_for_walls(status, &logical_maze, vote_table, 6);

         if(status.nav_alg == Q_LEARNING ) {
            // Q-LEARNING ALOGORITHM

            qmaze =  update_maze(qmaze, logical_maze);
            
            if(status.cur_cell.x == box.OX && status.cur_cell.y == box.OY) {
               qLearning(qmaze, &box);
            }

            // updating and printing the two types of maze
            if(mm_mode == MAPPING) 
            {
               if(status.cur_cell.x == status.header_data.target_x &&
                     status.cur_cell.y == status.header_data.target_y) 
               {
                  countTotal++;
                  if(countTotal == 1) 
                  {
                     Reward(qmaze, 0,0, 10000000);
                     Reward(qmaze, 0,1,  0.01);
                     Reward(qmaze, 0,-1, 0.01);
                     Reward(qmaze, 1,0,  0.01);
                     Reward(qmaze, -1,0, 0.01);
                  }

                  if(countTotal == limit) {
                     mm_mode = FAST_RUN;
                     path = QLPath(qmaze);
                  } else {
                     restart(qmaze, &box);
                  }

                  write_fifo(tx_msg, GOAL_REACHED_FLAG, NULL);
               }
            } 
            else if(mm_mode == FAST_RUN) {

               if(!emptyQueue_XY(path)) {
                  if(box.OX == status.cur_cell.x &&
                     box.OY == status.cur_cell.y) 
                  {
                     path.head = (path.head)->next;
                  }

                  struct oddpair_XY XY_tmp = summitQueue_XY(path);

                  box.OX = XY_tmp.OX;

                  box.OY = XY_tmp.OY;
               } else {
                  mm_mode = STOP;
                  box.OX = status.cur_cell.x;
                  box.OY = status.cur_cell.y;
               }
            } else if(mm_mode == STOP) {
               box.OX = status.cur_cell.x;
               box.OY = status.cur_cell.y;
            }

         } else if(status.nav_alg == FLOOD_FILL) {
            // FLOOD FILL ALGORITHM
            
            if (mm_mode == MAPPING) {
               //printf("|||||||||||||||| MAPPING\n");
               floodFill(logical_maze, X_target, Y_target);
               box = minValueNeighbour(logical_maze, status.cur_cell.x, status.cur_cell.y);

               if(status.cur_cell.x == status.header_data.target_x
                     && status.cur_cell.y == status.header_data.target_y) {
                  mm_mode = BACK_TO_START;
                  write_fifo(tx_msg, GOAL_REACHED_FLAG, NULL);
               }

               if(!logical_maze.maze[box.OY*logical_maze.size+box.OX].visited)
                  logical_maze.maze[box.OY*logical_maze.size+box.OX].visited = true;
            } else if(mm_mode == BACK_TO_START) {
               //printf("|||||||||||||||| BACK_TO_START\n");
               floodFill(logical_maze, 0, 0);
               box = minValueNeighbour(logical_maze, status.cur_cell.x, status.cur_cell.y);

               if(status.cur_cell.x == 0 && status.cur_cell.y == 0) {
                  mm_mode = FAST_RUN;

                  floodFill(logical_maze, X_target, Y_target);
                  path = backwardFloodFill(logical_maze, 0, 0);
                  printQueue_XY(path);
                  //path = reorganise_path(&path);
               }

               if(!logical_maze.maze[box.OY*logical_maze.size+box.OX].visited)
                  logical_maze.maze[box.OY*logical_maze.size+box.OX].visited = true;                              
            } else if(mm_mode == FAST_RUN) {
               //printf("|||||||||||||||| FAST_RUN\n");
               if(!emptyQueue_XY(path)) {
                  if(box.OX == status.cur_cell.x &&
                     box.OY == status.cur_cell.y)
                  {
                     path.head = (path.head)->next;
                  }

                  struct oddpair_XY XY_tmp = summitQueue_XY(path);

                  box.OX = XY_tmp.OX;

                  box.OY = XY_tmp.OY;
               } else {
                  mm_mode = STOP;
                  box.OX = status.cur_cell.x;
                  box.OY = status.cur_cell.y;
               }
            } else if(mm_mode == STOP) {
               box.OX = status.cur_cell.x;
               box.OY = status.cur_cell.y;
            }
         }

         display_logical_maze(status, 6, vote_table);
         if(status.nav_alg == Q_LEARNING) {
            printf("(count = %d, limit = %d)\n", countTotal, limit);
            print_Qmaze(qmaze);
         }
         else {
            displayMaze(logical_maze, true);
         }

         printf("(%d %d)\n", box.OX, box.OY);
         
         update_control(&status, box, 0); // initialise values

         write_fifo(tx_msg, MOTOR_FLAG, &status);
         break;

      case POSITION_FLAG:
         // Set the new pose
         setPosition = 1;
         break;

      case NAVIGATION_FLAG:
         printf("Changing algorithm to %s\n", (status.nav_alg == Q_LEARNING) ? "Q_LEARNING" : "FLOOD_FILL");
         break;
      }
   }

   freeQueue_XY(&path);
   return 0;
}
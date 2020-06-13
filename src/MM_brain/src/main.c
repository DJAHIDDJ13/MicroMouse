/*!
   \file main.c
   \author MMteam


   \brief Main program for the micromouse brain, this program
   must be flexible and support both simulation and
   real robot modes of use.

   \warning Attention our project must contain only one main program
   called main.c, to make a test you have to create a program
   in the tests folder and give it a different name than main.c

   \date 2020
*/

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
   struct Micromouse status;
   struct Box box = {0};

   while(1) {
      read_fifo(&rx_msg);
      format_rx_data_mm(rx_msg, &status);

      switch(rx_msg.flag) {
         case HEADER_FLAG:
            //dump_header_data(status);
            init_cell(&status);

            vote_table = init_vote_array(vote_table, (int)(status.header_data.maze_width / status.header_data.box_width));
            logical_maze = initMaze(logical_maze.maze, status.header_data.maze_height / status.header_data.box_height);
            
            floodFill(logical_maze, status.header_data.target_x, status.header_data.target_y);
            box = minValueNeighbour(logical_maze, status.cur_cell.x, status.cur_cell.y);
            
            update_control(&status, box, 1); // initialise values
            break;

         case SENSOR_FLAG:
            //dump_sensor_data(status);
            //dump_estimation_data(status);
            update_cell(&status); 
            vote_for_walls(status, &logical_maze, vote_table, 6);

            floodFill(logical_maze, status.header_data.target_x, status.header_data.target_y);
            box = minValueNeighbour(logical_maze, status.cur_cell.x, status.cur_cell.y);
            update_control(&status, box, 0); // initialise values

            /* Adjust display time step */
                 display_logical_maze(status, 6, vote_table);
//          displayMaze(logical_maze, true);
//          displayMaze(logical_maze, false);
    
            break;
      }
      //dump_estimation_data(status);
      write_fifo(tx_msg, MOTOR_FLAG, &status);
   }

   return 0;
}

/*!
   \file communication_test.c
   \author MMteam


   \brief Main test for the communication module.

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

int **vertical_walls, **horizontal_walls;

int main(void)
{
   log_message("INFO", "Listener", "run", "Starting listener...");
   log_message("INFO", "Writer", "run", "Starting writer...");
   set_starting_time();

   create_fifo();
   
   struct Micromouse status;
   int i = 0;

   while(1) {
      read_fifo(&rx_msg);
      format_rx_data_mm(rx_msg, &status);

      switch(rx_msg.flag) {
         case HEADER_FLAG:
            dump_header_data(status);
            init_cell(&status);
            update_control(&status, 1); // initialise values

            vertical_walls = malloc(((status.header_data.maze_width / status.header_data.box_width) + 1) * sizeof(*vertical_walls));
            horizontal_walls = malloc(((status.header_data.maze_width / status.header_data.box_width) + 1) * sizeof(*horizontal_walls));
            for ( i = 0; i < (status.header_data.maze_width / status.header_data.box_width) + 1; i++) {
               vertical_walls[i] = malloc(((status.header_data.maze_height / status.header_data.box_height) + 1) * sizeof(*vertical_walls[i]));
               horizontal_walls[i] = malloc(((status.header_data.maze_height / status.header_data.box_height) + 1) * sizeof(*horizontal_walls[i]));
            }

            break;
         case SENSOR_FLAG:
            //dump_sensor_data(status);
            update_cell(&status);
            update_control(&status, 0); // initialise values
            break;
      }
      //dump_estimation_data(status);
      write_fifo(tx_msg, MOTOR_FLAG, &status);
      
      vote_for_walls(detect_wall(status), vertical_walls, horizontal_walls);
      /* Adjust display time step */
      //if ((int)time(NULL)%5 == 4)
         //display_logical_maze(status, 25, vertical_walls, horizontal_walls);

   }

   return 0;
}

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
#include <pthread.h>
#include <time.h>

#include "box.h"
#include "brain.h"
#include "maze.h"
#include "position.h"
#include "communication.h"
#include "queue.h"
#include "utils.h"
#include "cell_estim.h"

/* MUTEX */
//pthread_cond_t condition = PTHREAD_COND_INITIALIZER;
//pthread_mutex_t mutex = PTHREAD_MUTEX_INITIALIZER;
/* GLOBAL VARIABLES */
RX_Message rx_msg;
TX_Message tx_msg;
SensorData sensor_data;
HeaderData header_data;

/* LISTENER */
/*void *thread_1(void *arg)
{
   log_message("INFO", "Listener", "run", "Starting listener...");

   while (1) {
      read_fifo(&rx_msg);
      format_rx_data(rx_msg, &sensor_data, &header_data);
      pthread_mutex_lock (&mutex);
      pthread_cond_signal (&condition);
      pthread_mutex_unlock (&mutex);
   }
*/
   /* No warning */
/*   (void) arg;
   pthread_exit(NULL);
}
*/
/* WRITER */
/*void *thread_2(void *arg)
{
   float test[2] = { 1.23, 4.56 };
   log_message("INFO", "Writer", "run", "Starting writer...");

   while (1) {
      pthread_mutex_lock(&mutex);
      pthread_cond_wait (&condition, &mutex);
 */
      /* WRITING */
      /* ...Processing... */
      /* Code snipet to use received data */
      /*
      printf("MAZE DIMENSIONS : %f x %f\n", header_data.maze_width, header_data.maze_height);
      */
/*      write_fifo(tx_msg, MOTOR_FLAG, test);
      pthread_mutex_unlock(&mutex);
   }
*/
   /* No warning */
/*   (void) arg;
   pthread_exit(NULL);
}
*/


int main(void)
{

   //pthread_t listener;
   //pthread_t reader;

   log_message("INFO", "Listener", "run", "Starting listener...");
   log_message("INFO", "Writer", "run", "Starting writer...");
   set_starting_time();

   create_fifo();
   
   float test[2] = {50, 50};

   struct Micromouse status;

   iVec2 cell;
   status.engines[0] = test[0];
   status.engines[1] = test[1];

   while(1) {
      read_fifo(&rx_msg);
      format_rx_data_mm(rx_msg, &status);

      switch(rx_msg.flag) {
         case HEADER_FLAG:
//            dump_header_data(status); // the function definition won't compile for some reason
           printf("Header Data:\n");
            printf("\tMaze size: %g, %g\n", status.header_data.maze_width, 
                                            status.header_data.maze_height);
            printf("\tBox size: %g, %g\n", status.header_data.box_width, 
                                           status.header_data.box_height);
            printf("\tInit pose: %g, %g, %g\n", status.header_data.initial_x, 
                                                status.header_data.initial_y, 
                                                status.header_data.initial_angle);
            printf("\tTarget pos: %g, %g\n", status.header_data.target_x, 
                                             status.header_data.target_y);
            printf("\tEncoder data: LPR:%g, circumference: %g\n", status.header_data.lines_per_revolution, 
                                                                  status.header_data.wheel_circumference);
         

            cell = init_cell(status);
            break;
         case SENSOR_FLAG:
//            dump_sensor_data(status);
            printf("Sensor Data:\n");
            printf("\tAccl: %g, %g, %g\n", status.sensor_data.gyro.xyz.x, 
                                           status.sensor_data.gyro.xyz.y, 
                                           status.sensor_data.gyro.xyz.z);
            printf("\tGyro: %g, %g, %g\n", status.sensor_data.gyro.ypr.x, 
                                           status.sensor_data.gyro.ypr.y, 
                                           status.sensor_data.gyro.ypr.z);
            printf("\tSens: %g, %g, %g, %g\n", status.sensor_data.sensors[0], 
                                               status.sensor_data.sensors[1], 
                                               status.sensor_data.sensors[2], 
                                               status.sensor_data.sensors[3]);
            printf("\tEnc: %g %g\n", status.sensor_data.encoders[0], 
                                     status.sensor_data.encoders[1]);
 
            cell = update_cell(status);
            break;
      }

      write_fifo(tx_msg, MOTOR_FLAG, &status);
      printf("Current estimated cell is: (%d, %d)\n", cell.x, cell.y);
   }

/*   if (pthread_create(&listener, NULL, thread_1, NULL) || 
       pthread_create(&reader, NULL, thread_2, NULL) ) {
      perror("pthread_create");
      return 1;
   }

   if (pthread_join(listener, NULL) || pthread_join(reader, NULL)) {
      perror("pthread_join");
      return 1;
   }
*/
   return 0;
}

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
#include "control.h"
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

   printf("%ld\n", sizeof(HeaderData));

   log_message("INFO", "Listener", "run", "Starting listener...");
   log_message("INFO", "Writer", "run", "Starting writer...");
   set_starting_time();

   create_fifo();
   
   struct Micromouse status;

   iVec2 cell;

   while(1) {
      read_fifo(&rx_msg);
      format_rx_data_mm(rx_msg, &status);

      switch(rx_msg.flag) {
         case HEADER_FLAG:
//            dump_header_data(status);
            cell = init_cell(status);
            break;
         case SENSOR_FLAG:
//            dump_sensor_data(status);
            cell = update_cell(status);
            update_control(&status, 0);
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

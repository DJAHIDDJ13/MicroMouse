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
#include <pthread.h>
#include <time.h>

#include "box.h"
#include "brain.h"
#include "communication.h"
#include "maze.h"
#include "micromouse.h"
#include "position.h"
#include "queue.h"
#include "utils.h"

#define TEST 0

/* MUTEX */
pthread_cond_t condition = PTHREAD_COND_INITIALIZER;
pthread_mutex_t mutex = PTHREAD_MUTEX_INITIALIZER;
/* GLOBAL VARIABLES */
RX_Message rx_msg;
TX_Message tx_msg;
SensorData sensor_data;
HeaderData header_data;

/* LISTENER */
void *thread_1(void *arg) {
    log_message("INFO", "Listener", "run", "Starting listener...");
	while (1) {
		read_fifo(&rx_msg);
		format_rx_data(rx_msg, &sensor_data, &header_data);
		pthread_mutex_lock (&mutex);
		pthread_cond_signal (&condition);
		pthread_mutex_unlock (&mutex);
	}

    /* No warning */
    (void) arg;
    pthread_exit(NULL);
}

/* WRITER */
void *thread_2(void *arg) {
	float test[2] = { 1.23, 4.56 };
    log_message("INFO", "Writer", "run", "Starting writer...");
	
	while (1) {
		pthread_mutex_lock(&mutex);
		pthread_cond_wait (&condition, &mutex);
		/* WRITING */
		/* ...Processing...*/
		write_fifo(tx_msg, MOTOR_FLAG, test);
		pthread_mutex_unlock(&mutex);
	}

    /* No warning */
    (void) arg;
    pthread_exit(NULL);
}

int main(void) {
#if TEST == 0
    pthread_t listener;
	pthread_t reader;

	set_starting_time();

	create_fifo();

    if (pthread_create(&listener, NULL, thread_1, NULL) || pthread_create(&reader, NULL, thread_2, NULL) ) {
		perror("pthread_create");
		return 1;
    }

    if (pthread_join(listener, NULL) || pthread_join(reader, NULL)) {
		perror("pthread_join");
		return 1;
    }
#else

#endif

	return 0;
}
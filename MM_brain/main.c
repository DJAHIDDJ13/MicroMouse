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

#include "utils.h"
#include "communication.h"

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
		format_tx_data(&tx_msg, MOTOR_FLAG, test);	
		write_fifo(tx_msg);
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
	/* TEST CODE SNIPETS [TO REMOVE] */
	/*
	unsigned char bytes[4];
	unsigned long n = 175;

	bytes[0] = (n >> 24) & 0xFF;
	bytes[1] = (n >> 16) & 0xFF;
	bytes[2] = (n >> 8) & 0xFF;
	bytes[3] = n & 0xFF;

	printf("%x %x %x %x\n", (unsigned char)bytes[0],
							(unsigned char)bytes[1],
							(unsigned char)bytes[2],
							(unsigned char)bytes[3]);
	*/
	/*
	unsigned char buffer[10] = { 0 };
	unsigned char to_write[10] = { 255, 1, 2, 3, 4, 5, 6, 7, 8, 9 };
	FILE *ptr;
	int i = 0;

	ptr = fopen("/tmp/test.bin","wb");
	fwrite(to_write,sizeof(to_write),1,ptr);
	fclose(ptr);

	ptr = fopen("/tmp/test.bin","rb");
	fread(buffer,sizeof(buffer),1,ptr);
	fclose(ptr);

	for(i = 0; i<10; i++)
    	printf("%u ", buffer[i]);
	*/
	/*
	int ii;
	union {
		float a;
		unsigned char bytes[4];
	} thing;

	thing.a = 1.234;
	for (ii=0; ii<4; ii++) 
		printf ("byte %d is %02x\n", ii, thing.bytes[ii]);
	return 0;
	*/
/*      
    fp = fopen (full_path, "w"); 
    if (fp == NULL) 
    { 
        fprintf(stderr, "\nError opend file\n"); 
        exit (1); 
    } 
  
      
    fwrite (&test, sizeof(Message), 1, fp); 
  
    fclose (fp); 
*/
	int i = 0;
	Message test;
	unsigned char flag;
	unsigned char content[40];
	FILE *fp;
	union {
		float a;
		unsigned char bytes[4];
	} byte_float;
	byte_float.a = 1.234;

	printf("%ld\n", sizeof(test.content));
	fp = fopen("/tmp/c_tx", "wb");
	memset(test.content, 0, sizeof(test.content)); 
	test.flag = 1;
	for (i = 0; i < 4; i++) {
		test.content[i] = byte_float.bytes[i];
	}
	fwrite (&test, sizeof(Message), 1, fp);

/*	flag = 255;
	content[0] = 56;
	fwrite (&flag, sizeof(flag), 1, fp);
	fwrite (&content, sizeof(content), 1, fp);
*/
	
	fclose(fp);
#endif

	return 0;
}
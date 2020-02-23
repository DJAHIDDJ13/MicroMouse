#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>
#include <string.h>
#include <errno.h>
#include <sys/types.h>
#include <sys/stat.h>
#include <signal.h>
#include <pthread.h>

#include "utils.h"
#include "communication.h"

#define TEST 1

/* MUTEX */
pthread_cond_t condition = PTHREAD_COND_INITIALIZER;
pthread_mutex_t mutex = PTHREAD_MUTEX_INITIALIZER;
char output[BUFFER_SIZE] = "";

/* LISTENER */
void *thread_1(void *arg) {
    printf("C - LISTENING...\n");

	while (1) {
		read_fifo(output);
		pthread_mutex_lock (&mutex);
		pthread_cond_signal (&condition);
		pthread_mutex_unlock (&mutex);
	}

    /* No warning */
    (void) arg;
    pthread_exit(NULL);
}

/* READER */
void *thread_2(void *arg) {
    printf("C - READING...\n");
	
	while (1) {
		pthread_mutex_lock(&mutex);
		pthread_cond_wait (&condition, &mutex);
		printf("%s\n", output);
		/* ANSWER */
		write_fifo("PONG!");
		pthread_mutex_unlock(&mutex);
	}

    /* No warning */
    (void) arg;
    pthread_exit(NULL);
}

int main(void) {
    pthread_t listener;
	pthread_t reader;

	create_fifo();

    printf("DEBUG 1.\n");

    if (pthread_create(&listener, NULL, thread_1, NULL) || pthread_create(&reader, NULL, thread_2, NULL) ) {
		perror("pthread_create");
		return 1;
    }

    if (pthread_join(listener, NULL) || pthread_join(reader, NULL)) {
		perror("pthread_join");
		return 1;
    }

	printf("DEBUG 2.\n");

#if TEST == 0
	create_fifo();
	if (fork() == 0) {
		while (!kill(parent_pid, 0)) {
			/* listener */
			read_fifo(output);
		}
	} else {
		for (i = 0; i < 3; i++) {
			printf("Hello\n");
			sleep(3);
			printf("%s\n", output);
		}
		/* write_fifo("test"); */
	}
#endif

	return 0;
}

#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>
#include <string.h>
#include <errno.h>
#include <sys/types.h>
#include <sys/stat.h>
#include <signal.h>
#include <pthread.h>

#include "communication.h"
#include "utils.h"

/* FIFO approach on /tmp/ file for interprocess communication
 * TO_DO : 	to change as shared memory (/dev/shm) if the speed 
 * 			doesn't fit our usecase : 
 * 			i.e. /!\ Only Linux & MacOS compatible atm
 */

int get_tx_fifo_path(char *path) {
	strcat(path, FIFO_PATH);
	strcat(path, FIFO_TX_FILENAME);
	return 0;
}

int get_rx_fifo_path(char *path) {
	strcat(path, FIFO_PATH);
	strcat(path, FIFO_RX_FILENAME);
	return 0;
}

/* Bidirectionnal communication
 * => two FIFOs are being created
 */
int create_fifo() {
	char 	full_path_tx[BUFFER_SIZE] = "",
		full_path_rx[BUFFER_SIZE] = "";
	struct stat stats = {0};
	get_tx_fifo_path(full_path_tx);
	get_rx_fifo_path(full_path_rx);
	
	/* ensure parent directory exists */
	if (stat(FIFO_PATH, &stats) == -1) {
		mkdir(FIFO_PATH, 0700);
	}

	/* /!\ remove first */
	remove(full_path_tx);
	if (errno == EACCES || errno == EINVAL) {
		perror("remove");
		return 1;
	}
	remove(full_path_rx);
	if (errno == EACCES || errno == EINVAL) {
		perror("remove");
		return 1;
	}

	/* mode : -rw-rw-rw */
	if (mkfifo(full_path_tx, 0666) != 0 || mkfifo(full_path_rx, 0660) != 0) {
		perror("mkfifo");
		return 1;
	}

	return 0;
}

int write_fifo(char *input) {
	FILE *fp;
	char full_path[BUFFER_SIZE] = "";
	get_tx_fifo_path(full_path);

	fp = fopen(full_path, "w");
	if (fp == 0) {
		perror("fopen");
		return 1;
	}
	
	fputs(input, fp);

	fclose(fp);

	return 0;
}

int read_fifo(char *output) {
	FILE *fp;
	char full_path[BUFFER_SIZE] = "";
	get_rx_fifo_path(full_path);

	fp = fopen(full_path, "r");
	if (fp == 0) {
		perror("fopen");
		return 1;
	}
	
	while (fgets(output, BUFFER_SIZE, fp) != NULL);

	fclose(fp);

	return 0;
}

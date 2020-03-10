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

void init_rx_message(RX_Message* rx_msg, unsigned char flag) {
	(*rx_msg).flag = flag;
	switch (flag) {
		case HEADER_FLAG:
			(*rx_msg).content.int_array = malloc(HEADER_CONTENT_SIZE);
			break;
		case SENSOR_FLAG:
			(*rx_msg).content.float_array = malloc(SENSOR_CONTENT_SIZE);
			break;
		default:
			log_message("ERROR", "Listener", "init_rx_message", "No matching flag found.");
	}
}

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

/***************************************************************************************************************************
 * GLOBAL FORMAT (in bytes)
 * +----------+-------------+
 * | FLAG (1) | CONTENT (8) |
 * +----------+-------------+
 *
 * CONTENT :
 *      FLAG=MOTOR
 *          - MOTOR# = motor power
 * +------------+------------+
 * | MOTORL (4) | MOTORR (4) |
 * +------------+------------+
 ***************************************************************************************************************************/
int write_fifo(TX_Message tx_msg) {
	FILE *fp;
	char full_path[BUFFER_SIZE] = "";
	get_tx_fifo_path(full_path);

	fp = fopen(full_path, "wb");
	if (fp == 0) {
		perror("fopen");
		return 1;
	}
	
	fwrite(&tx_msg.flag, sizeof(tx_msg.flag), 1, fp);
	fwrite(tx_msg.content, sizeof(tx_msg.content), 1, fp);

	fclose(fp);

	return 0;
}

/***************************************************************************************************************************
 * GLOBAL FORMAT (in bytes)
 * +----------+-----------------+
 * | FLAG (1) | CONTENT (16-40) |
 * +----------+-----------------+
 *
 * CONTENT :
 *      FLAG=HEADER
 *          - MAZE# = maze dimension
 *          - INIT# = micromouse initial position information
 *          - TAR#  = target position
 * +-----------+-----------+-----------+-----------+-----------+-----------+-----------+
 * | MAZEL (2) | MAZEH (2) | INITX (2) | INITY (2) | INITA (2) | TARX  (2) | TARY  (2) |
 * +-----------+-----------+-----------+-----------+-----------+-----------+-----------+
 *      FLAG=DATA_SENSOR
 *          - DIST# = distances
 *          - ACC#  = accelerometer values
 * +-----------+-----------+-----------+-----------+-----------+-----------+-----------+-----------+-----------+-----------+
 * | DIST1 (4) | DIST2 (4) | DIST3 (4) | DIST4 (4) | ACC1  (4) | ACC2  (4) | ACC3  (4) | ACC4  (4) | ACC5  (4) | ACC6  (4) |
 * +-----------+-----------+-----------+-----------+-----------+-----------+-----------+-----------+-----------+-----------+
 ***************************************************************************************************************************/
int read_fifo(RX_Message* rx_msg) {
	int i = 0, j = 0, cursor = 0;
	int byteToInt = 0;
	union {
		float floatNumber;
		unsigned char bytesNumber[4];
	} byteToFloat;

	FILE *fp;
	char full_path[BUFFER_SIZE] = "";
	unsigned char buffer[MAX_MSG_SIZE] = { 0 };
	get_rx_fifo_path(full_path);

	fp = fopen(full_path, "rb");
	if (fp == 0) {
		perror("fopen");
		return 1;
	}
	
	fread(buffer, sizeof(buffer), 1, fp);

	init_rx_message(rx_msg, buffer[0]);
	switch ((*rx_msg).flag) {
		case HEADER_FLAG:
			for (i = 1; i < HEADER_CONTENT_SIZE + 1; i++) {
				byteToInt = 0;
				for (j = 0; j < 2; j++) {
					if (j == 0)
						byteToInt = ((int)buffer[j] << j*8 );
					else
						byteToInt |= ((int)buffer[j] << j*8 );
					i++;
				}
				printf("%d\n", byteToInt);
			}
			break;
		case SENSOR_FLAG:
			for (i = 1; i < SENSOR_CONTENT_SIZE + 1; i++) {
				for (j = 0; j < 4; j++)
					byteToFloat.bytesNumber[j] = buffer[i+j];
				i += 3;
				(*rx_msg).content.float_array[cursor] = byteToFloat.floatNumber;
				cursor++;
			}
			break;
		default:
			log_message("ERROR", "Listener", "init_rx_message", "No matching flag found.");
	}

	fclose(fp);

	return 0;
}

void format_rx_data(RX_Message rx_msg, SensorData* sensor_data, HeaderData* header_data) {
	switch (rx_msg.flag) {
		case HEADER_FLAG:
			(*header_data).maze_width = rx_msg.content.int_array[0];
			(*header_data).maze_height = rx_msg.content.int_array[1];
			(*header_data).initial_x = rx_msg.content.int_array[2];
			(*header_data).initial_y = rx_msg.content.int_array[3];
			(*header_data).initial_angle = rx_msg.content.int_array[4];
			(*header_data).target_x = rx_msg.content.int_array[5];
			(*header_data).target_y = rx_msg.content.int_array[6];
			break;
		case SENSOR_FLAG:
			(*sensor_data).dist_left = rx_msg.content.float_array[0];
			(*sensor_data).dist_left_front = rx_msg.content.float_array[1];
			(*sensor_data).dist_right_front = rx_msg.content.float_array[2];
			(*sensor_data).dist_right = rx_msg.content.float_array[3];
			(*sensor_data).accelerometer_1 = rx_msg.content.float_array[4];
			(*sensor_data).accelerometer_2 = rx_msg.content.float_array[5];
			(*sensor_data).accelerometer_3 = rx_msg.content.float_array[6];
			(*sensor_data).accelerometer_4 = rx_msg.content.float_array[7];
			(*sensor_data).accelerometer_5 = rx_msg.content.float_array[8];
			(*sensor_data).accelerometer_6 = rx_msg.content.float_array[9];
			break;
		default:
			log_message("ERROR", "Listener", "format_rx_data", "No matching flag found.");
	}
}

void format_tx_data(TX_Message *tx_msg, unsigned char flag, void* content) {
	float* data = content;
	int i = 0, j = 0, cursor = 0;
	union {
		float float_number;
		unsigned char bytes_number[4];
	} floatToByte;
	(*tx_msg).flag = flag;

	switch (flag) {
		case MOTOR_FLAG:
			(*tx_msg).content = malloc(MOTOR_CONTENT_SIZE);
			for (i = 0; i < (int) (MOTOR_CONTENT_SIZE / sizeof(float)); i++) {
				floatToByte.float_number = data[i];
				for (j = 0; j < 4; j++) {
					(*tx_msg).content[cursor] = floatToByte.bytes_number[j];
					cursor++;
				}
			}
			break;
		default:
			log_message("ERROR", "Writer", "format_tx_data", "No matching flag found.");
	}
}
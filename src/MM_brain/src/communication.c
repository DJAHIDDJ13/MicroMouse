#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>
#include <string.h>
#include <errno.h>
#include <sys/types.h>
#include <sys/stat.h>
#include <signal.h>
#include <pthread.h>

#include "micromouse.h"
#include "communication.h"
#include "utils.h"

/* FIFO approach on /tmp/ file for interprocess communication
 * TO_DO : 	to change as shared memory (/dev/shm) if the speed
 * 			doesn't fit our usecase :
 * 			i.e. /!\ Only Linux & MacOS compatible atm
 */

void init_rx_message(RX_Message* rx_msg, unsigned char flag)
{
   rx_msg->flag = flag;

   switch (flag) {
   case HEADER_FLAG:
      rx_msg->content.float_array = malloc(sizeof(HeaderData));
      break;

   case SENSOR_FLAG:
      rx_msg->content.float_array = malloc(sizeof(SensorData));
      break;

   default:
      log_message("ERROR", "Listener", "init_rx_message", "No matching flag found.");
   }
}

int get_tx_fifo_path(char *path)
{
   strcat(path, FIFO_PATH);
   strcat(path, FIFO_TX_FILENAME);
   return 0;
}

int get_rx_fifo_path(char *path)
{
   strcat(path, FIFO_PATH);
   strcat(path, FIFO_RX_FILENAME);
   return 0;
}

/* Bidirectionnal communication
 * => two FIFOs are being created
 */
int create_fifo()
{
   char 	full_path_tx[BUFFER_SIZE] = "",
         full_path_rx[BUFFER_SIZE] = "";
   struct stat stats = {0};
   get_tx_fifo_path(full_path_tx);
   get_rx_fifo_path(full_path_rx);

   /* ensure parent directory exists */
   if (stat(FIFO_PATH, &stats) == -1) {
      mkdir(FIFO_PATH, 0700);
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
int write_fifo(TX_Message tx_msg, unsigned char flag, void* content)
{
   FILE *fp;
   char full_path[BUFFER_SIZE] = "";
   get_tx_fifo_path(full_path);

   fp = fopen(full_path, "wb");

   if (fp == 0) {
      perror("fopen");
      return 1;
   }

   format_tx_data(&tx_msg, flag, content);

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
 *          - BOX# = box size (cells dimension)
 * +-----------+-----------+-----------+-----------+-----------+-----------+-----------+-----------+-----------+
 * | MAZEL (4) | MAZEH (4) | INITX (4) | INITY (4) | INITA (4) | TARX  (4) | TARY  (4) | BOXW  (4) | BOXH  (4) |
 * +-----------+-----------+-----------+-----------+-----------+-----------+-----------+-----------+-----------+
 *      FLAG=DATA_SENSOR
 *          - DIST# = distances
 *          - ACC#  = accelerometer values
 * +-----------+-----------+-----------+-----------+-----------+-----------+-----------+-----------+-----------+-----------+
 * | DIST1 (4) | DIST2 (4) | DIST3 (4) | DIST4 (4) | ACC1  (4) | ACC2  (4) | ACC3  (4) | ACC4  (4) | ACC5  (4) | ACC6  (4) |
 * +-----------+-----------+-----------+-----------+-----------+-----------+-----------+-----------+-----------+-----------+
 ***************************************************************************************************************************/
int read_fifo(RX_Message* rx_msg)
{
   int i = 0, j = 0, cursor = 0;
   char logMsg[512] = "", numberToStr[80];

   union {
      float floatNumber;
      unsigned char bytesNumber[4];
   } byteToFloat;

   FILE *fp;
   char full_path[BUFFER_SIZE] = "";
   unsigned char buffer[MAX(sizeof(HeaderData), sizeof(SensorData))] = { 0 };
   get_rx_fifo_path(full_path);

   fp = fopen(full_path, "rb");

   if (fp == 0) {
      perror("fopen");
      return 1;
   }

   fread(buffer, sizeof(buffer), 1, fp);

   init_rx_message(rx_msg, buffer[0]);
   strcpy(logMsg, "Received : ");
   sprintf(numberToStr, "%u", rx_msg->flag);
   strcat(logMsg, numberToStr);
   strcat(logMsg, " ");

   switch (rx_msg->flag) {
   case HEADER_FLAG:
      for (i = 1; i < sizeof(HeaderData) + 1; i++) {
         for (j = 0; j < 4; j++) {
            byteToFloat.bytesNumber[j] = buffer[i + j];
         }

         i += 3;
         sprintf(numberToStr, "%.6g ", byteToFloat.floatNumber);
         strcat(logMsg, numberToStr);
         rx_msg->content.float_array[cursor] = byteToFloat.floatNumber;
         cursor++;
      }     

      break;

   case SENSOR_FLAG:
      for (i = 1; i < sizeof(SensorData) + 1; i++) {
         for (j = 0; j < 4; j++) {
            byteToFloat.bytesNumber[j] = buffer[i + j];
         }

         i += 3;
         sprintf(numberToStr, "%.6g ", byteToFloat.floatNumber);
         strcat(logMsg, numberToStr);
         rx_msg->content.float_array[cursor] = byteToFloat.floatNumber;
         cursor++;
      }

      break;

   default:
      log_message("ERROR", "Listener", "init_rx_message", "No matching flag found.");
   }

   log_message("INFO", "Listener", "read_fifo", logMsg);

   fclose(fp);

   return 0;
}

void format_rx_data(RX_Message rx_msg, SensorData* sensor_data, HeaderData* header_data)
{
   switch (rx_msg.flag) {
   case HEADER_FLAG:
      memcpy(header_data, rx_msg.content.float_array, sizeof(*header_data));
      break;

   case SENSOR_FLAG:
      memcpy(sensor_data, rx_msg.content.float_array, sizeof(*sensor_data));
      break;

   default:
      log_message("ERROR", "Listener", "format_rx_data", "No matching flag found.");
   }
}

void format_rx_data_mm(RX_Message rx_msg, struct Micromouse* data)
{
   switch (rx_msg.flag) {
   case HEADER_FLAG:
      memcpy(&(data->header_data), rx_msg.content.float_array, sizeof(data->header_data));
      break;

   case SENSOR_FLAG:
      memcpy(&(data->sensor_data), rx_msg.content.float_array, sizeof(data->sensor_data));
      break;

   default:
      log_message("ERROR", "Listener", "format_rx_data", "No matching flag found.");
   }

}

void format_tx_data(TX_Message *tx_msg, unsigned char flag, void* content)
{
   char logMsg[512] = "", numberToStr[80];
   float* data = content;
   int i = 0, j = 0, cursor = 0;
   union {
      float float_number;
      unsigned char bytes_number[4];
   } floatToByte;
   tx_msg->flag = flag;

   strcpy(logMsg, "Sending : ");
   sprintf(numberToStr, "%u ", flag);
   strcat(logMsg, numberToStr);

   switch (flag) {
   case MOTOR_FLAG:
      tx_msg->content = malloc(MOTOR_CONTENT_SIZE);

      for (i = 0; i < (int) (MOTOR_CONTENT_SIZE / sizeof(float)); i++) {
         floatToByte.float_number = data[i];

         for (j = 0; j < 4; j++) {
            tx_msg->content[cursor] = floatToByte.bytes_number[j];
            cursor++;
         }

         sprintf(numberToStr, "%.6g ", data[i]);
         strcat(logMsg, numberToStr);
      }

      break;

   default:
      log_message("ERROR", "Writer", "format_tx_data", "No matching flag found.");
   }

   log_message("INFO", "Writer", "write_fifo", logMsg);
}

void dump_sensor_data(struct Micromouse data) 
{
   printf("Sensor Data:\n");
   printf("\tAccl: %g, %g, %g\n", data.sensor_data.gyro.xyz.x, 
                                  data.sensor_data.gyro.xyz.y, 
                                  data.sensor_data.gyro.xyz.z);
   printf("\tGyro: %g, %g, %g\n", data.sensor_data.gyro.ypr.x, 
                                  data.sensor_data.gyro.ypr.y, 
                                  data.sensor_data.gyro.ypr.z);
   printf("\tSens: %g, %g, %g, %g\n", data.sensor_data.sensors[0], 
                                      data.sensor_data.sensors[1], 
                                      data.sensor_data.sensors[2], 
                                      data.sensor_data.sensors[3]);
   printf("\tEnc: %g %g\n", data.sensor_data.encoders[0], 
                            data.sensor_data.encoders[1]);

}

void dump_header_data(struct Micromouse data) 
{
   printf("Header Data:\n");
   printf("\tMaze size: %g, %g\n", data.header_data.maze_width, 
                                   data.header_data.maze_height);
   printf("\tBox size: %g, %g\n", data.header_data.box_width, 
                                  data.header_data.box_height);
   printf("\tInit pose: %g, %g, %g\n", data.header_data.initial_x, 
                                       data.header_data.initial_y, 
                                       data.header_data.initial_angle);
   printf("\tTarget pos: %g, %g\n", data.header_data.target_x, 
                                    data.header_data.target_y);
   printf("\tLines per revolution: %g\n", data.header_data.lines_per_revolution);
   printf("\tEncoder data: LPR:%g, circumference: %g\n", data.header_data.lines_per_revolution, 
                                                         data.header_data.wheel_circumference);
   printf("\tOrigin pos: %g, %g\n", data.header_data.origin_x, 
                                    data.header_data.origin_y);
   printf("\tSensor placement:\n");
   printf("\t\tBottom left %g, %g\n", data.header_data.left_sensor_position_x, 
                               data.header_data.left_sensor_position_y);
   printf("\t\tTop left %g, %g\n", data.header_data.top_left_sensor_position_x, 
                               data.header_data.top_left_sensor_position_y);
   printf("\t\tTop right %g, %g\n", data.header_data.top_right_sensor_position_x, 
                               data.header_data.top_right_sensor_position_y);
   printf("\t\tBottom right %g, %g\n", data.header_data.right_sensor_position_x, 
                               data.header_data.right_sensor_position_y);
}

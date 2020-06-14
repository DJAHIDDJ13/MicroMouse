#ifndef COMMUNICATION_H
#define COMMUNICATION_H

#include "micromouse.h"

#define FIFO_PATH "/tmp/"
#define FIFO_TX_FILENAME "c_tx"
#define FIFO_RX_FILENAME "java_tx"
#define BUFFER_SIZE 256

/* FLAG(2) + MAX(CONTENT_SIZE) */
#define MAX(a,b) (((a)>(b))?(a+2):(b+2))

#define HEADER_FLAG 11
#define SENSOR_FLAG 10
#define POSITION_FLAG 30
#define MOTOR_FLAG 20
#define PING_FLAG 66
#define GOAL_REACHED_FLAG 33

#define PING_CONTENT_SIZE 		  40
#define MOTOR_CONTENT_SIZE 		  8
#define GOAL_REACHED_CONTENT_SIZE 1
#define POSITION_CONTENT_SIZE 12

typedef struct {
   unsigned char flag;
   union {
      float* float_array;
      int* int_array;
   } content;
} RX_Message;

typedef struct {
   unsigned char flag;
   unsigned char* content;
} TX_Message;

typedef struct {
   float random_sequence[10];
} PingData;

typedef struct {
   Vec2 pos;
   float ang;
} PositionData;

void init_fifo();
void init_rx_message(RX_Message* rx_msg, unsigned char flag);
int get_tx_fifo_path(char *path);
int get_rx_fifo_path(char *path);
int create_fifo();
int write_fifo(TX_Message tx_msg, unsigned char flag, void* content);
int read_fifo(RX_Message* rx_msg);
// void format_rx_data(RX_Message rx_msg, SensorData* sensor_data, HeaderData* header_data, PingData* ping_data);
void format_rx_data_mm(RX_Message rx_msg, struct Micromouse* data);
void format_tx_data(TX_Message *tx_msg, unsigned char flag, void* content);
void dump_sensor_data(struct Micromouse data);
void dump_header_data(struct Micromouse data);
void dump_estimation_data(struct Micromouse data);
#endif

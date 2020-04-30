#include "utils.h"

#define FIFO_PATH "/tmp/"
#define FIFO_TX_FILENAME "c_tx"
#define FIFO_RX_FILENAME "java_tx"
#define BUFFER_SIZE 256

#define MAX_MSG_SIZE 50

#define HEADER_FLAG 11
#define HEADER_CONTENT_SIZE 16
#define SENSOR_FLAG 10
#define SENSOR_CONTENT_SIZE 40
#define MOTOR_FLAG 20
#define MOTOR_CONTENT_SIZE 8

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
   float   dist_left,
           dist_left_front,
           dist_right_front,
           dist_right;
   float   accelerometer_1,
           accelerometer_2,
           accelerometer_3,
           accelerometer_4,
           accelerometer_5,
           accelerometer_6;
} SensorData;

typedef struct {
   int maze_width,
       maze_height;
   int initial_x,
       initial_y,
       initial_angle;
   int target_x,
       target_y;
} HeaderData;

void init_rx_message(RX_Message* rx_msg, unsigned char flag);
int get_tx_fifo_path(char *path);
int get_rx_fifo_path(char *path);
int create_fifo();
int write_fifo(TX_Message tx_msg, unsigned char flag, void* content);
int read_fifo(RX_Message* rx_msg);
void format_rx_data(RX_Message rx_msg, SensorData* sensor_data, HeaderData* header_data);
void format_tx_data(TX_Message *tx_msg, unsigned char flag, void* content);

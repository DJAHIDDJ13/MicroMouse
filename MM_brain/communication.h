#include "utils.h"

#define FIFO_PATH "/tmp/"
#define FIFO_TX_FILENAME "c_tx"
#define FIFO_RX_FILENAME "java_tx"
#define BUFFER_SIZE 512

int get_tx_fifo_path(char *path);
int get_rx_fifo_path(char *path);
int create_fifo();
int write_fifo(char *input);
int read_fifo(char *output);

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
#include <time.h>

#include "communication.h"
#include "utils.h"

#define SEQ_SIZE 10
#define RAND_RANGE 50
#define PING_NUMBER 10

RX_Message rx_msg;
TX_Message tx_msg;
SensorData sensor_data;
HeaderData header_data;
PingData ping_data;
double PING_STARTING_TIME;
struct timespec SEQ_START, SEQ_END;

void set_ping_starting_time() {
    PING_STARTING_TIME = time(NULL);
}

int main(void) {
    float random_sequence[SEQ_SIZE] = { 0.0 };
    float original_seq[SEQ_SIZE] = { 0.0 };
    float rand_number;
    int i = 0, counter = 0, error_counter = 0, received = 0, error = 0;
    long total_time = 0, min_seq_time = 9999999, max_seq_time = 0, seq_time = 0, bytes_transmitted = 0;
    double total_time_s = 0;

    log_message("INFO", "Listener", "run", "Starting listener...");
    log_message("INFO", "Writer", "run", "Starting writer...");
    set_ping_starting_time();

    srand((unsigned int)time(NULL));
    create_fifo();

    printf("[%gs] PING Simulation - %d(%d) bytes of data.\n", (time(NULL) - PING_STARTING_TIME), PING_CONTENT_SIZE, PING_CONTENT_SIZE+1);    // LOGS

    /* 1st REQUEST */
    for (i = 0; i < SEQ_SIZE; i++) {
        rand_number = (float)(rand() % RAND_RANGE);
        original_seq[i] = rand_number;
        random_sequence[i] = rand_number;
    }

    write_fifo(tx_msg, PING_FLAG, random_sequence);

    /* LISTENING REPLY */
    while(counter < PING_NUMBER) {
        read_fifo(&rx_msg);
        format_rx_data(rx_msg, &sensor_data, &header_data, &ping_data);

        switch(rx_msg.flag) {
        case PING_FLAG:
            /* GENERATE RANDOM SEQUENCE NUMBER */
            
            for (i = 0; i < SEQ_SIZE; i++) {
                if (original_seq[i] != ping_data.random_sequence[i])
                    error = 1;
            }

            if (error == 1) {
                error_counter++;
                error = 0;
            } else {
                received++;
            }

            for (i = 0; i < SEQ_SIZE; i++) {
                rand_number = (float)(rand() % RAND_RANGE);
                original_seq[i] = rand_number;
                random_sequence[i] = rand_number;
            }
            clock_gettime(CLOCK_MONOTONIC_RAW, &SEQ_START);
            write_fifo(tx_msg, PING_FLAG, random_sequence);
            clock_gettime(CLOCK_MONOTONIC_RAW, &SEQ_END);
            seq_time = (SEQ_END.tv_sec - SEQ_START.tv_sec) * 1000000 + (SEQ_END.tv_nsec - SEQ_START.tv_nsec) / 1000;
            total_time += seq_time;
            if (min_seq_time > seq_time)
                min_seq_time = seq_time;
            if (max_seq_time < seq_time)
                max_seq_time = seq_time;
            //sleep(1);
            printf("[%gs]\t%d bytes from Simulation: ping_seq=%d time=%ld ms\n",    (time(NULL) - PING_STARTING_TIME), 
                                                                                    PING_CONTENT_SIZE + 1, 
                                                                                    counter + 1, 
                                                                                    seq_time); // LOGS
            counter++;
            break;
        default:
            break;
        }
   }

    printf("\n########### Simulation ping statistics ###########\n");
    printf("%d messages transmitted, %d received, %g%% loss, total time %ld ms\n",  PING_NUMBER,
                                                                                    received,
                                                                                    (float)(error_counter/PING_NUMBER),
                                                                                    total_time);
    total_time_s = (float)(total_time/1000.0);
    bytes_transmitted = received*2*(PING_CONTENT_SIZE+1);
    printf("min/avg/max = %ld/%g/%ld ms - spd = %g Bps\n",min_seq_time,    
                                            (float)(total_time/PING_NUMBER),
                                            max_seq_time,
                                            (float)(bytes_transmitted/total_time_s));
    return 0;
}
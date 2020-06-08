#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>
#include <string.h>
#include <time.h>

#include "utils.h"

int STARTING_TIME = 0;

void set_starting_time()
{
   STARTING_TIME = (int)time(NULL);
}

void log_message(char* log_level, char* process, char* function, char* msg)
{
#if DEBUG
   printf( "[%d] %s - %s()\t[%s] : %s\n", (int)time(NULL) - STARTING_TIME, process, function, log_level, msg);
#endif
   if (!strcmp(log_level, "ERROR")) {
      exit(1);
   }
}

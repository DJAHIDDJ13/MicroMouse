#include "utils.h"

#define PORT 5432
#define BUFFER_SIZE 512

int initSocket(int *socketDescriptor);
int configSocket(int socketDescriptor);
void listenComm(int socketDescriptor);
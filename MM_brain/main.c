#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>
#include <string.h>
#include <sys/types.h>
#include <sys/socket.h>
#include <arpa/inet.h>
#include <netinet/in.h>
#include <netinet/ip.h>

#include "utils.h"
#include "communication.h"

int main(int argc, char *argv[]) {
    int socketFd = 0;
    initSocket(&socketFd);
    configSocket(socketFd);

    while(1) {
        listenComm(socketFd);
    }

    close(socketFd);

    return 0;
}
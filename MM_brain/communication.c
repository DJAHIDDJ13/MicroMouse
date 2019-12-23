#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>
#include <string.h>
#include <sys/types.h>
#include <sys/socket.h>
#include <arpa/inet.h>
#include <netinet/in.h>
#include <netinet/ip.h>

#include "communication.h"
#include "utils.h"

/* Socket initialization
 * ---
 */
int initSocket(int *socketDescriptor) {
    /* TO_REMOVE : int socket(int domain, int type, int protocol);
     * domain : AF_INET (IPv4)
     * type : SOCK_STREAM (TCP) | SOCK_DGRAM (UDP)
     */
    *socketDescriptor = socket(AF_INET, SOCK_DGRAM, 0);
    if (*socketDescriptor == -1) {
        perror("Socket initialization has failed");
        return 1;
    }

    return 0;
}

/* Bind the socket
 * ---
 */
int configSocket(int socketDescriptor) {
    struct sockaddr_in srvAddress;

    memset(&srvAddress, 0, sizeof(struct sockaddr_in));

    srvAddress.sin_family = AF_INET;
    srvAddress.sin_addr.s_addr = htonl(INADDR_ANY);
    srvAddress.sin_port = htons(PORT);
    
    if ( bind(socketDescriptor, (struct sockaddr *) &srvAddress, sizeof(struct sockaddr_in)) == -1 ) {
        perror("Socket configuration has failed");
        return 1;
    }

    return 0;
}

void listenComm(int socketDescriptor) {
    unsigned char buffer[BUFFER_SIZE];
    int recvLen;
    // Interlocutor's infos.
    struct sockaddr_in srcAddr;
    socklen_t addrLen = sizeof(srcAddr);

    recvLen = recvfrom(socketDescriptor, buffer, BUFFER_SIZE, 0, (struct sockaddr *)&srcAddr, &addrLen);
    if (recvLen > 0) {
        buffer[recvLen] = 0;
        printf("%s\n", buffer);
    }
}
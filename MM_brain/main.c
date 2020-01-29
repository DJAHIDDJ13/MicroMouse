#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>
#include <string.h>
#include <errno.h>
#include <sys/types.h>
#include <sys/stat.h>

#include "utils.h"
#include "communication.h"

int main(void) {
	
	char output[BUFFER_SIZE] = "";

	create_fifo();
	if (fork() == 0) {
		/* listener */
		read_fifo(output);
	} else {
		printf("Hello\n");
		/* write_fifo("test"); */
	}

	printf("%s\n", output);

	return 0;
}

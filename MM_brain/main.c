#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>
#include <string.h>
#include <errno.h>
#include <sys/types.h>
#include <sys/stat.h>

#include "utils.h"
#include "communication.h"

int main(int argc, char *argv[]) {
	
	char output[BUFFER_SIZE] = "";

	create_fifo();
	//write_fifo("test");
	read_fifo(output);

	printf("%s\n", output);

	return 0;
}

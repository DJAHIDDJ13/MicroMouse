all: MM_brain

MM_brain: utils.o communication.o main.o
	gcc -o MM_brain utils.o communication.o main.o

utils.o: utils.c utils.h
	gcc -o utils.o -c utils.c -W -Wall -ansi -pedantic

communication.o: communication.c utils.h communication.h
	gcc -o communication.o -c communication.c -W -Wall -ansi -pedantic

main.o: main.c utils.h communication.h
	gcc -o main.o -c main.c -W -Wall -ansi -pedantic

clean:
	rm -rf *.o

mrproper: clean
	rm -rf MM_brain
			

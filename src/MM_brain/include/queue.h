/*! 
   \file Stack_XY.h
   \author MMteam

   
   \brief Header file to declare the structure and the functions used 
   		  to implement a generic stack.

   \see stack.c

   \date 2020
*/

#ifndef QUEUE_H

#define QUEUE_H

#include <stdlib.h>
#include <stdio.h>
#include <stdbool.h>
#include <stdint.h>

/*    Structure representing a Queue    */

struct oddpair_XY {

	int16_t OX:15; 			  /* The abscissa of the box 
							      in the maze     */
	
	int16_t OY:15; 			  /* The ordinate of the box  
							      in the maze     */

	uint8_t sign:1;			  /* One bit for the signe */
};

typedef struct Cell {

	struct oddpair_XY XY;
	struct Cell* next; /* pointer to next cell */
} *List_XY;

typedef struct {
	
	List_XY head;
	List_XY tail;
} Queue_XY;

/* Here some primitives for the Queue */
/* --------------------------------------------- */

/* Create a oddpair_XY variable */
struct oddpair_XY createOddpair_XY(int16_t OX, int16_t OY, int8_t sign);

/* Initialize a stack */
Queue_XY initQueue_XY();

/* Test if a queue is empty */
bool emptyQueue_XY(Queue_XY queue);

/* Determine the value of the top of the queue */
struct oddpair_XY summitQueue_XY(Queue_XY queue);

/* Push a value into the queue */
void pushQueue_XY(Queue_XY* queue, struct oddpair_XY value);

/* Pop the summit of the queue */
void popQueue_XY(Queue_XY* queue);

/* Free the memory of a queue */
void freeQueue_XY(Queue_XY* queue);

/* Print a queue */
void printQueue_XY(Queue_XY queue);

#endif
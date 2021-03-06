/*!
   \file flood_fill.h
   \author MMteam


   \brief Header file to declare the functions used
   		  to implement the MM brain.

   \details This header file contains only declarations
   			of the functions.

   	\see flood_fill.c

   \date 2020
*/

#ifndef FLOOD_FILL_H

#define FLOOD_FILL_H

#include <maze.h>
#include <micromouse.h>
#include <queue.h>
#include <stdint.h>

/* Fill a case of the maze with a color */
void fill(struct Maze maze, int16_t OX, int16_t OY, int16_t color);

/* Push the destination boxs of the maze to the queue */
void pushDestinationBoxs(Queue_XY* queue, int16_t OX, int16_t OY);

/* The FloodFill algorithm */
void floodFill(struct Maze maze, int16_t OX, int16_t OY);

/* Backward flood fill algorithm */
Queue_XY backwardFloodFill(struct Maze maze, int16_t OX, int16_t OY);

#endif

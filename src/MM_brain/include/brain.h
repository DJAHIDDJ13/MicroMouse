/*! 
   \file brain.h
   \author MMteam

   
   \brief Header file to declare the functions used 
   		  to implement the MM brain.

   \details This header file contains only declarations 
   			of the functions.

   	\see brain.c

   \date 2020
*/

#ifndef BRAIN_H

#define BRAIN_H

#include <maze.h>
#include <micromouse.h>
#include <queue.h>
#include <stdint.h>

/* Fill a case of the maze with a color */
void fill(struct Maze maze, int16_t OX, int16_t OY, int16_t color);

/* Flood fill algorithm */
void flooFill(struct Maze maze, int16_t OX, int16_t OY);

#endif
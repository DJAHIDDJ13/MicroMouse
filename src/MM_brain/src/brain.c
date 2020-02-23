/*! 
   \file brain.c
   \author MMteam

   
   \brief This file contains the implementation
   		  of the different MM brain function
   		  such as flood fill algorithm.

   \see brain.h

   \date 2020
*/

#include <brain.h>

/* Fill a case of the maze with a color */
void fill(struct Maze maze, int16_t OX, int16_t OY, int16_t color) {
	int16_t size = maze.size;

	if((OX < 0 || OX >= size) || (OY < 0 || OY >= size)) {
		printf("fill:invalide file entering %s %d\n", __FUNCTION__, __LINE__);
		exit(0);
	}

	maze.maze[OY*size+OX].value = color;
}

/* Flood fill algorithm */
void flooFill(struct Maze maze, int16_t OX, int16_t OY) {

	struct Box* boxs = maze.maze;
	int16_t size = maze.size;

	if(boxs == NULL) {
		printf("flooFill:invalide file entering %s %d\n", __FUNCTION__, __LINE__);
		exit(0);
	}

	int16_t colorMaze = 0;

	Queue_XY queue = initQueue_XY();
	
	struct oddpair_XY XY = createOddpair_XY(OX, OY, 0);
	pushQueue_XY(&queue, XY);
	uint8_t sign = 0;

	while(!emptyQueue_XY(queue)) {
		XY = summitQueue_XY(queue);
		popQueue_XY(&queue);
		
		if(XY.sign != sign) {
			sign = XY.sign;
			colorMaze++;
		}
		fill(maze, XY.OX, XY.OY, colorMaze);

		//Top neighbour, check if ther is no wall
		if(!X_TH_wallCheck(BOX_TOP_SIDE, boxs[(XY.OY)*size+XY.OX]) 
			&& boxs[(XY.OY-1)*size+XY.OX].value == -1 && boxs[(XY.OY-1)*size+XY.OX].value != -2) {
		
			pushQueue_XY(&queue, createOddpair_XY(XY.OX, XY.OY-1, 1 - XY.sign));
			boxs[(XY.OY-1)*size+XY.OX].value = -2;
		}

		//Bottom neighbour, check if ther is no wall
		if(!X_TH_wallCheck(BOX_BOTTOM_SIDE, boxs[(XY.OY)*size+XY.OX]) 
			&& boxs[(XY.OY+1)*size+XY.OX].value == -1 && boxs[(XY.OY+1)*size+XY.OX].value != -2) {
		
			pushQueue_XY(&queue, createOddpair_XY(XY.OX, XY.OY+1, 1 - XY.sign));
			boxs[(XY.OY+1)*size+XY.OX].value = -2;
		}

		//Left neighbour, check if ther is no wall
		if(!X_TH_wallCheck(BOX_LEFT_SIDE, boxs[XY.OY*size+(XY.OX)]) 
			&& boxs[XY.OY*size+(XY.OX-1)].value == -1 && boxs[XY.OY*size+(XY.OX-1)].value != -2) {
			
			pushQueue_XY(&queue, createOddpair_XY(XY.OX-1, XY.OY, 1 - XY.sign));
			boxs[XY.OY*size+(XY.OX-1)].value = -2;
		}

		//Right neighbour, check if ther is no wall
		if(!X_TH_wallCheck(BOX_RIGHT_SIDE, boxs[XY.OY*size+(XY.OX)]) 
			&& boxs[XY.OY*size+(XY.OX+1)].value == -1 && boxs[XY.OY*size+(XY.OX+1)].value != -2) {
			
			pushQueue_XY(&queue, createOddpair_XY(XY.OX+1, XY.OY, 1 - XY.sign));
			boxs[XY.OY*size+(XY.OX+1)].value = -2;
		}
	}

	freeQueue_XY(&queue);
}

/* Backward flood fill algorithm */
Queue_XY backwardFloodFill(struct Maze maze, int16_t OX, int16_t OY) {
	
	struct Box* boxs = maze.maze;
	int16_t size = maze.size;

	if(boxs == NULL) {
		printf("flooFill:invalide file entering %s %d\n", __FUNCTION__, __LINE__);
		exit(0);
	}

	Queue_XY queue = initQueue_XY();
	struct Box box = boxs[OY*size+OX];
	pushQueue_XY(&queue, createOddpair_XY(OX, OY, 1));

	while (box.value != 0) {
		box = minValueNeighbour(maze, OX, OY);

		if(box.value == INT16_MAX)
			break;

		pushQueue_XY(&queue, createOddpair_XY(box.OX, box.OY, 1));

		OX = box.OX;
		OY = box.OY;
	}

	return queue;
}
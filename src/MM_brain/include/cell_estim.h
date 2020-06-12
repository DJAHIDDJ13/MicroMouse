#ifndef CELL_ESTIM_H
#define CELL_ESTIM_H

#include <maze.h>
#include <box.h>

extern struct timeval cur_celltime, prevtime;

enum wall_position{NoWall = -1, WallTop = 3, WallBottom = 4, WallLeft = 9, WallRight = 16};

typedef struct {
   iVec2 cell_pos;
   enum wall_indicator wall_pos;
   char wall_present;
} WallPosition;

void init_cell(struct Micromouse* status);
void update_cell(struct Micromouse* status);
void detect_wall(struct Micromouse status);
void vote_for_walls(struct Micromouse status, struct Maze* logical_maze, int **vote_table, int threshold);
//int **init_vote_array(int size);
int **init_vote_array(int** prev, int size);
void display_logical_maze(struct Micromouse status, int threshold, int **vote_table);
/* utils */
float float_abs(float val);
#endif

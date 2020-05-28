#ifndef CELL_ESTIM_H
#define CELL_ESTIM_H

extern struct timeval cur_celltime, prevtime;

enum wall_position{NoWall = -1, WallTop = 3, WallBottom = 4, WallLeft = 9, WallRight = 16};

typedef struct {
   iVec2 cell_pos;
   enum wall_position wall_pos;
} WallPosition;

void init_cell(struct Micromouse* status);
void update_cell(struct Micromouse* status);
WallPosition* detect_wall(struct Micromouse status);
void vote_for_walls(WallPosition *detected_walls, int **vertical_walls, int **horizontal_walls);
void display_logical_maze(struct Micromouse status, int threshold, int **vertical_walls, int **horizontal_walls);
/* utils */
float float_abs(float val);
#endif

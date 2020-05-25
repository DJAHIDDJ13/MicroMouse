#ifndef CELL_ESTIM_H
#define CELL_ESTIM_H

extern struct timeval cur_celltime, prevtime;

enum wall_position{NoWall, WallTop, WallRight, WallBottom, WallLeft};

typedef struct {
   iVec2 cell_pos;
   enum wall_position wall_pos;
} WallPosition;

void init_cell(struct Micromouse* status);
void update_cell(struct Micromouse* status);
WallPosition* detect_wall(struct Micromouse status);
/* utils */
float float_abs(float val);
#endif

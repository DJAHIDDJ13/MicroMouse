#ifndef CELL_ESTIM_H
#define CELL_ESTIM_H

extern struct timeval cur_celltime, prevtime;

iVec2 init_cell(struct Micromouse status);
iVec2 update_cell(struct Micromouse status);

#endif

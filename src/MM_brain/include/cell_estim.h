#ifndef CELL_ESTIM_H
#define CELL_ESTIM_H

extern struct timeval cur_celltime, prevtime;

void init_cell(struct Micromouse* status);
void update_cell(struct Micromouse* status);
#endif

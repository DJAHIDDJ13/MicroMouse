#ifndef CONTROL_H
#define CONTROL_H


float calc_error(struct Micromouse status);
void update_controller(struct Micromouse* status, float time_step);
void update_control(struct Micromouse* status, float time_step);
#endif 

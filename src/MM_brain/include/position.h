#ifndef POS_H
#define POS_H

#include "micromouse.h"

void init_pos(Vec3 i_pos, Vec3 i_vel, Vec3 i_acc, 
              Vec3 i_ang, Vec3 i_ang_vel, Vec3 i_ang_acc,
              struct Micromouse* status);
void update_pos(struct Micromouse* m);
#endif

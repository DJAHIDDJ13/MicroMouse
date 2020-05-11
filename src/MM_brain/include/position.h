#ifndef POS_H
#define POS_H
#include "micromouse.h"

struct Position {
   Vec3 pos;
   Vec3 ang; // yaw, pitch, roll
};

// extern struct Position cur, prev;


struct Position init_pos(Vec3 i_pos, Vec3 i_vel, Vec3 i_acc,
                         Vec3 i_ang, Vec3 i_ang_vel, Vec3 i_ang_acc, float time_step);

struct Position update_pos(struct Micromouse m, float time_step);

#endif

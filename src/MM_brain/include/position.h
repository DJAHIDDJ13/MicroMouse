#ifndef POS_H
#define POS_H
#include "micromouse.h"

struct Position {
   Vec pos;
   Vec ang; // yaw, pitch, roll
};

extern struct Position cur, prev;


struct Position init_pos(Vec i_pos, Vec i_vel, Vec i_acc,
                         Vec i_ang, Vec i_ang_vel, Vec i_ang_acc, float time_step);

struct Position update_pos(struct Micromouse m, float time_step);

#endif

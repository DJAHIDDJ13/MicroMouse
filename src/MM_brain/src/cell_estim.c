#include <stdio.h>
#include <stdlib.h>
#include <time.h>
#include <sys/time.h>

#include <micromouse.h>
#include <position.h>
#include <communication.h>
// TODO: send this in communication
#define BOX_SIZE 10.0

iVec2 cur;
struct Position estim;
struct timeval curtime, prevtime;

iVec2 init_cell(HeaderData init)
{
   Vec3 i_pos = {.x = init.initial_x, .y = init.initial_y, .z = 0};
   Vec3 i_vel = {.x = 0, .y = 0, .z = 0};
   Vec3 i_acc = {.x = 0, .y = 0, .z = 0};

   Vec3 i_ang     = {.x = 0, .y = 0, .z = init.initial_angle};
   Vec3 i_ang_vel = {.x = 0, .y = 0, .z = 0};
   Vec3 i_ang_acc = {.x = 0, .y = 0, .z = 0};

   float time_step = 16.66666f;

   estim = init_pos(i_pos, i_vel, i_acc, i_ang, i_ang_vel, i_ang_acc, time_step);

   cur.x = estim.pos.x / BOX_SIZE;
   cur.y = estim.pos.y / BOX_SIZE;

   gettimeofday(&curtime, NULL);

   return cur;
}

iVec2 update_cell(struct Micromouse status)
{
   prevtime = curtime;
   gettimeofday(&curtime, NULL);

   float mdiff = (1e6 * (curtime.tv_sec - prevtime.tv_sec) + curtime.tv_usec - prevtime.tv_usec) / 1000.0f;
   estim = update_pos(status, mdiff);

   cur.x = estim.pos.x / BOX_SIZE;
   cur.y = estim.pos.y / BOX_SIZE;

   return cur;
}

#include <stdio.h>
#include <stdlib.h>
#include <time.h>
#include <sys/time.h>

#include <micromouse.h>
#include <position.h>
#include <communication.h>
// TODO: send this in communication
// #define BOX_SIZE 10.0

iVec2 cur_cell;
struct Position estim;
struct timeval cur_celltime, prevtime;

iVec2 init_cell(struct Micromouse status)
{
   Vec3 i_pos = {.x = status.header_data.initial_x, .y = status.header_data.initial_y, .z = 0};
   Vec3 i_vel = {.x = 0, .y = 0, .z = 0};
   Vec3 i_acc = {.x = 0, .y = 0, .z = 0};

   Vec3 i_ang     = {.x = 0, .y = 0, .z = status.header_data.initial_angle};
   Vec3 i_ang_vel = {.x = 0, .y = 0, .z = 0};
   Vec3 i_ang_acc = {.x = 0, .y = 0, .z = 0};

   float time_step = 0.0f;

   estim = init_pos(i_pos, i_vel, i_acc, i_ang, i_ang_vel, i_ang_acc, time_step);
   
   cur_cell.x = (estim.pos.x - status.header_data.initial_x) / status.header_data.box_width;
   cur_cell.y = (estim.pos.y - status.header_data.initial_y) / status.header_data.box_width;

   gettimeofday(&cur_celltime, NULL);

   return cur_cell;
}

iVec2 update_cell(struct Micromouse status)
{
   prevtime = cur_celltime;
   gettimeofday(&cur_celltime, NULL);

   float mdiff = (1e6 * (cur_celltime.tv_sec - prevtime.tv_sec) + cur_celltime.tv_usec - prevtime.tv_usec) / 1000.0f;
   estim = update_pos(status, mdiff);

   //printf("\ncur_cellrent position estimation: %g, %g, %g\n", estim.pos.x, estim.pos.y, estim.pos.z);
   //printf("cur_cellrent angle estimation: %g, %g, nn%g\n\n", estim.ang.x, estim.ang.y, estim.ang.z);
   //cur_cell.x = estim.pos.x / status.header_data.box_width;
   //cur_cell.y = estim.pos.y / status.header_data.box_width;
   cur_cell.x = (estim.pos.x - status.header_data.initial_x) / status.header_data.box_width;
   cur_cell.y = (estim.pos.y - status.header_data.initial_y) / status.header_data.box_width;

   return cur_cell;
}

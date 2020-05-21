#include <stdio.h>
#include <stdlib.h>
#include <time.h>
#include <sys/time.h>

#include <micromouse.h>
#include <position.h>
#include <communication.h>

// time vals to track the time step more accurately
struct timeval cur_celltime, prevtime;

void init_cell(struct Micromouse* status)
{
   // initializing the timevals
   gettimeofday(&cur_celltime, NULL);
   
   // setting the initial values are static at the initial coordinates
   Vec3 i_pos = {.x = status->header_data.initial_x, .y = status->header_data.initial_y, .z = 0};
   Vec3 i_vel = {.x = 0, .y = 0, .z = 0};
   Vec3 i_acc = {.x = 0, .y = 0, .z = 0};

   // same for the angles with the initial yaw value
   Vec3 i_ang     = {.x = 0, .y = 0, .z = status->header_data.initial_angle};
   Vec3 i_ang_vel = {.x = 0, .y = 0, .z = 0};
   Vec3 i_ang_acc = {.x = 0, .y = 0, .z = 0};

   // set the first time step to 0 and initialize the position estimator
   status->time_step = 0.0f;
   init_pos(i_pos, i_vel, i_acc, i_ang, i_ang_vel, i_ang_acc, status);
   
   // get the cell estimation
   status->cur_cell.x = 1 + (status->header_data.origin_x - status->cur_pose.pos.x) / status->header_data.box_width;
   status->cur_cell.y = (status->header_data.origin_y - status->cur_pose.pos.y) / status->header_data.box_height;
}

void update_cell(struct Micromouse* status)
{
   // updating the previous timeval and getting the new value
   prevtime = cur_celltime;
   gettimeofday(&cur_celltime, NULL);

   // calculating the value in ms, (second difference * 100,000 + microsecond diff) / 1000
   float mdiff = (1e6 * (cur_celltime.tv_sec - prevtime.tv_sec) + 
                         cur_celltime.tv_usec - prevtime.tv_usec) / 1000.0f;
   // setting the diff as the time_step
   status->time_step = mdiff;
   
   update_pos(status);

   // get the cell estimation
   status->cur_cell.x = 1 + (status->header_data.origin_x - status->cur_pose.pos.x) / status->header_data.box_width;
   status->cur_cell.y = (status->header_data.origin_y - status->cur_pose.pos.y) / status->header_data.box_height;
}

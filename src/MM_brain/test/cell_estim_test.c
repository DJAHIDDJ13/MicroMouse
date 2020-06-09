#include <stdio.h>
#include <sys/time.h>
#include <math.h>

#include "position.h"
#include "micromouse.h"

int main(int argc, const char *argv[])
{
   // the test is passed initially
   int verif = 1;

   // fixed time step of 60FPS
   const float time_step = 1000 / 60; // 16.66666ms

   // initialize the estimator 
   Vec3 i_pos = {.x = 0, .y = 0, .z = 0};
   Vec3 i_vel = {.x = 0, .y = 0, .z = 0};
   Vec3 i_acc = {.x = 0, .y = 0, .z = 0};

   Vec3 i_ang = {.x = 0, .y = 0, .z = 0};
   Vec3 i_ang_vel = {.x = 0, .y = 0, .z = 0};
   Vec3 i_ang_acc = {.x = 0, .y = 0, .z = 0};

   struct Micromouse status = {
      .sensor_data = {
         .gyro = {
            .xyz = {0, 0, 0},
            .ypr = {0, 0, 0}
         }
      },
      .time_step = time_step
   };
 
   init_pos(i_pos, i_vel, i_acc, i_ang, i_ang_vel, i_ang_acc, &status);

   /** 
    * Test the angle estimation
    */
   // dummy gyroscope angle 1 radians/sec for 1 sec or 60 time steps
   status.sensor_data.gyro.ypr.z = 1;

   int num_time_steps = (int) (1000 / time_step); // should be 60
   for (int i = 0; i < num_time_steps; i++) {
       update_pos(&status);
   }

   // We verify that the estimated angle is actually 1
   if(fabs(status.cur_pose.ang.z - 1) < 0.01)
      verif = 0;

   // reset
   status.sensor_data.gyro.ypr.z = 0;

   // we use the return value as the verification
   return !verif;
}

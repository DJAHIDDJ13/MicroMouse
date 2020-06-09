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
   const float time_step = 1000.0f / 60.0f; // 16.66666ms
   printf("%g\n", time_step);
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

   printf("Init: %g\n", status.cur_pose.ang.z);
   int num_time_steps = (int) (1000 / time_step); // should be 60

   for (int i = 0; i < num_time_steps; i++) {
      printf("Going on 1rad/s: %g\n", status.cur_pose.ang.z);
      update_pos(&status);
   }

   printf("Verifying %g = 1\n", status.cur_pose.ang.z);

   // We verify that the estimated angle is actually 1
   if(fabs(status.cur_pose.ang.z - 1) > 0.1) {
      verif = 0;
   }

   // dummy gyroscope angle -1 radians/sec for 1 sec or 60 time steps
   status.sensor_data.gyro.ypr.z = -1;

   for (int i = 0; i < num_time_steps; i++) {
      printf("Going back %g\n", status.cur_pose.ang.z);
      update_pos(&status);
      printf("Verifying %g = 0, %g\n", status.cur_pose.ang.z, fabs(status.cur_pose.ang.z));
   }


   // return back to 0
   // We verify that the estimated angle is actually 1
   if(fabs(status.cur_pose.ang.z) > 0.1) {
      verif = 0;
   }

   // reset
   status.sensor_data.gyro.ypr.z = 0;

   // we use the return value as the verification
   return !verif;
}

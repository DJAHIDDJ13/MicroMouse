#include <stdio.h>
#include <sys/time.h>
#include <math.h>

#include "position.h"
#include "micromouse.h"

int main(int argc, const char *argv[])
{
   struct Position estim;

   Vec3 i_pos = {.x = 0, .y = 0, .z = 0};
   Vec3 i_vel = {.x = 0, .y = 0, .z = 0};
   Vec3 i_acc = {.x = 0, .y = 0, .z = 0};

   Vec3 i_ang = {.x = 0, .y = 0, .z = M_PI / 4};
   Vec3 i_ang_vel = {.x = 0, .y = 0, .z = 0};
   Vec3 i_ang_acc = {.x = 0, .y = 0, .z = 0};

   float time_step = 16.66666f;

   estim = init_pos(i_pos, i_vel, i_acc, i_ang, i_ang_vel, i_ang_acc, time_step);
   printf("(%g %g %g), (%g %g %g)\n", estim.pos.x, estim.pos.y, estim.pos.z, estim.ang.x, estim.ang.y, estim.ang.z);

   struct Micromouse x_forward = {
      .gyro = {
         .xyz = {1.0f, 0, 0},
         .ypr = {0, 0, 0}
      }
   };

   struct Micromouse x_2backward = {
      .gyro = {
         .xyz = {-2.0f, 0, 0},
         .ypr = {0, 0, 0}
      }
   };

   struct Micromouse still = {
      .gyro = {
         .xyz = {0, 0, 0},
         .ypr = {0, 0, 0}
      }
   };

   // One forward acceleration on x for one time_step
   estim = update_pos(x_forward, time_step);
   printf("Applying 1m/s^2 on x axis for 1 time_step\n(%g %g %g), (%g %g %g)\n", estim.pos.x, estim.pos.y, estim.pos.z, estim.ang.x, estim.ang.y, estim.ang.z);
   // no acceleration for 10 time_steps
   printf("No acceleration for 10 time steps\n");

   for(int i = 0; i < 10; i++) {
      estim = update_pos(still, time_step);
      printf("(%g %g %g), (%g %g %g)\n", estim.pos.x, estim.pos.y, estim.pos.z, estim.ang.x, estim.ang.y, estim.ang.z);
   }

   // 2 backward acceleration on x for one time_step; This should stop it and
   // make it go backwards
   estim = update_pos(x_2backward, time_step);
   printf("\nApplying -2m/s^2 on x axis for 1 time_step\n(%g %g %g), (%g %g %g)\n", estim.pos.x, estim.pos.y, estim.pos.z, estim.ang.x, estim.ang.y, estim.ang.z);
   // no acceleration for 10 time_steps
   printf("No acceleration for 10 time steps\n");

   for(int i = 0; i < 10; i++) {
      estim = update_pos(still, time_step);
      printf("(%g %g %g), (%g %g %g)\n", estim.pos.x, estim.pos.y, estim.pos.z, estim.ang.x, estim.ang.y, estim.ang.z);
   }

   // 1 forward acceleration on x for one time_step
   estim = update_pos(x_forward, time_step);
   printf("\nApplying 1m/s^2 on x axis for 1 time_step\n(%g %g %g), (%g %g %g)\n", estim.pos.x, estim.pos.y, estim.pos.z, estim.ang.x, estim.ang.y, estim.ang.z);
   // no acceleration for 10 time_steps
   printf("No acceleration for 10 time steps\n");

   for(int i = 0; i < 10; i++) {
      estim = update_pos(still, time_step);
      printf("(%g %g %g), (%g %g %g)\n", estim.pos.x, estim.pos.y, estim.pos.z, estim.ang.x, estim.ang.y, estim.ang.z);
   }

   return 0;
}

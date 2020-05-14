#include <stdio.h>
#include <sys/time.h>
#include <math.h>

#include "micromouse.h"
#include "position.h"

struct Position cur, prev, next;

/**
 * i_pos, i_vel, i_acc: initial position, velocity and acceleration
 * time_step: in milliseconds
 */

struct Position init_pos(Vec3 i_pos, Vec3 i_vel, Vec3 i_acc, Vec3 i_ang, Vec3 i_ang_vel, Vec3 i_ang_acc, float time_step)
{
   double ts = time_step / 1000.0;
   printf("ts = %g\n", ts);
   prev.pos = i_pos;
   prev.ang = i_ang;

   cur.pos.x = i_pos.x + i_vel.x * ts + 0.5f * i_acc.x * ts * ts;
   cur.pos.y = i_pos.y + i_vel.y * ts + 0.5f * i_acc.y * ts * ts;
   cur.pos.z = i_pos.z + i_vel.z * ts + 0.5f * i_acc.z * ts * ts;

   cur.ang.x = i_ang.x + i_ang_vel.x * ts + 0.5f * i_ang_acc.x * ts * ts;
   cur.ang.y = i_ang.y + i_ang_vel.y * ts + 0.5f * i_ang_acc.y * ts * ts;
   cur.ang.z = i_ang.z + i_ang_vel.z * ts + 0.5f * i_ang_acc.z * ts * ts;

   printf("\nCurrent1* position displacement: %g, %g, %g\n", cur.pos.x, cur.pos.y, cur.pos.z);
   printf("Current angle: %g, %g, %g\n\n", cur.ang.x, cur.ang.y, cur.ang.z);
 
   return cur;
}


/**
 * m: micrmouse struct containing the gyroscope values
 * time_step: in milliseconds
 */
struct Position update_pos(struct Micromouse m, float time_step)
{
   printf("\nCurrent2* position displacement: %g, %g, %g\n", cur.pos.x, cur.pos.y, cur.pos.z);
   printf("Current angle: %g, %g, %g\n\n", cur.ang.x, cur.ang.y, cur.ang.z);
   // ms to s
   double ts = time_step / 1000.0;

   // 2nd degree integral of the angular acceleration
   // https://en.wikipedia.org/wiki/Verlet_integration#Basic_St%C3%B6rmer%E2%80%93Verlet
   next.ang.x = 2 * cur.ang.x - prev.ang.x + m.gyro.ypr.x * ts * ts;
   next.ang.y = 2 * cur.ang.y - prev.ang.y + m.gyro.ypr.y * ts * ts;
   next.ang.z = 2 * cur.ang.z - prev.ang.z + m.gyro.ypr.z * ts * ts;

   // perform 3d rotation
   // the displacement estimate
   next.pos.x = cur.pos.x - prev.pos.x + m.gyro.xyz.x * ts * ts;
   next.pos.y = cur.pos.y - prev.pos.y + m.gyro.xyz.y * ts * ts;
   next.pos.z = cur.pos.z - prev.pos.z + m.gyro.xyz.z * ts * ts;

 
   printf("\nCurrent position displacement: %g, %g, %g\n", next.pos.x, next.pos.y, next.pos.z);
   printf("Current angle: %g, %g, %g\n\n", next.ang.x, next.ang.y, next.ang.z);
   // applying the z axis rotation
   /**
    * θ rotation in z axis,
    *
    * [cosθ, −sinθ, 0]   [x]
    * |sinθ,  cosθ, 0| * |y|
    * [0   ,     0, 1]   [z]
    */

   next.pos.x = next.pos.x * cos(next.ang.z) - next.pos.y * sin(next.ang.z);
   next.pos.y = next.pos.x * sin(next.ang.z) + next.pos.y * cos(next.ang.z);
   next.pos.z = next.pos.z;

   printf("Current position after rotation: %g, %g, %g\n", next.pos.x, next.pos.y, next.pos.z);
   printf("Current angle: %g, %g, %g\n", next.ang.x, next.ang.y, next.ang.z);
   // adding the current estimate
   next.pos.x += cur.pos.x;
   next.pos.y += cur.pos.y;
   next.pos.z += cur.pos.z;
   printf("Current position plus: %g, %g, %g\n", next.pos.x, next.pos.y, next.pos.z);
   printf("Current angle: %g, %g, %g\n", next.ang.x, next.ang.y, next.ang.z);
 
   prev = cur;
   cur = next;

   printf("current time step: %gms\n", ts);
   return next;
}


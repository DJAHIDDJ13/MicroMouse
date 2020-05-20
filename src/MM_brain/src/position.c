#include <stdio.h>
#include <sys/time.h>
#include <math.h>

#include "micromouse.h"
#include "position.h"

struct Position cur, prev;//, next;
float prev_enc[2] = {0};
/**
 * i_pos, i_vel, i_acc: initial position, velocity and acceleration
 * time_step: in milliseconds
 */

struct Position init_pos(Vec3 i_pos, Vec3 i_vel, Vec3 i_acc, Vec3 i_ang, Vec3 i_ang_vel, Vec3 i_ang_acc, float time_step)
{
   double ts = time_step / 1000.0;
   printf("ts = %g\n", ts);
   
   prev.pos = i_pos;
   //prev.ang = i_ang;

   prev.pos.x = i_pos.x + i_vel.x * ts + 0.5f * i_acc.x * ts * ts;
   prev.pos.y = i_pos.y + i_vel.y * ts + 0.5f * i_acc.y * ts * ts;
   prev.pos.z = i_pos.z + i_vel.z * ts + 0.5f * i_acc.z * ts * ts;

   prev.ang.x = i_ang.x + i_ang_vel.x * ts + 0.5f * i_ang_acc.x * ts * ts;
   prev.ang.y = i_ang.y + i_ang_vel.y * ts + 0.5f * i_ang_acc.y * ts * ts;
   prev.ang.z = i_ang.z + i_ang_vel.z * ts + 0.5f * i_ang_acc.z * ts * ts;

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
   // ms to s
   double ts = time_step / 1000.0;


   // 2nd degree integral of the angular acceleration
   // https://en.wikipedia.org/wiki/Verlet_integration#Basic_St%C3%B6rmer%E2%80%93Verlet
//   next.ang.x = 2 * cur.ang.x - prev.ang.x + m.sensor_data.gyro.ypr.x * ts * ts;
//   next.ang.y = 2 * cur.ang.y - prev.ang.y + m.sensor_data.gyro.ypr.y * ts * ts;
   cur.ang.z = prev.ang.z +  m.sensor_data.gyro.ypr.z * ts;
   if(cur.ang.z > 2 * M_PI || cur.ang.z < 0)
      cur.ang.z = fmod(cur.ang.z + 2*M_PI, 2*M_PI);
   
   float displacement = ((m.sensor_data.encoders[0] - prev_enc[0]) + (m.sensor_data.encoders[1] - prev_enc[1])) / 2;
   displacement = displacement / m.header_data.lines_per_revolution * m.header_data.wheel_circumference;
   
   cur.pos.x = prev.pos.x + displacement * cos(cur.ang.z);
   cur.pos.y = prev.pos.y + displacement * sin(cur.ang.z);

   prev_enc[0] = m.sensor_data.encoders[0];
   prev_enc[1] = m.sensor_data.encoders[1];

//   printf("Angle estimate: %g, %g, %g, %g\n", cur.ang.x, cur.ang.y, cur.ang.z,fmod(-1,2));
//   printf("Position estimate: %g, %g, %g\n", cur.pos.x, cur.pos.y, cur.pos.z); 
   
   prev = cur;
   return cur;
}


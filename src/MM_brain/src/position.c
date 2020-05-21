#include <stdio.h>
#include <sys/time.h>
#include <math.h>

#include "micromouse.h"
#include "position.h"

/**
 * i_pos, i_vel, i_acc: initial position, velocity and acceleration
 * status: the micromouse data
 */
void init_pos(Vec3 i_pos, Vec3 i_vel, Vec3 i_acc, 
              Vec3 i_ang, Vec3 i_ang_vel, Vec3 i_ang_acc,
              struct Micromouse* status)
{
   // ms to s
   float ts = status->time_step / 1000.0f;
   
   status->prev_pose.pos.x = i_pos.x + i_vel.x * ts + 0.5f * i_acc.x * ts * ts;
   status->prev_pose.pos.y = i_pos.y + i_vel.y * ts + 0.5f * i_acc.y * ts * ts;
   status->prev_pose.pos.z = i_pos.z + i_vel.z * ts + 0.5f * i_acc.z * ts * ts;

   status->prev_pose.ang.x = i_ang.x + i_ang_vel.x * ts + 0.5f * i_ang_acc.x * ts * ts;
   status->prev_pose.ang.y = i_ang.y + i_ang_vel.y * ts + 0.5f * i_ang_acc.y * ts * ts;
   status->prev_pose.ang.z = i_ang.z + i_ang_vel.z * ts + 0.5f * i_ang_acc.z * ts * ts;
}


/**
 * m: micrmouse struct containing the micro mouse data
 */
void update_pos(struct Micromouse* m)
{
   // ms to s
   float ts = m->time_step / 1000.0f;

   m->cur_pose.ang.x = m->prev_pose.ang.x +  m->sensor_data.gyro.ypr.x * ts;
   m->cur_pose.ang.y = m->prev_pose.ang.y +  m->sensor_data.gyro.ypr.y * ts;
   m->cur_pose.ang.z = m->prev_pose.ang.z +  m->sensor_data.gyro.ypr.z * ts;
   
   // normalize to [0, 2*PI]
   if(m->cur_pose.ang.z > 2 * M_PI || m->cur_pose.ang.z < 0)
      m->cur_pose.ang.z = fmod(m->cur_pose.ang.z + 2*M_PI, 2*M_PI);
   
   // taking the average of the encoder values as the vehicle's displacement value in lines
   float displacement = ((m->sensor_data.encoders[0] - m->prev_enc[0]) + 
                         (m->sensor_data.encoders[1] - m->prev_enc[1])) / 2;

   // converting encoder lines to revolutions and then to length
   displacement = displacement / m->header_data.lines_per_revolution * m->header_data.wheel_circumference;
   
   // finding the displacement
   m->cur_pose.pos.x = m->prev_pose.pos.x + displacement * cos(m->cur_pose.ang.z);
   m->cur_pose.pos.y = m->prev_pose.pos.y + displacement * sin(m->cur_pose.ang.z);
   m->cur_pose.pos.z = 0;
   
   // updating the previous encoder values
   m->prev_enc[0] = m->sensor_data.encoders[0];
   m->prev_enc[1] = m->sensor_data.encoders[1];
 
   // updating the previous pose value
   m->prev_pose = m->cur_pose;
}


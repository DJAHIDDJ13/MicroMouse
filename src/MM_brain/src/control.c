#include "micromouse.h"
#include "cell_estim.h"
#include <time.h>
#include <sys/time.h>
#include <math.h>
#include <stdio.h>

#define BASE_SPEED 150
#define TURNING_LENGTH_THRESHOLD 700
#define MAX_SPEED 500

float PID(struct Micromouse* status, float err,
         const float Kp, const float Ki, const float Kd,
         char reset) 
{
   static float old_err = 0.0f, cumul_err = 0.0f;
   
   if(reset > 0) {
      old_err = 0.0f;
      cumul_err = 0.0f;
   }

   // updating the derivative
   float derivative = (err - old_err) / status->time_step;
   /* Maybe necessary when there is significant noise
   // applying a low pass filter
   float N = 10; // low pass filter strength
   fwd_derivative = N / (1 + N * (1 / fwd_derivative)); */

   // integral
   float integral = cumul_err * status->time_step;
   
   // output
   float out = Kp * err + Kd * derivative + Ki * integral;

   old_err = err;
   cumul_err = fmin(err, MAX_SPEED);

   return out;
}

enum ControlState {DEFAULT, MOVE_FWD, TURN_BACK, TURN_DIST, TURN_POS} control_state;

void turn_back_PID(struct Micromouse* status, int init)
{
/*   static float init_ang = 0;
   static float init_enc[NB_ENCODER];
   static float prev_middle = 0;
   if(init) {
      init_ang = M_PI_2 * round(status->cur_pose.ang.z / (M_PI_2));
      init_enc[0] = status->prev_enc[0];
      init_enc[1] = status->prev_enc[1];
   }
   
   float right_sensor = status->sensor_data.sensors[1],
         left_sensor = status->sensor_data.sensors[2],
         right_middle_sensor = status->sensor_data.sensors[0],
         left_middle_sensor = status->sensor_data.sensors[3];

   float ang_diff = M_PI - (init_ang - status->cur_pose.ang.z);
   float diff_enc = (status->prev_enc[0] - init_enc[0]) - (status->prev_enc[1] - init_enc[1]);
   printf("Init ang %g, And diff %g, Init enc %g, %g, Enc diff = %g\n", init_ang, ang_diff, init_enc[0], init_enc[1], diff_enc);
  */ 
   printf("NEED TO GO BACK\n");
   // NO CHOICE HERE
   // Go backwards until threshold is cleared then
   // Actually do the turning until it's over
   /*
   // Exit condition in case there isn't really a dead end
   if((left_middle_sensor > 320 || right_middle_sensor > 320) &&
      (left_sensor > TURNING_LENGTH_THRESHOLD || right_sensor > TURNING_LENGTH_THRESHOLD)) 
   {
      control_state = TURN_DIST;
   }
   float ang_dist = fmin(fabs(2*M_PI - status->cur_pose.ang.z - init_ang), 
                         fabs(status->cur_pose.ang.z - init_ang));
   if(fabs(ang_diff) > M_PI || (left_middle_sensor > 700 && right_middle_sensor > 700)) {
      control_state = DEFAULT;
   }
*/
   /*if(fabs(right_middle_sensor - 400) < 100 && fabs(left_middle_sensor - 400) < 100) {
      init_enc[0] = status->prev_enc[0];
      init_enc[1] = status->prev_enc[1];
   }*/
/*
   float err1 = 0.0f, err2 = 0.0f;
   float Kp = 1, Kd = 1000, Ki = 0.0f;
   
   float speed = (right_middle_sensor + left_middle_sensor) / 2 - prev_middle;

   if(left_middle_sensor > 300 && right_middle_sensor > 300 || speed > 1) {
      printf("TOO FAST\n");
      err1 = -10 * speed;
      err2 = -10 * speed; 
   } else if(left_middle_sensor < 300 && right_middle_sensor < 300) {
      printf("TOO CLOSE\n");
      err1 = -left_middle_sensor/2;
      err2 = -right_middle_sensor/2;
   }else if(diff_enc > 100) {
      printf("TOO FAR FROM AXIS\n");
      err1 = diff_enc/10;
      err2 = -diff_enc/10;
   } else {
      printf("TURNING\n");
      err1 = 10 * ang_diff;
      err2 = -10 * ang_diff;
   }
   // calling the general PID function   
   float out1 = PID(status, err1, Kp, Ki, Kd, 0);
   float out2 = PID(status, err2, Kp, Ki, Kd, 0);

   status->engines[0] = out1;
   status->engines[1] = out2; 
   
   prev_middle = (right_middle_sensor + left_middle_sensor) / 2;
   */
   control_state = DEFAULT;
}

void fwd_PID(struct Micromouse* status)
{
   printf("NEED TO GO FORWARD\n");
   // NO CHOICE HERE
   // do one step of moving then back to default state
   
   // Calculating th error
   float right_sensor = status->sensor_data.sensors[1],
         left_sensor = status->sensor_data.sensors[2],
         right_middle_sensor = status->sensor_data.sensors[0],
         left_middle_sensor = status->sensor_data.sensors[3];
   float err = left_sensor - right_sensor;

   if(left_sensor < 0 && right_sensor > 0) {
      err = right_sensor;
   } else if(right_sensor < 0 && left_sensor > 0) {
      err = -left_sensor;
   }

   // calling the general PID function   
   const float Kp = 1.5, Kd = 500, Ki = 0.01;
   float out = PID(status, err, Kp, Ki, Kd, 0);

   // using the output value
   status->engines[0] = BASE_SPEED + out;
   status->engines[1] = BASE_SPEED - out;

   // resetting the control to default
   control_state = DEFAULT;
}


void turn_PID_pos(struct Micromouse* status)
{
   printf("NEED TO TURN USING POS\n");
   // CHOICE HERE: EITHER (LEFT OR RIGHT OR FORWARD) OR (LEFT OR FORWARD) OR (RIGHT OR FORWARD)
   // keep checking for forward sensors while doing the turning
   // if forward found go to dist_turning state
   control_state = DEFAULT;
}

void turn_PID_dist(struct Micromouse* status)
{
   printf("NEED TO TURN USING DIST\n");
   // CHOICE HERE: EITHER (LEFT OR RIGHT) OR (LEFT) OR (RIGHT)
   // Actually do the turning
   control_state = DEFAULT;
}

void update_control(struct Micromouse* status, char init)
{
   if(init) {
      control_state = DEFAULT;
   }

   // first reset previous operation
   status->engines[0] = 0;
   status->engines[1] = 0;
   
   switch(control_state) {
   case TURN_BACK:
      turn_back_PID(status, init);
      return;

   case MOVE_FWD:
      fwd_PID(status);
      return;

   case TURN_POS:
      turn_PID_pos(status);
      return;

   case TURN_DIST:
      turn_PID_dist(status);
      return;

   default:
      break;
   }
   if(((status->sensor_data.sensors[0] > 0 || status->sensor_data.sensors[3] > 0) &&
       (status->sensor_data.sensors[1] < 0 || status->sensor_data.sensors[2] < 0)) ||

      ((status->sensor_data.sensors[0] > 0 || status->sensor_data.sensors[3] > 0) &&
       (status->sensor_data.sensors[1] > TURNING_LENGTH_THRESHOLD || status->sensor_data.sensors[2] > TURNING_LENGTH_THRESHOLD)))

   {
      control_state = TURN_DIST;
      turn_PID_dist(status);
   } else if((status->sensor_data.sensors[0] < 0 || status->sensor_data.sensors[3] < 0) &&
             ((status->sensor_data.sensors[1] < 0 && status->sensor_data.sensors[2] > 0) ||
              (status->sensor_data.sensors[1] > 0 && status->sensor_data.sensors[2] < 0))) {
      control_state = TURN_POS;
      turn_PID_pos(status);
   } else if(status->sensor_data.sensors[0] > 0 &&// status->sensor_data.sensors[0] < 700 &&
             status->sensor_data.sensors[1] > 0 &&// status->sensor_data.sensors[1] < 700 &&
             status->sensor_data.sensors[2] > 0 &&// status->sensor_data.sensors[2] < 700 &&
             status->sensor_data.sensors[3] > 0// && status->sensor_data.sensors[3] < 700 
             ) {
      control_state = TURN_BACK;
      turn_back_PID(status, 1);
   } else {
      control_state = MOVE_FWD;
      fwd_PID(status);
   }
}

#include "micromouse.h"
#include "cell_estim.h"
#include <time.h>
#include <sys/time.h>
#include <math.h>
#include <stdio.h>

#define BASE_SPEED 100
#define TURNING_LENGTH_THRESHOLD 540
#define MAX_SPEED 500
enum ControlState {DEFAULT, MOVE_FWD, TURN_BACK, TURN_DIST, TURN_POS} control_state;
float turn_back_old_err = 0, turn_back_cumul_err = 0;
void turn_back_PID(struct Micromouse* status)
{
   printf("NEED TO GO BACK\n");
   // NO CHOICE HERE
   // Go backwards until threshold is cleared then
   // Actually do the turning until it's over
   control_state = DEFAULT;
  /* float left_sensor = status->sensor_data.sensors[1],
         right_sensor = status->sensor_data.sensors[2],
         left_middle_sensor = status->sensor_data.sensors[0],
         right_middle_sensor = status->sensor_data.sensors[3];
   
   float err = 0.0f;
   if(left_middle_sensor > 0 && left_middle_sensor < 200 &&
      right_middle_sensor > 0 && right_middle_sensor < 200)
   {
      
   }
   
   // updating the derivative
   float turn_back_derivative = (err - turn_back_old_err) / time_step;
   float turn_back_integral = turn_back_cumul_err * time_step;

   const float Kp = 1, Kd = 50, Ki = 0.01;
   float out = Kp * err + Kd * turn_back_derivative + Ki * turn_back_integral;

   status->engines[0] = BASE_SPEED + out;
   status->engines[1] = BASE_SPEED - out;

   turn_back_old_err = err;
   turn_back_cumul_err = fmin(turn_back_cumul_err+err, MAX_SPEED);
   */
}

float fwd_old_err = 0, fwd_cumul_err = 0;
void fwd_PID(struct Micromouse* status)
{
   printf("NEED TO GO FORWARD\n");
   // NO CHOICE HERE
   // do one step of moving then back to default state
   
   // Calculating th error
   float left_sensor = status->sensor_data.sensors[1],
         right_sensor = status->sensor_data.sensors[2],
         left_middle_sensor = status->sensor_data.sensors[0],
         right_middle_sensor = status->sensor_data.sensors[3];
   float err = left_sensor - right_sensor;

   if(left_sensor < 0 && right_sensor > 0) {
      err = right_sensor;
   } else if(right_sensor < 0 && left_sensor > 0) {
      err = -left_sensor;
   }

   // updating the derivative
   float fwd_derivative = (err - fwd_old_err) / status->time_step;
   /* Maybe necessary when there is significant noise
   // applying a low pass filter
   float N = 10; // low pass filter strength
   fwd_derivative = N / (1 + N * (1 / fwd_derivative));
   */
   // integral
   float fwd_integral = fwd_cumul_err * status->time_step;
   
   const float Kp = 1, Kd = 50, Ki = 0.01;
   float out = Kp * err + Kd * fwd_derivative + Ki * fwd_integral;

   status->engines[0] = BASE_SPEED + out;
   status->engines[1] = BASE_SPEED - out;

   fwd_old_err = err;
   fwd_cumul_err = fmin(err, MAX_SPEED);

   control_state = DEFAULT;
}


float turn_init_angle;
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

void update_control(struct Micromouse* status)
{
   // first reset previous operation
   status->engines[0] = 0;
   status->engines[1] = 0;
   
   switch(control_state) {
   case TURN_BACK:
      turn_back_PID(status);
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
   } else if(//(status->sensor_data.sensors[0] < 0 || status->sensor_data.sensors[3] < 0) &&
             ((status->sensor_data.sensors[1] < 0 && status->sensor_data.sensors[2] > 0) ||
              (status->sensor_data.sensors[1] > 0 && status->sensor_data.sensors[2] < 0))) {
      control_state = TURN_POS;
      turn_PID_pos(status);
   } else if(status->sensor_data.sensors[0] > 0 &&
             status->sensor_data.sensors[1] > 0 &&
             status->sensor_data.sensors[2] > 0 &&
             status->sensor_data.sensors[3] > 0) {
      control_state = TURN_BACK;
      turn_back_PID(status);
   } else {
      control_state = MOVE_FWD;
      fwd_PID(status);
   }
}

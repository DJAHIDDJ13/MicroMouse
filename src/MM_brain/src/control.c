#include "micromouse.h"
#include "cell_estim.h"
#include <time.h>
#include <sys/time.h>
#include <math.h>
#include <stdio.h>
/*
float previous_error = 0;
float integral = 0;

float calc_error(struct Micromouse status)
{
   float err;
   float left_sensor = status.sensor_data.sensors[1],
         right_sensor = status.sensor_data.sensors[2],
         left_middle_sensor = status.sensor_data.sensors[0],
         right_middle_sensor = status.sensor_data.sensors[3];

   if(left_sensor < 500 && right_sensor < 500) {
      printf("WALLS ON BOTH SIDES\n");

      if(left_middle_sensor < 500) {
         printf("\tFRONT WALL ON LEFT\n");
      } else if(right_middle_sensor < 500) {
         printf("\tFRONT WALL ON RIGHT\n");
      } else {
         printf("\tNO WALLS IN FRONT\n");
      }

      err = right_sensor - left_sensor - 10 * left_middle_sensor;
   } else if(left_sensor < 500) {
      printf("WALLS ON LEFT SIDE\n");
      err = -5 * (20 - left_sensor);
   } else if(right_sensor < 500) {
      printf("WALLS ON RIGHT SIDE\n");
      err = -5 * (20 - right_sensor);
   } else {
      printf("NO WALLS\n");
      err = 0.0f;
   }

   return err;
}

void update_controller(struct Micromouse* status, float time_step)
{

   time_step = (1e6 * (cur_celltime.tv_sec - prevtime.tv_sec) + cur_celltime.tv_usec - prevtime.tv_usec) / 1000.0f;
   float error = calc_error(*status);
   integral += error * time_step;

   // Limit the integral
   if(integral > 10) { // some max acceleration value
      integral = 10;
   } else if(integral < -10) {
      integral = -10;
   }

   float derivative = (error - previous_error) / time_step;

   const float Kp = 1e-1, Ki = 1e-3, Kd = 1e-1;
   float out = Kp * error + Kd * derivative;// + Ki * integral + Kd * derivative;

   status->engines[0] = 100 + out;
   status->engines[1] = 100 - out;

   previous_error = error;
}
*/

#define BASE_SPEED 100
#define TURNING_LENGTH_THRESHOLD 540
#define MAX_SPEED 500
enum ControlState {DEFAULT, MOVE_FWD, TURN_BACK, TURN_DIST, TURN_POS} control_state;
void turn_back_PID(struct Micromouse* status, float time_step)
{
   printf("NEED TO GO BACK\n");
   // NO CHOICE HERE
   // Go backwards until threshold is cleared then
   // Actually do the turning until it's over
   control_state = DEFAULT;
}
float fwd_old_err = 0, fwd_cumul_err = 0;
void fwd_PID(struct Micromouse* status, float time_step)
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
   float fwd_derivative = (err - fwd_old_err) / time_step;
   float fwd_integral = fwd_cumul_err * time_step;
   printf("integral = %g, old err = %g, derivative = %g\n", fwd_integral, fwd_old_err, fwd_derivative);
   const float Kp = 1, Kd = 50, Ki = 0.01;
   float out = Kp * err + Kd * fwd_derivative + Ki * fwd_integral;

   status->engines[0] = BASE_SPEED + out;
   status->engines[1] = BASE_SPEED - out;

   fwd_old_err = err;
   fwd_cumul_err = fmin(err, MAX_SPEED);

   control_state = DEFAULT;
}


float turn_init_angle;
void turn_PID_pos(struct Micromouse* status, float time_step)
{
   printf("NEED TO TURN USING POS\n");
   // CHOICE HERE: EITHER (LEFT OR RIGHT OR FORWARD) OR (LEFT OR FORWARD) OR (RIGHT OR FORWARD)
   // keep checking for forward sensors while doing the turning
   // if forward found go to dist_turning state
   control_state = DEFAULT;
}

void turn_PID_dist(struct Micromouse* status, float time_step)
{
   printf("NEED TO TURN USING DIST\n");
   // CHOICE HERE: EITHER (LEFT OR RIGHT) OR (LEFT) OR (RIGHT)
   // Actually do the turning
   control_state = DEFAULT;
}

void update_control(struct Micromouse* status, float time_step)
{
   // first reset previous operation
   status->engines[0] = 0;
   status->engines[1] = 0;
   
   time_step = (1e6 * (cur_celltime.tv_sec - prevtime.tv_sec) +
                cur_celltime.tv_usec - prevtime.tv_usec) / 1000.0f;

   switch(MOVE_FWD){//control_state) {
   case TURN_BACK:
      turn_back_PID(status, time_step);
      return;

   case MOVE_FWD:
      fwd_PID(status, time_step);
      return;

   case TURN_POS:
      turn_PID_pos(status, time_step);
      return;

   case TURN_DIST:
      turn_PID_dist(status, time_step);
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
      turn_PID_dist(status, time_step);
   } else if(//(status->sensor_data.sensors[0] < 0 || status->sensor_data.sensors[3] < 0) &&
             ((status->sensor_data.sensors[1] < 0 && status->sensor_data.sensors[2] > 0) ||
              (status->sensor_data.sensors[1] > 0 && status->sensor_data.sensors[2] < 0))) {
      control_state = TURN_POS;
      turn_PID_pos(status, time_step);
   } else if(status->sensor_data.sensors[0] > 0 &&
             status->sensor_data.sensors[1] > 0 &&
             status->sensor_data.sensors[2] > 0 &&
             status->sensor_data.sensors[3] > 0) {
      control_state = TURN_BACK;
      turn_back_PID(status, time_step);
   } else {
      control_state = MOVE_FWD;
      fwd_PID(status, time_step);
   }
}

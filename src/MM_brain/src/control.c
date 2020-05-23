#include "micromouse.h"
#include "cell_estim.h"
#include <time.h>
#include <sys/time.h>
#include <math.h>
#include <stdio.h>

#define BASE_SPEED 300
#define TURNING_LENGTH_THRESHOLD 540
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
   static float init_ang = 0;
   if(init) {
      init_ang = M_PI_2 * round(status->cur_pose.ang.z / (M_PI_2));
   }
   
   printf("Init ang %g\n", init_ang);
   float left_sensor = status->sensor_data.sensors[1],
         right_sensor = status->sensor_data.sensors[2],
         left_middle_sensor = status->sensor_data.sensors[0],
         right_middle_sensor = status->sensor_data.sensors[3];
   float ang_diff = M_PI - (init_ang - status->cur_pose.ang.z);
   
   printf("NEED TO GO BACK\n");
   // NO CHOICE HERE
   // Go backwards until threshold is cleared then
   // Actually do the turning until it's over
   
   float maintain_value = 250;
   float upper_limit = 300;
   // Exit condition in case there isn't really a dead end
   /*if((left_middle_sensor > maintain_value || right_middle_sensor > maintain_value) &&
      (left_sensor > TURNING_LENGTH_THRESHOLD || right_sensor > TURNING_LENGTH_THRESHOLD)) 
   {
      control_state = TURN_DIST;
   }*/
   if(fabs(ang_diff) > M_PI) {
      control_state = DEFAULT;
   }

   float err1 = 0.0f, err2 = 0.0f;
   /*
   if(left_middle_sensor > 0 && left_middle_sensor < maintain_value &&
      right_middle_sensor > 0 && right_middle_sensor < maintain_value)
   {
      err1 = -left_middle_sensor;
      err2 = -right_middle_sensor;
      printf("TOO CLOSE %g, %g\n", err1, err2);
   } else if(left_middle_sensor > upper_limit &&
             right_middle_sensor > upper_limit)
   {
      err1 = -(middle_ground - left_middle_sensor);
      err2 = -(middle_ground - right_middle_sensor );
      printf("TOO FAR %g, %g\n", err1, err2);
   } else {
      err1 = 50 * ang_diff + (middle_ground - right_middle_sensor);
      err2 = -50 * ang_diff + (middle_ground - left_middle_sensor);
      printf("TURNING %g, %g\n", err1, err2);
   }
   */
   if((left_middle_sensor > 0 && (left_middle_sensor < 200 || left_middle_sensor > 400)) ||
      (right_middle_sensor > 0 && (right_middle_sensor < 200 || right_middle_sensor > 400)))
   {
      err1 = -300 + left_middle_sensor;
      err2 = -300 + left_middle_sensor;
   } else {
      err1 = 50 * ang_diff;// + ((left_middle_sensor) - 300) / 3;
      err2 = -50 * ang_diff;// + ((right_middle_sensor) - 300) / 3;
   }
   // calling the general PID function   
   const float Kp = 1, Kd = 1000, Ki = 0.0f;
   float out1 = PID(status, err1, Kp, Ki, Kd, 0);
   float out2 = PID(status, err2, Kp, Ki, Kd, 0);

   status->engines[0] = out1;
   status->engines[1] = out2; 
   
}

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

   // calling the general PID function   
   const float Kp = 1.5, Kd = 1000, Ki = 0.01;
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

void update_control(struct Micromouse* status)
{
   // first reset previous operation
   status->engines[0] = 0;
   status->engines[1] = 0;
   
   switch(control_state) {
   case TURN_BACK:
      turn_back_PID(status, 0);
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
   } else if(status->sensor_data.sensors[0] > 0 && status->sensor_data.sensors[0] < 500 &&
             status->sensor_data.sensors[1] > 0 && status->sensor_data.sensors[1] < 500 &&
             status->sensor_data.sensors[2] > 0 && status->sensor_data.sensors[2] < 500 &&
             status->sensor_data.sensors[3] > 0 && status->sensor_data.sensors[3] < 500 ) {
      control_state = TURN_BACK;
      turn_back_PID(status, 1);
   } else {
      control_state = MOVE_FWD;
      fwd_PID(status);
   }
}

#include "micromouse.h"
#include "cell_estim.h"
#include <time.h>
#include <sys/time.h>
#include <math.h>
#include <stdio.h>

#define BASE_SPEED 20
#define TURNING_LENGTH_THRESHOLD 850
#define MAX_SPEED 40

float PID(struct Micromouse* status, float err,
         const float Kp, const float Ki, const float Kd,
         float *old_err, float *cumul_err) 
{
   // updating the derivative
   float derivative = (err - *old_err) / status->time_step;

   // Maybe necessary when there is significant noise
   // applying a low pass filter
   float N = 10; // low pass filter strength
   derivative = N / (1 + N * (1 / derivative)); 

   // integral
   float integral = *cumul_err * status->time_step;
   printf("derivative = %g, integral = %g\n", derivative, integral);   
   // output
   float out = Kp * err + Kd * derivative + Ki * integral;

   *old_err = err;
   *cumul_err = fmin(fmax(err, -MAX_SPEED), MAX_SPEED);

   return out;
}

enum ControlState {DEFAULT, MOVE_FWD, TURN_BACK, TURN_DIST, TURN_POS} control_state;

void turn_back_PID(struct Micromouse* status, int init)
{
   static float old_err1 = 0.0, old_err2 = 0.0, cumul_err1 = 0.0, cumul_err2 = 0.0;

   static float init_ang = 0;
   if(init) {
      init_ang = M_PI_2 * round(status->cur_pose.ang.z / (M_PI_2));
      old_err1 = old_err2 = cumul_err1 = cumul_err2 = 0.0f;
   }
   
   float right_sensor = status->sensor_data.sensors[1],
         left_sensor = status->sensor_data.sensors[2],
         right_middle_sensor = status->sensor_data.sensors[0],
         left_middle_sensor = status->sensor_data.sensors[3];

   float ang_diff = M_PI - (init_ang - status->cur_pose.ang.z);
   printf("NEED TO GO BACK\n");
   // NO CHOICE HERE
   // Go backwards until threshold is cleared then
   // Actually do the turning until it's over
   // Exit condition in case there isn't really a dead end
   /*if((left_middle_sensor > 320 || right_middle_sensor > 320) &&
      (left_sensor > TURNING_LENGTH_THRESHOLD || right_sensor > TURNING_LENGTH_THRESHOLD)) 
   {
      control_state = TURN_DIST;
   }*/
   float ang_dist = fmin(fabs(2*M_PI - status->cur_pose.ang.z - init_ang), 
                         fabs(status->cur_pose.ang.z - init_ang));
   if(fabs(ang_dist) > 0.9 * M_PI || ((left_middle_sensor > 800 || left_middle_sensor < 0) && (right_middle_sensor > 800 || right_middle_sensor < 0))) {
      control_state = DEFAULT;
   }
   
   float err1 = 0.0f, err2 = 0.0f;
   float Kp = 1, Kd = 1000, Ki = 0.0f;
  
   // calculating the speed for each wheel 
   Vec2 speed = {.x=status->cur_pose.pos.x - status->cur_pose.pos.x,
                 .y=status->cur_pose.pos.y - status->cur_pose.pos.y};
   speed.x = cos(status->cur_pose.ang.z) * speed.x - sin(status->cur_pose.ang.z) * speed.y;
   speed.y = sin(status->cur_pose.ang.z) * speed.x + cos(status->cur_pose.ang.z) * speed.y;

   if((left_middle_sensor < 250 || right_middle_sensor < 250) && 
       left_middle_sensor > 0 && right_middle_sensor > 0) {
      err1 = -right_middle_sensor/100;
      err2 = -left_middle_sensor/100;
   } else if((left_middle_sensor > 300 && right_middle_sensor > 300) || 
             (fabs(speed.x) > 5 || fabs(speed.y) > 5)) {
      err1 = -200*speed.x + right_middle_sensor/100;
      err2 = -200*speed.y + left_middle_sensor/100;
   } else {
      Kd = 0;
      err1 = 30 * ang_diff;
      err2 = -30 * ang_diff;
   }
   // calling the general PID function   
   float out1 = PID(status, err1, Kp, Ki, Kd, &old_err1, &cumul_err1);
   float out2 = PID(status, err2, Kp, Ki, Kd, &old_err2, &cumul_err2);

   status->engines[0] = out1;
   status->engines[1] = out2; 
}

void fwd_PID(struct Micromouse* status)
{
   static float old_err = 0.0, cumul_err = 0.0;
   static int err_counter = 0;
   printf("NEED TO GO FORWARD\n");
   // NO CHOICE HERE
   // do one step of moving then back to default state
   
   // Calculating th error
   float right_sensor = status->sensor_data.sensors[1],
         left_sensor = status->sensor_data.sensors[2],
         right_middle_sensor = status->sensor_data.sensors[0],
         left_middle_sensor = status->sensor_data.sensors[3];
   float err = (left_sensor - right_sensor) / 4;

   printf("\x1b[31m" "ERRROR = %g, err counter = %d\n" "\x1b[0m", err, err_counter);

   if(left_sensor < 0 && right_sensor > 0) {
      err = right_sensor / 4;
   } else if(right_sensor < 0 && left_sensor > 0) {
      err = -left_sensor / 4;
   }

   /**
    * Readjusting the position and angle estimation if the vehicle is moving forward
    */
   if(fabs(err) < 13.0) 
      err_counter++;
   else
      err_counter = 0;

   if(err_counter > 10) {
      printf("\x1b[32m" "Readjusting the estimation ang = %g -> ", status->cur_pose.ang.z);
      int direction = round(status->cur_pose.ang.z / (M_PI_2));
      status->cur_pose.ang.z = M_PI_2 * direction;
      status->prev_pose.ang.z = M_PI_2 * direction;
      printf("%g ", status->cur_pose.ang.z);
      if(direction % 2 == 0) {
         float boxw = status->header_data.box_width;
         printf("posx = %g -> ", status->cur_pose.pos.x);
         status->cur_pose.pos.x = status->header_data.origin_x + boxw * (0.5f + status->cur_cell.x);
         status->prev_pose.pos.x = status->header_data.origin_x + boxw * (0.5f + status->cur_cell.x);

         printf("%g ", status->cur_pose.pos.x);
      } else {
         float boxh = status->header_data.box_height;
         printf("posy = %g -> ", status->cur_pose.pos.y);
         status->cur_pose.pos.y = status->header_data.origin_y + boxh * (0.5f + status->cur_cell.y);
         status->prev_pose.pos.y = status->header_data.origin_y + boxh * (0.5f + status->cur_cell.y);
         printf("%g""\x1b[0m\n", status->cur_pose.pos.y);
      }
      err_counter = 0;
   }
 
   // calling the general PID function   
   const float Kp = .5, Kd = 50, Ki = 0.001;
   float out = PID(status, err, Kp, Ki, Kd, &old_err, &cumul_err);

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

#include "micromouse.h"
#include "cell_estim.h"
#include "brain.h"

#include <time.h>
#include <sys/time.h>
#include <math.h>
#include <stdio.h>

#define BASE_SPEED 20
#define TURNING_LENGTH_THRESHOLD 750
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
////   printf("derivative = %g, integral = %g\n", derivative, integral);
   // output
   float out = Kp * err + Kd * derivative + Ki * integral;

   *old_err = err;
   *cumul_err = fmin(fmax(err, -MAX_SPEED), MAX_SPEED);

   return out;
}

enum ControlState {DEFAULT, MOVE_FWD, TURN_BACK, TURN} control_state;

void turn_back_PID(struct Micromouse* status, int init)
{
   static float old_err1 = 0.0, old_err2 = 0.0, cumul_err1 = 0.0, cumul_err2 = 0.0;

   static float init_ang = 0;

   if(init) {
      init_ang = M_PI_2 * round(status->cur_pose.ang.z / (M_PI_2));
      old_err1 = old_err2 = cumul_err1 = cumul_err2 = 0.0f;
      // TODO: Maybe a smarter way to do the turning
   }

   float right_sensor = status->sensor_data.sensors[1],
         left_sensor = status->sensor_data.sensors[2],
         right_middle_sensor = status->sensor_data.sensors[0],
         left_middle_sensor = status->sensor_data.sensors[3];

   float ang_diff = -M_PI - (init_ang - status->cur_pose.ang.z);
   //printf("NEED TO GO BACK\n");
   // NO CHOICE HERE
   // Go backwards until threshold is cleared then
   // Actually do the turning until it's over
   // Exit condition in case there isn't really a dead end
   
   float ang_dist = fmin(fabs(2 * M_PI - (status->cur_pose.ang.z - init_ang)),
                         fabs(status->cur_pose.ang.z - init_ang));

   if(fabs(ang_dist) > 0.9 * M_PI) {
      control_state = DEFAULT;
   }

   float err1 = 0.0f, err2 = 0.0f;
   float Kp = 1.5, Kd = 500, Ki = 0.0f;

   Vec2 speed = {.x = ((status->cur_pose.pos.x - status->prev_pose.pos.x) * 1000) / status->time_step,
                 .y = ((status->cur_pose.pos.y - status->prev_pose.pos.y) * 1000) / status->time_step
                };
   //printf("Speed = (%g, %g) %g\n", speed.x, speed.y, status->time_step);
   speed.x = cos(status->cur_pose.ang.z) * speed.x - sin(status->cur_pose.ang.z) * speed.y;
   speed.y = sin(status->cur_pose.ang.z) * speed.x + cos(status->cur_pose.ang.z) * speed.y;

   if((left_middle_sensor < 250 || right_middle_sensor < 250) &&
         left_middle_sensor > 0 && right_middle_sensor > 0) {
      err1 = -(350-right_middle_sensor) / 100;
      err2 = -(350-left_middle_sensor) / 100;
   }
   // shouldn't be too fast
   /*else if(fabs(speed.y) > 1) {
      //printf("TOO FAST");
      err1 = -200 * speed.y;
      err2 = -200 * speed.y;
   }*/
   else if(left_middle_sensor > 300 && right_middle_sensor > 300) {
      err1 = right_middle_sensor / 100;
      err2 = left_middle_sensor / 100;
   } else {
      Kd = 0;
      err1 = 50 * ang_diff;
      err2 = -50 * ang_diff;
   }

   // calling the general PID function
   float out1 = PID(status, err1, Kp, Ki, Kd, &old_err1, &cumul_err1);
   float out2 = PID(status, err2, Kp, Ki, Kd, &old_err2, &cumul_err2);

   status->engines[0] = out1;
   status->engines[1] = out2;
}

void readjust_position(struct Micromouse* status, float err, int init)
{
   static int err_counter = 0;

   if(init) {
      err_counter = 0;
   }

   if(fabs(err) < 10.0) {
      err_counter++;
   } else {
      err_counter = 0;
   }

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
         status->cur_pose.pos.y = status->header_data.origin_y - boxh * (0.5f + status->cur_cell.y);
         status->prev_pose.pos.y = status->header_data.origin_y - boxh * (0.5f + status->cur_cell.y);
         printf("%g""\x1b[0m\n", status->cur_pose.pos.y);
      }

      err_counter = 0;
   }
}

void fwd_PID(struct Micromouse* status, int init)
{
   static float old_err1 = 0.0, cumul_err1 = 0.0;
   static float old_err2 = 0.0, cumul_err2 = 0.0;
   static Vec3 target_pos;
   static int check_x;
   //printf("NEED TO GO FORWARD\n");

   if(init) {
      target_pos = status->cur_pose.pos;
      target_pos.x = status->header_data.origin_x;
      target_pos.y = status->header_data.origin_y;

      float ang = fmod(status->cur_pose.ang.z, 2 * M_PI);

      if(ang > M_PI_4 && ang < 3 * M_PI_4) {
         check_x = 1;
         target_pos.x += (status->cur_cell.x + 0.5f - 1) * status->header_data.box_width;
         target_pos.y -= (status->cur_cell.y + 0.5f) * status->header_data.box_height;
      } else if(ang > 3 * M_PI_4 && ang < 5 * M_PI_4) {
         check_x = 0;
         target_pos.x += (status->cur_cell.x + 0.5f) * status->header_data.box_width;
         target_pos.y -= (status->cur_cell.y + 0.5f + 1) * status->header_data.box_height;
      } else if(ang > 5 * M_PI_4 && ang < 7 * M_PI_4) {
         check_x = 1;
         target_pos.x += (status->cur_cell.x + 0.5f + 1) * status->header_data.box_width;
         target_pos.y -= (status->cur_cell.y + 0.5f) * status->header_data.box_height;
      } else {
         check_x = 0;
         target_pos.x += (status->cur_cell.x + 0.5f) * status->header_data.box_width;
         target_pos.y -= (status->cur_cell.y + 0.5f - 1) * status->header_data.box_height;
      }
   }

   // NO CHOICE HERE
   // do one step of moving then back to default state
   /*printf("cell %d %d, pos = %g %g, target = %g %g\n",
          status->cur_cell.x,
          status->cur_cell.y,
          status->cur_pose.pos.x,
          status->cur_pose.pos.y,
          target_pos.x,
          target_pos.y);*/

   // Calculating th error
   float right_sensor = status->sensor_data.sensors[1],
         left_sensor = status->sensor_data.sensors[2],
         right_middle_sensor = status->sensor_data.sensors[0],
         left_middle_sensor = status->sensor_data.sensors[3];
   const float Kp = 0.6, Kd = 50, Ki = 0.001;
   float err1 = (left_sensor - right_sensor) / 4;
   float err2 = -(left_sensor - right_sensor) / 4;

   if((check_x == 1 && fabs(status->cur_pose.pos.x - target_pos.x) < 1) ||
      (check_x == 0 && fabs(status->cur_pose.pos.y - target_pos.y) < 1) ||
      ((right_middle_sensor > 0 && right_middle_sensor < 200) &&
      (left_middle_sensor > 0 && left_middle_sensor < 200))) {
      control_state = DEFAULT;
      //printf("\x1b[32m" "RETURN TO DEFAULT\n" "\x1b[0m");
   }

   /**
    * Calculate error
    */
   float goal_ang = M_PI_2 * round(status->cur_pose.ang.z / (M_PI_2));
   float ang_diff = status->cur_pose.ang.z - goal_ang;

   Vec2 speed = {.x = status->cur_pose.pos.x - status->prev_pose.pos.x,
                 .y = status->cur_pose.pos.y - status->prev_pose.pos.y
                };
   speed.x = cos(status->cur_pose.ang.z) * speed.x - sin(status->cur_pose.ang.z) * speed.y;
   speed.y = sin(status->cur_pose.ang.z) * speed.x + cos(status->cur_pose.ang.z) * speed.y;

   if((left_sensor < 0 || left_sensor > 900) || (right_sensor < 0 || right_sensor > 900) || 
      (left_middle_sensor > 0 && right_middle_sensor > 0)) 
   {
      printf("Aligning angle\n");
      err1 = ang_diff * 20;
      err2 = -ang_diff * 20;
      if(fabs(ang_diff)  < 0.5) {
         printf("Speeding down\n");
         err1 -= 150 * speed.y;
         err2 -= 150 * speed.y;
      }

      if(right_sensor < 0 || right_sensor > 700) {
         printf("Wall on the right\n");
         err1 += (left_sensor - 500) / 50;
         err2 -= (left_sensor - 500) / 50;
      } else if(left_sensor < 0 || left_sensor > 700) {
         printf("Wall on the left\n");
         err1 -= (right_sensor - 500) / 50;
         err2 += (right_sensor - 500) / 50;
      }
  }

   /**
    * Readjusting the position and angle estimation if the vehicle is moving forward
    */
   
   if(left_sensor > 0 && right_sensor > 0) {
      readjust_position(status, left_sensor - right_sensor, init);
   }
   
   /*
   if(left_middle_sensor > 0 && left_middle_sensor < 700 &&
      right_middle_sensor > 0 && right_middle_sensor < 700)
   {
      err1 = -(200 - left_middle_sensor) / 20;
      err2 = -(200 - right_middle_sensor) / 20;
      //printf("WALL IN FRONT TURNING BACK %g %g\n", err1, err2);
   }*/


   // calling the general PID function
   float out1 = PID(status, err1, Kp, Ki, Kd, &old_err1, &cumul_err1);
   float out2 = PID(status, err2, Kp, Ki, Kd, &old_err2, &cumul_err2);

   // using the output value
   status->engines[0] = BASE_SPEED + out1;
   status->engines[1] = BASE_SPEED + out2;
}


void turn_PID(struct Micromouse* status, int direction, int init)
{
   //printf("NEED TO TURN USING POS\n");
   // CHOICE HERE: EITHER (LEFT OR RIGHT OR FORWARD) OR (LEFT OR FORWARD) OR (RIGHT OR FORWARD)
   // keep checking for forward sensors while doing the turning
   // if forward found go to dist_turning state
   static float old_err1 = 0.0, old_err2 = 0.0,
                cumul_err1 = 0.0, cumul_err2 = 0.0;
   static float turn_dir = 1;
   static float init_ang = 0;
   //static Vec3 target_pos;
   //static int check_x;
   float right_sensor = status->sensor_data.sensors[1],
         left_sensor = status->sensor_data.sensors[2],
         right_middle_sensor = status->sensor_data.sensors[0],
         left_middle_sensor = status->sensor_data.sensors[3];

   // init is the indicator for when the
   if(init) {
      init_ang = M_PI_2 * round(status->cur_pose.ang.z / (M_PI_2));
      old_err1 = old_err2 = cumul_err1 = cumul_err2 = 0.0f;

      turn_dir = direction;
   }

   // the difference from the initial angle to the goal angle
   // -PI/2 <= ang_diff <= PI/2
   float ang_diff = M_PI_2 - (init_ang - status->cur_pose.ang.z);

   // the change between the initial angle and the goal (0 <= ang_dist <= PI/2)
   float ang_dist = fmin(fabs(2 * M_PI - (status->cur_pose.ang.z - init_ang)),
                         fabs(status->cur_pose.ang.z - init_ang));

   // printf("ang_dist = %g\n", ang_dist);

   if(ang_dist > 0.9 * M_PI_2) {
      status->cur_pose.pos.x = status->header_data.origin_x + (status->cur_cell.x + 0.5) * status->header_data.box_width;
      status->cur_pose.pos.y = status->header_data.origin_y - (status->cur_cell.y + 0.5) * status->header_data.box_height;
      control_state = DEFAULT;
   }

   // Initializing the errors and gain values
   float err1 = 0.0f, err2 = 0.0f;
   float Kp = 1, Kd = 400, Ki = 0.0f;

   // calculating the speed for each wheel
   Vec2 speed = {.x = (status->cur_pose.pos.x - status->prev_pose.pos.x) / status->time_step,
                 .y = (status->cur_pose.pos.y - status->prev_pose.pos.y) / status->time_step
                };

   speed.x = cos(status->cur_pose.ang.z) * speed.x - sin(status->cur_pose.ang.z) * speed.y;
   speed.y = sin(status->cur_pose.ang.z) * speed.x + cos(status->cur_pose.ang.z) * speed.y;

   // printf("SPEED %g, %g\n", speed.x, speed.y);
   // shouldn't be too close
   if((left_middle_sensor < 250 || right_middle_sensor < 250) &&
      (left_middle_sensor > 0 && right_middle_sensor > 0)) {
      //printf("TOO CLOSE");
      err1 = -right_middle_sensor / 100;
      err2 = -left_middle_sensor / 100;

      if(right_middle_sensor < 0) {
         err1 = -1024 / 100;
      }

      if(left_middle_sensor < 0) {
         err1 = -1024 / 100;
      }
   }
   // shouldn't be too fast
   else if(/*fabs(speed.x) > 2 || */fabs(speed.y) > 2) {
      //printf("TOO FAST");
      err1 = -1000 * speed.y;
      err2 = -1000 * speed.y;
   }
   // move to the center of the cell

   // start turning when everything else is met
   else {
      // Kd = 1000;
      err1 = turn_dir * 20 * ang_diff;
      err2 = -turn_dir * 20 * ang_diff;
      //printf("ACTUALLY TURNING (%g, %g) %g %g\n", err1, err2, turn_dir, ang_diff);
   }

   // calling the general PID function
   float out1 = PID(status, err1, Kp, Ki, Kd, &old_err1, &cumul_err1);
   float out2 = PID(status, err2, Kp, Ki, Kd, &old_err2, &cumul_err2);

   status->engines[0] = out1;
   status->engines[1] = out2;
}

void update_control(struct Micromouse* status, struct Box box, char init)
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
      fwd_PID(status, 0);
      return;

   case TURN:
      turn_PID(status, 0, 0);
      return;

   default:
      break;
   }

   if(init) {
      printf("\33[0;34m" "Re-navigating\n" "\33[0m");
   }

   int ang = (int)round(fmod(status->cur_pose.ang.z, 2 * M_PI) / (M_PI_2))%4;
   int goal = 0;

   if(status->cur_cell.x == box.OX && status->cur_cell.y - 1 == box.OY ) {
      goal = 0;
   } else if(status->cur_cell.x + 1 == box.OX && status->cur_cell.y == box.OY ) {
      goal = 3;
   } else if(status->cur_cell.x == box.OX && status->cur_cell.y + 1 == box.OY ) {
      goal = 2;
   } else {
      goal = 1;
   }
   int diff = goal - ang;
   int ang_dist = (4 - abs(diff) < abs(diff))? 4-abs(diff): diff;
   int ang_decision = goal - ang;
   
   if(ang == 0 && goal == 3) {
      ang_decision = -1;
   } else if(ang == 3 && goal == 0) {
      ang_decision = 1;
   }

   if(abs(ang_dist) == 2) {
      printf("*******************************\ TURN BACK\n");
      control_state = TURN_BACK;
      turn_back_PID(status, 1);
   } else if(abs(ang_dist) == 1) {
      printf("*******************************\ TURNING %s\n", (ang_decision > 0)? "LEFT": "RIGHT");
      control_state = TURN;
      turn_PID(status, -ang_decision, 1);
   } else {
      printf("*******************************\ FORWARD\n");
      control_state = MOVE_FWD;
      fwd_PID(status, 1);
   }

   printf("ang = %d, goal = %d\n OX = %d, OY = %d\n", ang, goal, box.OX, box.OY);
   printf("cur_cell = (%d %d)\n*******************************\n", status->cur_cell.x, status->cur_cell.y);
}

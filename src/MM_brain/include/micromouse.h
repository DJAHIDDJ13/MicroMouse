/*!
   \file micromouse.h
   \author MMteam


   \brief Header file to describe the micorouse and its methods.

   \details This header file contains the data structure
			who will structure our robot.

   \date 2020
*/
#ifndef MICROMOUSE_H
#define MICROMOUSE_H

#include <stdint.h>

#define NB_ENGINE	2 /*       The total number of engines        */
#define NB_SENSOR	4 /*       The total number of sensors        */
#define NB_ENCODER 2 /*       The total number of encoders; one for each engine*/

typedef struct vec3 {
   float x, y, z;
} Vec3;

typedef struct vec2 {
   float x, y;
} Vec2;

typedef struct ivec2 {
   int x, y;
} iVec2;

struct Position {
   Vec3 pos;
   Vec3 ang; // yaw, pitch, roll
};

struct Gyro {
   Vec3 xyz; // x, y, z acceleration
   Vec3 ypr; // yaw, pitch and roll (angular acceleration)
};

typedef struct {
   float sensors[NB_SENSOR];

   struct Gyro gyro;

   float encoders[NB_ENCODER];
   float time_stamp;
} SensorData;

enum sensor_position{SensorLeft, SensorTopLeft, SensorTopRight, SensorRight};

typedef struct {
   float maze_width,
         maze_height;

   float initial_x,
         initial_y,
         initial_angle;

   float target_x,
         target_y;

   float box_width,
         box_height;

   float lines_per_revolution, 
         wheel_circumference;

   Vec3 sensors_position[4];
   
   float origin_x, origin_y;
} HeaderData;


enum NAV_ALG_TYPE {FLOOD_FILL, Q_LEARNING};
/*            Main structure for the micromouse "robot"           */
struct Micromouse {
   /*     Our robot need two engine and four infrared sensor     */
   float engines[NB_ENGINE];
   
   SensorData sensor_data;
   
   HeaderData header_data;

   float time_step;
   struct Position cur_pose;
   struct Position prev_pose;

   float prev_enc[NB_ENCODER];
   iVec2 cur_cell;
   float prev_time_stamp;
   enum NAV_ALG_TYPE nav_alg;
};

#endif

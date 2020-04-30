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

/*        Structure representing a motor of the micromouse        */
struct Engine {
   /*    Value of the motor, it will be turned into a vote
         value to activate the motor                             */
   int16_t value;
};

/*   Structure representing a infrared sensor of the micromouse   */
struct Sensor {
   /*   Value of the distance returned by the infrared sensor    */
   int16_t distanceValue;

   /* Light value "light level" returned by the infrared sensor  */
   int16_t lightValue;
};

typedef struct vec3 {
   float x, y, z;
} Vec3;

typedef struct ivec2 {
   int x, y;
} iVec2;

struct Gyro {
   Vec3 ypr; // yaw, pitch and roll (angular acceleration)
   Vec3 xyz; // x, y, z acceleration
};

/*            Main structure for the micromouse "robot"           */
struct Micromouse {
   /*     Our robot need two engine and four infrared sensor     */
   struct Engine engines[NB_ENGINE];

   struct Sensor sensors[NB_SENSOR];

   struct Gyro gyro;
};

#endif

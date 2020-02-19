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

#define NB_ENGINE	2 /*       The total number of engines        */
#define NB_SENSOR	4 /*       The total number of sensors        */

/*        Structure representing a motor of the micromouse        */
struct Engine {
	/*    Value of the motor, it will be turned into a vote
	      value to activate the motor                             */
	short int value;
};

/*   Structure representing a infrared sensor of the micromouse   */
struct Sensor {
	/*   Value of the distance returned by the infrared sensor    */
	short int distanceValue;

	/* Light value "light level" returned by the infrared sensor  */
	short int lightValue;
};

/*            Main structure for the micromouse "robot"           */
struct Micromouse {
	/*     Our robot need two engine and four infrared sensor     */
	struct Engine engines[NB_ENGINE];

	struct Sensor sensors[NB_SENSOR];
};

#endif
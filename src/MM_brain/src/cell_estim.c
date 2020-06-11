#include <stdio.h>
#include <stdlib.h>
#include <time.h>
#include <sys/time.h>
#include <math.h>

#include <micromouse.h>
#include <position.h>
#include <communication.h>
#include <cell_estim.h>

// time vals to track the time step more accurately
struct timeval cur_celltime, prevtime;

void init_cell(struct Micromouse* status)
{
   // initializing the timevals
   gettimeofday(&cur_celltime, NULL);
   
   // setting the initial values are static at the initial coordinates
   Vec3 i_pos = {.x = status->header_data.initial_x, .y = status->header_data.initial_y, .z = 0};
   Vec3 i_vel = {.x = 0, .y = 0, .z = 0};
   Vec3 i_acc = {.x = 0, .y = 0, .z = 0};

   // same for the angles with the initial yaw value
   Vec3 i_ang     = {.x = 0, .y = 0, .z = status->header_data.initial_angle};
   Vec3 i_ang_vel = {.x = 0, .y = 0, .z = 0};
   Vec3 i_ang_acc = {.x = 0, .y = 0, .z = 0};

   // set the first time step to 0 and initialize the position estimator
   status->time_step = 0.0f;
   init_pos(i_pos, i_vel, i_acc, i_ang, i_ang_vel, i_ang_acc, status);
   
   // get the cell estimation
   status->cur_cell.x = (status->cur_pose.pos.x - status->header_data.origin_x) / status->header_data.box_width;
   status->cur_cell.y = -(status->cur_pose.pos.y - status->header_data.origin_y) / status->header_data.box_height;
}

void update_cell(struct Micromouse* status)
{
   // updating the previous timeval and getting the new value
   prevtime = cur_celltime;
   gettimeofday(&cur_celltime, NULL);

   // calculating the value in ms, (second difference * 100,000 + microsecond diff) / 1000
   float mdiff = (float)(1e6 * (cur_celltime.tv_sec - prevtime.tv_sec) + 
                         cur_celltime.tv_usec - prevtime.tv_usec) / 1000.0f;
   // setting the diff as the time_step
   status->time_step = mdiff;
   
   update_pos(status);

   // get the cell estimation
   status->cur_cell.x = (status->cur_pose.pos.x - status->header_data.origin_x) / status->header_data.box_width;
   status->cur_cell.y = -(status->cur_pose.pos.y - status->header_data.origin_y) / status->header_data.box_height;
}

WallPosition* detect_wall(struct Micromouse status) {
   WallPosition *wall_positions = malloc(sizeof(WallPosition) * 4);
   int i = 0;
   Vec2 source = { .x = 0, .y = 0 };
   Vec2 target = { .x = 0, .y = 0 };
   Vec2 relative_cell_pos;
   float current_vehicle_angle, doubt_range = 2;

   for (i = 0; i < NB_SENSOR; i++) {
      if (status.sensor_data.sensors[i] > 0) {
         current_vehicle_angle = status.cur_pose.ang.z + M_PI;
         /* Compute source position */
         source.x = status.cur_pose.pos.x + status.header_data.sensors_position[i].x * cos(current_vehicle_angle) - status.header_data.sensors_position[i].y * sin(current_vehicle_angle);
         source.y = status.cur_pose.pos.y + status.header_data.sensors_position[i].x * sin(current_vehicle_angle) + status.header_data.sensors_position[i].y * cos(current_vehicle_angle);
         /* Compute sensor and wall intersection */
         target.x = source.x + status.sensor_data.sensors[i] * (10.0/1024.0) * cos(status.header_data.sensors_position[i].z*(M_PI/180) + current_vehicle_angle);
         target.y = source.y + status.sensor_data.sensors[i] * (10.0/1024.0) * sin(status.header_data.sensors_position[i].z*(M_PI/180) + current_vehicle_angle);
         /* Add offset */
         source.x = source.x - status.header_data.origin_x;
         source.y = source.y - status.header_data.origin_y;

         target.x = target.x - status.header_data.origin_x;
         target.y = target.y - status.header_data.origin_y;

         /* Compute cell */
         relative_cell_pos.x = fmod(target.x, status.header_data.box_width);
         relative_cell_pos.y = fmod(target.y, status.header_data.box_height);

         wall_positions[i].cell_pos.x = (int)(target.x / status.header_data.box_width);
         wall_positions[i].cell_pos.y = (int)-(target.y / status.header_data.box_height);

         /* Compute wall position */
         if (  relative_cell_pos.x - doubt_range > -relative_cell_pos.y && 
               status.header_data.box_width - relative_cell_pos.x - doubt_range > -relative_cell_pos.y) {
            wall_positions[i].wall_pos = WallTop;
         } else if ( relative_cell_pos.x - doubt_range > -relative_cell_pos.y && 
                     status.header_data.box_width - relative_cell_pos.x + doubt_range < -relative_cell_pos.y) {
            wall_positions[i].wall_pos = WallRight;
         } else if ( relative_cell_pos.x + doubt_range < -relative_cell_pos.y && 
                     status.header_data.box_width - relative_cell_pos.x + doubt_range < -relative_cell_pos.y) {
            wall_positions[i].wall_pos = WallBottom;
         } else if ( relative_cell_pos.x + doubt_range < -relative_cell_pos.y && 
                     status.header_data.box_width - relative_cell_pos.x - doubt_range > -relative_cell_pos.y) {
            wall_positions[i].wall_pos = WallLeft;
         } else {
            /* can't decide */
            wall_positions[i].cell_pos.x = -1;
            wall_positions[i].cell_pos.y = -1;
            wall_positions[i].wall_pos = NoWall;
         }
      } else {
         /* No wall */
         wall_positions[i].cell_pos.x = -1;
         wall_positions[i].cell_pos.y = -1;
         wall_positions[i].wall_pos = NoWall;
      }
   }
   return wall_positions;
}

float float_abs(float val) {
   if (val < 0)
      return -val;
   else
      return val;
}

void vote_for_walls(struct Micromouse status, struct Maze* logical_maze, WallPosition *detected_walls, int **vertical_walls, int **horizontal_walls, int threshold) {
   struct Box box_to_add;
   int i = 0;
   int16_t cell_x, cell_y;

   for (i = 0; i < NB_SENSOR; i++) {

      if (detected_walls[i].cell_pos.x >= 0 && detected_walls[i].cell_pos.y >= 0) {
         cell_x = detected_walls[i].cell_pos.x + 1;
         cell_y = detected_walls[i].cell_pos.y + 1;
         if ((detected_walls[i].wall_pos & 24) > 0) {
            vertical_walls[cell_x - (detected_walls[i].wall_pos & 1)][cell_y]++;
            /* Populate maze data struct. */
            if (vertical_walls[cell_x - (detected_walls[i].wall_pos & 1)][cell_y] > threshold) {
               /* ADD RIGHT AT (OX, OY) WALL */
               if ((cell_x - (detected_walls[i].wall_pos & 1)) - 1 >= 0 && (cell_x - (detected_walls[i].wall_pos & 1)) - 1 < status.header_data.maze_height/status.header_data.box_height) {
                  box_to_add = get_box(*logical_maze, (cell_x - (detected_walls[i].wall_pos & 1)) - 1, cell_y - 1);
                  box_to_add.OX = (cell_x - (detected_walls[i].wall_pos & 1)) - 1;
                  box_to_add.OY = cell_y - 1;
                  box_to_add.wallIndicator = ADD_INDICATOR(box_to_add.wallIndicator, RightIndicator);
                  insertBox(box_to_add, *logical_maze);
               }
               /* ADD LEFT AT (OX+1, OY) WALL */
               if (cell_x - (detected_walls[i].wall_pos & 1) >= 0 && cell_x - (detected_walls[i].wall_pos & 1) < status.header_data.maze_width/status.header_data.box_width) {
                  box_to_add = get_box(*logical_maze, cell_x - (detected_walls[i].wall_pos & 1), cell_y - 1);
                  box_to_add.OX = cell_x - (detected_walls[i].wall_pos & 1);
                  box_to_add.OY = cell_y - 1;
                  box_to_add.wallIndicator = ADD_INDICATOR(box_to_add.wallIndicator, LeftIndicator);
                  insertBox(box_to_add, *logical_maze);
               }
            }
         } else {
            horizontal_walls[cell_x][cell_y - (detected_walls[i].wall_pos & 1)]++;
            /* Populate maze data struct. */
            if (horizontal_walls[cell_x][cell_y - (detected_walls[i].wall_pos & 1)] > threshold) {               
               /* ADD BOTTOM AT (OX, OY) WALL */
               if ((cell_y - (detected_walls[i].wall_pos & 1)) - 1 >= 0 && (cell_y - (detected_walls[i].wall_pos & 1)) - 1 < status.header_data.maze_height/status.header_data.box_height) {
                  box_to_add = get_box(*logical_maze, cell_x - 1, (cell_y - (detected_walls[i].wall_pos & 1)) - 1);                  
                  box_to_add.OX = cell_x - 1;
                  box_to_add.OY = (cell_y - (detected_walls[i].wall_pos & 1)) - 1;
                  box_to_add.wallIndicator = ADD_INDICATOR(box_to_add.wallIndicator, BottomIndicator);
                  insertBox(box_to_add, *logical_maze);
               }
               /* ADD TOP AT (OX, OY+1) WALL */
               if (cell_y - (detected_walls[i].wall_pos & 1) >= 0 && cell_y - (detected_walls[i].wall_pos & 1) < status.header_data.maze_height/status.header_data.box_height) {
                  box_to_add = get_box(*logical_maze, cell_x - 1, cell_y - (detected_walls[i].wall_pos & 1));                  
                  box_to_add.OX = cell_x - 1;
                  box_to_add.OY = cell_y - (detected_walls[i].wall_pos & 1);
                  box_to_add.wallIndicator = ADD_INDICATOR(box_to_add.wallIndicator, TopIndicator);
                  insertBox(box_to_add, *logical_maze);
               }
            } 
         } 
      }
   }
}

int **init_vote_array(int size) {
   int **vote_array, i = 0, j = 0;
   vote_array = malloc(size * sizeof(*vote_array));
   for (i = 0; i < size; i++)
      vote_array[i] = malloc(size * sizeof(*vote_array[i]));

   for (i = 0; i < size; i++) {
      for (j = 0; j < size; j++) {
         vote_array[i][j] = 0;
      }
   }
   
   return vote_array;
}

void display_logical_maze(struct Micromouse status, int threshold, int **vertical_walls, int **horizontal_walls) {
   int i = 0, j = 0;
   printf("##################\n");
   for (i = 0; i < (status.header_data.maze_width / status.header_data.box_width) + 1; i++) {
      for (j = 0; j < (status.header_data.maze_height / status.header_data.box_height) + 1; j++) {
         if (horizontal_walls[j][i] > threshold) {
            printf("_");
         } else
            printf(" ");
         
         if (vertical_walls[j][i] > threshold)
            printf("|");
         else
            printf(" ");
      }
      printf("\n");
   }
   printf("##################\n");
}

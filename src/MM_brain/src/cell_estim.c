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

WallPosition wall_positions[NB_SENSOR] = {0};
void detect_wall(struct Micromouse status)
{
   int i = 0;
   Vec2 source = { .x = 0, .y = 0 };
   Vec2 target = { .x = 0, .y = 0 };
   Vec2 relative_cell_pos;
   float current_vehicle_angle, doubt_range = 1.3;

   for (i = 0; i < NB_SENSOR; i++) {
      int sensor_val = status.sensor_data.sensors[i];
      sensor_val = (sensor_val < 0) ? 1024 : sensor_val;

      current_vehicle_angle = status.cur_pose.ang.z + M_PI;
      /* Compute source position */
      source.x = status.cur_pose.pos.x + status.header_data.sensors_position[i].x * cos(current_vehicle_angle) - status.header_data.sensors_position[i].y * sin(current_vehicle_angle);
      source.y = status.cur_pose.pos.y + status.header_data.sensors_position[i].x * sin(current_vehicle_angle) + status.header_data.sensors_position[i].y * cos(current_vehicle_angle);
      /* Compute sensor and wall intersection */
      target.x = source.x + sensor_val * (10.0 / 1024.0) * cos(status.header_data.sensors_position[i].z * (M_PI / 180) + current_vehicle_angle);
      target.y = source.y + sensor_val * (10.0 / 1024.0) * sin(status.header_data.sensors_position[i].z * (M_PI / 180) + current_vehicle_angle);
      /* Add offset */
      source.x = source.x - status.header_data.origin_x;
      source.y = source.y - status.header_data.origin_y;

      target.x = target.x - status.header_data.origin_x;
      target.y = target.y - status.header_data.origin_y;

      /* Compute cell */
      relative_cell_pos.x = fmod(target.x, status.header_data.box_width);
      relative_cell_pos.y = fmod(target.y, status.header_data.box_height);

      wall_positions[i].cell_pos.x = (int)(target.x / status.header_data.box_width);
      wall_positions[i].cell_pos.y = (int) - (target.y / status.header_data.box_height);

      if (status.sensor_data.sensors[i] > 0) {
         wall_positions[i].wall_present = 1;

         /* Compute wall position */
         if (  relative_cell_pos.x - doubt_range > -relative_cell_pos.y &&
               status.header_data.box_width - relative_cell_pos.x - doubt_range > -relative_cell_pos.y) {
            wall_positions[i].wall_pos = TopIndicator;
         } else if ( relative_cell_pos.x - doubt_range > -relative_cell_pos.y &&
                     status.header_data.box_width - relative_cell_pos.x + doubt_range < -relative_cell_pos.y) {
            wall_positions[i].wall_pos = RightIndicator;
         } else if ( relative_cell_pos.x + doubt_range < -relative_cell_pos.y &&
                     status.header_data.box_width - relative_cell_pos.x + doubt_range < -relative_cell_pos.y) {
            wall_positions[i].wall_pos = BottomIndicator;
         } else if ( relative_cell_pos.x + doubt_range < -relative_cell_pos.y &&
                     status.header_data.box_width - relative_cell_pos.x - doubt_range > -relative_cell_pos.y) {
            wall_positions[i].wall_pos = LeftIndicator;
         } else {
            /* can't decide */
            wall_positions[i].cell_pos.x = -1;
            wall_positions[i].cell_pos.y = -1;
            wall_positions[i].wall_pos = NoneIndicator;
         }
      } else {
         wall_positions[i].wall_present = -1;

         iVec2 target_cell;
         iVec2 source_cell;
         source_cell.x = (int)(source.x / status.header_data.box_width);
         source_cell.y = (int) - (source.y / status.header_data.box_height);
         wall_positions[i].cell_pos.x = source_cell.x;
         wall_positions[i].cell_pos.y = source_cell.y;
         target_cell.x = (int)(target.x / status.header_data.box_width);
         target_cell.y = (int) - (target.y / status.header_data.box_height);

         if(source_cell.x == target_cell.x && source_cell.y == target_cell.y + 1) {
            wall_positions[i].wall_pos = TopIndicator;
         } else if(source_cell.x + 1 == target_cell.x && source_cell.y == target_cell.y) {
            wall_positions[i].wall_pos = RightIndicator;
         } else if(source_cell.x == target_cell.x && source_cell.y == target_cell.y - 1) {
            wall_positions[i].wall_pos = BottomIndicator;
         } else if(source_cell.x - 1 == target_cell.x && source_cell.y == target_cell.y) {
            wall_positions[i].wall_pos = LeftIndicator;
         } else {
            wall_positions[i].cell_pos.x = -1;
            wall_positions[i].cell_pos.y = -1;
         }

         printf("DELETING WALL %d %d, %d\n", wall_positions[i].cell_pos.x,
                wall_positions[i].cell_pos.y,
                wall_positions[i].wall_pos);
         //wall_positions[i].wall_pos);
         //wall_positions[i].cell_pos.x = -1;
         //wall_positions[i].cell_pos.y = -1;
         //wall_positions[i].wall_pos = NoneIndicator;
      }
   }
}

void generateBox(struct Maze maze, int16_t cell_x, int16_t cell_y, enum wall_indicator wall_ind,
                 int vote, int threshold)
{
   struct Box box = {0};

   if(vote >= threshold) {
      box = get_box(maze, cell_x, cell_y);
      box.OX = cell_x;
      box.OY = cell_y;
      box.wallIndicator = ADD_INDICATOR(box.wallIndicator, wall_ind);

      insertBox(box, maze);
   } else if(vote <= -threshold) {
      printf("cell %d %d\n", cell_x, cell_y);
      box = get_box(maze, cell_x, cell_y);
      box.OX = cell_x;
      box.OY = cell_y;

      //box.wallIndicator = REMOVE_INDICATOR(box.wallIndicator, wall_ind);
      insertBox(box, maze);
   }
}

void vote_for_walls(struct Micromouse status, struct Maze* logical_maze, int **vote_table, int threshold)
{
   int i = 0;
   int16_t cell_x, cell_y;
   enum wall_indicator wall_ind = {0};
   int wall_decision = 0;
   int width = (int)(status.header_data.maze_width / status.header_data.box_width) + 1;
   int vote;
   // detect walls using sensors
   detect_wall(status);

   for (i = 0; i < NB_SENSOR; i++) {
      cell_x = wall_positions[i].cell_pos.x;
      cell_y = wall_positions[i].cell_pos.y;
      wall_ind = wall_positions[i].wall_pos;
      wall_decision = wall_positions[i].wall_present;

      printf("%d (%d %d %d %d) %d\n", i, cell_x, cell_y, wall_ind, wall_decision, width);

      if (cell_x >= 0 && cell_y >= 0 && cell_x < width && cell_y < width) {
         switch(wall_ind) {
         case TopIndicator:
            vote_table[cell_y * width + cell_x][0] += wall_decision;

            vote = vote_table[cell_y * width + cell_x][0];
            generateBox(*logical_maze, cell_x, cell_y, TopIndicator, vote, threshold);
            generateBox(*logical_maze, cell_x, cell_y - 1, BottomIndicator, vote, threshold);

            break;

         case BottomIndicator:
            //if(cell_y <= width) {
            vote_table[(cell_y + 1)* width + cell_x][0] += wall_decision;
            vote = vote_table[(cell_y + 1) * width + cell_x][0];
            generateBox(*logical_maze, cell_x, cell_y, BottomIndicator, vote, threshold);
            generateBox(*logical_maze, cell_x, cell_y + 1, TopIndicator, vote, threshold);

            //}

            break;

         case LeftIndicator:
            vote_table[cell_y * width + cell_x][1] += wall_decision;
            vote = vote_table[cell_y * width + cell_x][1];
            generateBox(*logical_maze, cell_x, cell_y, LeftIndicator, vote, threshold);
            generateBox(*logical_maze, cell_x - 1, cell_y, RightIndicator, vote, threshold);

            break;

         case RightIndicator:
            //if(cell_x <= width) {
            vote_table[cell_y * width + cell_x + 1][1] += wall_decision;

            vote = vote_table[cell_y * width + cell_x + 1][1];
            generateBox(*logical_maze, cell_x, cell_y, RightIndicator, vote, threshold);
            generateBox(*logical_maze, cell_x + 1, cell_y, LeftIndicator, vote, threshold);

            //}

            break;

         case NoneIndicator:
            break;
         }
      }
   }
}

int **init_vote_array(int** prev, int size)
{
   size ++;
   int **vote_array = realloc(prev, size * size * sizeof(int*));

   for (int i = 0; i < size * size; i++) {
      if(prev != NULL) {
         free(vote_array[i]);
      }

      vote_array[i] = malloc(2 * sizeof(int));
   }

   for (int i = 0; i < size; i++) {
      for (int j = 0; j < size; j++) {
         vote_array[i * size + j][0] = 0;
         vote_array[i * size + j][1] = 0;
      }
   }

   return vote_array;
}

void display_logical_maze(struct Micromouse status, int threshold, int **vote_table)
{
   int i = 0, j = 0;
   printf("##################\n");
   int width = (int)(status.header_data.maze_width / status.header_data.box_width) + 1;
   int height = (int)(status.header_data.maze_height / status.header_data.box_height) + 1;
   printf("%d %d\n", width, height);

   for (i = -1; i < height - 1; i++) {
      for (j = 0; j < width; j++) {
         if(i >= 0) {
            printf("%c", (vote_table[i * width + j][1] > threshold) ? '|' : ' ');
         } else {
            printf(" ");
         }

         printf("%c", (vote_table[(i + 1) * width + j][0] > threshold) ? '_' : ' ');
      }

      printf("\n");

   }

   for (i = 0; i < height; i++) {
      for (j = 0; j < width; j++) {
         printf("(%d,%d) ", vote_table[i * width + j][0],
                vote_table[i * width + j][1]);
      }

      printf("\n");
   }



   printf("##################\n");
}

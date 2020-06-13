/*!
   \file queue_test.c
   \author MMteam


   \brief Main test for the queue structure.

   \warning Attention don't forget to free the
            memory occupied by the structures.

   \date 2020
*/
#include <stdio.h>
#include <stdint.h>
#include <queue.h>

int main(int argc, char **argv)
{

   struct oddpair_XY XY1 = {2, 2, 0};
   struct oddpair_XY XY2 = {2, 1, 1};
   struct oddpair_XY XY3 = {1, 2, 1};
   struct oddpair_XY XY4 = {1, 1, 0};
   struct oddpair_XY XY5 = {3, 1, 0};
   struct oddpair_XY XY6 = {3, 3, 1};

   Queue_XY queue = initQueue_XY();

   pushQueue_XY(&queue, XY1);
   pushQueue_XY(&queue, XY2);
   pushQueue_XY(&queue, XY3);
   pushQueue_XY(&queue, XY4);
   pushQueue_XY(&queue, XY5);
   pushQueue_XY(&queue, XY6);

   printQueue_XY(queue);
   printf("=============\n");
   printQueueBack_XY(queue);

   freeQueue_XY(&queue);

   return 0;
}

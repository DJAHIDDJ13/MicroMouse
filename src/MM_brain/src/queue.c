#include <queue.h>

/* Create a oddpair_XY variable */
struct oddpair_XY createOddpair_XY(int16_t OX, int16_t OY, int8_t sign)
{
   struct oddpair_XY XY;

   XY.OX = OX;
   XY.OY = OY;
   XY.sign = sign;

   return XY;
}

/* Initialize a stack */
Queue_XY initQueue_XY()
{

   Queue_XY queue;

   queue.head = queue.tail = NULL;
   return queue;
}

/* Test if a queue is empty */
bool emptyQueue_XY(Queue_XY queue)
{
   return (queue.head == NULL)? true : false;
}

bool emptyQueueTail_XY(Queue_XY queue)
{
   return (queue.tail == NULL)? true : false;  
}

/* Determine the value of the top of the queue */
struct oddpair_XY summitQueue_XY(Queue_XY queue)
{
   struct oddpair_XY value_XY = {0};

   if(!emptyQueue_XY(queue)) {
      value_XY = queue.head->XY;
   }

   return value_XY;
}

struct oddpair_XY tailQueue_XY(Queue_XY queue)
{
   struct oddpair_XY value_XY = {0};

   if(!emptyQueue_XY(queue)) {
      value_XY = queue.tail->XY;
   }

   return value_XY;
}

/* Push a value into the queue */
void pushQueue_XY(Queue_XY* queue, struct oddpair_XY value)
{

   List_XY cel;

   cel = (List_XY) malloc(sizeof(struct Cell));

   cel->XY = value;

   cel->next = NULL;

   if(emptyQueue_XY(*queue)) {
      cel->prev = NULL;
      queue->head = queue->tail = cel;
   } else {
      cel->prev = queue->tail;
      (queue->tail)->next = cel;
      queue->tail = cel;
   }
}

/* Pop the summit of the queue */
void popQueue_XY(Queue_XY* queue)
{

   List_XY queue_tmp;

   queue_tmp = queue->head;

   queue->head = (queue->head)->next;

   free(queue_tmp);

}

/* Free the memory of a queue */
void freeQueue_XY(Queue_XY* queue)
{

   while(!emptyQueue_XY(*queue)) {
      popQueue_XY(queue);
   }
}

/* Print a queue */
void printQueue_XY(Queue_XY queue)
{

   while(!emptyQueue_XY(queue)) {
      struct oddpair_XY XY_tmp = summitQueue_XY(queue);

      printf("%hd->(%hd, %hd)\n", XY_tmp.sign, XY_tmp.OX, XY_tmp.OY);

      queue.head = (queue.head)->next;
   }
}

void printQueueBack_XY(Queue_XY queue)
{

   while(!emptyQueue_XY(queue)) {
      struct oddpair_XY XY_tmp = tailQueue_XY(queue);

      printf("%hd->(%hd, %hd)\n", XY_tmp.sign, XY_tmp.OX, XY_tmp.OY);

      queue.tail = (queue.tail)->prev;
   }
}

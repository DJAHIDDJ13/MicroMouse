#include <queue.h>

/* Initialize a stack */
Queue_XY initQueue_XY() {
	
	Queue_XY queue;
	
	queue.head = queue.tail = NULL;
	return queue;
}

/* Test if a queue is empty */
bool emptyQueue_XY(Queue_XY queue) {
	return (queue.head == NULL) ? true : false;
}

/* Determine the value of the top of the queue */
struct oddpair_XY summitQueue_XY(Queue_XY queue) {
	struct oddpair_XY value_XY = {0};

	if(!emptyQueue_XY(queue))
		value_XY = queue.head->XY;

	return value_XY;
}

/* Push a value into the queue */
void pushQueue_XY(Queue_XY* queue, struct oddpair_XY value) {

	List_XY cel;

	cel = (List_XY) malloc(sizeof(struct Cell));

	cel->XY = value;

	cel->next = NULL;

	if(emptyQueue_XY(*queue))
		queue->head = queue->tail = cel;
	else {
		(queue->tail)->next = cel;
		queue->tail = cel;
	}
}

/* Pop the summit of the queue */
void popQueue_XY(Queue_XY* queue) {

	List_XY queue_tmp;

	queue_tmp = queue->head;

	queue->head = (queue->head)->next;

	free(queue_tmp);

}

/* Free the memory of a queue */
void freeQueue_XY(Queue_XY* queue) {

	while(!emptyQueue_XY(*queue))
		popQueue_XY(queue);
}
#include <brain.h>
#include <micromouse.h>
#include <flood_fill.h>
#include <rrtstar.h>
#include <box.h>
#include <flood_fill.h>
#include <control.h>
#include <maze.h>
#include <position.h>
#include <queue.h>
#include <cell_estim.h>


Queue_XY reorganise_path(Queue_XY* path) {
	Queue_XY min_path = initQueue_XY();

	int dir = -1;
	int new_dir;

	struct oddpair_XY XY_pred = summitQueue_XY(*path);

	while(!emptyQueue_XY(*path)) {
		popQueue_XY(path);
		
		struct oddpair_XY XY_cur = summitQueue_XY(*path);

		if(abs(XY_cur.OX - XY_pred.OX) == 1) {
			new_dir = 0;
		} else if(abs(XY_cur.OY - XY_pred.OY) == 1) {
			new_dir = 1;
		}

		if(new_dir != dir) {
			pushQueue_XY(&min_path, XY_pred);
		}

		XY_pred = XY_cur;
		dir = new_dir;
	}

	return min_path;
}
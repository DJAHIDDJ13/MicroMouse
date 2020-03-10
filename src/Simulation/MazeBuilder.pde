public class MazeBuilder{
  
  public Maze builderInitialMaze(float mazeW, float mazeH, int size, float ratio){
    float boxW = mazeW / size;
    float boxH = mazeH / size;
    int num_walls = size; // the number of walls per side
    
    Maze maze = new Maze(mazeH, mazeW, boxW, boxH, ratio);
    
    for(int i = 0; i < num_walls; i++) {
      // TOP
      maze.addWallAt(i, 0, WallOrientation.TOP_WALL);
      
      // RIGHT
      maze.addWallAt(size-1, i, WallOrientation.RIGHT_WALL);
      
      // BOTTOM
      maze.addWallAt(i, size-1, WallOrientation.BOTTOM_WALL);
      
      // LEFT
      maze.addWallAt(0, i, WallOrientation.LEFT_WALL);
    }
    Vec2 center = box2d.coordPixelsToWorld(new Vec2(SimulationUtility.MAZE_SIZE/2 + SimulationUtility.MAZE_SHIFTX, SimulationUtility.MAZE_SIZE/2 + SimulationUtility.MAZE_SHIFTY));

    Target defaultTarget = new Target(center.x, center.y, min(boxW, boxH));
    maze.setTarget(defaultTarget);
    
    
    Vehicle vehicle = new Vehicle(center.x, center.y, 0, 1.0);
    maze.setVehicle(vehicle);
    
    return maze;
  }
}

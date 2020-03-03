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
    Target defaultTarget = makeDefaultTarget(SimulationUtility.MAZE_SIZE + SimulationUtility.MAZE_SHIFTX, SimulationUtility.MAZE_SIZE + SimulationUtility.MAZE_SHIFTX, boxW, boxW);
    maze.setTarget(defaultTarget);
    
    Vehicle vehicle = new Vehicle(box2d.scalarWorldToPixels(mazeW / 2), box2d.scalarWorldToPixels(mazeH / 2), 0, 1.0);
    maze.setVehicle(vehicle);
    
    return maze;
  }
  
  public Target makeDefaultTarget(float mazeH, float mazeW, float boxW, float boxH){                  
    float xTarget = mazeW / 2;
    float yTarget = mazeH / 2;
    float rTarget = boxH / 2;
    
    return new Target(xTarget, yTarget, rTarget);
  }
}

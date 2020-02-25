public class MazeBuilder{
  
  public Maze builderInitialMaze(float mazeW, float mazeH, int size, float ratio){
    
    float boxW = mazeW / size;
    int num_walls = size; // the number of walls per side
    
    float wall_radius = boxW * ratio; // the radius of each wall
    float wall_len = boxW - wall_radius; // the length of each wall

    Maze maze = new Maze(mazeH, mazeW, boxW, wall_radius);
    
    // Top left corner of the canvas in world coordinates
    Vec2 top_left_corner = box2d.coordPixelsToWorld(new Vec2(SimulationUtility.MAZE_SHIFTX, SimulationUtility.MAZE_SHIFTY));
    
    for(int i = 0; i < num_walls; i++) {
      // Top row of border walls
      Vec2 cur = top_left_corner.add(new Vec2((i + 0.5) * boxW, 0));
      Wall wall = new Wall(cur.x, cur.y, wall_len / 2, wall_radius / 2, 0);
      maze.addWall(wall);
      
      // Bottom row of border walls
      cur = top_left_corner.add(new Vec2((i + 0.5) * boxW, -num_walls * boxW));
      wall = new Wall(cur.x, cur.y, wall_len / 2, wall_radius / 2, 0);
      maze.addWall(wall);
      
      // left column of border walls
      cur = top_left_corner.add(new Vec2(0, - (i + 0.5) * boxW));
      wall = new Wall(cur.x, cur.y, wall_len / 2, wall_radius / 2, HALF_PI);
      maze.addWall(wall);

      // right column of border walls
      cur = top_left_corner.add(new Vec2(num_walls * boxW, -(i + 0.5) * boxW));
      wall = new Wall(cur.x, cur.y, wall_len / 2, wall_radius / 2, HALF_PI);
      maze.addWall(wall);
    }
    Target defaultTarget = makeDefaultTarget(SimulationUtility.MAZE_SIZE + SimulationUtility.MAZE_SHIFTX, SimulationUtility.MAZE_SIZE + SimulationUtility.MAZE_SHIFTX, boxW, boxW);
    maze.setTarget(defaultTarget);
    
    Vehicle vehicle = new Vehicle(box2d.scalarWorldToPixels(mazeW / 2), box2d.scalarWorldToPixels(mazeH / 2), 0, 1.0);
    maze.setVehicle(vehicle);
    
    return maze;
  }
  
  public Target makeDefaultTarget(float mazeH, float mazeW, float boxH, float boxW){                  
    float xTarget = mazeW / 2;
    float yTarget = mazeH / 2;
    float rTarget = boxH / 2;
    
    return new Target(xTarget, yTarget, rTarget);
  }
}

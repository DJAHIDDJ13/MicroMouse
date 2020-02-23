public class MazeBuilder{
  
  public Maze builderInitialMaze(float mazeW, float mazeH, float boxW, float boxH){
    Maze maze = new Maze(mazeH, mazeW);
    
    int num_walls = floor(mazeW / boxW); // the number of walls per side
    
    float wall_radius = boxH; // the radius of each wall
    boxW -= wall_radius / num_walls; // adjusting to fit the box + 1 additional wall_radius for the beginning
    float wall_len = boxW - wall_radius; // the length of each wall
    
    // Top left corner of the canvas in world coordinates
    Vec2 top_left_corner = box2d.coordPixelsToWorld(new Vec2(SimulationUtility.MAZE_SHIFTX, SimulationUtility.MAZE_SHIFTY));
    
    for(int i = 0; i < num_walls; i++) {
      // Top row of border walls
      Vec2 cur = top_left_corner.add(new Vec2((i + 0.5) * boxW + wall_radius / 2, -0.5 * wall_radius));
      Wall wall = new Wall(cur.x, cur.y, wall_len / 2, wall_radius / 2, 0);
      maze.addWall(wall);
      
      // Bottom row of border walls
      cur = top_left_corner.add(new Vec2((i + 0.5) * boxW + wall_radius / 2, -0.5 * wall_radius - num_walls * boxW));
      wall = new Wall(cur.x, cur.y, wall_len / 2, wall_radius / 2, 0);
      maze.addWall(wall);
      
      // left column of border walls
      cur = top_left_corner.add(new Vec2(0.5 * wall_radius, - (i + 0.5) * boxW - wall_radius / 2));
      wall = new Wall(cur.x, cur.y, wall_len / 2, wall_radius / 2, HALF_PI);
      maze.addWall(wall);

      // right column of border walls
      cur = top_left_corner.add(new Vec2(0.5 * wall_radius + num_walls * boxW, -(i + 0.5) * boxW - wall_radius / 2));
      wall = new Wall(cur.x, cur.y, wall_len / 2, wall_radius / 2, HALF_PI);
      maze.addWall(wall);

    }
    
    Target defaultTarget = makeDefaultTarget(box2d.scalarWorldToPixels(mazeW / 2),  box2d.scalarWorldToPixels(mazeH / 2), boxW, boxW);
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

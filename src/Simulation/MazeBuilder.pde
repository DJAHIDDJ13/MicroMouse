public class MazeBuilder{
  
  public Maze emptyMazeSetup(float mazeW, float mazeH, int size, float ratio) {
    float boxW = mazeW / size;
    float boxH = mazeH / size;
    
    Maze maze = new Maze(mazeH, mazeW, boxW, boxH, ratio);
    Vec2 center = box2d.coordPixelsToWorld(new Vec2(SimulationUtility.MAZE_SIZE/2 + SimulationUtility.MAZE_SHIFTX, SimulationUtility.MAZE_SIZE/2 + SimulationUtility.MAZE_SHIFTY));

    Target defaultTarget = new Target(center.x, center.y, min(boxW, boxH));
    maze.setTarget(defaultTarget);
    
    
    // put vehicle on cell (0, 0)
    
    Vehicle vehicle = new Vehicle(0, 0, PI/2, 1.0);
    maze.setVehicleAt(vehicle, 2, 2);
    
    return maze;
  }
  
  public Maze builderInitialMaze(float mazeW, float mazeH, int size, float ratio){
    int num_walls = size;
    
    Maze maze = emptyMazeSetup(mazeH, mazeW, size, ratio);
    
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

    return maze;
  }
  
  public Maze generateRandomMaze(float mazeW, float mazeH, int size, float ratio) {
    int w = 2, h = 2;

    Maze maze = emptyMazeSetup(mazeH, mazeW, size, ratio);
    
    boolean[][] visited = new boolean[w][h];
    boolean[][][] res = new boolean[w][h][4];
    Deque<MazeCell> stack = new ArrayDeque<MazeCell>();
    Random rand = new Random();
    
    // start at cell (0, 0)
    MazeCell cur = new MazeCell(0, 0);
    stack.push(cur);
    
    while(!stack.isEmpty()) {
      cur = stack.pop();
      visited[cur.x][cur.y] = true;

      // Array to store the current cell's neighbors
      ArrayList<MazeCell> neighbors = new ArrayList<MazeCell>();
      // top
      if(cur.y-1 >= 0 && !visited[cur.x][cur.y-1]) {
        neighbors.add(new MazeCell(cur.x, cur.y-1));
      }
      
      // bottom
      if(cur.y+1 < h && !visited[cur.x][cur.y+1]) {
        neighbors.add(new MazeCell(cur.x, cur.y+1));
      }
      
      // left
      if(cur.x-1 >= 0 && !visited[cur.x-1][cur.y]) {
        neighbors.add(new MazeCell(cur.x-1, cur.y));
      }
      
      // right
      if(cur.x+1 < w && !visited[cur.x+1][cur.y]) {
        neighbors.add(new MazeCell(cur.x+1, cur.y));
      }
      
      // get a random neighbor //<>//
      if(neighbors.size() == 0) { // the current cell has no neighbors
        continue;
      } else {
        stack.push(cur);
        
        MazeCell choice = neighbors.get(rand.nextInt(neighbors.size()));
        stack.push(choice);
        // make a hole between cur and chosen cell
        res[cur.x][cur.y][cur.relativeOrientation(choice).getValue()] = true;
        res[choice.x][choice.y][choice.relativeOrientation(cur).getValue()] = true;
        neighbors = null;
      }
    }
    
    for(int i = 0; i < w; i++) {
      for(int j = 0; j < h; j++) {
        for(int k = 0; k < 4; k++) {
          if(res[i][j][k] == false) {
            maze.addWallAt(i, j, WallOrientation.wallOf(k));
          }
        }
      }
    }
    
    return maze;
  }
}

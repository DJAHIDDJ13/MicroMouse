public class MazeBuilder{
  
  public Maze emptyMazeSetup(float mazeW, float mazeH, int size, float ratio) {
    float boxW = mazeW / size;
    float boxH = mazeH / size;
    
    Maze maze = new Maze(mazeH, mazeW, boxW, boxH, ratio);

    final int targetX = ceil(((float)size) / 2.0) -1;
    final int targetY = ceil(((float)size) / 2.0) -1;
    Vec2 center = maze.getCellWorldCenterAt(targetX, targetY);
    Target defaultTarget = new Target(center.x, center.y, min(boxW, boxH));
    maze.setTarget(defaultTarget);
    
    
    // put vehicle on cell (0, 0)
    Vec2 p = maze.getCellWorldCenterAt(0, 0);
    Vehicle vehicle = new Vehicle(p.x, p.y, PI, 1.0);
    maze.setVehicle(vehicle);
    
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
  
  
  
 
  public boolean[][][] ImperfectMaze(int size, boolean[][][] res, int numWalls)
  {
  int neiX=0,  neiY=0, k=0;
  int[][] neiIndex = { {0,-1}, {0,1}, {-1,0}, {1,0} }; 
  List<MazeCell> startList = new ArrayList<MazeCell>();
  List<MazeCell> goalList = new ArrayList<MazeCell>();
  List<MazeCell> startGate = new ArrayList<MazeCell>();
  List<MazeCell> goalGate = new ArrayList<MazeCell>();
  MazeCell start = new MazeCell(0,0);
  MazeCell goal = new MazeCell(floor(size/2),floor(size/2));
  MazeCell curCell, neiCell;
  
    // setting up Start and Goal sets.
    for(int i = 0; i < size; i++) {
      for(int j = 0; j < size; j++) {
        if (start.distanceCells(i, j)+2< goal.distanceCells(i, j)) { 
        startList.add(new MazeCell(i, j)); 
      }
        else {
        goalList.add(new MazeCell(i, j));
      }
      }
    }
       
    /*println(startList.size());
    println(goalList.size());
    for(int in=0; in<4; in++) {print("le chiffre est ",neiIndex[in][0],neiIndex[in][1],"\n"); }*/
    
   for(int i=0; i<startList.size(); i++) {
     curCell = startList.get(i);  //print(curCell.x,curCell.y,"\n");
     for(int in=0; in<4; in++) {
        neiX=curCell.x+neiIndex[in][0];  
        neiY=curCell.y+neiIndex[in][1];
        if( (0<=neiX && neiX<size) && (0<=neiY && neiY<size)) {
          for (int j=0; j<goalList.size(); j++) {
            neiCell = goalList.get(j);
            if( ( k<4 ) &&
              (neiCell.x == neiX && neiCell.y==neiY) &&
              (res[curCell.x][curCell.y][neiCell.relativeOrientation(curCell).getValue()] == false) &&
              (res[neiCell.x][neiCell.y][curCell.relativeOrientation(neiCell).getValue()] == false))
              {
                startGate.add(k,curCell);
                goalGate.add(k,neiCell);
                res[curCell.x][curCell.y][neiCell.relativeOrientation(curCell).getValue()] = true;
                res[neiCell.x][neiCell.y][curCell.relativeOrientation(neiCell).getValue()] = true;
                k++;
              }
          }
        }    
     }
   }
   
  //print(startGate.size(),"\n"); 
  //print(goalGate.size(),"\n"); 
  //print(k);
  return res;
  }
  
  public Maze generateRandomMaze(float mazeW, float mazeH, int size, float ratio) {
    int w = size, h = size;

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
      
      // get a random neighbor
      if(neighbors.size() == 0) { // the current cell has no neighbors
        continue;
      } else {
        stack.push(cur);
        
        MazeCell choice = neighbors.get(rand.nextInt(neighbors.size()));
        stack.push(choice);
        // make a hole between cur and chosen cell
        res[cur.x][cur.y][choice.relativeOrientation(cur).getValue()] = true;
        res[choice.x][choice.y][cur.relativeOrientation(choice).getValue()] = true;
        neighbors = null;
      }
    }    
     
     res = ImperfectMaze(size,res,4);
     
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

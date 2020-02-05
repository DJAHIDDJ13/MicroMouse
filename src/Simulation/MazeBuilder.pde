public class MazeBuilder{
  
  public Maze builderInitialMaze(float mazeH, float mazeW, float boxH, float boxW){
    Wall wall;
    
    int wallBases = (int)(mazeW/boxW);
    int wallLR = (int)(mazeH/boxW)-1;
    Maze maze = new Maze(mazeH, mazeW);
    float shiftX = SimulationUtility.MAZE_SHIFTX;
    float shiftY = SimulationUtility.MAZE_SHIFTY;

    //create top wall
    float xWall = 0;
    float yWall = 0;
    for(int i = 0; i < wallBases; i++){
      wall = new Wall(xWall + boxW / 2 + shiftX, yWall + boxH / 2 + shiftY, boxW, boxH, 0);
      maze.addWall(wall);
      xWall += boxW;
    }
    
    //create bottom wall
    xWall = 0;
    yWall = mazeH - boxH;
    for(int i = 0; i < wallBases; i++){
      wall = new Wall(xWall + boxW / 2 + shiftX, yWall + boxH / 2 + shiftY, boxW, boxH, 0);
      maze.addWall(wall);
      xWall += boxW;
    }
    
    //create left wall
    xWall = 0;
    yWall = boxH;
    for(int i = 0; i < wallLR; i++){
      wall = new Wall(xWall + boxH / 2 + shiftX, yWall + boxW / 2 + shiftY, boxW, boxH, HALF_PI);
      maze.addWall(wall);
      yWall += boxW;
    }
    
    //create right wall
    xWall = mazeW - boxH;
    yWall = boxH;
    for(int i = 0; i < wallLR; i++){
      wall = new Wall(xWall + boxH / 2 + shiftX, yWall + boxW / 2 + shiftY, boxW, boxH, HALF_PI);
      maze.addWall(wall);
      yWall += boxW;
    }
    
    Target defaultTarget = makeDefaultTarget(mazeH,  mazeW, boxH, boxW);
    maze.setTarget(defaultTarget);
    
    Vehicle vehicle = new Vehicle(mazeW / 2, mazeH / 2, 0);
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

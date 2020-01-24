public class MazeBuilder{
  
  public MazeBuilder(){
  
  }
  
  public Maze builderInitialMaze(float mazeH, float mazeW, float boxH, float boxW, float shiftX, float shiftY){
    Wall wall;
    
    int wallBases = (int)(mazeW/boxW);
    int wallLR = (int)(mazeH/boxW)-1;
    
    Maze maze = new Maze(mazeH, mazeW);
    
    //create top wall
    float xWall = shiftX;
    float yWall = shiftY;
    for(int i = 0; i < wallBases; i++){
      wall = new Wall(xWall, yWall, boxH, boxW, 0);
      maze.addWall(wall);
      xWall += boxW;
    }
    
    //create bottom wall
    xWall = shiftX;
    yWall = mazeH-boxH+shiftY;
    for(int i = 0; i < wallBases; i++){
      wall = new Wall(xWall, yWall, boxH, boxW, 0);
      maze.addWall(wall);
      xWall += boxW;
    }
    
    //create left wall
    xWall = shiftX+1;
    yWall = shiftY+boxH;
    for(int i = 0; i < wallLR; i++){
      wall = new Wall(xWall, yWall, boxH, boxW, HALF_PI);
      maze.addWall(wall);
      yWall += boxW;
    }
    
    //create right wall
    xWall = mazeW-boxH+shiftX;
    yWall = shiftY+boxH;
    for(int i = 0; i < wallLR; i++){
      wall = new Wall(xWall, yWall, boxH, boxW, HALF_PI);
      maze.addWall(wall);
      yWall += boxW;
    }
    
    Target defaultTarget = makeDefaultTarget(mazeH,  mazeW, boxH, boxW, shiftX, shiftY);
    maze.setTarget(defaultTarget);
    
    return maze;
  }
  
  public Target makeDefaultTarget(float mazeH, float mazeW, float boxH, float boxW, float shiftX, float shiftY){                  
    float xTarget = (mazeW+shiftX) / 2;
    float yTarget = (mazeH+shiftY) / 2;
    float rTarget = boxH / 2;
    
    return new Target(xTarget, yTarget, rTarget);
  }
}

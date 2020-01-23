public class WorldBuilder{
  
  public World builderInitialWorld(float worldH, float worldW, float boxH, float boxW, float shiftX, float shiftY){
    Wall wall;
    
    int wallBases = (int)(worldW/boxW);
    int wallLR = (int)(worldH/boxW)-1;
    World world = new World(worldH, worldW);
    println(wallBases);
    //create top wall
    float xWall = shiftX;
    float yWall = shiftY;
    for(int i = 0; i < wallBases; i++){
      wall = new Wall(xWall, yWall, boxH, boxW, 0);
      world.addWall(wall);
      xWall += boxW;
    }
    
    //create bottom wall
    xWall = shiftX;
    yWall = worldH-boxH+shiftY;
    for(int i = 0; i < wallBases; i++){
      wall = new Wall(xWall, yWall, boxH, boxW, 0);
      world.addWall(wall);
      xWall += boxW;
    }
    
    //create left wall
    xWall = shiftX+1;
    yWall = shiftY+boxH;
    for(int i = 0; i < wallLR; i++){
      wall = new Wall(xWall, yWall, boxH, boxW, HALF_PI);
      world.addWall(wall);
      yWall += boxW;
    }
    
    //create right wall
    xWall = worldW-boxH+shiftX;
    yWall = shiftY+boxH;
    for(int i = 0; i < wallLR; i++){
      wall = new Wall(xWall, yWall, boxH, boxW, HALF_PI);
      world.addWall(wall);
      yWall += boxW;
    }
    
    Target defaultTarget = makeDefaultTarget(worldH,  worldW, boxH, boxW, shiftX, shiftY);
    world.setTarget(defaultTarget);
    
    return world;
  }
  
  public Target makeDefaultTarget(float worldH, float worldW, float boxH, float boxW, float shiftX, float shiftY){                  
    float xTarget = (worldW+shiftX) / 2;
    float yTarget = (worldH+shiftY) / 2;
    float rTarget = boxH / 2;
    
    return new Target(xTarget, yTarget, rTarget);
  }
}

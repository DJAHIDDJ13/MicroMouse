public class WorldBuilder{
  
  public World builderInitialWorld(float worldH, float worldW, float boxH, float boxW){
    Wall wall;
    
    int wallBases = (int)(worldW/boxW);
    int wallLR = (int)(worldH/boxW)-1;
    World world = new World(worldH, worldW);
    float shiftX = SimulationUtility.WORLD_SHIFTX;
    float shiftY = SimulationUtility.WORLD_SHIFTY;
    
    //create top wall
    float xWall = 0;
    float yWall = 0;
    for(int i = 0; i < wallBases; i++){
      wall = new Wall(xWall + boxW / 2 + shiftX, yWall + boxH / 2 + shiftY, boxH, boxW, 0);
      world.addWall(wall);
      xWall += boxW;
    }
    
    //create bottom wall
    xWall = 0;
    yWall = worldH - boxH;
    for(int i = 0; i < wallBases; i++){
      wall = new Wall(xWall + boxW / 2 + shiftX, yWall + boxH / 2 + shiftY, boxH, boxW, 0);
      world.addWall(wall);
      xWall += boxW;
    }
    
    //create left wall
    xWall = 0;
    yWall = boxH;
    for(int i = 0; i < wallLR; i++){
      wall = new Wall(xWall + boxH / 2 + shiftX, yWall + boxW / 2 + shiftY, boxH, boxW, HALF_PI);
      world.addWall(wall);
      yWall += boxW;
    }
    
    //create right wall
    xWall = worldW - boxH;
    yWall = boxH;
    for(int i = 0; i < wallLR; i++){
      wall = new Wall(xWall + boxH / 2 + shiftX, yWall + boxW / 2 + shiftY, boxH, boxW, HALF_PI);
      world.addWall(wall);
      yWall += boxW;
    }
    
    Target defaultTarget = makeDefaultTarget(worldH,  worldW, boxH, boxW);
    world.setTarget(defaultTarget);
    
    return world;
  }
  
  public Target makeDefaultTarget(float worldH, float worldW, float boxH, float boxW){                  
    float xTarget = worldW / 2;
    float yTarget = worldH / 2;
    float rTarget = boxH / 2;
    
    return new Target(xTarget, yTarget, rTarget);
  }
}

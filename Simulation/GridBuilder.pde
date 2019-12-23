public class WorldBuilder{
  
  public World builderInitialWorld(float worldH, float worldW, 
                            float boxH, float boxW, float shiftX, float shiftY){
    Wall wall;
    
    int wallBases = (int)(worldW/boxW);
    int wallLR = (int)(worldH/boxW)-1;
    World world = new World(worldH, worldW);

    //create top wall
    float xWall = shiftX;
    float yWall = shiftY;
    for(int i = 0; i < wallBases; i++){
      wall = new Wall(xWall,yWall,boxH,boxW,0);
      world.addObject(wall);
      xWall += boxW;
    }
    
    //create bottom wall
    xWall = shiftX;
    yWall = worldH-boxH+shiftY;
    for(int i = 0; i < wallBases; i++){
      wall = new Wall(xWall,yWall,boxH,boxW,0);
      world.addObject(wall);
      xWall += boxW;
    }
    
    //create left wall
    xWall = shiftX+1;
    yWall = shiftY+boxH;
    for(int i = 0; i < wallLR; i++){
      wall = new Wall(xWall,yWall,boxW,boxH,0);
      world.addObject(wall);
      yWall+=boxW;
    }
    
    //create right wall
    xWall = worldW-boxH+shiftX;
    yWall = shiftY+boxH;
    for(int i = 0; i < wallLR; i++){
      wall = new Wall(xWall,yWall,boxW,boxH,0);
      world.addObject(wall);
      yWall += boxW;
    }
    
    return world;
  }
}

class WorldBuilder{
  
  World builderInitialWorld(float worldH, float worldW, float boxH, float boxW, float shift){
    Wall wall;
    
    int wallBases = (int)(worldW/boxW);
    int wallLR = (int)(worldH/boxW)-1;
    World world = new World(worldH, worldW);

    //create top wall
    float xWall = shift;
    float yWall = shift;
    for(int i = 0; i < wallBases; i++){
      wall = SimulationFactory.createWall(xWall, yWall, boxH, boxW);
      world.addObject(wall);
      xWall+=boxW;
    }
    
    //create bottom wall
    xWall = shift;
    yWall = worldH-boxH+shift;
    for(int i = 0; i < wallBases; i++){
      wall = SimulationFactory.createWall(xWall, yWall, boxH, boxW);
      world.addObject(wall);
      xWall+=boxW;
    }
    
    //create left wall
    xWall = shift;
    yWall = shift+boxH;
    for(int i = 0; i < wallLR; i++){
      wall = SimulationFactory.createWall(xWall, yWall, boxW, boxH);
      world.addObject(wall);
      yWall+=boxW;
    }
    
    //create right wall
    xWall = worldW-boxH+shift;
    yWall = shift+boxH;
    for(int i = 0; i < wallLR; i++){
      wall = SimulationFactory.createWall(xWall, yWall, boxW, boxH);
      world.addObject(wall);
      yWall+=boxW;
    }
    
    return world;
  }
}

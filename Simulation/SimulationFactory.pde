public static class SimulationFactory{
 
  private static Simulation factory = new Simulation();
  
  static Wall createWall(float x, float y, float h, float w){
    return factory.new Wall(x,y,h,w);  
  }
  
  static World createWorld(float worldH, float worldW){
    return factory.new World(worldH,worldW);
  }
}

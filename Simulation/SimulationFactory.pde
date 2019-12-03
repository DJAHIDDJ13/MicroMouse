public static class SimulationFactory{
 
  private static Simulation factory = new Simulation();
  
  static Wall createWall(float x, float y, float h, float w, float alpha){
    return factory.new Wall(x,y,h,w,alpha);  
  }
  
  static World createWorld(float worldH, float worldW){
    return factory.new World(worldH,worldW);
  }
}

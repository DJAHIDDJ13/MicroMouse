public static class SimulationFactory{
 
  private static Simulation factory = new Simulation();
  
  static Coordinates createCoordinates(int x, int y, int h, int w){
    return factory.new Coordinates(x, y, h, w);
  }
  
  static BoxType createFreeBox(){
    return factory.new FreeBox(); 
  }
  
  static BoxType createTakenBox(){
    return factory.new TakenBox(); 
  }
  
  static Box createBox(Coordinates position, BoxType type){
    return factory.new Box(position, type);  
  }
  
}

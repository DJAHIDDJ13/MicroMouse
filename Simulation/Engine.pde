class Engine{
  int turn;
  World world;
  WorldBuilder builder;
  SimulationEntry systemEntry;
  
  Engine(SimulationEntry systemEntry){
    this.systemEntry = systemEntry;
    float worldH = systemEntry.getWorldH();
    float worldW = systemEntry.getWorldW();
    builder = new WorldBuilder();
    world = builder.builderInitialWorld(worldH, worldW);
    turn = 0;
  }
  
  void simulate(){
   
    turn++;
  }
  
  World getWorld(){
    return world;
  }
  
  void setWorld(World world){
    this.world = world;
  }
  
  int getTurn(){
    return turn;
  }
  
  void setTurn(int turn){
   this.turn = turn; 
  }
}

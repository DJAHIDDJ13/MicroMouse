public class Engine{
  private int turn;
  private World world;
  private WorldBuilder builder;
  private SimulationEntry systemEntry;
  
  public Engine(SimulationEntry systemEntry){
    this.systemEntry = systemEntry;
    float worldH = systemEntry.getWorldH();
    float worldW = systemEntry.getWorldW();
    float boxH = systemEntry.getBoxH();
    float boxW = systemEntry.getBoxW();
    float shiftX = systemEntry.getShiftX();
    float shiftY = systemEntry.getShiftY();
    builder = new WorldBuilder();
    world = builder.builderInitialWorld(worldH,worldW,boxH,boxW,shiftX,shiftY);
    turn = 0;
  }
  
  public void simulate(){
   
    turn++;
  }
  
  public World getWorld(){
    return world;
  }
  
  public void setWorld(World world){
    this.world = world;
  }
  
  public int getTurn(){
    return turn;
  }
  
  public void setTurn(int turn){
   this.turn = turn; 
  }
  
  public SimulationEntry getSimulationEntry(){
     return systemEntry; 
  }
  
  public void setSimulationEntry(SimulationEntry systemEntry){
     this.systemEntry = systemEntry;
  }     
}

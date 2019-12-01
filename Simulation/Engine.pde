class Engine{
  int turn;
  Grid grid;
  GridBuilder builder;
  SimulationEntry systemEntry;
  
  Engine(SimulationEntry systemEntry){
    this.systemEntry = systemEntry;
    int cols = systemEntry.getCols();
    int rows = systemEntry.getRows();
    int boxH = systemEntry.getBoxH();
    int boxW = systemEntry.getBoxW();
    builder = new GridBuilder();
    grid = builder.builderInitialGrid(cols, rows, boxH, boxW);
    turn = 0;
  }
  
  void simulate(){
   
    turn++;
  }
  
  Grid getGrid(){
    return grid;
  }
  
  void setGrid(Grid grid){
    this.grid = grid;
  }
  
  int getTurn(){
    return turn;
  }
  
  void setTurn(int turn){
   this.turn = turn; 
  }
}

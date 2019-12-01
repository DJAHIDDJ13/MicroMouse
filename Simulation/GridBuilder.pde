class GridBuilder{
  
  Grid builderInitialGrid(int cols, int rows, int boxH, int boxW){
    Grid grid = new Grid(cols, rows, boxH, boxW);
    Coordinates position;
    BoxType type;
    Box box;
    for(int i = 0; i < rows; i++){
     for(int j = 0; j < cols; j++){
      position = SimulationFactory.createCoordinates(i, j, boxH, boxW);
      type = (isTakenBoxByInitial(i, j, rows, cols)) ? 
      SimulationFactory.createTakenBox() : SimulationFactory.createFreeBox();
      box = SimulationFactory.createBox(position, type);
      grid.setBoxAt(i, j, box); 
     }
    }
    return grid;
  }
  
  boolean isTakenBoxByInitial(int i, int j, int rows, int cols){
     return (i == 0) || i == rows-1 || (j == 0) || (j == cols-1);
  }
}

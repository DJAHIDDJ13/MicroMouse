public class SimulationEntry{
  
  private String file;
  private float mazeH,mazeW;
  private float boxH,boxW;
  private float shiftX,shiftY;
  //add here all the variable that can be used for simulation
  
  public SimulationEntry(String file, float mazeH, float mazeW, 
                  float boxH, float boxW, float shiftX, float shiftY) {
    this.file = file;
    this.mazeH = mazeH;
    this.mazeW = mazeW;
    this.boxH = boxH;
    this.boxW = boxW;
    this.shiftX = shiftX;
    this.shiftY = shiftY;
  }
  
  public SimulationEntry(float mazeH, float mazeW, float boxH, float boxW, float shiftX, float shiftY) {
    this.mazeH = mazeH;
    this.mazeW = mazeW;
    this.boxH = boxH;
    this.boxW = boxW;
    this.shiftX = shiftX;
    this.shiftY = shiftY;
  }
  
  public SimulationEntry(float rows, float cols) {
    this.boxW = 800 / 160; //the perfect size is 25.
    this.boxH = 800 / 1.6; //it has to be boxH = boxW/2 to work well
    this.mazeH = SimulationUtility.MAZE_SIZE;
    this.mazeW = SimulationUtility.MAZE_SIZE;
    this.shiftX = SimulationUtility.MAZE_SHIFTX;
    this.shiftY = SimulationUtility.MAZE_SHIFTY;
  }
  
  public SimulationEntry(String file){
    this.file = file;
  }
  
  public void setParameters(int rows, int cols){
    this.boxW = SimulationUtility.MAZE_SIZE/rows; //the perfect size is 25.
    this.boxH = boxW /10; //it has to be boxH = boxW/2 to work well
    this.mazeH = rows*boxW;
    this.mazeW = cols*boxW;
  }
  
  public String getFile(){
    return file;
  }
  
  public void setFile(String file){
    this.file = file;
  }
  
  public float getMazeH(){
    return mazeH;
  }
  
  public void setMazeH(float mazeH){
    this.mazeH = mazeH;
  }
  
  public float getMazeW(){
    return mazeW;
  }
  
  public void setMazeW(float mazeW){
    this.mazeW = mazeW;
  }
  
  public float getBoxH(){
    return boxH;
  }
  
  public void setBoxH(float boxH){
    this.boxH = boxH;
  }
  
  public float getBoxW(){
    return boxW;
  }
  
  public void setBoxW(float boxW){
    this.boxW = boxW;
  }
  
   public float getShiftX(){
    return shiftX;
  }
  
  public void setShiftX(float shiftX){
    this.shiftX = shiftX;
  }

   public float getShiftY(){
    return shiftY;
  }
  
  public void setShiftY(float shiftY){
    this.shiftY = shiftY;
  }
}

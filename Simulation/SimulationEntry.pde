public class SimulationEntry{
  private String file;
  private float worldH,worldW;
  private float boxH,boxW;
  private float shiftX,shiftY;
  //add here all the variable that can be used for simulation
  
  public SimulationEntry(String file, float worldH, float worldW, 
                  float boxH, float boxW, float shiftX, float shiftY){
    this.file = file;
    this.worldH = worldH;
    this.worldW = worldW;
    this.boxH = boxH;
    this.boxW = boxW;
    this.shiftX = shiftX;
    this.shiftY = shiftY;
  }
  
  public SimulationEntry(float worldH, float worldW, float boxH, float boxW, float shiftX, float shiftY){
    this.worldH = worldH;
    this.worldW = worldW;
    this.boxH = boxH;
    this.boxW = boxW;
    this.shiftX = shiftX;
    this.shiftY = shiftY;
  }
  
  public SimulationEntry(float cols, float rows){
    this.boxW = 800/rows; //the perfect size is 25.
    this.boxH = boxW/2; //it has to be boxH = boxW/2 to work well
    this.worldH = rows*boxW;
    this.worldW = cols*boxW;
    this.shiftX = 5;
    this.shiftY = 5;
  }
  
  public SimulationEntry(String file){
    this.file = file;
  }
  
  public void setParameters(int rows, int cols){
    this.boxW = 800/rows; //the perfect size is 25.
    this.boxH = boxW/2; //it has to be boxH = boxW/2 to work well
    this.worldH = rows*boxW;
    this.worldW = cols*boxW;    
  }
  
  public String getFile(){
    return file;
  }
  
  public void setFile(String file){
    this.file = file;
  }
  
  public float getWorldH(){
    return worldH;
  }
  
  public void setWorldH(float worldH){
    this.worldH = worldH;
  }
  
  public float getWorldW(){
    return worldW;
  }
  
  public void setWorldW(float worldW){
    this.worldW = worldW;
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

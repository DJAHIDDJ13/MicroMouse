class SimulationEntry{
  String file;
  float worldH,worldW;
  float boxH,boxW;
  float shiftX,shiftY;
  //add here all the variable that can be used for simulation
  
  SimulationEntry(String file, float worldH, float worldW, 
                  float boxH, float boxW, float shiftX, float shiftY){
    this.file = file;
    this.worldH = worldH;
    this.worldW = worldW;
    this.boxH = boxH;
    this.boxW = boxW;
    this.shiftX = shiftX;
    this.shiftY = shiftY;
  }
  
  SimulationEntry(float worldH, float worldW, float boxH, float boxW, float shiftX, float shiftY){
    this.worldH = worldH;
    this.worldW = worldW;
    this.boxH = boxH;
    this.boxW = boxW;
    this.shiftX = shiftX;
    this.shiftY = shiftY;
  }
  
  SimulationEntry(float cols, float rows){
    this.boxW = 800/rows; //the perfect size is 25.
    this.boxH = boxW/2; //it has to be boxH = boxW/2 to work well
    this.worldH = rows*boxW;
    this.worldW = cols*boxW;
    this.shiftX = 5;
    this.shiftY = 5;
  }
  
  SimulationEntry(String file){
    this.file = file;
  }
  
  void setParameters(int rows, int cols){
    this.boxW = 800/rows; //the perfect size is 25.
    this.boxH = boxW/2; //it has to be boxH = boxW/2 to work well
    this.worldH = rows*boxW;
    this.worldW = cols*boxW;    
  }
  
  String getFile(){
    return file;
  }
  
  void setFile(String file){
    this.file = file;
  }
  
  float getWorldH(){
    return worldH;
  }
  
  void setWorldH(float worldH){
    this.worldH = worldH;
  }
  
  float getWorldW(){
    return worldW;
  }
  
  void setWorldW(float worldW){
    this.worldW = worldW;
  }
  
  float getBoxH(){
    return boxH;
  }
  
  void setBoxH(float boxH){
    this.boxH = boxH;
  }
  
  float getBoxW(){
    return boxW;
  }
  
  void setBoxW(float boxW){
    this.boxW = boxW;
  }
  
   float getShiftX(){
    return shiftX;
  }
  
  void setShiftX(float shiftX){
    this.shiftX = shiftX;
  }

   float getShiftY(){
    return shiftY;
  }
  
  void setShiftY(float shiftY){
    this.shiftY = shiftY;
  }
}

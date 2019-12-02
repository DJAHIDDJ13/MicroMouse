class SimulationEntry{
  String file;
  float worldH,worldW;
  float boxH,boxW;
  float shift;
  //add here all the variable that can be used for simulation
  
  SimulationEntry(String file, float worldH, float worldW, float boxH, float boxW, float shift){
    this.file = file;
    this.worldH = worldH;
    this.worldW = worldW;
    this.boxH = boxH;
    this.boxW = boxW;
    this.shift = shift;
  }
  
  SimulationEntry(float worldH, float worldW, float boxH, float boxW, float shift){
    this.worldH = worldH;
    this.worldW = worldW;
    this.boxH = boxH;
    this.boxW = boxW;
    this.shift = shift;
  }
  
  SimulationEntry(String file){
    this.file = file;
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
  
   float getShift(){
    return shift;
  }
  
  void setShift(float shift){
    this.shift = shift;
  }
}

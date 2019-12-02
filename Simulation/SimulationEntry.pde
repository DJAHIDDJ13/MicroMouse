class SimulationEntry{
  String file;
  float worldH,worldW;
  //add here all the variable that can be used for simulation
  
  SimulationEntry(String file, float worldH, float worldW){
    this.file = file;
    this.worldH = worldH;
    this.worldW = worldW;
  }
  
  SimulationEntry(float worldH, float worldW){
    this.worldH = worldH;
    this.worldW = worldW;
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
}

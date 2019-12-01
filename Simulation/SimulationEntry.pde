class SimulationEntry{
  String file;
  int cols;
  int rows;
  int boxH,boxW;
  //add here all the variable that can be used for simulation
  
  SimulationEntry(String file, int cols, int rows, int boxH, int boxW){
    this.file = file;
    this.cols = cols;
    this.rows = rows;
    this.boxH = boxH;
    this.boxW = boxW;
  }
  
  SimulationEntry(int cols, int rows, int boxH, int boxW){
    this.cols = cols;
    this.rows = rows;
    this.boxH = boxH;
    this.boxW = boxW;
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
  
  int getCols(){
    return cols;
  }
  
  void setCols(int cols){
    this.cols = cols;
  }
  
  int getRows(){
    return rows;
  }
  
  void setRows(int rows){
    this.rows = rows;
  }
  
  int getBoxH(){
    return boxH;
  }
  
  void setBoxH(int boxH){
    this.boxH = boxH;
  }
  
  int getBoxW(){
    return boxW;
  }
  
  void setBoxW(int boxW){
    this.boxW = boxW;
  }
}

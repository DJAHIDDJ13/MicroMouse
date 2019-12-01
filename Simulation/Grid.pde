class Grid{
  int cols;
  int rows;
  float boxH;
  float boxW;
  Box[] boxes;  
  
  Grid(int cols, int rows, float boxH, float boxW){
    boxes = new Box[rows*cols];
    this.cols = cols;
    this.rows = rows;
    this.boxH = boxH;
    this.boxW = boxW;
  }
  
  Grid(int cols, int rows, float boxH, float boxW, Box[] boxes){
    this.cols = cols;
    this.rows = rows;
    this.boxes = boxes;
    this.boxH = boxH;
    this.boxW = boxW;
  }
  
  Box getBoxAt(int i, int j){
     Box boxAt = null;
     if(i < rows && j < cols){
       boxAt = boxes[i*cols+j];
     }
     
     return boxAt;
  }
  
  void setBoxAt(int i, int j, Box box){
    if(i < rows && j < cols){
      boxes[i*cols+j] = box;
    }
  }
  
  // Drawing the grid
  void display(int shift){
    stroke(0,0,0);
    int box_shift = shift*6;
    strokeWeight(2);
    rect(5, 5, cols*boxW, rows*boxH);
    for(int i = 0; i < rows; i++){
     for(int j = 0; j < cols; j++){
      Box box = boxes[i*cols+j];
      strokeWeight(10);
      if(!box.type.isFree())
        stroke(255,0,0);
      else
        stroke(0,0,0);
      point(box.position.getX()*box.position.getW()+box_shift
      , box.position.getY()*box.position.getH()+box_shift);
     }
    }
    strokeWeight(1);
  }
}

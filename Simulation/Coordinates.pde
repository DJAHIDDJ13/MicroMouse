class Coordinates{
  
  int x,y;
  int h,w; 
  
  Coordinates(int x, int y, int h, int w){
    this.x = x;
    this.y = y;
    this.h = h;
    this.w = w;
  }
  
  int getX(){
    return x; 
  }
  
  int getY(){
    return y; 
  }
  
  int getH(){
    return h; 
  }
  
  int getW(){
    return w; 
  }
  
  void setX(int x){
    this.x = x; 
  }
  
  void setY(int y){
    this.y = y;
  }
  
  void setH(int h){
    this.h = h; 
  }
  
  void setW(int w){
    this.w = w; 
  }
}

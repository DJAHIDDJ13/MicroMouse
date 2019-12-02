// A rectangular box
abstract class Object{
  
  float x,y;
  float h,w; 
  
  // Constructor
  Object(float x, float y, float h, float w){
    this.x = x;
    this.y = y;
    this.h = h;
    this.w = w;
  }
  
  float getX(){
    return x; 
  }
  
  float getY(){
    return y; 
  }
  
  float getH(){
    return h; 
  }
  
  float getW(){
    return w; 
  }
  
  void setX(float x){
    this.x = x; 
  }
  
  void setY(float y){
    this.y = y;
  }
  
  void setH(float h){
    this.h = h; 
  }
  
  void setW(float w){
    this.w = w; 
  }
  
  boolean equals(Object object){
    return this.x == object.getX() && this.y == object.getY()
            && this.h == object.getH() && this.w == object.getW();
  }
  
  abstract boolean isWall();
}

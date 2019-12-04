// A rectangular box
abstract class Object{
  
  float x,y;
  float h,w;
  float alpha;
  
  // But we also have to make a body for box2d to know about it
  Body b;

  
  // Constructor
  Object(float x, float y, float h, float w, float alpha){
    this.x = x;
    this.y = y;
    this.h = h;
    this.w = w;
    this.alpha = alpha;
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
  
  float getAlpha(){
    return alpha;
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
  
  void setAlpha(float alpha){
    this.alpha = alpha;
  }
  
  boolean coordinatesInPerimeter(float mX, float mY){
   return (mX >= x && mX <= w+x) && (mY >= y && mY <= h+y); 
  }
  
  boolean equals(Object object){
    return this.x == object.getX() && this.y == object.getY()
            && this.h == object.getH() && this.w == object.getW();
  }
  
  abstract boolean isWall();
}

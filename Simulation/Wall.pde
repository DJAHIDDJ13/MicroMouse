class Wall extends Object{
 
  // Constructor
  Wall(float x, float y, float h, float w, float alpha){
    super(x,y,h,w,alpha);
  }
  
  boolean isWall(){
    return true;
  }
}

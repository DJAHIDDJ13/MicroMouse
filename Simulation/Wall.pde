public class Wall extends Object{
 
  // Constructor
  public Wall(float x, float y, float h, float w, float alpha){
    super(x,y,h,w,alpha);
  }
  
  public boolean isWall(){
    return true;
  }
}

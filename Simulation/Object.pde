// A rectangular box
public abstract class Object{
  
  private float x,y;
  private float h,w;
  private float alpha;
  
  // But we also have to make a body for box2d to know about it
  private Body body;

  
  // Constructor
  public Object(float x, float y, float h, float w, float alpha){
    this.x = x;
    this.y = y;
    this.h = h;
    this.w = w;
    this.alpha = alpha;
    makeBody();
  }
  
  public void setPosition(float x, float y, float h, float w, float alpha){
    this.x = x;
    this.y = y;
    this.h = h;
    this.w = w;
    this.alpha = alpha;
    makeBody();   
  }
  
  public float getX(){
    return x; 
  }
  
  public float getY(){
    return y; 
  }
  
  public float getH(){
    return h; 
  }
  
  public float getW(){
    return w; 
  }
  
  public float getAlpha(){
    return alpha;
  }
  
  public void setX(float x){
    this.x = x; 
  }
  
  public void setY(float y){
    this.y = y;
  }
  
  public void setH(float h){
    this.h = h; 
  }
  
  public void setW(float w){
    this.w = w; 
  }
  
  public void setAlpha(float alpha){
    this.alpha = alpha;
  }
  
  public boolean coordinatesInPerimeter(float mX, float mY){
   return (mX >= x && mX <= w+x) && (mY >= y && mY <= h+y); 
  }
  
  public boolean equals(Object object){
    return this.x == object.getX() && this.y == object.getY()
            && this.h == object.getH() && this.w == object.getW();
  }
  
  public Body getBody(){
    return body;
  }
  
  public void setBody(Body body){
    this.body = body;
  }
  
  // This function removes the particle from the box2d world
  public void killBody(){
    Simulation.getBox2D().destroyBody(body);
  }

  // This function adds the rectangle to the box2d world
  abstract void makeBody();
  public abstract boolean isWall();
  public abstract void display();
}

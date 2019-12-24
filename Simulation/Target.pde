public class Target extends Box{
  
  private float r;
  
  // Constructor
  public Target(float x, float y, float h, float w, float alpha, float r){
    super(x,y,h,w,alpha);
    this.r = r;
  }
  
  public boolean isWall(){
    return false;
  }
  
  public boolean isTarget(){
    return true;
  }
  
  public float getR(){
    return r;
  }
  
  public void setR(float r){
    this.r = r;
  }
  
  public boolean coordinatesInPerimeter(float mX, float mY){
    float x1 = getX();
    float y1 = getY();
    
    float d = sqrt(pow((mX-x1),2)+pow((mY-y1),2));
    
    return d < r;
  }
  
  public void setPosition(float x, float y, float h, float w, float alpha, float r){
    setX(x);
    setY(y);
    setH(h);
    setW(w);
    setAlpha(alpha);
    this.r = r;
    makeBody();   
  }
  
  public void display(){
    // We look at each body and get its screen position
    Vec2 pos = Simulation.getBox2D().getBodyPixelCoord(getBody());
    // Get its angle of rotation
    float a = getBody().getAngle();
    
    pushMatrix();
    translate(pos.x, pos.y);
    rotate(a);
    fill(127);
      stroke(0);
      strokeWeight(1);
      ellipse(0, 0, r*2, r*2);
      line(-r, 0, r, 0);
      line(0, -r, 0, r);
    fill(255);
    popMatrix();
  }
  
  public void displayVertex(){
    
  }
  
  public void makeBody(){
    // box2d circle shape of radius r
    CircleShape cs = new CircleShape();
    cs.m_radius = box2d.scalarPixelsToWorld(r);

    // Define a fixture
    FixtureDef fd = new FixtureDef();
    fd.shape = cs;
    // Parameters that affect physics
    fd.density = 1;
    fd.friction = 0.3;
    fd.restitution = 0.5; 

    // Define the body and make it from the shape
    BodyDef bd = new BodyDef();
    bd.type = BodyType.STATIC;
    bd.position.set(Simulation.getBox2D().coordPixelsToWorld(getX(),getY()));
    bd.setAngle(getAlpha());

    setBody(Simulation.getBox2D().createBody(bd));
    getBody().createFixture(fd);
  }
}

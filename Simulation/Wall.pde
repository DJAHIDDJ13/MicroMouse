public class Wall extends Box{
 
  // Constructor
  public Wall(float x, float y, float h, float w, float alpha){
    super(x,y,h,w,alpha);
  }
  
  public boolean isWall(){
    return true;
  }
  
  public void display(){
    // We look at each body and get its screen position
    Vec2 pos = box2d.getBodyPixelCoord(getBody());
    // Get its angle of rotation
    float a = getBody().getAngle();      
    
    pushMatrix();
    fill(127,0,0);
      translate(pos.x, pos.y);
      rotate(-a);
      stroke(0);
      rect(0, 0, getW(), getH());
    fill(255);
    popMatrix();
  }
  
  void displayVertex(){
    float dx,dy,dw,dh,alpha;
    float worldS = 1;    
    
    fill(127,0,0);
    dw = getW()/(worldS*2);
    dh = getH()/(worldS*2);  
    dx = getX()+wall.getW()/2;
    dy = getY()+wall.getH()/2;
    alpha = -getAlpha();
    beginShape();
      vertex(dx+(int)floor(0.5+dw*cos(alpha))-(int)floor(0.5+dh*sin(alpha)),
      dy+(int)floor(0.5+dh*cos(alpha))+(int)floor(0.5+dw*sin(alpha)));
      vertex(dx-(int)floor(0.5+dw*cos(alpha))-(int)floor(0.5+dh*sin(alpha)),
      dy+(int)floor(0.5+dh*cos(alpha))-(int)floor(0.5+dw*sin(alpha)));
     vertex(dx-(int)floor(0.5+dw*cos(alpha))+(int)floor(0.5+dh*sin(alpha)),
     dy-(int)floor(0.5+dh*cos(alpha))-(int)floor(0.5+dw*sin(alpha)));
     vertex(dx+(int)floor(0.5+dw*cos(alpha))+(int)floor(0.5+dh*sin(alpha)),
     dy-(int)floor(0.5+dh*cos(alpha))+(int)floor(0.5+dw*sin(alpha)));
     vertex(dx+(int)floor(0.5+dw*cos(alpha))-(int)floor(0.5+dh*sin(alpha)),
     dy+(int)floor(0.5+dh*cos(alpha))+ (int)floor(0.5+dw*sin(alpha)));
   endShape();
   fill(255);  
  }
  
  public void makeBody(){
    // Define a polygon (this is what we use for a rectangle)
    PolygonShape sd = new PolygonShape();
    float box2dW = Simulation.getBox2D().scalarPixelsToWorld(getW()/2);
    float box2dH = Simulation.getBox2D().scalarPixelsToWorld(getH()/2);
    sd.setAsBox(box2dW, box2dH);
    
    // Define a fixture
    FixtureDef fd = new FixtureDef();
    fd.shape = sd;
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
    
    getBody().setGravityScale(0.0);
  }
}

public class Wall {
  private float h, w;
  private Body body;

  // Constructor
  public Wall(float x, float y, float w, float h, float angle) {
    this.h = h;
    this.w = w;
    makeBody(x, y, angle);
  }
  
  public Vec2 getPosition() {
    return body.getPosition();
  }
  
  public float getAngle() {
    return body.getAngle(); 
  }
  
  public void setPosition(float x, float y) {
    body.setTransform(new Vec2(x, y), getAngle());
  }
  
  public void setAngle(float angle) {
    body.setTransform(getPosition(), angle);
  }

  public void setTransform(float x, float y, float angle) {
    body.setTransform(new Vec2(x, y), angle);
  }

  public Body getBody() {
    return body; 
  }

  public void display() {
    // We look at each body and get its screen position
    Vec2 pos = box2d.coordWorldToPixels(getPosition());
    
    // Get its angle of rotation
    float a = getAngle();
    
    float pixelW = box2d.scalarWorldToPixels(w);
    float pixelH = box2d.scalarWorldToPixels(h);
    
    pushMatrix();
    rectMode(CENTER);
    fill(127,0,0);
      translate(pos.x , pos.y);
      // adjust for the maze canvas shift
      translate(-SimulationUtility.MAZE_SHIFTX, -SimulationUtility.MAZE_SHIFTY);
      rotate(-a);
      stroke(0);
      rect(0, 0, pixelW * 2, pixelH * 2);
    fill(255);
    popMatrix();
  }
    
  public void makeBody(float x, float y, float angle) {
    // Define a polygon (this is what we use for a rectangle)
    PolygonShape sd = new PolygonShape();
    sd.setAsBox(w, h);
    
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
    bd.position.set(x, y);
    bd.setAngle(angle);

    this.body = box2d.createBody(bd);
    this.body.createFixture(fd);
    
    //this.body.setGravityScale(1.0);
    
    // set the current wall object as data for the body
    this.body.setUserData(this);
  }
}

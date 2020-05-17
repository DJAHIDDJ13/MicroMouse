public class Wheel {
  private float w, h;
  private float pixelW, pixelH;
  private Body body;
  private float revolutionAngle; 

  // Constructor
  public Wheel(float x, float y, float w, float h, float angle) {
    this.h = h;
    this.w = w;
    this.pixelW = box2d.scalarWorldToPixels(w);
    this.pixelH = box2d.scalarWorldToPixels(h);
    
    makeBody(x, y, angle);
    revolutionAngle = 0.0;
  }
  public Wheel(Vec2 p, float w, float h, float angle) {
    this.h = h;
    this.w = w;
    this.pixelW = box2d.scalarWorldToPixels(w);
    this.pixelH = box2d.scalarWorldToPixels(h);
    
    makeBody(p.x, p.y, angle);
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
  
  public void setPosition(Vec2 p) {
    body.setTransform(p, getAngle());
  }
  
  public void setAngle(float angle) {
    body.setTransform(getPosition(), angle);
  }

  public void setTransform(float x, float y, float angle) {
    body.setTransform(new Vec2(x, y), angle);
  }
  
  public void setTransform(Vec2 p, float angle) {
    body.setTransform(p, angle);
  }

  public Body getBody() {
    return body; 
  }
  
  // calculates the lateral velocity of the body
  Vec2 getLateralVelocity() {
    Vec2 currentRightNormal = body.getWorldVector(new Vec2(1, 0));
    return currentRightNormal.mul(Vec2.dot(currentRightNormal, body.getLinearVelocity()));
  }
  
  // calculates forward velocity
  Vec2 getForwardVelocity() {
    Vec2 currentRightNormal = body.getWorldVector(new Vec2(0, 1));
    return currentRightNormal.mul(Vec2.dot(currentRightNormal, body.getLinearVelocity()));
  }
  
  public float getRevolutionAngle() {
    return revolutionAngle;
  }
  
  void updateFriction() {
    // cancelling lateral velocity
    float maxLateralImpulse = 3.0f;
    Vec2 impulse = getLateralVelocity().mul(10*-body.getMass());
    if ( impulse.length() > maxLateralImpulse ) // allow skidding at after a certain point
      impulse.mul(maxLateralImpulse / impulse.length());
    body.applyLinearImpulse(impulse, body.getWorldCenter(), true);

    // limiting angular velocity
    body.applyAngularImpulse(10f * body.getAngularVelocity() * -body.getInertia());

    // apply drag force
    Vec2 currentForwardNormal = getForwardVelocity();
    float currentForwardSpeed = currentForwardNormal.normalize();
    float dragForceMagnitude = -2 * currentForwardSpeed;
    body.applyForce(currentForwardNormal.mul(dragForceMagnitude), body.getWorldCenter());

    /** Revolution angle calc logic here */
    /** Needs to model the way the wheel moves when there is lateral and/or frontal skidding */
    /** between 0-2*PI (to avoid floating point precision problems when if the values get too big)??
     ** may cause problem with sampling of the encoder if the readings are 
     ** too long apart. maybe 0-10*PI or something to make the problem less likely */
    //float wheelCircumference = PI * r * r;

    revolutionAngle = 0;
  }
  
  //tire class function
  void move(float force) {      
      //find current speed in forward direction
      Vec2 currentForwardNormal = body.getWorldVector(new Vec2(0, 1));

      body.applyForce(currentForwardNormal.mul(force), body.getWorldCenter());
  }

  public void display() {
    // We look at each body and get its screen position
    Vec2 pos = box2d.coordWorldToPixels(getPosition());
    // Get its angle of rotation
    float a = getAngle();
    
    pushMatrix();
    rectMode(CENTER);
    fill(127,127,127);
      translate(pos.x, pos.y);
      translate(-SimulationUtility.MAZE_SHIFTX, -SimulationUtility.MAZE_SHIFTY);
      rotate(-a);
      stroke(0);
      rect(0, 0, pixelW, pixelH);
    fill(255);
    popMatrix();
  }
  
  public void makeBody(float x, float y, float angle) {
    // Define a polygon (this is what we use for a rectangle) //<>// //<>//
    PolygonShape sd = new PolygonShape();
    sd.setAsBox(w / 2, h / 2);
    
    // Define a fixture
    FixtureDef fd = new FixtureDef();
    fd.shape = sd;
    
    // Parameters that affect physics (Surface)
    fd.density = 1;
    fd.friction = 0.3;
    fd.restitution = 0.5; 

    // Define the body and make it from the shape
    BodyDef bd = new BodyDef();
    bd.type = BodyType.DYNAMIC;
    bd.position.set(x, y);
    bd.setAngle(angle);
    
    // to ignore during the sensor callback
    bd.userData = new Integer(1);

    this.body = box2d.createBody(bd);
    this.body.createFixture(fd);
    
    this.body.setGravityScale(1.0);
  }
}

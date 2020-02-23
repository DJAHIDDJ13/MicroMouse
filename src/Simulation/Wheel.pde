public class Wheel {
  private float w, h;
  private Body body;

  // Constructor
  public Wheel(float x, float y, float w, float h, float angle) {
    this.h = h;
    this.w = w;
    makeBody(x, y, angle);
  }
  
  public Vec2 getPosition() {
    Vec2 pos = box2d.getBodyPixelCoord(body);
    // adjust for the maze canvas shift
    pos.x -= SimulationUtility.MAZE_SHIFTX;
    pos.y -= SimulationUtility.MAZE_SHIFTY;
    return pos;
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
  }
  
  //tire class function
  void move(float force) {      
      //find current speed in forward direction
      Vec2 currentForwardNormal = body.getWorldVector(new Vec2(0, 1));

      body.applyForce(currentForwardNormal.mul(force), body.getWorldCenter());
  }

  public void display() {
    // We look at each body and get its screen position
    Vec2 pos = getPosition();
    
    // Get its angle of rotation
    float a = getAngle();
    
    pushMatrix();
    rectMode(CENTER);
    fill(127,127,127);
      translate(pos.x, pos.y);
      rotate(-a);
      stroke(0);
      rect(0, 0, w, h);
    fill(255);
    popMatrix();
  }
  
  public void makeBody(float x, float y, float angle) {
    // Define a polygon (this is what we use for a rectangle)
    PolygonShape sd = new PolygonShape();
    float box2dW = box2d.scalarPixelsToWorld(w / 2);
    float box2dH = box2d.scalarPixelsToWorld(h / 2);
    sd.setAsBox(box2dW, box2dH);
    
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
    bd.position.set(box2d.coordPixelsToWorld(x, y));
    bd.setAngle(angle);

    this.body = box2d.createBody(bd);
    this.body.createFixture(fd);
    
    this.body.setGravityScale(1.0);
  }
}

public class Wheel {
  
  private float w, h;
  private float pixelW, pixelH;
  private Body body;
  private double revolutionAngle; 
  private float wheelCircumference;
  private Vec2 prev_pos;
  private float prev_ang;
  private boolean first_value = false;
  private double total_displacement;
  private double force;
  private double forward_displacement;
  private double backward_displacement;
  
  // Constructor
  public Wheel(float x, float y, float w, float h, float angle) {
    this.h = h;
    this.w = w;
    this.pixelW = box2d.scalarWorldToPixels(w);
    this.pixelH = box2d.scalarWorldToPixels(h);
    this.force = 0;
    
    makeBody(x, y, angle);
    revolutionAngle = 0.0;
    
    prev_pos = new Vec2();
    prev_ang = 0;
    total_displacement = 0.0;
    forward_displacement = 0.0;
    backward_displacement = 0.0;
    wheelCircumference = PI * (h/2) * (h/2);
  }
  
  public Wheel(Vec2 p, float w, float h, float angle) {
    this.h = h;
    this.w = w;
    this.pixelW = box2d.scalarWorldToPixels(w);
    this.pixelH = box2d.scalarWorldToPixels(h);
    
    makeBody(p.x, p.y, angle);
    
    prev_pos = new Vec2();
    prev_ang = 0;
    total_displacement = 0.0;
    forward_displacement = 0.0;
    backward_displacement = 0.0;
    wheelCircumference = PI * h * h;
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
  
  public double getForce() {
    return force;
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
  
  public float getWheelCircumference() {
    return wheelCircumference; 
  }
  
  public double getRevolutionAngle() {
    /** Revolution angle calc logic here */
    /** Needs to model the way the wheel moves when there is lateral and/or frontal skidding */
    /** between 0-2*PI (to avoid floating point precision problems when if the values get too big)??
     ** may cause problem with sampling of the encoder if the readings are 
     ** too long apart. maybe 0-10*PI or something to make the problem less likely */
     Vec2 new_pos = getPosition();
     float new_ang = getAngle();
     
     /*float dist = dist(new_pos.x, new_pos.y, prev_pos.x, prev_pos.y);
     
     if(dist > 0.9 * simCon.maze.getBoxW()) {
        prev_pos.set(new_pos);
        prev_ang = new_ang;
        
        return revolutionAngle;
     }*/
     
    if(first_value) {
      total_displacement += cos(new_ang - prev_ang) * dist(prev_pos.x, prev_pos.y, new_pos.x, new_pos.y);
      
      // Figuring out the direction of the movement of the wheel
      Vec2 diff = new_pos.sub(prev_pos); // the movement vector
      // the angle of the vehicle restricted between -PI and PI, the double modulus is necessary to handle negative numbers
      // Here we phase the angle by HALF_PI and then restrict it between 0,2*PI. then back to -PI,PI
      float restricted_ang = (((new_ang - HALF_PI) % TWO_PI) + TWO_PI) % TWO_PI - PI;
      float movement_heading = atan2(diff.y, diff.x); // the angle of the movement vector (heading)
      
      // in order for the wheel to be moving forward, the heading of the movement vector and the direction angle of the wheel
      // must be the same or within PI/2 of each other (plus or minus PI/2), otherwise the movement is backwards
      if(abs(movement_heading - restricted_ang) < HALF_PI) { // wheel moving forward
        forward_displacement += cos(new_ang - prev_ang) * dist(prev_pos.x, prev_pos.y, new_pos.x, new_pos.y);
      } else { // backward
        backward_displacement += dist(prev_pos.x, prev_pos.y, new_pos.x, new_pos.y);
      }
      total_displacement = forward_displacement  - backward_displacement;
      revolutionAngle = total_displacement / wheelCircumference * 2*PI;
    }
    
    first_value = true;
    prev_pos.set(new_pos);
    prev_ang = new_ang;
    
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
    body.applyAngularImpulse(10f * body.getAngularVelocity() * -body.getInertia() * 7f);

    // apply drag force
    Vec2 currentForwardNormal = getForwardVelocity();
    float currentForwardSpeed = currentForwardNormal.normalize();
    float dragForceMagnitude = -10 * currentForwardSpeed;
    body.applyForce(currentForwardNormal.mul(dragForceMagnitude), body.getWorldCenter());
  }
  
  //tire class function
  void move(float desiredSpeed) { 
      // 200
      float m_maxDriveForce = 200;
      
      //find current speed in forward direction
      Vec2 currentForwardNormal = body.getWorldVector(new Vec2(0, 1));
      float currentSpeed = Vec2.dot(getForwardVelocity(), currentForwardNormal);
      //apply necessary force
      float force = 0;
      if ( desiredSpeed > currentSpeed )
          force = m_maxDriveForce;
      else if ( desiredSpeed < currentSpeed )
          force = -m_maxDriveForce;
      else
          return;
      this.force = force;
      //m_body->ApplyForce( force * currentForwardNormal, m_body->GetWorldCenter() );
      body.applyForce(currentForwardNormal.mul(force), body.getWorldCenter());
  }

  public void display() {
    // We look at each body and get its screen position
    Vec2 pos = box2d.coordWorldToPixels(getPosition());
    // Get its angle of rotation

    float a = getAngle();
    
    pushMatrix();
    rectMode(CENTER);
    fill(0,0,0,150);
      translate(pos.x, pos.y);
      translate(-SimulationUtility.MAZE_SHIFTX, -SimulationUtility.MAZE_SHIFTY);
      rotate(-a);
      stroke(0);
      rect(0, 0, pixelW, pixelH);
    fill(255);
    popMatrix();
  }
  
  public void makeBody(float x, float y, float angle) {
    // Define a polygon (this is what we use for a rectangle)
    PolygonShape sd = new PolygonShape();
    sd.setAsBox(w / 2, h / 2);
    
    // Define a fixture
    FixtureDef fd = new FixtureDef();
    fd.shape = sd;
    
    // Parameters that affect physics (Surface)
    fd.density = 0.5;
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

public class Vehicle {
  private final Vec2[] topShape;
  private final Vec2[] middleShape;
  private final Vec2[] bottomShape;
  private final Vec2 wheelSize;
  private final Vec2[] wheelPos;
  private final Vec2[] sensorPos;
  private final float[] sensorAngles;
  
  private Wheel FRWheel, BRWheel, FLWheel, BLWheel;
  private Sensor[] sensors;
  
  private float vehicleSize;
  private Body body;

  // Constructor
  public Vehicle(float x, float y, float angle, float size) {
    // top
    topShape = new Vec2[5];
    topShape[0] = new Vec2(-58, -35).mul(size);
    topShape[1] = new Vec2(-50, -63).mul(size);
    topShape[2] = new Vec2(0, -79).mul(size);
    topShape[3] = new Vec2(49, -63).mul(size);
    topShape[4] = new Vec2(59, -35).mul(size);

    
    // middle
    middleShape = new Vec2[4];
    middleShape[0] = new Vec2(39, -35).mul(size);
    middleShape[1] = new Vec2(39, 34).mul(size);    
    middleShape[2] = new Vec2(-38, 35).mul(size);
    middleShape[3] = new Vec2(-38, -35).mul(size);
    
    // bottom
    bottomShape = new Vec2[4];
    bottomShape[0] = new Vec2(52, 34).mul(size);
    bottomShape[1] = new Vec2(52, 51).mul(size);
    bottomShape[2] = new Vec2(-52, 51).mul(size);
    bottomShape[3] = new Vec2(-52, 35).mul(size);

    wheelSize = new Vec2(8, 27).mul(size);
    wheelPos = new Vec2[4];
    wheelPos[0] = new Vec2(48, -14).mul(size);
    wheelPos[1] = new Vec2(-48, -14).mul(size);
    wheelPos[2] = new Vec2(48, 15).mul(size);
    wheelPos[3] = new Vec2(-48, 15).mul(size);
        
    sensorPos = new Vec2[4];
    sensorPos[0] = new Vec2(-42, -51).mul(size);
    sensorPos[1] = new Vec2(-20, -64).mul(size);
    sensorPos[2] = new Vec2(20, -64).mul(size);
    sensorPos[3] = new Vec2(42, -51).mul(size);
    
    sensorAngles = new float[4];
    sensorAngles[0] = -90-10;
    sensorAngles[1] = -90-60;
    sensorAngles[2] = -90+60;
    sensorAngles[3] = -90+10;

    vehicleSize = size;

    makeSensors(4);
    makeWheels(x, y, angle);
    makeBody(x, y, angle);
    createJoints();
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
  
  // calculates forward velocity
  Vec2 getForwardVelocity() {
    Vec2 currentRightNormal = body.getWorldVector(new Vec2(0, 1));
    return currentRightNormal.mul(Vec2.dot(currentRightNormal, body.getLinearVelocity()));
  }
  
  public void updateDrag() {
    // apply drag force
    Vec2 currentForwardNormal = getForwardVelocity();
    float currentForwardSpeed = currentForwardNormal.normalize();
    float dragForceMagnitude = -2 * currentForwardSpeed;
    body.applyForce(currentForwardNormal.mul(dragForceMagnitude), body.getWorldCenter()); 
  }
  
  public void update() {
    updateDrag();
    FRWheel.updateFriction();
    FLWheel.updateFriction();
    BRWheel.updateFriction();
    BLWheel.updateFriction();
    
    for(Sensor sensor: sensors) {
      sensor.update(getPosition(), getAngle());
    }
  }
  
  public void sensorActivation() {
   for(int i = 0; i < sensors.length; i++) {
      sensors[i].sensorDetect();
      //println("Sensor [",i,"] -> ", sensors[i].getAngle());
   }
  }
  
  public void move(float left_m, float right_m) {
    FRWheel.move(right_m);
    BRWheel.move(right_m);

    BLWheel.move(left_m);
    FLWheel.move(left_m);
    
    body.applyForce(new Vec2(0, 500), body.getWorldCenter());
  }
  
  private void displaySensors() {
    for(int i = 0; i < sensors.length; i++) {
      sensors[i].display();
      println("Sensor " + i + ": " + sensors[i].getValue());
    } 
    println();
  }
  
  public void display() {
    // We look at each body and get its screen position
    Vec2 pos = getPosition();
    // Get its angle of rotation
    float a = getAngle();
    
    pushMatrix();
    fill(127,127,127);
      Vec2 offset = new Vec2(0, 0);

      translate(pos.x + offset.x, pos.y + offset.y);
      rotate(-a); 
      stroke(0);
      
      beginShape();
        //Drawing of top shape
        for(Vec2 vec: topShape)
          vertex(vec.x, vec.y);
        
        vertex(middleShape[0].x, middleShape[0].y);
        vertex(middleShape[1].x, middleShape[1].y);
        
        vertex(bottomShape[0].x, bottomShape[0].y);
        vertex(bottomShape[1].x, bottomShape[1].y);
        vertex(bottomShape[2].x, bottomShape[2].y);
        vertex(bottomShape[3].x, bottomShape[3].y);
        
        vertex(middleShape[2].x, middleShape[2].y);
        vertex(middleShape[3].x, middleShape[3].y); 
        
        vertex(topShape[0].x, topShape[0].y);
        
      endShape();
    fill(255);
    popMatrix();
    
    //Drawing of the wheels
    FRWheel.display();
    FLWheel.display();
    BRWheel.display();
    BLWheel.display();

    displaySensors();
}
  
  public void makeSensors(int nbSensors) {
    sensors = new Sensor[nbSensors];
    for(int i = 0; i < nbSensors; i++) {
        Vec2 p1 = sensorPos[i];
        float ang = radians(sensorAngles[i]);
        float len = 100;
        
        sensors[i] = new Sensor(p1, ang, len);
    } 
  }
  
  public void makeWheels(float x, float y, float angle) {
    // wheels
    FRWheel = new Wheel(wheelPos[0].x + x, wheelPos[0].y + y, wheelSize.x, wheelSize.y, angle);
    FLWheel = new Wheel(wheelPos[1].x + x, wheelPos[1].y + y, wheelSize.x, wheelSize.y, angle);
    BRWheel = new Wheel(wheelPos[2].x + x, wheelPos[2].y + y, wheelSize.x, wheelSize.y, angle);
    BLWheel = new Wheel(wheelPos[3].x + x, wheelPos[3].y + y, wheelSize.x, wheelSize.y, angle);
  }
  
  public void makeBody(float x, float y, float angle) {
    float x_, y_;
    
    // Define a polygon
    // top shape
    PolygonShape top_s = new PolygonShape();
    Vec2[] topShapeWorld = topShape.clone();
    for(int i = 0; i < topShapeWorld.length; i++) {
      x_ = box2d.scalarPixelsToWorld(topShapeWorld[i].x);
      y_ = -box2d.scalarPixelsToWorld(topShapeWorld[i].y);
      
      topShapeWorld[i] = new Vec2(x_, y_);
    }
    top_s.set(topShapeWorld, topShapeWorld.length);
    
    // middle
    PolygonShape middle_s = new PolygonShape();
    Vec2[] middleShapeWorld = middleShape.clone();
    for(int i = 0; i < middleShapeWorld.length; i++) {
      x_ = box2d.scalarPixelsToWorld(middleShapeWorld[i].x);
      y_ = -box2d.scalarPixelsToWorld(middleShapeWorld[i].y);
      
      middleShapeWorld[i] = new Vec2(x_, y_);
    }
    middle_s.set(middleShapeWorld, middleShapeWorld.length);

    // bottom
    PolygonShape bottom_s = new PolygonShape();
    Vec2[] bottomShapeWorld = bottomShape.clone();
    for(int i = 0; i < bottomShapeWorld.length; i++) {
      x_ = box2d.scalarPixelsToWorld(bottomShapeWorld[i].x);
      y_ = -box2d.scalarPixelsToWorld(bottomShapeWorld[i].y);
      
      bottomShapeWorld[i] = new Vec2(x_, y_);
    }
    bottom_s.set(bottomShapeWorld, bottomShapeWorld.length);
    
    // Define a fixture
    FixtureDef top_fd = new FixtureDef();
    top_fd.shape = top_s;

    // Parameters that affect physics (Surface)
    top_fd.density = 1;
    top_fd.friction = 1;
    top_fd.restitution = 0.6; 
    
    
    // Define a fixture middle
    FixtureDef middle_fd = new FixtureDef();
    middle_fd.shape = middle_s;

    // Parameters that affect physics (Surface)
    middle_fd.density = 1;
    middle_fd.friction = 1;
    middle_fd.restitution = 0.6; 

    // Define a fixture bottom
    FixtureDef bottom_fd = new FixtureDef();
    bottom_fd.shape = bottom_s;
    
    // Parameters that affect physics (Surface)
    bottom_fd.density = 1;
    bottom_fd.friction = 1;
    bottom_fd.restitution = 0.6; 
    
    // Define the body and make it from the shape
    BodyDef bd = new BodyDef();
    bd.type = BodyType.DYNAMIC;
    bd.position.set(box2d.coordPixelsToWorld(x, y));
    bd.setAngle(angle);

    this.body = box2d.createBody(bd);
    this.body.createFixture(top_fd);
    this.body.createFixture(middle_fd);
    this.body.createFixture(bottom_fd);
  }
  
  void createJoints() {
    WeldJointDef FRJoint = new WeldJointDef();
    FRJoint.initialize(body, FRWheel.getBody(), FRWheel.getBody().getWorldCenter());
    WeldJointDef FLJoint = new WeldJointDef();
    FLJoint.initialize(body, FLWheel.getBody(), FLWheel.getBody().getWorldCenter());
    WeldJointDef BRJoint = new WeldJointDef();
    BRJoint.initialize(body, BRWheel.getBody(), BRWheel.getBody().getWorldCenter());
    WeldJointDef BLJoint = new WeldJointDef();
    BLJoint.initialize(body, BLWheel.getBody(), BLWheel.getBody().getWorldCenter());
    
    box2d.createJoint(FRJoint);
    box2d.createJoint(FLJoint);
    box2d.createJoint(BRJoint);
    box2d.createJoint(BLJoint);
  }
}

public class Vehicle {
  
  private final Vec2[] topShape, middleShape, bottomShape;
  private final Vec2 wheelSize;
  private final Vec2[] wheelPos, sensorPos;
  private final float[] sensorAngles;
  
  private Wheel FRWheel, BRWheel, FLWheel, BLWheel;
  private Sensor[] sensors;
  private Accelerometer accelerometer;
  private RotaryEncoder left_encoder, right_encoder; // to simulate encoders at timers 1 and 4
  private float[] encoderData;
  private float vehicleSize;
  private Body body;
  private int vehicleId;
  private long time_stamp;
  private long init_time;
  
  private final static float sensorAngle1 = 90, sensorAngle2 = 10, sensorAngle3 = 60; 

  // Constructor
  public Vehicle(float x, float y, float angle, float size) {
    vehicleSize = size/20;
    
    // top
    topShape = new Vec2[5];
    topShape[0] = new Vec2(-58, -35).mul(vehicleSize);
    topShape[1] = new Vec2(-50, -63).mul(vehicleSize);
    topShape[2] = new Vec2(0, -79).mul(vehicleSize);
    topShape[3] = new Vec2(49, -63).mul(vehicleSize);
    topShape[4] = new Vec2(59, -35).mul(vehicleSize);

    // middle
    middleShape = new Vec2[4];
    middleShape[0] = new Vec2(39, -35).mul(vehicleSize);
    middleShape[1] = new Vec2(39, 34).mul(vehicleSize);    
    middleShape[2] = new Vec2(-38, 35).mul(vehicleSize);
    middleShape[3] = new Vec2(-38, -35).mul(vehicleSize);

    // bottom
    bottomShape = new Vec2[4];
    bottomShape[0] = new Vec2(52, 34).mul(vehicleSize);
    bottomShape[1] = new Vec2(52, 51).mul(vehicleSize);
    bottomShape[2] = new Vec2(-52, 51).mul(vehicleSize);
    bottomShape[3] = new Vec2(-52, 35).mul(vehicleSize);

    // Wheel size and positions
    wheelSize = new Vec2(box2d.scalarPixelsToWorld(8), box2d.scalarPixelsToWorld(27)).mul(vehicleSize * box2d.scaleFactor);
    wheelPos = new Vec2[4];
    wheelPos[0] = box2d.vectorPixelsToWorld(new Vec2(48, -14).mul(vehicleSize * box2d.scaleFactor));
    wheelPos[1] = box2d.vectorPixelsToWorld(new Vec2(-48, -14).mul(vehicleSize * box2d.scaleFactor));
    wheelPos[2] = box2d.vectorPixelsToWorld(new Vec2(48, 15).mul(vehicleSize * box2d.scaleFactor));
    wheelPos[3] = box2d.vectorPixelsToWorld(new Vec2(-48, 15).mul(vehicleSize * box2d.scaleFactor));
    
    // Sensor positions
    sensorPos = new Vec2[4];
    sensorPos[0] = new Vec2(-42, -51).mul(vehicleSize);
    sensorPos[1] = new Vec2(-20, -64).mul(vehicleSize);
    sensorPos[2] = new Vec2(20, -64).mul(vehicleSize);
    sensorPos[3] = new Vec2(42, -51).mul(vehicleSize);
    
    // Sensors angles
    sensorAngles = new float[4];
    sensorAngles[0] = -sensorAngle1-sensorAngle2;
    sensorAngles[1] = -sensorAngle1-sensorAngle3;
    sensorAngles[2] = -sensorAngle1+sensorAngle3;
    sensorAngles[3] = -sensorAngle1+sensorAngle2;
    
    makeWheels(x, y, angle);
    makeBody(x, y, angle);
    createJoints();

    makeSensors(sensorAngles.length);
    accelerometer = new Accelerometer();
    
    left_encoder = new RotaryEncoder();
    right_encoder = new RotaryEncoder();
    encoderData = new float[2];
    init_time = System.nanoTime();
  }
  
  public int getVehicleId() {
    return vehicleId;
  }
  
  public Vec2 getPosition() {    
    return body.getPosition();
  }
  
  public float getEncoderLinesPerRevolution() {
    return left_encoder.getLinesPerRevolution(); 
  }
  
  public float getAngle() {
    return body.getAngle(); 
  }
  
  public float[] getEncoderData() {
    encoderData[0] = (float) left_encoder.getValue();
    encoderData[1] = (float) right_encoder.getValue();
    return encoderData;
  }
  
  public double getLeftWheelForce() {
    return FLWheel.getForce();
  }
  
  public double getRightWheelForce() {
    return FRWheel.getForce();
  }
  
  public float getTimeStamp() {
    return (time_stamp - init_time) / 1000.0f; 
  }
  
  public void setPosition(float x, float y) {
    FRWheel.setPosition(wheelPos[0].x + x, wheelPos[0].y + y);
    FLWheel.setPosition(wheelPos[1].x + x, wheelPos[1].y + y);
    BRWheel.setPosition(wheelPos[2].x + x, wheelPos[2].y + y);
    BLWheel.setPosition(wheelPos[3].x + x, wheelPos[3].y + y);
    
    body.setTransform(new Vec2(x, y), getAngle());
  }

  public void setAngle(float angle) {
    FRWheel.setAngle(angle);
    FLWheel.setAngle(angle);
    BRWheel.setAngle(angle);
    BLWheel.setAngle(angle);
    
    body.setTransform(getPosition(), angle);
  }
  
  public void setLinearVelocity(float x, float y) {
    FRWheel.getBody().setLinearVelocity(new Vec2(x, y));
    FLWheel.getBody().setLinearVelocity(new Vec2(x, y));
    BRWheel.getBody().setLinearVelocity(new Vec2(x, y));
    BLWheel.getBody().setLinearVelocity(new Vec2(x, y));
    
    body.setLinearVelocity(new Vec2(x, y));
  }
  
  public void setAngularVelocity(float w) {
    FRWheel.getBody().setAngularVelocity(w);
    FLWheel.getBody().setAngularVelocity(w);
    BRWheel.getBody().setAngularVelocity(w);
    BLWheel.getBody().setAngularVelocity(w);
    
    body.setAngularVelocity(w);

  }

  public void setTransform(float x, float y, float angle) {
    FRWheel.setTransform(translateVec2(rotateVec2(wheelPos[0], angle), x, y), angle);
    FLWheel.setTransform(translateVec2(rotateVec2(wheelPos[1], angle), x, y), angle);
    BRWheel.setTransform(translateVec2(rotateVec2(wheelPos[2], angle), x, y), angle);
    BLWheel.setTransform(translateVec2(rotateVec2(wheelPos[3], angle), x, y), angle);

    body.setTransform(new Vec2(x, y), angle);
  }

  public Vec2 rotateVec2(Vec2 p, float angle) {
    return new Vec2(p.x*cos(angle) - p.y*sin(angle), p.x*sin(angle) + p.y*cos(angle));
  }
  
  public Vec2 rotateVec2(float x, float y, float angle) {
    return new Vec2(x*cos(angle) - y*sin(angle), x*sin(angle) + y*cos(angle));
  }

  public Vec2 translateVec2(float x, float y, float tx, float ty) {
    return new Vec2(x + tx, y + ty);
  }

  public Vec2 translateVec2(Vec2 p, float tx, float ty) {
    return new Vec2(p.x + tx, p.y + ty);
  }

  public Body getBody() {
    return body; 
  }

  public float getWheelCircumference() {
    return FRWheel.getWheelCircumference(); 
  }

  // calculates forward velocity
  Vec2 getForwardVelocity() {
    Vec2 currentRightNormal = body.getWorldVector(new Vec2(0, 1));
    return currentRightNormal.mul(Vec2.dot(currentRightNormal, body.getLinearVelocity()));
  }

  Vec2[] getSensorPos() {
    return this.sensorPos;
  }

  float[] getSensorAngles() {
    return this.sensorAngles;
  }

  public void updateDrag() {
    // apply drag force
    Vec2 currentForwardNormal = getForwardVelocity();
    float currentForwardSpeed = currentForwardNormal.normalize();
    float dragForceMagnitude = -10 * currentForwardSpeed;
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

    accelerometer.update(getPosition(), getAngle());
    left_encoder.update(FRWheel.getRevolutionAngle());
    right_encoder.update(FLWheel.getRevolutionAngle());
    time_stamp = System.nanoTime();
  }
  
  public void move(float left_m, float right_m) {
    FRWheel.move(right_m);
    BRWheel.move(right_m);

    BLWheel.move(left_m);
    FLWheel.move(left_m);
  }
  
  private void displaySensors() {
    if(simCon.getDisplaySensors()) {
      for(int i = 0; i < sensors.length; i++) {
        sensors[i].display();
      }
    }
  }
   
  public void display() {
    // We look at each body and get its screen position
    Vec2 pos = box2d.coordWorldToPixels(getPosition());
    // Get its angle of rotation
    float a = getAngle();
    
    pushMatrix();
    fill(127,127,127);
      translate(pos.x, pos.y);
      translate(-SimulationUtility.MAZE_SHIFTX, -SimulationUtility.MAZE_SHIFTY);

      rotate(-a);
      scale(box2d.scaleFactor);
      stroke(0);
      strokeWeight(2 / box2d.scaleFactor);
      
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
    strokeWeight(1);
    popMatrix();
    
    // Displaying the wheels
    FRWheel.display();
    FLWheel.display();
    BRWheel.display();
    BLWheel.display();
    
    displaySensors();
  }
  
  public PVector getAcceleration() {
    return accelerometer.getAccelerometer();
  }
  
  public PVector getAngularAcceleration() {
    return accelerometer.getGyro();
  }
  
  public Sensor[] getSensorValues() {
    return sensors;
  }
  
  public void makeSensors(int nbSensors) {
    sensors = new Sensor[nbSensors];
    for(int i = 0; i < nbSensors; i++) {
        Vec2 p1 = sensorPos[i];
        float ang = radians(sensorAngles[i]);
        float len = 10;
        
        sensors[i] = new Sensor(p1, ang, len);
    }
  }
  
  public void makeWheels(float x, float y, float angle) {
    // wheels
    FRWheel = new Wheel(translateVec2(rotateVec2(wheelPos[0], angle), x, y), wheelSize.x, wheelSize.y, angle);
    FLWheel = new Wheel(translateVec2(rotateVec2(wheelPos[1], angle), x, y), wheelSize.x, wheelSize.y, angle);
    BRWheel = new Wheel(translateVec2(rotateVec2(wheelPos[2], angle), x, y), wheelSize.x, wheelSize.y, angle);
    BLWheel = new Wheel(translateVec2(rotateVec2(wheelPos[3], angle), x, y), wheelSize.x, wheelSize.y, angle);
  }
  
  public void makeBody(float x, float y, float angle) {    
    // Define a polygon
    // top shape
    PolygonShape top_s = new PolygonShape();
    Vec2[] topShapeWorld = topShape.clone();
    for(int i = 0; i < topShapeWorld.length; i++) {
      topShapeWorld[i] = new Vec2(topShapeWorld[i].x, -topShapeWorld[i].y);
    }
    top_s.set(topShapeWorld, topShapeWorld.length);
    
    // middle
    PolygonShape middle_s = new PolygonShape();
    Vec2[] middleShapeWorld = middleShape.clone();
    for(int i = 0; i < middleShapeWorld.length; i++) {
      middleShapeWorld[i] = new Vec2(middleShapeWorld[i].x, -middleShapeWorld[i].y);
    }
    middle_s.set(middleShapeWorld, middleShapeWorld.length);

    // bottom
    PolygonShape bottom_s = new PolygonShape();
    Vec2[] bottomShapeWorld = bottomShape.clone();
    for(int i = 0; i < bottomShapeWorld.length; i++) {
      bottomShapeWorld[i] = new Vec2(bottomShapeWorld[i].x, -bottomShapeWorld[i].y);
    }
    bottom_s.set(bottomShapeWorld, bottomShapeWorld.length);
    
    // Define a fixture
    FixtureDef top_fd = new FixtureDef();
    top_fd.shape = top_s;

    // Parameters that affect physics (Surface)
    top_fd.density = 0.5;
    top_fd.friction = 0.3;
    top_fd.restitution = 0.5; 
    
    
    // Define a fixture middle
    FixtureDef middle_fd = new FixtureDef();
    middle_fd.shape = middle_s;

    // Parameters that affect physics (Surface)
    middle_fd.density = 0.5;
    middle_fd.friction = 0.5;
    middle_fd.restitution = 0.6; 

    // Define a fixture bottom
    FixtureDef bottom_fd = new FixtureDef();
    bottom_fd.shape = bottom_s;
    
    // Parameters that affect physics (Surface)
    bottom_fd.density = 0.5;
    bottom_fd.friction = 0.5;
    bottom_fd.restitution = 0.6; 
    
    // Define the body and make it from the shape
    BodyDef bd = new BodyDef();
    bd.type = BodyType.DYNAMIC;
    bd.position.set(x, y);
    bd.setAngle(angle);
    
    // to ignore during the sensor callback
    bd.userData = new Integer(1);

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

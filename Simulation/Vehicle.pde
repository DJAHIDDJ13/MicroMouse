public class Vehicle {
  private final Vec2[] topShape;
  private final Vec2[] middleShape;
  private final Vec2[] bottomShape;
  private Wheel FRWheel, BRWheel, FLWheel, BLWheel;
  private float angle;
  private Body body;

  // Constructor
  public Vehicle(float x, float y, float angle) {
    // top
    topShape = new Vec2[5];
    topShape[0] = new Vec2(4, 48);
    topShape[1] = new Vec2(12, 20);
    topShape[2] = new Vec2(62, 4);
    topShape[3] = new Vec2(111, 20);
    topShape[4] = new Vec2(121, 48);
    
    // middle
    middleShape = new Vec2[4];
    middleShape[0] = new Vec2(101, 48);
    middleShape[1] = new Vec2(101, 117);    
    middleShape[2] = new Vec2(24, 118);
    middleShape[3] = new Vec2(24, 48);
    
    // bottom
    bottomShape = new Vec2[4];
    bottomShape[0] = new Vec2(114, 117);
    bottomShape[1] = new Vec2(114, 134);
    bottomShape[2] = new Vec2(10, 134);
    bottomShape[3] = new Vec2(10, 118);


    for(Vec2 v: topShape) {
      println(v); 
    }
    // wheels
    FRWheel = new Wheel(110, 97, 8, 27, 0);
    FLWheel = new Wheel(14, 97, 8, 27, 0);
    BRWheel = new Wheel(110, 68, 8, 27, 0);
    BLWheel = new Wheel(14, 68, 8, 27, 0);
    
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
  
  //tire class function
  void move(float desiredSpeed) {      

  }
  
  public void update() {
    FRWheel.updateFriction();
    FLWheel.updateFriction();
    BRWheel.updateFriction();
    BLWheel.updateFriction();
  }
  
  public void move(float left_m, float right_m) {
    FRWheel.move(right_m);
    BRWheel.move(right_m);

    BLWheel.move(left_m);
    FLWheel.move(left_m);
    
    body.applyForce(new Vec2(0, 500), body.getWorldCenter());
  }
  
  public void display() {
    // We look at each body and get its screen position
    Vec2 pos = getPosition();
    //Vec2 centeroid = body.centroid(new Transform());
    // Get its angle of rotation
    float a = getAngle();
    
    pushMatrix();
    fill(127,127,127);
      translate(pos.x, pos.y);
      rotate(-a); 
      stroke(0);
      beginShape();
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
      endShape();
    fill(255);
    popMatrix();
    
    FRWheel.display();
    FLWheel.display();
    BRWheel.display();
    BLWheel.display();
  }
  
  public void makeBody(float x, float y, float angle) {
    // print("test");
    // Define a polygon
    // top shape
    PolygonShape top_s = new PolygonShape();
    Vec2[] topShapeWorld = topShape.clone();
    for(int i = 0; i < topShapeWorld.length; i++) {
      topShapeWorld[i] = box2d.coordPixelsToWorld(topShapeWorld[i]);
    }
    top_s.set(topShapeWorld, topShapeWorld.length);

    // middle
    PolygonShape middle_s = new PolygonShape();
    Vec2[] middleShapeWorld = middleShape.clone();
    for(int i = 0; i < middleShapeWorld.length; i++) {
      middleShapeWorld[i] = box2d.coordPixelsToWorld(middleShapeWorld[i]);
    }
    middle_s.set(middleShapeWorld, middleShapeWorld.length);

    // bottom
    PolygonShape bottom_s = new PolygonShape();
    Vec2[] bottomShapeWorld = bottomShape.clone();
    println(bottomShapeWorld);
    for(int i = 0; i < bottomShapeWorld.length; i++) {
      bottomShapeWorld[i] = box2d.coordPixelsToWorld(bottomShapeWorld[i]);
    }
    println(bottomShapeWorld);
    bottom_s.set(bottomShapeWorld, bottomShapeWorld.length);
    println("Centroid " + bottom_s.centroid(new Transform())); 
    
    // PolygonShape test_s = new PolygonShape();
    // test_s.setAsBox(box2d.scalarPixelsToWorld(5), box2d.scalarPixelsToWorld(5));
    //FixtureDef test_fd = new FixtureDef();
    //test_fd.shape = test_s;
    // Parameters that affect physics (Surface)
    //test_fd.density = 1;
    //test_fd.friction = 0.3;
    //test_fd.restitution = 0.5; 

    // Define a fixture
    FixtureDef top_fd = new FixtureDef();
    top_fd.shape = top_s;

    // Parameters that affect physics (Surface)
    top_fd.density = 1;
    top_fd.friction = 0.3;
    top_fd.restitution = 0.5; 

    // Define a fixture middle
    FixtureDef middle_fd = new FixtureDef();
    middle_fd.shape = middle_s;

    // Parameters that affect physics (Surface)
    middle_fd.density = 1;
    middle_fd.friction = 0.3;
    middle_fd.restitution = 0.5; 

    // Define a fixture bottom
    FixtureDef bottom_fd = new FixtureDef();
    bottom_fd.shape = bottom_s;
    
    // Parameters that affect physics (Surface)
    bottom_fd.density = 1;
    bottom_fd.friction = 0.3;
    bottom_fd.restitution = 0.5; 
    
    // Define the body and make it from the shape
    BodyDef bd = new BodyDef();
    bd.type = BodyType.DYNAMIC;
    //bd.position.set(box2d.coordPixelsToWorld(x, y));
    bd.position.set(new Vec2(0, 0));
    bd.setAngle(angle);

    this.body = box2d.createBody(bd);
    this.body.createFixture(top_fd);
    this.body.createFixture(middle_fd);
    this.body.createFixture(bottom_fd);
    
    // this.body.setGravityScale(1.0);
  }
}

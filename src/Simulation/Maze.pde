import org.jbox2d.collision.shapes.Shape;
import org.jbox2d.collision.AABB;
import org.jbox2d.callbacks.QueryCallback;
import java.util.*;

public class Maze {
  private float mazeH, mazeW;
  private float boxW, wallRadius, wallLen;
  private int rows, cols;
  
  private LinkedList<Wall> walls; // using linked list since there will be a lot of inserts/delete
  private Target target;
  private Vehicle vehicle;
  
  public Maze(float mazeW, float mazeH, float boxW, float wallRadius) {
    this.mazeW = mazeW;
    this.mazeH = mazeH;
    this.boxW = boxW;
    this.wallRadius = wallRadius;
    this.wallLen = boxW - wallRadius;
    walls = new LinkedList<Wall>();
  }

  public Target getTarget() {
    return target;
  }
  
  public void setTarget(Target target) {
    this.target = target; 
  }
  
  public float getMazeH(){
    return mazeH;
  }
  
  public void setMazeH(float mazeH){
    this.mazeH = mazeH;
  }
  
  public float getMazeW(){
    return mazeW;
  }
  
  public void setMazeW(float mazeW){
    this.mazeW = mazeW;
  }
  
  public void setVehicle(Vehicle vehicle) {
    this.vehicle = vehicle; 
  }
  
  public Collection<Wall> getWalls(){
    return walls;
  }
  
  public void setWalls(LinkedList<Wall> walls){
    this.walls = walls;
  }

  public boolean wallExist(Wall wall){
    return walls.contains(wall);
  }
  
  public void addWall(Wall wall){
    walls.push(wall);
  }
  
  public Wall addWallAt(int x, int y, WallOrientation o) {    
    float angle = 0.0f;
    Vec2 offset = new Vec2();

    switch(o) {
    case TOP_WALL:    // top
      offset.set(0.5 * boxW, 0         ); angle = 0.0f;    break;
    case RIGHT_WALL:  // right
      offset.set(boxW      , 0.5 * boxW); angle = HALF_PI; break;
    case BOTTOM_WALL: // bottom
      offset.set(0.5 * boxW, boxW      ); angle = 0.0f;    break;
    case LEFT_WALL:   // left
      offset.set(0         , 0.5 * boxW); angle = HALF_PI; break;
    }

    Vec2 top_left_corner = box2d.coordPixelsToWorld(new Vec2(SimulationUtility.MAZE_SHIFTX, SimulationUtility.MAZE_SHIFTY));
    Vec2 cur = top_left_corner.add(new Vec2(x * boxW + offset.x, -y * boxW - offset.y));
    Wall added = new Wall(cur.x, cur.y, wallLen / 2, wallRadius / 2, angle);
    addWall(added);
    
    return added;
  }
  
  // TODO: change this
  ArrayList<Body> getBodyAtPoint(float x, float y) {
    // Create a small box at mouse point
    Vec2 v = box2d.coordPixelsToWorld(x, y);
    final float EPSILON = 0.001;
    AABB aabb = new AABB(new Vec2(v.x - EPSILON, v.y - EPSILON), new Vec2(v.x + EPSILON, v.y + EPSILON));
    
    // Look at the shapes intersecting this box (max.: 10)
    final BodyQueryCallback bodyQueryCallback = new BodyQueryCallback();
    box2d.world.queryAABB(bodyQueryCallback, aabb);
   
    // TODO: find a better way to do this
    return bodyQueryCallback.getBodies();
  }

  public void removeBodyAt(float x, float y) {
    ArrayList<Body> bodies = getBodyAtPoint(x, y);
    for(Body body: bodies) {
      println(body, body.getTransform().p.x, body.getTransform().p.y);
      walls.remove(body.getUserData());
      box2d.destroyBody(body);
    }
  }
  
  public void moveVehicle(float l, float r) {
    vehicle.move(l, r);
  }
  
  public void update() {
    vehicle.update();
  }
  
  // Drawing the grid
  public void display(){
    float size = SimulationUtility.MAZE_SIZE;
    
    // maze canvas
    strokeWeight(2);
    rect(SimulationUtility.MAZE_SHIFTX, SimulationUtility.MAZE_SHIFTY, size, size);
    
    
    // everything draw here starts at the edge maze
    push();
    translate(SimulationUtility.MAZE_SHIFTX, SimulationUtility.MAZE_SHIFTY);

    // draw border line
    line(0, size, size, size);
    line(size, size, size, 0);
    
    // draw all the walls
    for(Wall wall : walls) {
      wall.display();
    }
    
    // draw the vehicle
    vehicle.display();   
   
    // draw the target
    if(target != null)
      target.display();
    
    pop();
    
    // fill whatever isn't canvas
    fill(150);
    stroke(150);
    rect(0, 0, SimulationUtility.MAZE_SHIFTX, height);
    rect(0, 0, width, SimulationUtility.MAZE_SHIFTY);
    rect(SimulationUtility.MAZE_SHIFTX + SimulationUtility.MAZE_SIZE, 0, width, height);
    rect(0, SimulationUtility.MAZE_SHIFTY + SimulationUtility.MAZE_SIZE, width, height);
    noFill();
    strokeWeight(2);
    stroke(0);
    rect(SimulationUtility.MAZE_SHIFTX, SimulationUtility.MAZE_SHIFTY, size, size);
    fill(255);
  } 
}

class BodyQueryCallback implements QueryCallback {
  ArrayList<Body> bodies = new ArrayList<Body>();
  
  @Override
  public boolean reportFixture(Fixture fixture) {
    bodies.add(fixture.getBody());
    return false;
  }
  
  public ArrayList<Body> getBodies() {
    return bodies;
  }
}

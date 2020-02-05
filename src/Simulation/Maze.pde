import org.jbox2d.collision.shapes.Shape;
import org.jbox2d.collision.AABB;
import org.jbox2d.callbacks.QueryCallback;
import java.util.*;

public class Maze {
  private float mazeH, mazeW;
  private LinkedList<Wall> walls; // using linked list since there will be a lot of inserts/delete
  private Target target;
  private Vehicle vehicle;
  
  public Maze(float mazeH, float mazeW) {
    this.mazeH = mazeH;
    this.mazeW = mazeW;
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
  
  // TODO: change this
  ArrayList<Body> getBodyAtPoint(float x, float y) {
    // Create a small box at mouse point
    org.jbox2d.dynamics.World world = box2d.getWorld();
    Vec2 v = box2d.coordPixelsToWorld(x, y);
    final float EPSILON = 0.001;
    AABB aabb = new AABB(new Vec2(v.x - EPSILON, v.y - EPSILON), new Vec2(v.x + EPSILON, v.y + EPSILON));
    
    // Look at the shapes intersecting this box (max.: 10)
    final BodyQueryCallback bodyQueryCallback = new BodyQueryCallback();
    world.queryAABB(bodyQueryCallback, aabb);
   
    // TODO: find a better way to do this
    return bodyQueryCallback.getBodies();
  }

  public void removeBodyAt(float x, float y) {
    ArrayList<Body> bodies = getBodyAtPoint(x, y);
    println("Deleting bodies at " + x + " AND " + y + " " + box2d.coordPixelsToWorld(new Vec2(x, y)));
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
    rect(SimulationUtility.MAZE_SHIFTX, SimulationUtility.MAZE_SHIFTY, mazeW, mazeH);

    
    // everything draw here starts at the edge maze
    push();
    translate(SimulationUtility.MAZE_SHIFTX, SimulationUtility.MAZE_SHIFTY);

    // draw border line
    line(0, size, size, size);
    line(size, size, size, 0);
 
    // draw all the walls
    for(Wall wall : walls){
      wall.display();
    }
    
    // draw the vehicle
    vehicle.display();   
   
    // draw the target
    if(target != null)
      target.display();
          
    pop();
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

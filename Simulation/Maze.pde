import org.jbox2d.collision.shapes.Shape;
import org.jbox2d.collision.AABB;
import org.jbox2d.callbacks.QueryCallback;
import java.util.*;

public class Maze {
  private float mazeH, mazeW;
  private HashMap<Body, Wall> walls;
  private Target target;
  
  public Maze(float mazeH, float mazeW) {
    this.mazeH = mazeH;
    this.mazeW = mazeW;
    walls = new HashMap<Body, Wall>();
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
  
  public Collection<Wall> getWalls(){
    return walls.values();
  }
  
  public void setWalls(HashMap<Body, Wall> walls){
    this.walls = walls;
  }
  /*
  public Wall getWallAt(int i){
   Wall wall = null;
     if(i < walls.size())
       wall = walls.get(i);
   return wall;
  }
  */

  public boolean wallExist(Wall wall){
    return walls.containsValue(wall);
  }
  
  public void addWall(Wall wall){
    walls.put(wall.getBody(), wall);
  }
  
  ArrayList<Body> getBodyAtPoint(float x, float y) {
    // Create a small box at mouse point
    org.jbox2d.dynamics.World world = box2d.getWorld();
    Vec2 v = box2d.coordPixelsToWorld(x, y);
    final float EPSILON = 0.01;
    AABB aabb = new AABB(new Vec2(v.x - EPSILON, v.y - EPSILON), new Vec2(v.x + EPSILON, v.y + EPSILON));
    
    // Look at the shapes intersecting this box (max.: 10)
    final BodyQueryCallback bodyQueryCallback = new BodyQueryCallback();
    world.queryAABB(bodyQueryCallback, aabb);
   
    // TODO: find a better way to do this
    return bodyQueryCallback.getBodies();
  }

  public void removeBodyAt(float x, float y) {
    ArrayList<Body> bodies = getBodyAtPoint(x, y);
    println("Deleting bodies");
    for(Body body: bodies) {
      println(body);
      walls.remove(body);
    }
  }
  
  // Drawing the grid
  public void display(float shiftX, float shiftY){
    float size = SimulationUtility.MAZE_SIZE;
    float shiftx = SimulationUtility.MAZE_SHIFTX+7;
    float shifty = SimulationUtility.MAZE_SHIFTY+7;
    
    strokeWeight(2);
    rect(shiftX, shiftY, mazeW, mazeH);
    
    for(Wall wall : walls.values()){
      wall.display();
    }
    
    if(target != null)
      target.display();
    
    stroke(255);
    line(0, size+shifty, size+shiftx, size+shifty);
    line(size+shiftx, size+shifty, size+shiftx, 0);
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

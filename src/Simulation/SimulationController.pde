import controlP5.*;

public class SimulationController{
  
  private SimulationEntry simulationEntry;
  private MazeBuilder mazeBuilder;
  
  private ControlP5 cp5;
  private float toAddX, toAddY, toAddR, toAddW, toAddH, toAddA;
  
  private int objectPanelState;
  private boolean showingMovingObject;
  private boolean deleteMode;
  private boolean snap;
  private CheckBox snapCheckBox;
  
  private int dashed;
  
  private int size;
  
  private final float panelX = 40;
  private final float panelY = 865;
  private final float panelW = 40;
  private final float panelH = 20;
  private final float panelR = 10;
  
  private Maze maze;
  
  public SimulationController(int size){
    this.size = size;
    
    refreshMaze();
    
    objectPanelState = 0;
    showingMovingObject = false;
    deleteMode = false;
    snap = true;
    dashed = 0;
  }
  
  public int getDashed() {
    return dashed;
  }
  
  public SimulationEntry getSimulationEntry(){
    return simulationEntry;
  }
  
  public Maze getMaze() {
    return maze;
  }
  
 private void refreshMaze() {
   Vec2 gravity = new Vec2(0, 0);
   box2d.createWorld(gravity);

   simulationEntry = new SimulationEntry(size, size);
   mazeBuilder = new MazeBuilder();
   box2d.setScaleFactor(80.0f / size);
   maze = mazeBuilder.builderInitialMaze(box2d.scalarPixelsToWorld(SimulationUtility.MAZE_SIZE),
                                         box2d.scalarPixelsToWorld(SimulationUtility.MAZE_SIZE),
                                         size,
                                         simulationEntry.getRatio());
/* test the addWallAt
   println(maze.addWallAt(1, 1, WallOrientation.LEFT_WALL));
   println(maze.addWallAt(1, 1, WallOrientation.RIGHT_WALL));
   println(maze.addWallAt(1, 1, WallOrientation.TOP_WALL));
   println(maze.addWallAt(1, 1, WallOrientation.BOTTOM_WALL));
*/
 }
  
 public void setController(ControlP5 cp5) {
   this.cp5 = cp5;
 }
 
 public ControlP5 getController(){
   return this.cp5;
 }
  
 public void createControllers(){
    cp5.addButton("+")
       .setValue(1)
       .setPosition(80,840)
       .setSize(20,20)
       ;
    
    cp5.addButton("-")
       .setValue(2)
       .setPosition(80,870)
       .setSize(20,20)
       ;
       
   cp5.addButton("Turn+")
       .setValue(1)
       .setPosition(110,830)
       .setSize(40,30)
       ;
    
    cp5.addButton("Turn-")
       .setValue(2)
       .setPosition(110,870)
       .setSize(40,30)
       ;
       
    cp5.addButton("Add")
       .setValue(3)
       .setPosition(160,855)
       .setSize(40,30)
       ;
    
    cp5.addButton("Remove")
       .setValue(4)
       .setPosition(210,855)
       .setSize(40,30)
       ;
  
    cp5.addButton("Refresh")
       .setValue(5)
       .setPosition(772,855)
       .setSize(40,30)
       ;
    
    cp5.addNumberbox("Size")
       .setPosition(260,855)
       .setSize(40,30)
       .setScrollSensitivity(1.1)
       .setDirection(Controller.HORIZONTAL)
       .setValue(8)
       .setRange(4, 32)
       ;
       
    snapCheckBox = cp5.addCheckBox("SnapCheckBox")
       .setPosition(772, 830)
       .setSize(10, 10)
       .addItem("Snap to grid", 0)
       .activateAll()
       ;
  } 
  
  public void displayMovingObject() {
    rectMode(CENTER);
    // diplay wall at mouseX, mouseY
    pushMatrix();
    Vec2 temp = box2d.coordWorldToPixels(toAddX, toAddY);
    translate(temp.x, temp.y);
    rotate(-toAddA);
    
    float pixelW = box2d.scalarWorldToPixels(toAddW);
    float pixelH = box2d.scalarWorldToPixels(toAddH);
    
    if(objectPanelState == 0) {
      fill(127,0,0);
        stroke(0);
        rect(0, 0, pixelW, pixelH);
      fill(255);
    } // display target
    else {
      fill(127);
        strokeWeight(1);
        ellipse(0, 0, toAddR*2, toAddR*2);
        line(-toAddR, 0, toAddR, 0);
        line(0, -toAddR, 0, toAddR);
      fill(255);
    }
    
    popMatrix();
    
    rectMode(CORNER);
  }

  public void displayPanel() {
    stroke(0);
    rect(5, 830, 70, 70);
}
  
  public void keyPressedHandler() {
    if(key == 'z')
      maze.moveVehicle(400, 400);
    else if(key == 's')
      maze.moveVehicle(-400, -400);
    else if(key == 'q')
      maze.moveVehicle(-400, 400);
    else if(key == 'd')
      maze.moveVehicle(400, -400);
  }

  public void controlEventHandler(ControlEvent event) {
    String eventControllerName = "";
    if(event.getType() != 2)
      eventControllerName = event.getController().getName();
      
    deleteMode = false;
    if(eventControllerName.equals("Turn+") || eventControllerName.equals("Turn-")){
      if(toAddA == 0) {
        toAddA = HALF_PI;
      } else {
        toAddA = 0; 
      }
    } else if(eventControllerName.equals("+") || eventControllerName.equals("-")){
      objectPanelState = 1 - objectPanelState; 
    } else if(eventControllerName.equals("Add")) {
      showingMovingObject = !showingMovingObject;
    } else if(eventControllerName.equals("Remove")) {
      showingMovingObject = false;
      deleteMode = true;
    } else if(eventControllerName.equals("Refresh")) {
      refreshMaze();
    } else if(eventControllerName.equals("Size")) {
      size = (int)cp5.get("Size").getValue();
    } else if(event.isFrom(snapCheckBox)) {
      snap = !snap;
    }
  }
  
  public void mousePressedHandler() {
    // if the click was on the canvas
    if(mouseX < SimulationUtility.MAZE_SIZE + SimulationUtility.MAZE_SHIFTX && mouseY < SimulationUtility.MAZE_SIZE + SimulationUtility.MAZE_SHIFTY) {
      // if showing moving object , means we're adding
      if(showingMovingObject) {
        if(objectPanelState == 0) {
          Wall toAdd = new Wall(toAddX, toAddY, toAddW / 2, toAddH / 2, toAddA);
          maze.addWall(toAdd);
        } else {
          maze.getTarget().setPosition((float) mouseX, (float) mouseY);
        }
      } else if(deleteMode) { // otherwise we're deleting
        maze.removeBodyAt((float) mouseX, (float) mouseY);
      }
    }
  }

  public void snapToGrid() {
    Vec2 top_left_corner = box2d.coordPixelsToWorld(new Vec2(SimulationUtility.MAZE_SHIFTX, SimulationUtility.MAZE_SHIFTY));
    Vec2 temp = box2d.coordPixelsToWorld(mouseX, mouseY).sub(top_left_corner);
    /* FIX THIS */
    float boxW = box2d.scalarPixelsToWorld(SimulationUtility.MAZE_SIZE) / size;
    float boxH = boxW * simulationEntry.getRatio();
    toAddW = boxW - boxH;
    toAddH = boxH;
    toAddX = round(temp.x / boxW) * boxW - cos(toAddA) * (boxW / 2) + top_left_corner.x;
    toAddY = round(temp.y / boxW) * boxW - sin(toAddA) * (boxW / 2) + top_left_corner.y;
    toAddR = toAddH / 2;
  }
  
  // updates the gui
  public void updateController() {
    if(showingMovingObject && mouseX < SimulationUtility.MAZE_SIZE + SimulationUtility.MAZE_SHIFTX 
        && mouseY < SimulationUtility.MAZE_SIZE + SimulationUtility.MAZE_SHIFTY) {
      if(snap) {
        snapToGrid();
      } else {
        float boxW = box2d.scalarPixelsToWorld(SimulationUtility.MAZE_SIZE) / size;
        float boxH = boxW * simulationEntry.getRatio();

        Vec2 temp = box2d.coordPixelsToWorld(mouseX, mouseY);
        toAddX = temp.x;
        toAddY = temp.y;
        toAddW = boxW - boxH;
        toAddH = boxH;
        toAddR = toAddH / 2;
      }
    } else {
      Vec2 temp = box2d.coordPixelsToWorld(panelX, panelY);
      toAddX = temp.x;
      toAddY = temp.y;
      toAddW = box2d.scalarPixelsToWorld(panelW);
      toAddH = box2d.scalarPixelsToWorld(panelH);
      toAddR = panelR;
    }
  }
  
  public void update() {
    dashed++;
    updateController();
    maze.update();
  }
  
  public void display() {
    displayPanel();
    displayMovingObject();
  }
}

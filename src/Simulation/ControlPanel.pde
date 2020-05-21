public class ControlPanel {

  private ControlP5 cp5;
  private Maze maze;

  private float toAddX, toAddY, toAddW, toAddH, toAddA;

  private boolean showingMovingObject;
  private boolean deleteMode;
  private boolean snap;
  private boolean setPosition;

  private final float panelX = 40;
  private final float panelY = 865;
  private final float panelW = 40;
  private final float panelH = 20;
            
  public ControlPanel(ControlP5 cp5, Maze maze) {
    this.maze = maze;
    this.cp5 = cp5;

    showingMovingObject = false;
    deleteMode = false;
    snap = false;
    setPosition = false;
  }

  public void mousePressedHandler() {
    // if the click was on the canvas
    if (mouseX < SimulationUtility.MAZE_SIZE + SimulationUtility.MAZE_SHIFTX && mouseY < SimulationUtility.MAZE_SIZE + SimulationUtility.MAZE_SHIFTY) {
      // if showing moving object , means we're adding
      if (showingMovingObject) {
          Wall toAdd = new Wall(toAddX, toAddY, toAddW / 2, toAddH / 2, toAddA);
          maze.addWall(toAdd);
      } else if (setPosition) {
        int j = (int) (box2d.scalarPixelsToWorld(mouseX-SimulationUtility.MAZE_SHIFTX) / maze.getBoxH());
        int i = (int) (box2d.scalarPixelsToWorld(mouseY-SimulationUtility.MAZE_SHIFTY) / maze.getBoxW());
        
        Vec2 p = maze.getCellWorldCenterAt(j, i);
        Vehicle vehicle = new Vehicle(p.x, p.y, PI, 1.0);
        maze.setVehicle(vehicle);
      } else if (deleteMode) { // otherwise we're deleting
        maze.removeBodyAt((float) mouseX, (float) mouseY);
      }
    }
  }

  public void keyPressedHandler() {
    
  }

  public void controlEventHandler(ControlEvent event) {
    String eventControllerName = "";
    if (event.getType() != 2)
      eventControllerName = event.getController().getName();
    else
      eventControllerName = event.getName();
      
    deleteMode = false;
    if (eventControllerName.equals("Turn+") || eventControllerName.equals("Turn-")) {
      if (toAddA == 0) {
        toAddA = HALF_PI;
      } else {
        toAddA = 0;
      }
    } else if (eventControllerName.equals("Add")) {
      showingMovingObject = !showingMovingObject;
      setPosition = false;
    } else if (eventControllerName.equals("Remove")) {
      showingMovingObject = false;
      deleteMode = true;
      setPosition = false;
    } else if (eventControllerName.equals("Refresh")) {
      simCon.refreshMaze();
    } else if (eventControllerName.equals("Size")) {
      int size = (int) cp5.get("Size").getValue();
      simCon.setSize(size);
    } else if (eventControllerName.equals("SnapCheckBox")) {
      snap = !snap;
    } else if (eventControllerName.equals("Set position")) {
      setPosition = !setPosition;
      showingMovingObject = false;
    }
  }

  public void createControllers() {
    cp5.addButton("Turn+")
      .setValue(1)
      .setPosition(80, 830)
      .setSize(40, 30)
      ;

    cp5.addButton("Turn-")
      .setValue(2)
      .setPosition(80, 870)
      .setSize(40, 30)
      ;

    cp5.addButton("Add")
      .setValue(3)
      .setPosition(130, 855)
      .setSize(40, 30)
      ;

    cp5.addButton("Remove")
      .setValue(4)
      .setPosition(180, 855)
      .setSize(40, 30)
      ;

    cp5.addButton("Refresh")
      .setValue(5)
      .setPosition(772, 855)
      .setSize(40, 30)
      ;

    cp5.addNumberbox("Size")
      .setPosition(230, 855)
      .setSize(40, 30)
      .setScrollSensitivity(1.1)
      .setDirection(Controller.HORIZONTAL)
      .setValue(8)
      .setRange(4, 32)
      ;
      
    cp5.addButton("Set position")
      .setValue(6)
      .setPosition(280, 855)
      .setSize(60, 30)
      ;

    cp5.addCheckBox("SnapCheckBox")
      .setPosition(745, 830)
      .setSize(10, 10)
      .addItem("Snap to grid", 0)
      .activateAll()
      ;
  }

  public void update() {
    updateController();
  }

  public void display() {
    displayPanel();
    displayMovingObject();
  }

  public void snapToGrid() {
    Vec2 top_left_corner = box2d.coordPixelsToWorld(new Vec2(SimulationUtility.MAZE_SHIFTX, SimulationUtility.MAZE_SHIFTY));
    Vec2 temp = box2d.coordPixelsToWorld(mouseX, mouseY).sub(top_left_corner);
    /* FIX THIS */
    float boxW = box2d.scalarPixelsToWorld(SimulationUtility.MAZE_SIZE) / simCon.simulationEntry.getRows();
    float boxH = boxW * simCon.simulationEntry.getRatio();
    toAddW = boxW + boxH;
    toAddH = boxH;

    toAddX = round(temp.x / boxW) * boxW - cos(toAddA) * (boxW / 2) + top_left_corner.x;
    toAddY = round(temp.y / boxW) * boxW - sin(toAddA) * (boxW / 2) + top_left_corner.y;
  }

  // updates the gui
  public void updateController() {
    if (showingMovingObject && mouseX < SimulationUtility.MAZE_SIZE + SimulationUtility.MAZE_SHIFTX 
      && mouseY < SimulationUtility.MAZE_SIZE + SimulationUtility.MAZE_SHIFTY) {
      if (snap) {
        snapToGrid();
      } else {
        float boxW = box2d.scalarPixelsToWorld(SimulationUtility.MAZE_SIZE) / simCon.simulationEntry.getRows();
        float boxH = boxW * simCon.simulationEntry.getRatio();

        Vec2 temp = box2d.coordPixelsToWorld(mouseX, mouseY);
        toAddX = temp.x;
        toAddY = temp.y;
        toAddW = boxW - boxH;
        toAddH = boxH;
      }
    } else {
      Vec2 temp = box2d.coordPixelsToWorld(panelX, panelY);
      toAddX = temp.x;
      toAddY = temp.y;
      toAddW = box2d.scalarPixelsToWorld(panelW);
      toAddH = box2d.scalarPixelsToWorld(panelH);
    }
  }

  public void displayMovingObject() {
    rectMode(CENTER);
    // diplay wall at mouseX, mouseY
    pushMatrix();

      float pixelW = box2d.scalarWorldToPixels(toAddW);
      float pixelH = box2d.scalarWorldToPixels(toAddH);
    
      Vec2 temp = box2d.coordWorldToPixels(toAddX, toAddY);
      translate(temp.x, temp.y);
      rotate(-toAddA);      
      fill(127, 0, 0, 150);
      stroke(0, 150);
      rect(0, 0, pixelW, pixelH);
      fill(255);

    popMatrix();

    rectMode(CORNER);
  }

  public void displayPanel() {
    stroke(0);
    rect(5, 830, 70, 70);
  }
}

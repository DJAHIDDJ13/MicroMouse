public class ControlPanel {

  private ControlP5 cp5;
  private Maze maze;

  private float toAddX, toAddY, toAddR, toAddW, toAddH, toAddA;

  private int objectPanelState;
  private boolean showingMovingObject;
  private boolean deleteMode;
  private boolean snap;

  private final float panelX = 40;
  private final float panelY = 865;
  private final float panelW = 40;
  private final float panelH = 20;
  private final float panelR = 10;  
            
  public ControlPanel(ControlP5 cp5, Maze maze) {
    this.maze = maze;
    this.cp5 = cp5;

    objectPanelState = 0;
    showingMovingObject = false;
    deleteMode = false;
    snap = false;
  }

  public void mousePressedHandler() {
    // if the click was on the canvas
    if (mouseX < SimulationUtility.MAZE_SIZE + SimulationUtility.MAZE_SHIFTX && mouseY < SimulationUtility.MAZE_SIZE + SimulationUtility.MAZE_SHIFTY) {
      // if showing moving object , means we're adding
      if (showingMovingObject) {
        if (objectPanelState == 0) {
          Wall toAdd = new Wall(toAddX, toAddY, toAddW / 2, toAddH / 2, toAddA);
          maze.addWall(toAdd);
        } else {
          maze.getTarget().setPosition((float) mouseX, (float) mouseY);
        }
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
    } else if (eventControllerName.equals("+") || eventControllerName.equals("-")) {
      objectPanelState = 1 - objectPanelState;
    } else if (eventControllerName.equals("Add")) {
      showingMovingObject = !showingMovingObject;
    } else if (eventControllerName.equals("Remove")) {
      showingMovingObject = false;
      deleteMode = true;
    } else if (eventControllerName.equals("Refresh")) {
      simCon.refreshMaze();
    } else if (eventControllerName.equals("Size")) {
      int size = (int) cp5.get("Size").getValue();
      simCon.setSize(size);
    } else if (eventControllerName.equals("SnapCheckBox")) {
      snap = !snap;
    }
  }

  public void createControllers() {
    cp5.addButton("+")
      .setValue(1)
      .setPosition(80, 840)
      .setSize(20, 20)
      ;

    cp5.addButton("-")
      .setValue(2)
      .setPosition(80, 870)
      .setSize(20, 20)
      ;

    cp5.addButton("Turn+")
      .setValue(1)
      .setPosition(110, 830)
      .setSize(40, 30)
      ;

    cp5.addButton("Turn-")
      .setValue(2)
      .setPosition(110, 870)
      .setSize(40, 30)
      ;

    cp5.addButton("Add")
      .setValue(3)
      .setPosition(160, 855)
      .setSize(40, 30)
      ;

    cp5.addButton("Remove")
      .setValue(4)
      .setPosition(210, 855)
      .setSize(40, 30)
      ;

    cp5.addButton("Refresh")
      .setValue(5)
      .setPosition(772, 855)
      .setSize(40, 30)
      ;

    cp5.addNumberbox("Size")
      .setPosition(260, 855)
      .setSize(40, 30)
      .setScrollSensitivity(1.1)
      .setDirection(Controller.HORIZONTAL)
      .setValue(8)
      .setRange(4, 32)
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
    toAddR = toAddH / 2;
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

  public void displayMovingObject() {
    rectMode(CENTER);
    // diplay wall at mouseX, mouseY
    pushMatrix();
    Vec2 temp = box2d.coordWorldToPixels(toAddX, toAddY);
    translate(temp.x, temp.y);
    rotate(-toAddA);

    float pixelW = box2d.scalarWorldToPixels(toAddW);
    float pixelH = box2d.scalarWorldToPixels(toAddH);

    if (objectPanelState == 0) {
      fill(127, 0, 0, 150);
      stroke(0, 150);
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
}

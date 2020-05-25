public class ControlPanel {

  private ControlP5 cp5;
  private Maze maze;

  private float toAddX, toAddY, toAddW, toAddH, toAddA;

  private boolean showingMovingObject;
  private boolean deleteMode;
  private boolean snap;
  private boolean setPosition;
  private boolean PerfectMaze = true ;

  private final float panelX = 40;
  private final float panelY = 845;
  private final float panelW = 40;
  private final float panelH = 20;
  
  private Button buttonStart;  
            
  public ControlPanel(ControlP5 cp5) {
    this.cp5 = cp5;
    showingMovingObject = deleteMode = snap = setPosition = false;
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
        
        Vec2 position = maze.getCellWorldCenterAt(j, i);
        maze.getVehicle().setTransform(position.x, position.y, PI);
        // stop the vehicle from moving
        maze.getVehicle().setLinearVelocity(0, 0);
        maze.getVehicle().setAngularVelocity(0);
        
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
    } 
    else if (eventControllerName.equals("Clear")) {
      simCon.clearMaze();

    } else if (eventControllerName.equals("Refresh")) {
      simCon.refreshMaze(PerfectMaze);
     }
     else if (eventControllerName.equals("Add")) {
      showingMovingObject = !showingMovingObject;
      setPosition = false;
    } else if (eventControllerName.equals("Remove")) {
      showingMovingObject = false;
      deleteMode = true;
      setPosition = false;
    } else if (eventControllerName.equals("Size")) {
      int size = (int) cp5.get("Size").getValue();
      simCon.setSize(size);
    } else if (eventControllerName.equals("SnapCheckBox")) {
      snap = !snap;
    } else if (eventControllerName.equals("Set position")) {
      setPosition = !setPosition;
      showingMovingObject = false;
    } else if (eventControllerName.equals("DebugCheckBox")) {
      simCon.setDebigMode(!simCon.getDebugMode());
    } else if (eventControllerName.equals("Start")) {
      simCon.setStart(!simCon.getStart());
    } else if(eventControllerName.equals("algo")) { 
      ButtonBar bar = (ButtonBar)event.getController();
      switch(bar.hover()) {
        case 1 :
          println("Algorithme Q learning");
          break;
        case 2 :
          println("Algorithme RRT");
          break;
        default :
          println("Algorithme Flood fill");
          break;
      }
    } else if(eventControllerName.equals("Maze type")) {
      ScrollableList list = (ScrollableList)event.getController();
      if((int)list.getValue() == 0) {
        PerfectMaze = true;
        println("Generate perfect maze");
      } else {
        PerfectMaze = false;
        println("Generate imperfect maze");
      }
    }
  }

  public void createControllers() {
    cp5.addButton("Turn+")
      .setValue(1)
      .setPosition(90, 810)
      .setSize(60, 30)
      ;

    cp5.addButton("Turn-")
      .setValue(2)
      .setPosition(90, 850)
      .setSize(60, 30)
      ;

    cp5.addButton("Add")
      .setValue(3)
      .setPosition(160, 830)
      .setSize(60, 30)
      ;

    cp5.addButton("Remove")
      .setValue(4)
      .setPosition(230, 830)
      .setSize(60, 30)
      ;
      
    cp5.addButton("Clear")
      .setValue(7)
      .setPosition(772, 870)
      .setSize(50, 25)
      .setColorForeground(#EA0037)
      ;
      
    cp5.addButton("Refresh")
      .setValue(5)
      .setPosition(772, 830)
      .setSize(50, 25)
      ;

    cp5.addNumberbox("Size")
      .setPosition(662, 870)
      .setSize(50, 25)
      .setScrollSensitivity(1.1)
      .setDirection(Controller.HORIZONTAL)
      .setValue(8)
      .setRange(4, 32)
      ;
      
    cp5.addButton("Set position")
      .setValue(6)
      .setPosition(300, 830)
      .setSize(80, 30)
      ;

    buttonStart = cp5.addButton("Start")
      .setValue(6)
      .setPosition(300, 870)
      .setSize(80, 30)
      .setColorBackground(#FC0000); 
      ;

    cp5.addCheckBox("SnapCheckBox")
      .setPosition(745, 810)
      .setSize(15, 15)
      .addItem("Snap to grid", 0)
      .activateAll()
      ;
      
    cp5.addCheckBox("DebugCheckBox")
      .setPosition(425, 870)
      .setSize(15, 15)
      .addItem("Show debug panel", 0)
      .activateAll()
      ;      
      
    ButtonBar b = cp5.addButtonBar("algo")
       .setPosition(425, 830)
       .setSize(191, 30)
       .addItems(split("a b c"," "))
       ;
       
    b.changeItem("a","text","Flood fill");
    b.changeItem("b","text","Q learning");
    b.changeItem("c","text","RRT*");
    
    List type_maze_list = Arrays.asList("Perfect maze", "Imperfect maze");
    /* add a ScrollableList, by default it behaves like a DropdownList */
    cp5.addScrollableList("Maze type")
       .setPosition(662, 830)
       .setSize(100, 100)
       .setBarHeight(20)
       .setItemHeight(20)
       .addItems(type_maze_list)
       .setType(ScrollableList.DROPDOWN)
       .setValue(0)
       .setBackgroundColor(#EA0037)
       .setColorForeground(#EA0037)
       .setOpen(false)  
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
    float boxW = box2d.scalarPixelsToWorld(SimulationUtility.MAZE_SIZE) / simCon.getMaze().getRows();
    float boxH = boxW * SimulationUtility.RATIO;
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
        float boxW = box2d.scalarPixelsToWorld(SimulationUtility.MAZE_SIZE) / simCon.getMaze().getRows();
        float boxH = boxW * SimulationUtility.RATIO;

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
    
    if(simCon.getStart())
      buttonStart.setColorBackground(#0BFC00);
    else
      buttonStart.setColorBackground(#FC0000);
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
    rect(5, 810, 70, 70);
    
    fill(0);
    textSize(13);
    strokeWeight(2);
    text("Choose a navigation algorithm", 425, 825);
    text("Maze Type", 662, 825);
    text("Maze Size", 662, 865);
  }
  
  public boolean getSnap() {
    return snap;
  }
  
  public void setMaze(Maze maze) {
    this.maze = maze;
  }
}

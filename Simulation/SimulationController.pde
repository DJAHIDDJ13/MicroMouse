import controlP5.*;

public class SimulationController{
  
  private SimulationEntry simulationEntry;
  private MazeBuilder mazeBuilder;
  
  private ControlP5 cp5;
  private float toAddX, toAddY, toAddR, toAddW, toAddH, toAddA;
  
  private int objectPanelState;
  private boolean showingMovingObject;
  private boolean deleteMode;
  
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
  }
  
  public SimulationEntry getSimulationEntry(){
    return simulationEntry;
  }
  
  public Maze getMaze() {
    return maze;
  }
  
 private void refreshMaze() {
   simulationEntry = new SimulationEntry(size, size);
   mazeBuilder = new MazeBuilder();
   maze = mazeBuilder.builderInitialMaze(simulationEntry.getMazeH(),
                                        simulationEntry.getMazeW(),
                                        simulationEntry.getBoxH(),
                                        simulationEntry.getBoxW());
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
       .setValue(16)
       .setRange(8, 32)
       ;
  }
  
  
  public void displayMovingObject() {
    rectMode(CENTER);
    // diplay wall at mouseX, mouseY
    pushMatrix();
    translate(toAddX, toAddY);
    rotate(-toAddA);
    
    if(objectPanelState == 0) {
      fill(127,0,0);
        stroke(0);
        rect(0, 0, toAddW, toAddH);
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

  public void controlEventHandler(ControlEvent event) {
    deleteMode = false;
    if(event.getController().getName().equals("Turn+") || event.getController().getName().equals("Turn-")){
      if(toAddA == 0) {
        toAddA = HALF_PI;
      } else {
        toAddA = 0; 
      }
    } else if(event.getController().getName().equals("+") || event.getController().getName().equals("-")){
      objectPanelState = 1 - objectPanelState; 
    } else if(event.getController().getName().equals("Add")) {
      showingMovingObject = !showingMovingObject;
    } else if(event.getController().getName().equals("Remove")) {
      showingMovingObject = false;
      deleteMode = true;
    } else if(event.getController().getName().equals("Refresh")) {
      refreshMaze();
    } else if(event.getController().getName().equals("Size")) {
      size = (int)cp5.get("Size").getValue();
    }
  }
  
  public void mousePressedHandler() {
    // if the click was on the canvas
    if(mouseX < maze.getMazeW() && mouseY < maze.getMazeH()) {
      // if showing moving object , means we're adding
      if(showingMovingObject) {
        if(objectPanelState == 0) {
          Wall toAdd = new Wall((float) mouseX, (float) mouseY, toAddW, toAddH, toAddA);
          maze.addWall(toAdd);
        } else {
          maze.getTarget().setPosition((float) mouseX, (float) mouseY);
        }
      } else if(deleteMode) { // otherwise we're deleting
        maze.removeBodyAt((float) mouseX, (float) mouseY);
      }
    }
  }
  
  public void update() {
    if(showingMovingObject && mouseX < maze.getMazeW() && mouseY < maze.getMazeH()) {
      toAddX = mouseX;
      toAddY = mouseY;
      toAddH = simulationEntry.getBoxH();
      toAddW = simulationEntry.getBoxW();
      toAddR = toAddH / 2;
    } else {
      toAddX = panelX;
      toAddY = panelY;
      toAddW = panelW;
      toAddH = panelH;
      toAddR = panelR;
    }
  }
  
  public void display() {
    displayPanel();
    displayMovingObject();
  }
}

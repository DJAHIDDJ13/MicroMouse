import controlP5.*;

public class SimulationController{
  
  private ControlP5 cp5;
  private float toAddX, toAddY, toAddR, toAddW, toAddH, toAddA;
  
  private int objectPanelState;
  private boolean showingMovingObject;
  private boolean deleteMode;
  
  private final float panelX = 20;
  private final float panelY = 855;
  private final float panelW = 20;
  private final float panelH = 40;
  private final float panelR = 10;
  
  private World world;
  
  public SimulationController(World world){
    this.world = world;
    objectPanelState = 0;
    showingMovingObject = false;
    deleteMode = false;
  }
  
  public World getWorld() {
    return world;
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
    // diplay wall at mouseX, mouseY
    if(objectPanelState == 0) {
      pushMatrix();
      fill(127,0,0);
        translate(toAddX, toAddY);
        rotate(-toAddA);
        stroke(0);
        rect(0, 0, toAddW, toAddH);
        fill(255);
      popMatrix();
    } // display target
    else {
      pushMatrix();
      translate(toAddX, toAddY);
      rotate(toAddA);
      fill(127);
        strokeWeight(1);
        ellipse(0, 0, toAddR*2, toAddR*2);
        line(-toAddR, 0, toAddR, 0);
        line(0, -toAddR, 0, toAddR);
      fill(255);
      popMatrix();
    }
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
      showingMovingObject = false;      
    } else if(event.getController().getName().equals("Size")) {
      showingMovingObject = false;
    }
  }
  
  public void mousePressedHandler() {
    // if the click was on the canvas
    if(mouseX < world.getWorldW() && mouseY < world.getWorldH()) {
      // if showing moving object , means we're adding
      if(showingMovingObject) {
        if(objectPanelState == 0) {
          Wall toAdd = new Wall((float) mouseX, (float) mouseY, toAddW, toAddH, toAddA);
          world.addWall(toAdd);
        } else {
          world.getTarget().setPosition((float) mouseX, (float) mouseY);
        }
      } else if(deleteMode) { // otherwise we're deleting
        world.removeBodyAt((float) mouseX, (float) mouseY);
      }
    }
  }
  
  public void update() {
    if(showingMovingObject && mouseX < world.getWorldW() && mouseY < world.getWorldH()) {
      toAddX = mouseX;
      toAddY = mouseY;
      toAddH = simulationEntry.getBoxH();
      toAddW = simulationEntry.getBoxW();
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

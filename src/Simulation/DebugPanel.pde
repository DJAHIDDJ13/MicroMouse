public class DebugPanel {

  private ControlP5 cp5; 
  
  private int panel;
            
  public DebugPanel(ControlP5 cp5) {
    this.cp5 = cp5;
    panel = 0;
  }

  public void mousePressedHandler() {

  }

  public void keyPressedHandler() {
    
  }

  public void controlEventHandler(ControlEvent event) {
    String eventControllerName = event.getName();
    if(eventControllerName.equals("bar")) { 
      ButtonBar bar = (ButtonBar)event.getController();
      panel = bar.hover();
    }
  }

  public void createControllers() {
    ButtonBar b = cp5.addButtonBar("bar")
       .setPosition(845, 317)
       .setSize(600, 30)
       .addItems(split("a b c d e"," "))
       ;
    
    b.changeItem("a","text","Communication");
    b.changeItem("b","text","User utility");
    b.changeItem("c","text","Flood fill");
    b.changeItem("d","text","Q learning");
    b.changeItem("e","text","RRT*");
  }

  public void update() {
    updateController();
  }
  
  public void displayCommunication_debug() {
    
  }
  
  public void displayUserUtility_debug() {
    fill(0);
    textSize(18);
    strokeWeight(2);
    text("Maze heigth : ", 1090, 380);
    text("Maze Width : " , 1090, 420);
    
    line(1000, 440, 1270, 440);
    
    text("Box heigth : ", 1090, 470);
    text("Box Width : " , 1090, 510);
    
    line(1000, 530, 1270, 530);

    text("Rows : ", 1090, 560);
    text("Columns : " , 1090, 600);
    
    fill(255);
    strokeWeight(1);
  }
  
  public void displayFloodFill_debug() {
    
  }
  
  
  public void displayQLearning_debug() {
    
  }
  
  
  public void displayRRT_debug() {
    
  }  

  public void display() {
    displayPanel();
    
    switch(panel) {
      case 1 :
        displayUserUtility_debug();
        break;
      case 2 :
        displayFloodFill_debug();
        break;
      case 3 :
        displayQLearning_debug();
        break;
      case 4 :
        displayRRT_debug();
        break;        
      default :
        displayCommunication_debug();
        break;
    }
  }

  // updates the gui
  public void updateController() {

  }

  public void displayPanel() {
    strokeWeight(2);
    fill(137,147,177,150);
    rect(830, 350, 640, 535);
    strokeWeight(0);
    fill(255);
  }
}

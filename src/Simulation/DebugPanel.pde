public class DebugPanel {

  private ControlP5 cp5; 
  
  private int panel;
  
  private Textarea console;
  
  private Button buttonControl;      
  
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
    } else if (eventControllerName.equals("Control")) {
      simCon.setBotControl(!simCon.getBotControl());
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
    
    
    console = cp5.addTextarea("txt")
                  .setPosition(850,370)
                  .setFont(createFont(PFont.list()[17],18))
                  .setLineHeight(18)
                  .setColor(color(255))
                  .setColorBackground(color(0, 200))
                  .setColorForeground(color(0, 200))
                  .setWidth(600)
                  .setHeight(500)
                  ;
                  
    buttonControl = cp5.addButton("Control")
      .setValue(1)
      .setPosition(1015, 670)
      .setSize(60, 30)
      ;                  
  }

  public void update() {
    updateController();
  }
  
  public void displayCommunication_debug() {
    console.show();
  }
  
  public void displayUserUtility_debug() {
    buttonControl.show();
    
    Maze maze = simCon.getMaze();
    
    fill(0);
    textSize(18);
    strokeWeight(2);
    
    text("Maze heigth : ", 1090, 380);
    text("Maze Width : " , 1090, 420);
    
    line(900, 440, 1370, 440);
    
    text("Box heigth : ", 1090, 470);
    text("Box Width : " , 1090, 510);
    
    line(900, 530, 1370, 530);

    text("Rows : ", 1090, 560);
    text("Columns : " , 1090, 600);
    
    line(900, 620, 1370, 620);
    
    text("Number of mice : ", 1090, 650);
    text("Controled by : " , 1090, 690);
    
    line(900, 710, 1370, 710);
    
    text("Number of walls : ", 1090, 740);
    text("Mice hit the wall : ", 1090, 780);
    text("Reach the target : ", 1090, 820);
    text("Number of boxes visited : ", 1090, 860);
    
    fill(255);
    
    text(maze.getMazeH(), 1205, 380);
    text(maze.getMazeW(), 1200, 420);
    
    text(maze.getBoxH(), 1190, 470);
    text(maze.getBoxW(), 1185, 510); 
    
    text(maze.getRows(), 1150, 560);
    text(maze.getCols(), 1182, 600);
    
    text(maze.getNumberOfMice(), 1233, 650);
    text((simCon.getBotControl()) ? "Bot" : "USER", 1220, 690);

    text(maze.getWalls().size(), 1235, 740);
    text("no", 1250, 780);
    text("no", 1250, 820);
    text("10", 1317, 860);    
    
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
        console.hide();
        displayUserUtility_debug();
        break;
      case 2 :
        console.hide();
        buttonControl.hide();
        displayFloodFill_debug();
        break;
      case 3 :
        console.hide();
        buttonControl.hide();
        displayQLearning_debug();
        break;
      case 4 :
        console.hide();
        buttonControl.hide();
        displayRRT_debug();
        break;        
      default :
        buttonControl.hide();
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
  
  public void addText(String text) {
    if(!text.isEmpty()) {
      console.setText(console.getText() + text);
      console.scroll(1);
    }
  }
}

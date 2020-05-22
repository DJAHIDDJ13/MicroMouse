public class DebugPanel {

  private ControlP5 cp5; 
  
  private int panel;
  private boolean bot;
  
  private Textarea myTextarea;
            
  public DebugPanel(ControlP5 cp5) {
    this.cp5 = cp5;
    panel = 0;
    bot = true;
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
    
    
    myTextarea = cp5.addTextarea("txt")
                  .setPosition(850,370)
                  .setFont(createFont(PFont.list()[17],18))
                  .setLineHeight(18)
                  .setColor(color(255))
                  .setColorBackground(color(0, 200))
                  .setColorForeground(color(0, 200))
                  .setWidth(600)
                  .setHeight(500)
                  ;      
  }

  public void update() {
    updateController();
  }
  
  public void displayCommunication_debug() {
    myTextarea.show();
  }
  
  public void displayUserUtility_debug() {
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
    
    text("Nulber of mice : ", 1090, 650);
    text("Controled by : " , 1090, 690);
    
    line(900, 710, 1370, 710);
    
    text("Nulber of walls : ", 1090, 740);
    text("Mice hit the wall : ", 1090, 780);
    text("Reach the target : ", 1090, 820);
    text("Number of boxes visited : ", 1090, 860);
    
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
        myTextarea.hide();
        displayUserUtility_debug();
        break;
      case 2 :
        myTextarea.hide();
        displayFloodFill_debug();
        break;
      case 3 :
        myTextarea.hide();
        displayQLearning_debug();
        break;
      case 4 :
        myTextarea.hide();
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
  
  public void setBot(boolean bot) {
    this.bot = bot;
  }
  
  public void addText(String text) {
    if(!text.isEmpty()) {
      myTextarea.setText(myTextarea.getText() + text);
      myTextarea.scroll(1);
    }
  }
}

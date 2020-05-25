import controlP5.*;

public class SimulationController {
  
  private Maze maze;
  private MazeBuilder mazeBuilder;
  private CommunicationController comCon;
  
  private ControlP5 cp5;
  
  private ControlPanel controlPanel;
  private InformationPanel informationPanel;
  private DebugPanel debugPanel;
  
  private int size;
  
  private final static float box2d_scalar = 80.0f;
  private final static float user_motor_force = 300;
  
  private boolean botControl = false;
  private boolean displaySensors;
  private boolean debugMode;
  private int numberOfConsoleTextChange;
  
  private boolean start;
  
  public SimulationController(ControlP5 cp5, int size){
    this.cp5 = cp5;
    this.size = size;
    comCon = new CommunicationController();
    informationPanel = new InformationPanel(cp5);
    controlPanel = new ControlPanel(cp5);
    debugPanel = new DebugPanel(cp5);
    
    botControl = true; 
    displaySensors = true;
    debugMode = false;
    start = true;
    
    numberOfConsoleTextChange = 0;
    
    refreshMaze(true);
  }
  
  public boolean getDebugMode() {
    return debugMode;
  }
  
  public void setDebigMode(boolean debugMode) {
    this.debugMode = debugMode;
  }
  
  public boolean getStart() {
    return start;
  }
  
  public void setStart(boolean start) {
     this.start = start; 
  }
  
  public Maze getMaze() {
    return maze;
  }
  
  public void setSize(int size) {
    this.size = size;
  }
  
  public void setBotControl(boolean botControl) {
    this.botControl = botControl;
  }
  
  public boolean getBotControl() {
    return botControl;
  }
  
  public CommunicationController getComCon() {
    return comCon; 
  }
  
  public void setDisplaySensors(boolean displaySensors) {
    this.displaySensors = displaySensors;
  }
  
  public boolean getDisplaySensors() {
    return displaySensors;
  }
  
  public int getNumberOfConsoleTextChange() {
    return numberOfConsoleTextChange;
  }
  
  public void setNumberOfConsoleTextChange(int numberOfConsoleTextChange) {
    this.numberOfConsoleTextChange = numberOfConsoleTextChange;
  }
  
  public void printConsole() {
    debugPanel.addText(CommunicationUtility.consoleText);
    CommunicationUtility.consoleText = "";
    numberOfConsoleTextChange++;
  }
  
  public void refreshMaze(Boolean PerfectMaze) {   
   // Creating the box2d world
   Vec2 gravity = new Vec2(0, 0);
   box2d.createWorld(gravity);
   box2d.setScaleFactor(box2d_scalar / size);
   
   // build the maze
   mazeBuilder = new MazeBuilder();
   maze = mazeBuilder.generateRandomMaze(PerfectMaze, 
                                         box2d.scalarPixelsToWorld(SimulationUtility.MAZE_SIZE),
                                         box2d.scalarPixelsToWorld(SimulationUtility.MAZE_SIZE),
                                         size,
                                         SimulationUtility.RATIO);
   
   // initializing the communication controller
   comCon.setMaze(maze);
   informationPanel.setMaze(maze);
   controlPanel.setMaze(maze);
  }
  
  
    public void clearMaze() {   
   // Creating the box2d world
   Vec2 gravity = new Vec2(0, 0);
   box2d.createWorld(gravity);
   box2d.setScaleFactor(box2d_scalar / size);
   
   // build the maze
   mazeBuilder = new MazeBuilder();
   maze = mazeBuilder.builderInitialMaze(box2d.scalarPixelsToWorld(SimulationUtility.MAZE_SIZE),
                                         box2d.scalarPixelsToWorld(SimulationUtility.MAZE_SIZE),
                                         size,
                                         SimulationUtility.RATIO);
   
   // initializing the communication controller
   comCon.setMaze(maze);
   informationPanel.setMaze(maze);
   controlPanel.setMaze(maze);
  }
  
  public void setController(ControlP5 cp5) {
    this.cp5 = cp5;
  }
 
  public ControlP5 getController(){
    return this.cp5;
  }
  
  public void createControllers() {
    controlPanel.createControllers();
    informationPanel.createControllers();
    debugPanel.createControllers();
  } 
  
  public void keyPressedHandler() {
    controlPanel.keyPressedHandler();
    informationPanel.keyPressedHandler();
    debugPanel.keyPressedHandler();
    
    if(!botControl) {
      if(key == 'z')
        maze.moveVehicle(user_motor_force, user_motor_force);
      else if(key == 's')
        maze.moveVehicle(-user_motor_force, -user_motor_force);
      else if(key == 'q')
        maze.moveVehicle(-user_motor_force, user_motor_force);
      else if(key == 'd')
        maze.moveVehicle(user_motor_force, -user_motor_force);
    }
  }

  public void controlEventHandler(ControlEvent event) {
    controlPanel.controlEventHandler(event);
    informationPanel.controlEventHandler(event);
    debugPanel.controlEventHandler(event);
  }
  
  public void mousePressedHandler() {
    controlPanel.mousePressedHandler();
    informationPanel.mousePressedHandler();
    debugPanel.mousePressedHandler();
  }

  public void update() {
    controlPanel.update();
    
    informationPanel.update();
    debugPanel.update();
    
    maze.update();

    comCon.update();
    
    printConsole();
  }
  
  public void display() {
    maze.display();
    controlPanel.display();

    if(debugMode) {
      informationPanel.display();
      debugPanel.display();
    } else {
      displayTeamInformation();      
    }
    
    displayFPS();
  }
  
  public void displayTeamInformation() {
    fill(0);
    
    textSize(18);
    strokeWeight(2);
    int baseY = 200;
    text("Master 1 Informatique et Ingénieurie des Systèmes Complexes (IISC)", 860, baseY+30);
  
    text("Cergy Paris Université" , 1050, baseY+70);
    
    line(900, baseY+100, 1370, baseY+100);
    
    text("Résolution de labyrinthes par véhicule intelligent", 920, baseY+130);
    text("Micromouse" , 1090, baseY+170);
    
    line(900, baseY+200, 1370, baseY+200);

    text("This program is a simulator for the Micromouse competition featuring :", 860, baseY+230);
    text("-A simulated Micromouse vehicle" , 870, baseY+260);
    text("-A world editor", 870, baseY+280);
    text("-A graphical user interface" , 870, baseY+300);
    text("-C programming facilities" , 870, baseY+320);
    
    text("Authors : ABDELMOUMENE Djahid, AGRANE Amine, AYAD Ishak, LAY Donald.", 820, baseY+370);
    
    fill(0,0,255);
    text("https://github.com/DJAHIDDJ13/MicroMouse", 940, baseY+390);
    
    fill(255);    
  }
  
  public void displayFPS() {  
    fill(255);
    textSize(15);
    text("FPS: "+round(frameRate), 1400, 25);
  }
}

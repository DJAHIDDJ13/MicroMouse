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
  
  private boolean botControl;
  private boolean displaySensors;
  
  public SimulationController(ControlP5 cp5, int size){
    this.cp5 = cp5;
    this.size = size;
    comCon = new CommunicationController();
    informationPanel = new InformationPanel(cp5);
    controlPanel = new ControlPanel(cp5);
    debugPanel = new DebugPanel(cp5);
    
    botControl = true; 
    displaySensors = true;
    
    refreshMaze(true);
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
  
  public void setDisplaySensors(boolean displaySensors) {
    this.displaySensors = displaySensors;
  }
  
  public boolean getDisplaySensors() {
    return displaySensors;
  }
  
  public void printConsole() {
    debugPanel.addText(CommunicationUtility.consoleText);
    CommunicationUtility.consoleText = "";
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
    informationPanel.display();
    debugPanel.display();
  }
}

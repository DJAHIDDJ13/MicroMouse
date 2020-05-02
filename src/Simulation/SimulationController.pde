import controlP5.*;

public class SimulationController {
  public SimulationEntry simulationEntry;
  private Maze maze;
  private MazeBuilder mazeBuilder;
  
  private ControlP5 cp5;
  
  private ControlPanel controlPanel;
  private InformationPanel informationPanel;
  
  /* Communication */
  Listener listener;
  Writer writer;

  // TO BE REMOVED
  private int dashed;

  private int size;
    
  public SimulationController(ControlP5 cp5, int size){
    this.listener = new Listener();
    this.writer = new Writer();
    this.cp5 = cp5;
    this.size = size;
    refreshMaze();
    
    dashed = 0;
  }
  
  public SimulationEntry getSimulationEntry(){
    return simulationEntry;
  }
  
  public Maze getMaze() {
    return maze;
  }
  
  public void setSize(int size) {
    this.size = size;
  }
  
  public void refreshMaze() {   
   // Creating the box2d world
   Vec2 gravity = new Vec2(0, 0);
   box2d.createWorld(gravity);
   box2d.setScaleFactor(80.0f / size);

   // new simulation entry
   simulationEntry = new SimulationEntry(size, size);
   
   
   // build the maze
   mazeBuilder = new MazeBuilder();
   maze = mazeBuilder.generateRandomMaze(box2d.scalarPixelsToWorld(SimulationUtility.MAZE_SIZE),
                                         box2d.scalarPixelsToWorld(SimulationUtility.MAZE_SIZE),
                                         size,
                                         simulationEntry.getRatio());
   
   // Initializing the GUI Panels
   controlPanel = new ControlPanel(this, cp5, maze);
   informationPanel = new InformationPanel(this, cp5, maze);
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
  } 
  
  public void keyPressedHandler() {
    controlPanel.keyPressedHandler();
    informationPanel.keyPressedHandler();
    
    if(key == 'z')
      maze.moveVehicle(400, 400);
    else if(key == 's')
      maze.moveVehicle(-400, -400);
    else if(key == 'q')
      maze.moveVehicle(-400, 400);
    else if(key == 'd')
      maze.moveVehicle(400, -400);
  }

  public void controlEventHandler(ControlEvent event) {
    controlPanel.controlEventHandler(event);
    informationPanel.controlEventHandler(event);
  }
  
  public void mousePressedHandler() {
    controlPanel.mousePressedHandler();
    informationPanel.mousePressedHandler();
  }

  public void update() {
    controlPanel.update();
    informationPanel.update();
    
    maze.update();
  }
  
  public void display() {
    maze.display();
    controlPanel.display();
    informationPanel.display();
    
    /* COMMUNICATION : TO BE MOVED IN OTHER SECTION (?) */
    /* SENSORS POSITIONS
     *    _______________
     *   / 0          2  \
     *  / 1             3 \
     *
     */
    //float[] accelerometerData = ArrayUtils.addAll(maze.getVehicleAcceleration().array(), getVehicleAngularAcceleration().array());
    float[] accelerometerData = new float[6];
    System.arraycopy(maze.getVehicleAcceleration().array(), 0, accelerometerData, 0, 3);
    System.arraycopy(maze.getVehicleAngularAcceleration().array(), 0, accelerometerData, 3, 3);

    SensorData sensorMessage = new SensorData();
    sensorMessage.setDistanceData(maze.getVehicleSensorValues());
    sensorMessage.setAccelerometerData(accelerometerData);
    sensorMessage.setContent();

    this.writer.writeFifo(sensorMessage);
    Message rxMsg = this.listener.getRxMessage();

    /* CODE SNIPET TO USE RX MSG
    if (rxMsg != null) 
      System.out.println("Using received data : " + rxMsg.getLeftPowerMotor() + " AND " + rxMsg.getRightPowerMotor());
    */

    dashed++;
  }
  
  // TO BE REMOVED
  public int getDashed() {
    return dashed; 
  }
}

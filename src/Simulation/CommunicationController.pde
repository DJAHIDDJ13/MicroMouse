public class CommunicationController {
  
  private Maze maze;
  
  /* Communication */
  private Listener listener;
  private Writer writer;
  private SensorData sensorMessage;
  private MotorData motorMessage;
  private HeaderData headerMessage;
  

  public CommunicationController() {
    listener = new Listener();
    writer = new Writer();
    sensorMessage = new SensorData();
    motorMessage = new MotorData();
    headerMessage = new HeaderData();
  }
  
  public void setMaze(Maze maze) {
    this.maze = maze;
    sendHeaders();
  }
  
  public void sendHeaders() {
    println("Sending headers");
    Vec2 p = maze.getVehicle().getPosition();
    float a = maze.getVehicle().getAngle();
    Vec2 tp = maze.getTarget().getPosition();
    float[] mazeData = {maze.getWidth(), maze.getHeight()}, 
          initialPosData = {p.x, p.y, a}, 
          targetPosData = {tp.x, tp.y},
          cellSizeData = {maze.getBoxW(), maze.getBoxH()};
          
    headerMessage.setMazeData(mazeData);
    headerMessage.setInitialPosData(initialPosData);
    headerMessage.setTargetPosData(targetPosData);
    headerMessage.setCellSizeData(cellSizeData);

    headerMessage.setContent();
    this.writer.writeFifo(headerMessage);
  }
  
  public void update() {
    /* SENSORS POSITIONS
     *    _______________
     *   / 0          2  \
     *  / 1             3 \
     *
     */
    //float[] accelerometerData = ArrayUtils.addAll(maze.getVehicleAcceleration().array(), getVehicleAngularAcceleration().array());
    float[] accelerometerData = new float[6]; //<>// //<>// //<>//
    System.arraycopy(maze.getVehicleAcceleration().array(), 0, accelerometerData, 0, 3);
    System.arraycopy(maze.getVehicleAngularAcceleration().array(), 0, accelerometerData, 3, 3);

    sensorMessage.setDistanceData(maze.getVehicleSensorValues());
    sensorMessage.setAccelerometerData(accelerometerData);
    sensorMessage.setContent();

    this.writer.writeFifo(sensorMessage);
    /* CODE SNIPET TO USE RX MSG*/
    Message rxMsg = this.listener.getRxMessage();
    /*if (rxMsg != null) 
      //System.out.println("Using received data : " + rxMsg.getLeftPowerMotor() + " AND " + rxMsg.getRightPowerMotor());
      maze.moveVehicle(rxMsg.getLeftPowerMotor(), rxMsg.getRightPowerMotor());
    m*/
  }
}

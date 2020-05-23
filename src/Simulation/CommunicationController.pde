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
    Vec2 p = maze.getVehicle().getPosition();
    Vec2 tp = maze.getTarget().getPosition();
    Vec2 origin = box2d.coordPixelsToWorld(SimulationUtility.MAZE_SHIFTX, SimulationUtility.MAZE_SHIFTY);
    
    float a = maze.getVehicle().getAngle();
    float encoderLinesPerRevolution = maze.getVehicle().getEncoderLinesPerRevolution();
    float wheelCircumference = maze.getVehicle().getWheelCircumference();
    float[] mazeData = {maze.getWidth(), maze.getHeight()}, 
                        initialPosData = {p.x, p.y, a}, 
                        targetPosData = {tp.x, tp.y},
                        cellSizeData = {maze.getBoxW(), maze.getBoxH()},
                        encoderData = {encoderLinesPerRevolution, wheelCircumference},
                        sensorsPos = new float[12],
                        originPos = {origin.x, origin.y};

    int i = 0;
    
    for (Vec2 sensorPos : maze.getVehicle().getSensorPos()) {
      sensorsPos[i] = sensorPos.x;
      i++;
      sensorsPos[i] = sensorPos.y;
      i++;
      sensorsPos[i] = maze.getVehicle().getSensorAngles()[(i+1)/maze.getVehicle().getSensorPos().length];
      i++;
  }
    
          
    headerMessage.setMazeData(mazeData);
    headerMessage.setInitialPosData(initialPosData);
    headerMessage.setTargetPosData(targetPosData);
    headerMessage.setCellSizeData(cellSizeData);
    headerMessage.setEncoderLinesPerRevolution(encoderData);
    headerMessage.setSensorsPos(sensorsPos);
    headerMessage.setOriginPos(originPos);

    headerMessage.setContent();
    this.writer.writeFifo(headerMessage);
  }
  
  public void update() {
    /* SENSORS POSITIONS
     *    _______________
     *   / 2          1  \
     *  / 3             0 \ //<>// //<>// //<>//
     *  Rearrange to become : //<>// //<>//
     *    _______________
     *   / 1          2  \
     *  / 0             3 \ //<>// //<>// //<>//
     */
    //float[] accelerometerData = ArrayUtils.addAll(maze.getVehicleAcceleration().array(), getVehicleAngularAcceleration().array());
    float[] accelerometerData = new float[6]; //<>// //<>// //<>// //<>// //<>// //<>// //<>// //<>//
    System.arraycopy(maze.getVehicleAcceleration().array(), 0, accelerometerData, 0, 3);
    System.arraycopy(maze.getVehicleAngularAcceleration().array(), 0, accelerometerData, 3, 3);
    
    float tmp_float;
    float[] distanceData = maze.getVehicleSensorValues();
    
    for (int i = 0; i < distanceData.length / 2; i++) {
      tmp_float = distanceData[i];
      distanceData[i] = distanceData[distanceData.length - 1 - i];
      distanceData[distanceData.length - 1 - i] = tmp_float;
    }

    sensorMessage.setDistanceData(distanceData);
    sensorMessage.setAccelerometerData(accelerometerData);
    sensorMessage.setEncoderData(maze.vehicle.getEncoderData());
    sensorMessage.setContent();
    this.writer.writeFifo(sensorMessage);
    /* CODE SNIPET TO USE RX MSG*/
    Message rxMsg = this.listener.getRxMessage();
    if (rxMsg != null && simCon.getBotControl())
      //System.out.println("Using received data : " + rxMsg.getLeftPowerMotor() + " AND " + rxMsg.getRightPowerMotor());
      maze.moveVehicle(rxMsg.getLeftPowerMotor(), rxMsg.getRightPowerMotor());
  }
}

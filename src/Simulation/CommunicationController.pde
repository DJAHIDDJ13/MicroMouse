public class CommunicationController {
  
  private Maze maze;
  
  /* Communication */
  private Listener listener;
  private Writer writer;
  /* TX */
  private SensorData sensorMessage;
  private HeaderData headerMessage;
  private ReplyPingData replyPingMessage;
  /* RX */
  private MotorData motorMessage;
  private RequestPingData requestPingMessage;

  public CommunicationController() {
    listener = new Listener();
    writer = new Writer();
    sensorMessage = new SensorData();
    motorMessage = new MotorData();
    headerMessage = new HeaderData();
    replyPingMessage = new ReplyPingData();
    requestPingMessage = new RequestPingData();
  }
  
  public void setMaze(Maze maze) {
    this.maze = maze;
    sendHeaders();
  }

  public void sendHeaders() {
    Vec2 p = maze.getVehicle().getPosition();
    Vec2 tp = maze.getTarget().getCell(maze.getRows());
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
    Vec2[] sensorsPosTmp = {  maze.getVehicle().getSensorPos()[3],
                              maze.getVehicle().getSensorPos()[2],
                              maze.getVehicle().getSensorPos()[1],
                              maze.getVehicle().getSensorPos()[0]
                            };

    for (Vec2 sensorPos : sensorsPosTmp) {
      sensorsPos[i] = sensorPos.x;
      i++;
      sensorsPos[i] = sensorPos.y;
      i++;
      sensorsPos[i] = maze.getVehicle().getSensorAngles()[(maze.getVehicle().getSensorPos().length - 1) - ((i+1)/maze.getVehicle().getSensorPos().length)];
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
    float[] randomSequence = new float[10]; // PING
    /* SENSORS POSITIONS
     *    _______________
     *   / 2          1  \
     *  / 3             0 \
     *  Rearrange to become :
     *    _______________
     *   / 1          2  \
     *  / 0             3 \  
     */
    float[] accelerometerData = new float[6]; 
    System.arraycopy(maze.getVehicleAcceleration().array(), 0, accelerometerData, 0, 3);
    System.arraycopy(maze.getVehicleAngularAcceleration().array(), 0, accelerometerData, 3, 3);
    
    Sensor[] sensors = maze.getVehicleSensorValues();
    // reversing the order before sending
    float[] distanceData = {sensors[3].getValue(), 
                            sensors[2].getValue(), 
                            sensors[1].getValue(), 
                            sensors[0].getValue()};

    sensorMessage.setDistanceData(distanceData);
    sensorMessage.setAccelerometerData(accelerometerData);
    sensorMessage.setEncoderData(maze.vehicle.getEncoderData());
    sensorMessage.setTimeStamp(maze.vehicle.getTimeStamp());
    sensorMessage.setContent();
    this.writer.writeFifo(sensorMessage);
    /* CODE SNIPET TO USE RX MSG*/
    Message rxMsg = this.listener.getRxMessage();
    if (rxMsg != null && simCon.getBotControl()) {
      maze.moveVehicle(rxMsg.getLeftPowerMotor(), rxMsg.getRightPowerMotor());
    } else if (rxMsg != null && rxMsg.getFlag() == CommunicationUtility.PING_FLAG) {
      // PING REQUEST RECEIVED
      randomSequence = rxMsg.getRandomSequence();
      // PING REPLY
      replyPingMessage.setRandomSequence(randomSequence);
      replyPingMessage.setContent();
      this.writer.writeFifo(replyPingMessage);
    }
  }
}

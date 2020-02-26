public class InformationPanel {
  SimulationController simCon;
  ControlP5 cp5;
  Maze maze;
  
  PVector acc;
  PVector angAcc;
  
  
  String accText;
  String angAccText;
  String sensorText;
  public InformationPanel(SimulationController simCon, ControlP5 cp5, Maze maze) {
    this.maze = maze;
    this.cp5 = cp5;
    this.simCon = simCon;
    
    // get the acceleration vectors 
    acc = maze.getVehicleAcceleration();
    angAcc = maze.getVehicleAngularAcceleration();
    
    updateText();
  }
  
  public void mousePressedHandler() {
    
  }
  
  public void keyPressedHandler() {

  }
  
  public void controlEventHandler(ControlEvent event) {

  }
  
  public void createControllers() {
    
  }
  
  public void update() {
    
  }

  public void updateText() {
    int div = 1;
    accText = String.format("x: %.1f, y:%.1f, z:%.1f", acc.x / div, acc.y / div, acc.z / div);
    angAccText = String.format("x: %.1f, y:%.1f, z:%.1f", angAcc.x / div, angAcc.y / div, angAcc.z / div);
    
    float[] sensorVals = maze.getVehicleSensorValues();
    sensorText = "";
    for(int i = 0; i < sensorVals.length; i++) {
      sensorText += String.format("%.1f ",sensorVals[i]);
    }
  }

  public void display() {
    if(frameCount % 5 == 0) {
      updateText();
    }
    fill(0);
    rect(830, 20, 640, 400);
    fill(255);
    textSize(22);
    text("Accelerometer ("+ accText +")", 900, 50);
    text("Gyroscope       ("+ angAccText +")", 900, 80);
    text("Sensors           ("+ sensorText +")", 900, 110);
    fill(255);
  }
}

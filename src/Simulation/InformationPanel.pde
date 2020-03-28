public class InformationPanel {
  SimulationController simCon;
  ControlP5 cp5;
  Maze maze;
  
  PVector acc;
  PVector angAcc;
  
  String accText;
  String angAccText;
  String sensorText;

  final int redHue = 0, blueHue = 240;  

  Vehicle vehicle;
  Vec2[] topShape,middleShape,bottomShape;
  
  //constructor
  public InformationPanel(SimulationController simCon, ControlP5 cp5, Maze maze) {
    this.maze = maze;
    this.cp5 = cp5;
    this.simCon = simCon;
    float vehicleSize = 1.5;
    
    // top
    topShape = new Vec2[5];
    topShape[0] = new Vec2(-58, -35).mul(vehicleSize);
    topShape[1] = new Vec2(-50, -63).mul(vehicleSize);
    topShape[2] = new Vec2(0, -79).mul(vehicleSize);
    topShape[3] = new Vec2(49, -63).mul(vehicleSize);
    topShape[4] = new Vec2(59, -35).mul(vehicleSize);

    // middle
    middleShape = new Vec2[4];
    middleShape[0] = new Vec2(39, -35).mul(vehicleSize);
    middleShape[1] = new Vec2(39, 34).mul(vehicleSize);    
    middleShape[2] = new Vec2(-38, 35).mul(vehicleSize);
    middleShape[3] = new Vec2(-38, -35).mul(vehicleSize);

    // bottom
    bottomShape = new Vec2[4];
    bottomShape[0] = new Vec2(52, 34).mul(vehicleSize);
    bottomShape[1] = new Vec2(52, 51).mul(vehicleSize);
    bottomShape[2] = new Vec2(-52, 51).mul(vehicleSize);
    bottomShape[3] = new Vec2(-52, 35).mul(vehicleSize);
    
    // get the acceleration vectors 
    acc = maze.getVehicleAcceleration();
    angAcc = maze.getVehicleAngularAcceleration();
    
    //updateText();
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

public void drawSensor(int sensorX, int sensorY, float sensorValue) {
  int sensorSize = 14;
  if(sensorValue == -1) {
    fill(0);
  } else {
    fill(map(sensorValue, 0, 99, redHue, blueHue), 360, 360);
  }
  
  ellipse(sensorX,sensorY,sensorSize,sensorSize);
}


public void GenericVehicleInformations( )  {
  
  int vehicleX= 1000;
  int vehicleY=170;
  
  // proximity bar
  int numProx = 6;
  int rectX=1250;
  int rectY = 70;
  int rectSize=12;
 
    // Generic Vehicl Body
    pushMatrix();
    fill(127,127,127);
      translate(vehicleX, vehicleY);

      rotate(0);
      stroke(0);
    beginShape();
        //Drawing of top shape
        for(Vec2 vec: topShape)
          vertex(vec.x, vec.y);
        
        vertex(middleShape[0].x, middleShape[0].y);
        vertex(middleShape[1].x, middleShape[1].y);
        
        vertex(bottomShape[0].x, bottomShape[0].y);
        vertex(bottomShape[1].x, bottomShape[1].y);
        vertex(bottomShape[2].x, bottomShape[2].y);
        vertex(bottomShape[3].x, bottomShape[3].y);
        
        vertex(middleShape[2].x, middleShape[2].y);
        vertex(middleShape[3].x, middleShape[3].y); 
        
        vertex(topShape[0].x, topShape[0].y);
    endShape();
    fill(255);
    strokeWeight(1);
    popMatrix();
    
    //print proximity bar indicator
    fill(0);
    textSize(16);
    text("Proximity", rectX-90, rectY+10);
    textSize(15);
    text("Low", rectX-5, rectY-10);
    text("High", rectX+145, rectY-10);
    
    colorMode(HSB, 360, 100, 100);
    for (int i = 0; i <= numProx; i++) {
     fill(map(i, 0, numProx, redHue, blueHue), 100, 100);
     rect(rectX, rectY, rectSize, rectSize);
     rectX += 25;
    }

    //print sensors
    float[] sensors = maze.getVehicleSensorValues();
    drawSensor(970,70,sensors[0]);    // sensor 0
    drawSensor(1027,70,sensors[2]);   // sensor 1
    drawSensor(930,100,sensors[1]);   // sensor 2
    drawSensor(1070,100,sensors[3]);  // sensor 3
    colorMode(RGB, 255, 255, 255);
    
    // print sensors value
    fill(255);
    textSize(14);
    text(sensors[0], 950,55);
    text(sensors[2],1007,55);
    text(sensors[1],910,85);
    text(sensors[3],1050,85);

    
    // Gyroscope x,y,z values
    int div=1;
    fill(0);
    textSize(16);
    text("Gyroscope :",rectX-265,rectY+70); 
    textSize(15);
    text("X :",rectX-265,rectY+90); 
    text("Y :",rectX-265,rectY+110); 
    text("Z :",rectX-265,rectY+130); 
    textSize(14);
    fill(255);
    text(angAcc.x/div, rectX-250,rectY+90);
    text(angAcc.y/div, rectX-250,rectY+110);
    text(angAcc.z/div, rectX-250,rectY+130);
    
    // Accelerometer x,y,z values
    fill(0);
    textSize(16);
    text("Accelerometer :",rectX-125,rectY+70); 
    textSize(15);
    text("X :",rectX-125,rectY+90); 
    text("Y :",rectX-125,rectY+110); 
    text("Z :",rectX-125,rectY+130); 
    textSize(14);
    fill(255);
    text(acc.x/div, rectX-110,rectY+90);
    text(acc.y/div, rectX-110,rectY+110);
    text(acc.z/div, rectX-110,rectY+130);
}


  public void display() {
    fill(81,92,94);
    rect(810, 5, 640, 300);
    GenericVehicleInformations();
  }
}

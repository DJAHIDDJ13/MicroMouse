import java.awt.Color;
public class InformationPanel {
  
  private Maze maze;
  private ControlP5 cp5; 
  
  private PVector acc;
  private PVector angAcc;

  private final int redHue = 0, blueHue = 240;  
  private Vec2[] topShape,middleShape,bottomShape;
  
  private final int LWheelX1 = 955, LWheelY1 = 180, LWheelX2 = 955;
  private final int RWheelX1 = 1045, RWheelY1 = 180, RWheelX2 = 1045;
  
  private Button buttonSensors;
  
  //constructor
  public InformationPanel(ControlP5 cp5) {
    this.cp5 = cp5;
    
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
    acc = new PVector();
    angAcc = new PVector();
  }
  
  public void mousePressedHandler() {
    
  }
  
  public void keyPressedHandler() {

  }
  
  public void controlEventHandler(ControlEvent event) {
    String eventControllerName = event.getName();
    if(eventControllerName.equals("Display sensors")) { 
      simCon.setDisplaySensors(!simCon.getDisplaySensors());
    }
  }
  
  public void createControllers() {
    buttonSensors = cp5.addButton("Display sensors")
       .setValue(1)
       .setPosition(955, 20)
       .setSize(90, 30)
    ;     
  }
  
  public void update() {
    acc = maze.getVehicleAcceleration();
    angAcc = maze.getVehicleAngularAcceleration();
    
    if(!simCon.getDebugMode()) {
      buttonSensors.hide();
    } else {
      buttonSensors.show();
    }
  }

  public void drawSensor(int sensorX, int sensorY, float sensorValue) {
    int sensorSize = 14;
    
    if(sensorValue == -1) {
      fill(0);
    } 
    else {
      fill(map(sensorValue, 0, 1024, redHue, blueHue), 360, 360);
    }
  
    ellipse(sensorX,sensorY,sensorSize,sensorSize);
        
    // print sensors value
    fill(0, 0, 100); // white in hsb
    textSize(14);
    text(round(sensorValue),sensorX - 20, sensorY - 15);
  }

  public void drawEngine() {
    textSize(14);
    strokeWeight(2);
    //left engine
    // draw the line
    double leftForce = maze.getLeftWheelForce();
    int LWheelY2 = -(int)(leftForce*15/100) + LWheelY1;
    line(LWheelX1, LWheelY1, LWheelX2, LWheelY2);

    // draw a triangle at (x2, y2)
    pushMatrix();
      translate(LWheelX2, LWheelY2);
      rotate(atan2(LWheelX1-LWheelX2, LWheelY2-LWheelY1));
      line(0, 0, -5, -5);
      line(0, 0, 5, -5);
    popMatrix();
    
    //right engine
    // draw the line
    double rightForce = maze.getRightWheelForce();
    int RWheelY2 = -(int)(rightForce*15/100) + RWheelY1;
    line(RWheelX1, RWheelY1, RWheelX2, RWheelY2);

    // draw a triangle at (x2, y2)
    pushMatrix();
      translate(RWheelX2, RWheelY2);
      rotate(atan2(RWheelX1-RWheelX2, RWheelY2-RWheelY1));
      line(0, 0, -5, -5);
      line(0, 0, 5, -5);
    popMatrix(); 
    strokeWeight(1);
  }

  public void GenericVehicleInformations( )  {
    int vehicleX= 1000;
    int vehicleY=190;
  
    // proximity bar
    int numProx = 6;
    int rectX=1250;
    int rectY = 70;
    int rectSize=12;
    
    double leftForce = maze.getLeftWheelForce();
    double rightForce = maze.getRightWheelForce();
 
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
    Sensor[] sensors = maze.getVehicleSensorValues();
    
    drawSensor(1070, 120, sensors[0].getValue());    // sensor 0
    drawSensor(1027, 90, sensors[1].getValue());   // sensor 1
    drawSensor(970, 90, sensors[2].getValue());   // sensor 2
    drawSensor(930, 120, sensors[3].getValue());  // sensor 3
    colorMode(RGB, 255, 255, 255);
    
/*    // print sensors value
    fill(255);
    textSize(14);
    text(round(sensors[0].getValue()),950,75);
    text(round(sensors[1].getValue()),1007,75);
    text(round(sensors[2].getValue()),910,105);
    text(round(sensors[3].getValue()),1050,105);
*/
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
    
    fill(0);
    textSize(16);
    text("Left motor :",rectX-265,rectY+170);
    textSize(15);
    fill(255);
    text((int)leftForce, rectX-165,rectY+170);
      
    fill(0);
    textSize(16);
    text("Right motor :",rectX-265,rectY+210);
    textSize(15);
    fill(255);
    text((int)rightForce, rectX-155,rectY+210);
    
    drawEngine();
  }

  public void display() {
    fill(137,147,177,150);
    rect(830, 5, 640, 300);
    GenericVehicleInformations();
  }
  
  public void setMaze(Maze maze) {
    this.maze = maze;
  }
}

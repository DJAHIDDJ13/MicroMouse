// Class to simulate the angular and directional acceleration sensors
public class Accelerometer {
   private PVector accelerometer; // 3d vector to store the directional acceleration
   private PVector gyro; // 3d vector to store the angular acceleration
   
   // To track the vehicle's position changes   
   private Vec2 curPosition; 
   private Vec2 prevPosition;
   private Vec2 prevprevPosition;

   // Vehicle's angle changes
   private float curAngle;
   private float prevAngle;
   private float prevprevAngle;
   
   // time steps between each (physics) update -should be around 1 / 60 seconds for 60 FPS-
   private int curMillis;
   private int prevMillis;
   private int prevprevMillis;
   
   public Accelerometer() {
     accelerometer = new PVector(0, 0, 0); // the z axis will be ignored (set to 0)
     gyro = new PVector(0, 0, 0); // both the x and y axis rotations will be ignored since they are not simulated
     
     curPosition = new Vec2(0, 0);
     prevPosition = new Vec2(0, 0);
     prevprevPosition = new Vec2(0, 0);
     
     curAngle = 0; 
     prevAngle = 0;
     prevprevAngle = 0;
     
     curMillis = millis();
     prevMillis = millis();
     prevprevMillis = millis();
   }
   
   // in radians per second squared
   public PVector getGyro() {
     return gyro;
   }
   
   // in meters per second squared
   public PVector getAccelerometer() {
     return accelerometer;
   }
   
   // calculate numerical second derivative using verlet's integration method
   // https://en.wikipedia.org/wiki/Verlet_integration#Verlet_integration_(without_velocities)
   private float secondDerivative(float x1, float x2, float x3, float time_step) {
     return (x3 - 2 * x2 + x1) / (time_step * time_step);
   }
   
   // update the acceleration values
   public void update(Vec2 vehiclePos, float vehicleAngle) {
     // update the time stamps values
     prevprevMillis = prevMillis;
     prevMillis = curMillis;
     curMillis = millis();
     
     // elapsed time or step time (in seconds)
     float prev_time_step = (prevMillis - prevprevMillis) / 1000.0;
     float cur_time_step = (curMillis - prevMillis) / 1000.0;
     // taking the average of the two time steps
     float avg_time_step = (prev_time_step + cur_time_step) / 2;
     
     // update the position values
     prevprevPosition = prevPosition;
     prevPosition = curPosition;
     curPosition = vehiclePos;
     
     // update the angle values
     prevprevAngle = prevAngle;
     prevAngle = curAngle;
     curAngle = vehicleAngle;

     // the directional acceleration needs 3 discrete position samples 
     accelerometer.x = secondDerivative(prevprevPosition.x, prevPosition.x, curPosition.x, avg_time_step);
     accelerometer.y = secondDerivative(prevprevPosition.y, prevPosition.y, curPosition.y, avg_time_step);
     
     // same for the angular acceleration
     gyro.z = secondDerivative(prevprevAngle, prevAngle, curAngle, avg_time_step);
     
     //println(prevprevPosition, prevPosition, curPosition);
   }
   
   public void display() {
     line(curPosition.x -SimulationUtility.MAZE_SHIFTX, curPosition.y-SimulationUtility.MAZE_SHIFTY, curPosition.x + accelerometer.x, curPosition.y + accelerometer.y);
   }
}

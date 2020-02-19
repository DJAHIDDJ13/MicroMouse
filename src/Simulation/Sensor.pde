public class Sensor {
  private EdgeShapesCallback callback;
  
  private Vec2 source;
   private Vec2 target;
   private final Vec2 relativePos;
   private Vec2 castPoint;
   
   private float len;
   private float angle;
   private float value;
   
   public Sensor(Vec2 source, float angle, float len) {
     callback = new EdgeShapesCallback();
     
     relativePos = source;
   
     source = new Vec2(0, 0);
     target = new Vec2(0, 0);
     castPoint = new Vec2(0, 0);
     
     this.angle = angle;
     this.len = len;
     this.value = 0.0;
   }
   
   public Vec2 getSource() {
     return source;
   }
   
   public void setSource(Vec2 source) {
     this.source = source;
   }
   
   public Vec2 getTarget() {
     return target;
   }
   
   public void setTarget(Vec2 target) {
     this.target = target;
   }
   
   public float getLen() {
     return len;
   }
   
   public void setLen(float len) {
     this.len = len;
   }
   
   public float getAngle() {
     return angle;
   }
   
   public void update(Vec2 vehiclePos, float vehicleAngle) {
     source = new Vec2(vehiclePos.x + relativePos.x * cos(-vehicleAngle) - relativePos.y * sin(-vehicleAngle), 
                       vehiclePos.y + relativePos.x * sin(-vehicleAngle) + relativePos.y * cos(-vehicleAngle));
     
     target = new Vec2(source.x + len * cos(angle - vehicleAngle), source.y + len * sin(angle - vehicleAngle));
     sensorDetect();
   }
   
   public void sensorDetect() {
     callback.setM_fixture(null);
     
     box2d.world.raycast(callback, box2d.coordPixelsToWorld(source), box2d.coordPixelsToWorld(target));
     if (callback.getM_fixture() != null) {
        castPoint = box2d.coordWorldToPixels(callback.getM_point());
        value = floor(len / sqrt((castPoint.x - source.x) * (castPoint.x - source.x) + (castPoint.y - source.y) * (castPoint.y - source.y)));
     } else {
        value = -1;
     }
   }
   
   public void display() {
     stroke(180);
     stroke(255, 0, 0);
     if(value != -1)
       ellipse(castPoint.x, castPoint.y, 10, 10);
     stroke(0);
   }
   
   public float getValue() {
     return value;
   }
}

public class Sensor {
   private Vec2 source;
   private Vec2 target;
   private float len;
   private float degree;
   
   public Sensor(Vec2 source, float angle, float len) {
     this.source = source;
     this.len = len;
     this.degree = 0;
     target = new Vec2(source.x + len*cos(angle), source.y + len*sin(angle));
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
   
   public float getDegree() {
     return degree;
   }
   
   public void sensorDetect() {
     EdgeShapesCallback callback = new EdgeShapesCallback();
     box2d.world.raycast(callback, source, target);
     if (callback.getM_fixture() != null) {
        float distance = sqrt(pow(callback.getM_point().x - source.x, 2) + pow(callback.getM_point().y - source.y, 2));
        degree = floor(len / distance);
     } else {
        degree = 0;
     }
   }
   
   public void display() {
     line(source.x ,source.y, target.x, target.y);
   }
}

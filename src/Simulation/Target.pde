public class Target {
  private Vec2 pos;
  private float r;

  // Constructor
  public Target(float x, float y, float r) {
    Vec2 pixelCenter = box2d.coordWorldToPixels(new Vec2(x, y));
    pos = new Vec2();
    pos.x = pixelCenter.x;
    pos.y = pixelCenter.y;
    this.r = box2d.scalarWorldToPixels(r) / 10;
  }
  
  public Vec2 getPosition() {
    return box2d.coordPixelsToWorld(pos);
  }

  
  public void setPosition(float x, float y) {
    pos.x = x;
    pos.y = y;
  }

  public void display() {
    pushMatrix();
    translate(pos.x, pos.y);
    fill(127);
      strokeWeight(1);
      ellipse(0, 0, r*2, r*2);
      line(-r, 0, r, 0);
      line(0, -r, 0, r);
    fill(255);
    popMatrix();
  }
}

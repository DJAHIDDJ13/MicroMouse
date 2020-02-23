public class Target {
  private float x, y, r;

  // Constructor
  public Target(float x, float y, float r) {
    Vec2 pixelPos = box2d.coordWorldToPixels(x, y);
    this.x = pixelPos.x;
    this.y = pixelPos.y;
    this.r = r;
  }
  
  public float getPositionX() {
    return x;
  }
  
  public float getPositionY() {
    return y;
  }
  
  public void setPosition(float x, float y) {
    this.x = x;
    this.y = y;
  }

  public void display() {
    float pixel_r = box2d.scalarWorldToPixels(r) / 4;
    pushMatrix();
    translate(x, y);
    fill(127);
      strokeWeight(1);
      ellipse(0, 0, pixel_r*2, pixel_r*2);
      line(-pixel_r, 0, pixel_r, 0);
      line(0, -pixel_r, 0, pixel_r);
    fill(255);
    popMatrix();
  }
}

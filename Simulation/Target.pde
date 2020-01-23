public class Target {
  private float x, y, r;

  // Constructor
  public Target(float x, float y, float r) {
    this.x = x;
    this.y = y;
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
    pushMatrix();
    translate(x, y);
    fill(127);
      strokeWeight(1);
      ellipse(0, 0, r*2, r*2);
      line(-r, 0, r, 0);
      line(0, -r, 0, r);
    fill(255);
    popMatrix();
  }
}

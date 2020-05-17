/**
 * To simplify this sends the total number of ticks
 */
public class RotaryEncoder {
  private final int linesPerRevolution = 1024;

  public int lineCumul;
  
  public RotaryEncoder() {
    lineCumul = 0;
  }
  
  public void update(double totalRevolutionAngle) {
    /** Probably should change the abs to the distance between the two angles in a circle or 10*PI ?*/
    lineCumul = round((float)totalRevolutionAngle / (TWO_PI) * linesPerRevolution);
  }
  
  public int getValue() {
     return round(lineCumul);
  }
  public int getLinesPerRevolution() {
     return linesPerRevolution; 
  }
}

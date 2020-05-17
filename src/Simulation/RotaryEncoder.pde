/**
 * To simplify this sends the total number of ticks
 */
public class RotaryEncoder {
  private final int linesPerRevolution = 1024;
  private float prevRevolutionAngle;

  public int lineCumul;
  
  public RotaryEncoder() {
    prevRevolutionAngle = -1;
    lineCumul = 0;
  }
  
  public void update(float newRevolutionAngle) {
    if(prevRevolutionAngle != -1) {
      lineCumul = round(abs(newRevolutionAngle - prevRevolutionAngle) / linesPerRevolution);
    }
    prevRevolutionAngle = newRevolutionAngle;
  }
  
  public int getValue() {
     return lineCumul;
  }
}

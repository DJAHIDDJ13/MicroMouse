public class DebugPanel {

  private ControlP5 cp5; 
            
  public DebugPanel(ControlP5 cp5) {
    this.cp5 = cp5;
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
    updateController();
  }

  public void display() {
    displayPanel();
  }

  // updates the gui
  public void updateController() {

  }

  public void displayPanel() {
    strokeWeight(2);
    fill(255);
    rect(830, 310, 640, 600);
    strokeWeight(0);
  }
}

import org.jbox2d.common.*;
import org.jbox2d.dynamics.joints.*;
import org.jbox2d.collision.shapes.*;
import org.jbox2d.collision.shapes.Shape;
import org.jbox2d.common.*;
import org.jbox2d.dynamics.*;

// A reference to our box2d world
public static Box2DProcessing box2d;
SimulationController simCon;

void setup(){
  size(1500,920);
  smooth();
  
  // Initialize box2d physics and create the world
  box2d = new Box2DProcessing(this);
  box2d.createWorld();
  
  simCon = new SimulationController(16);
  simCon.setController(new ControlP5(this));
  simCon.createControllers();
}

void draw() {
  background(150);
  stroke(0);

  // We must always step through time!
  box2d.step();
  simCon.update();

  simCon.getMaze().display();
  simCon.display();
}

void controlEvent(ControlEvent event) {
  simCon.controlEventHandler(event);
}

void mousePressed() {
  simCon.mousePressedHandler();
}

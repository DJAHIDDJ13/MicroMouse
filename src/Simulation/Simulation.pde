
import shiffman.box2d.*;
import org.jbox2d.common.*;
import org.jbox2d.dynamics.joints.*;
import org.jbox2d.collision.shapes.*;
import org.jbox2d.collision.shapes.Shape;
import org.jbox2d.common.*;
import org.jbox2d.dynamics.*;
import org.jbox2d.dynamics.contacts.*;
import org.jbox2d.callbacks.ContactListener;
import org.jbox2d.callbacks.ContactImpulse;
import org.jbox2d.collision.Manifold;
import org.jbox2d.callbacks.RayCastCallback;

// A reference to our box2d world
public static Box2DProcessing box2d;
SimulationController simCon;

public static final long  STARTING_TIME = System.currentTimeMillis();
private final static int initialSize = 4;

void setup(){
  //size(1500,910);

  fullScreen();
  smooth();

  // Initialize box2d physics and create the world
  box2d = new Box2DProcessing(this, 10.0f);
  Vec2 gravity = new Vec2(0, 0);
  box2d.createWorld(gravity);
  // Turn on collision listening!
  box2d.listenForCollisions();
  
  simCon = new SimulationController(new ControlP5(this), initialSize);
  simCon.createControllers();
}

void draw() {
  background(150);
  stroke(0);
  // We must always step through time!
  box2d.step();
  simCon.update();
  
  simCon.display();
}

void controlEvent(ControlEvent event) {
  simCon.controlEventHandler(event);
}

void beginContact(Contact cp) {
  println("here");
  simCon.beginContact(cp);
}

void endContact(Contact cp) {
  simCon.endContact(cp);
}

void mousePressed() {  
  simCon.mousePressedHandler();
}

void keyPressed() {
  simCon.keyPressedHandler();
}

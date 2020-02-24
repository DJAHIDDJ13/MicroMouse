import shiffman.box2d.*;

import org.jbox2d.common.*;
import org.jbox2d.dynamics.joints.*;
import org.jbox2d.collision.shapes.*;
import org.jbox2d.collision.shapes.Shape;
import org.jbox2d.common.*;
import org.jbox2d.dynamics.*;
import org.jbox2d.callbacks.RayCastCallback;

import garciadelcastillo.dashedlines.*;

// A reference to our box2d world
public static Box2DProcessing box2d;
public static DashedLines dash;
SimulationController simCon;

void setup(){
  size(1500,920);
  // smooth();
  
  // Initialize box2d physics and create the world
  box2d = new Box2DProcessing(this, 10.0f);
  Vec2 gravity = new Vec2(0, 0);
  box2d.createWorld(gravity);
  
  // Initialize it, passing a reference to the current PApplet
  dash = new DashedLines(this);
  // Set the dash-gap pattern in pixels
  dash.pattern(30, 10, 15, 10);
  
  simCon = new SimulationController(new ControlP5(this), 8);
  simCon.createControllers();
}

void draw() {
  background(150);
  smooth();
  stroke(0);

  // We must always step through time!
  box2d.step();
  simCon.update();
  
  // Animate dashes with 'walking ants' effect
  dash.offset(simCon.getDashed());
  
  
  simCon.getMaze().display();
  simCon.display();
}

void controlEvent(ControlEvent event) {
  simCon.controlEventHandler(event);
}

void mousePressed() {
  simCon.mousePressedHandler();
}

void keyPressed() {
  simCon.keyPressedHandler();
}

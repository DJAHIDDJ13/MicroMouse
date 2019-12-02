// This seems to be broken with the Box2D 2.1.2 version I'm using

import shiffman.box2d.*;

import org.jbox2d.collision.shapes.*;
import org.jbox2d.common.*;
import org.jbox2d.dynamics.*;
import org.jbox2d.dynamics.joints.*;

// A reference to our box2d world
Box2DProcessing box2d;

static final int worldH = 700;
static final int worldW = 1000;
static final int boxH = 45;
static final int boxW = 60;

SimulationEntry systemEntry;
Engine engine;

void setup(){
  size(1500,800);
  smooth();
  
  // Initialize box2d physics and create the world
  box2d = new Box2DProcessing(this);
  box2d.createWorld();
  
  systemEntry = new SimulationEntry(worldH, worldW);
  engine = new Engine(systemEntry);
  
}

 void draw() {
  background(150);

  // We must always step through time!
  box2d.step();
  
  engine.getWorld().display();
}

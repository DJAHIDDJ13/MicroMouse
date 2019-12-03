// This seems to be broken with the Box2D 2.1.2 version I'm using

import shiffman.box2d.*;

import org.jbox2d.collision.shapes.*;
import org.jbox2d.common.*;
import org.jbox2d.dynamics.*;
import org.jbox2d.dynamics.joints.*;

// A reference to our box2d world
Box2DProcessing box2d;

//There can be 16×16 cells, or 32×32 cells. 
static final int cols = 32;
static final int rows = 32;

SimulationEntry systemEntry;
Engine engine;
World world;
ArrayList<Object> objects;

void setup(){
  size(1500,900);
  smooth();
  
  // Initialize box2d physics and create the world
  box2d = new Box2DProcessing(this);
  box2d.createWorld();
  
  systemEntry = new SimulationEntry(cols, rows);
  engine = new Engine(systemEntry);
  
}

 void draw() {
  background(150);

  // We must always step through time!
  box2d.step();
  
  world = engine.getWorld();
  world.display(systemEntry.getShiftX(),systemEntry.getShiftY());
  objects = world.getObjects();
  Object obj;
  for(int i = 0; i < objects.size(); i++){
    obj = objects.get(i);
    if(obj.isWall()){
      fill(127,0,0);
      rect(obj.getX(), obj.getY(), obj.getW(), obj.getH());
      fill(255);
    }
  }
}

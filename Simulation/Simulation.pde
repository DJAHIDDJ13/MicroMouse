// This seems to be broken with the Box2D 2.1.2 version I'm using

import shiffman.box2d.*;

import org.jbox2d.collision.shapes.*;
import org.jbox2d.common.*;
import org.jbox2d.dynamics.*;
import org.jbox2d.dynamics.joints.*;

// A reference to our box2d world
Box2DProcessing box2d;

static final float worldH = 700;
static final float worldW = 1000;
static final float boxH = 25;
static final float boxW = 50;
static final float shift = 5;

SimulationEntry systemEntry;
Engine engine;
World world;
ArrayList<Object> objects;

void setup(){
  size(1500,800);
  smooth();
  
  // Initialize box2d physics and create the world
  box2d = new Box2DProcessing(this);
  box2d.createWorld();
  
  systemEntry = new SimulationEntry(worldH, worldW, boxH, boxW, shift);
  engine = new Engine(systemEntry);
  
}

 void draw() {
  background(150);

  // We must always step through time!
  box2d.step();
  
  world = engine.getWorld();
  world.display();
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

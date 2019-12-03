// This seems to be broken with the Box2D 2.1.2 version I'm using

import shiffman.box2d.*;

import org.jbox2d.collision.shapes.*;
import org.jbox2d.common.*;
import org.jbox2d.dynamics.*;
import org.jbox2d.dynamics.joints.*;

// A reference to our box2d world
Box2DProcessing box2d;

static final int cols = 32;
static final int rows = 32;

static final float boxW = 25; //the perfect size is 35.
static final float boxH = boxW/2; //it has to be boxH = boxW*2 to work well
static final float worldH = rows*boxW;
static final float worldW = cols*boxW;

static final float shiftX = 5;
static final float shiftY = 5;

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
  
  systemEntry = new SimulationEntry(worldH, worldW, boxH, boxW, shiftX, shiftY);
  engine = new Engine(systemEntry);
  
}

 void draw() {
  background(150);

  // We must always step through time!
  box2d.step();
  
  world = engine.getWorld();
  world.display(shiftX,shiftY);
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

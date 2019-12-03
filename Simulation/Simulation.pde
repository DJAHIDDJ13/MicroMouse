// This seems to be broken with the Box2D 2.1.2 version I'm using
import controlP5.*;

import shiffman.box2d.*;

import org.jbox2d.collision.shapes.*;
import org.jbox2d.common.*;
import org.jbox2d.dynamics.*;
import org.jbox2d.dynamics.joints.*;

// A reference to our box2d world
Box2DProcessing box2d;

ControlP5 cp5;

//There can be 16×16 cells, or 32×32 cells. 
static final int cols = 16;
static final int rows = 16;

SimulationEntry systemEntry;
Engine engine;
World world;

//Object controler to add a wall
Wall wall;
float rotate,xWall,yWall,hWall,wWall;
boolean addClick,correctCords;

void setup(){
  size(1500,950);
  smooth();
  
  // Initialize box2d physics and create the world
  box2d = new Box2DProcessing(this);
  box2d.createWorld();
  
  // Initialize ControlP5
  cp5 = new ControlP5(this);
  
  createButtons();
  
  rotate = 0;
  xWall = 20;
  yWall = 855;
  hWall = 20;
  wWall = 40;
  
  systemEntry = new SimulationEntry(cols, rows);
  engine = new Engine(systemEntry);
  wall = SimulationFactory.createWall(xWall,yWall,hWall,wWall,rotate);
  addClick = correctCords = false;
}

void draw() {
  background(150);
  stroke(0);

  // We must always step through time!
  box2d.step();
  
  world = engine.getWorld();
  world.display(systemEntry.getShiftX(),systemEntry.getShiftY());
  
  objectPanel();
  wallProcess();
}

void wallProcess(){
  wall.setAlpha(rotate);
  if(addClick){
    if(mouseX < systemEntry.getWorldW() && mouseY < systemEntry.getWorldH()){
      wall.setH(systemEntry.getBoxH()); wall.setW(systemEntry.getBoxW());
      wall.setX(mouseX); wall.setY(mouseY);
      correctCords = true;
    }
    else{
      wall.setH(hWall); wall.setW(wWall);
      wall.setX(xWall); wall.setY(yWall);
      correctCords = false;
    }
  }
}

void controlEvent(ControlEvent theEvent) {
  if(theEvent.getController().getName().equals("Turn+")){
    rotate += 0.1;
  } 
  else if(theEvent.getController().getName().equals("Turn-")){
    rotate -= 0.1;
  }
}

// function Add will receive changes from 
// controller with name Add
void Add() {
  addClick = !addClick;
}

void mousePressed() {
  if(correctCords && addClick){
    engine.getWorld().addObject(wall);
    
    wall = SimulationFactory.createWall(xWall,yWall,hWall,wWall,rotate);
    correctCords = false;
    addClick = false;
    rotate = 0;
  }
}

void objectPanel(){
  float dx,dy,dw,dh,alpha;
  float worldS = 1;
  stroke(0);
  rect(5, 830, 70, 70); 
        fill(127,0,0);
        dw = wall.getW()/(worldS*2);
        dh = wall.getH()/(worldS*2);  
        dx = wall.getX()+wall.getW()/2;
        dy = wall.getY()+wall.getH()/2;
        alpha = wall.getAlpha();
        beginShape();
          vertex(dx+(int)floor(0.5+dw*cos(alpha))-(int)floor(0.5+dh*sin(alpha)),
                dy+(int)floor(0.5+dh*cos(alpha))+(int)floor(0.5+dw*sin(alpha)));
          vertex(dx-(int)floor(0.5+dw*cos(alpha))-(int)floor(0.5+dh*sin(alpha)),
                dy+(int)floor(0.5+dh*cos(alpha))-(int)floor(0.5+dw*sin(alpha)));
          vertex(dx-(int)floor(0.5+dw*cos(alpha))+(int)floor(0.5+dh*sin(alpha)),
                dy-(int)floor(0.5+dh*cos(alpha))-(int)floor(0.5+dw*sin(alpha)));
          vertex(dx+(int)floor(0.5+dw*cos(alpha))+(int)floor(0.5+dh*sin(alpha)),
                dy-(int)floor(0.5+dh*cos(alpha))+(int)floor(0.5+dw*sin(alpha)));
          vertex(dx+(int)floor(0.5+dw*cos(alpha))-(int)floor(0.5+dh*sin(alpha)),
                dy+(int)floor(0.5+dh*cos(alpha))+ (int)floor(0.5+dw*sin(alpha)));
        endShape();
      fill(255);
}

void createButtons(){
  cp5.addButton("Turn+")
     .setValue(0)
     .setPosition(90,840)
     .setSize(40,20)
     ;
  
  cp5.addButton("Turn-")
     .setValue(0)
     .setPosition(90,870)
     .setSize(40,20)
     ;
     
  cp5.addButton("Add")
     .setValue(0)
     .setPosition(140,855)
     .setSize(40,20)
     ; 
}

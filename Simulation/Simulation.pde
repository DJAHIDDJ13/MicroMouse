// This seems to be broken with the Box2D 2.1.2 version I'm using
import shiffman.box2d.*;
import org.jbox2d.common.*;
import org.jbox2d.dynamics.joints.*;
import org.jbox2d.collision.shapes.*;
import org.jbox2d.collision.shapes.Shape;
import org.jbox2d.common.*;
import org.jbox2d.dynamics.*;

// A reference to our box2d world
Box2DProcessing box2d;

//There can be 16×16 cells, or 32×32 cells. 
int cols = 16;
int rows = cols;

SimulationEntry systemEntry;
Engine engine;
World world;

SimulationControler cp5 = new SimulationControler();

//Object controler to add a wall
Wall wall;
float rotate,xWall,yWall,hWall,wWall;
boolean addClick,removeClick,correctCords;

void setup(){
  size(1500,920);
  smooth();
  
  // Initialize box2d physics and create the world
  box2d = new Box2DProcessing(this);
  box2d.createWorld();
  
  rotate = 0;
  xWall = 20;
  yWall = 855;
  hWall = 20;
  wWall = 40;
  
  cp5.setControler(new ControlP5(this));
  cp5.createControlers();
  
  wall = SimulationFactory.createWall(xWall,yWall,hWall,wWall,rotate);
  addClick = correctCords = removeClick = false;
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
  else if(removeClick){
     if(mouseX < systemEntry.getWorldW() && mouseY < systemEntry.getWorldH()){
        correctCords = true;
    }   
  }
}

void controlEvent(ControlEvent theEvent) {
  if(theEvent.getController().getName().equals("Turn+")){
    rotate += 0.112;
  } 
  else if(theEvent.getController().getName().equals("Turn-")){
    rotate -= 0.112;
  }
   else if(theEvent.getController().getName().equals("Maze size")){
    println("here");
  }
}

// function Add will receive changes from 
// controller with name Add
void Add() {
  addClick = !addClick;
  removeClick = false;
}

// function Add will receive changes from 
// controller with name Remove
void Remove() {
  removeClick = !removeClick;
  addClick = false;
}

// function Add will receive changes from 
// controller with name Refresh
void Refresh(){
  systemEntry = new SimulationEntry(cols, rows);
  engine = new Engine(systemEntry);
}

// function Add will receive changes from 
// controller with name Size
void Size(int size){
  rows = size;
  cols = size;
}

void mousePressed() {
  if(correctCords){
    if(addClick){
      engine.getWorld().addObject(wall);
    
      wall = SimulationFactory.createWall(xWall,yWall,hWall,wWall,rotate);
    }
    else if(removeClick){
      int wallRemoveIndex = world.IsWall(mouseX,mouseY);
      if(wallRemoveIndex != -1){
        world.removeObjectAt(wallRemoveIndex);
      }
    }
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

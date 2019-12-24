// This seems to be broken with the Box2D 2.1.2 version I'm using
import shiffman.box2d.*;
import org.jbox2d.common.*;
import org.jbox2d.dynamics.joints.*;
import org.jbox2d.collision.shapes.*;
import org.jbox2d.collision.shapes.Shape;
import org.jbox2d.common.*;
import org.jbox2d.dynamics.*;

// A reference to our box2d world
public static Box2DProcessing box2d;

//There can be 16×16 cells, or 32×32 cells. 
int cols = 16;
int rows = cols;
private int NUMBER_OBJECT_EXISTING;
private int INDEX_CURRENT_OBJECT_TO_ADD = 1;
private ArrayList<Box> boxToAdd;

SimulationEntry systemEntry;
Engine engine;
World world;

SimulationControler cp5 = new SimulationControler();

float rotate,xAdd,yAdd,hAdd,wAdd,rAdd;
boolean addClick,removeClick,correctCords;

void setup(){
  size(1500,920);
  smooth();
  
  // Initialize box2d physics and create the world
  box2d = new Box2DProcessing(this);
  box2d.createWorld();
  
  rotate = 0;
  xAdd = 20;
  yAdd = 855;
  hAdd = 20;
  wAdd = 40;
  rAdd = hAdd / 2;
  
  cp5.setControler(new ControlP5(this));
  cp5.createControlers();
  
  boxToAdd = new ArrayList<Box>();
  
  makeListObject();
  
  NUMBER_OBJECT_EXISTING = boxToAdd.size() - 1;
  
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
  ObjectToAddProcess();
}

private void ObjectToAddProcess(){
  Box box = boxToAdd.get(INDEX_CURRENT_OBJECT_TO_ADD);
  
  box.setAlpha(rotate);
  if(addClick){
    if(mouseX < systemEntry.getWorldW() && mouseY < systemEntry.getWorldH()){
      if(box.isWall())
        box.setPosition(mouseX,mouseY,systemEntry.getBoxH(),systemEntry.getBoxW(),rotate,systemEntry.getBoxH() / 2);
      else if(box.isTarget())
        box.setPosition(mouseX,mouseY,systemEntry.getBoxH(),systemEntry.getBoxW(),0,systemEntry.getBoxH() / 2);
      
      correctCords = true;
    }
    else{
      if(box.isWall())
         box.setPosition(xAdd,yAdd,hAdd,wAdd,rotate,rAdd);
       else if(box.isTarget())
         box.setPosition(xAdd+20,yAdd+10,hAdd,wAdd,0,rAdd);
      correctCords = false;
    }
  }
  else if(removeClick){
     if(mouseX < systemEntry.getWorldW() && mouseY < systemEntry.getWorldH()){
        correctCords = true;
    } 
    else{
     correctCords = false; 
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
  else if(theEvent.getController().getName().equals("+")){
    INDEX_CURRENT_OBJECT_TO_ADD = (INDEX_CURRENT_OBJECT_TO_ADD - NUMBER_OBJECT_EXISTING != 0) ?  
                                  INDEX_CURRENT_OBJECT_TO_ADD + 1 : 0;
  }
  else if(theEvent.getController().getName().equals("-")){
    INDEX_CURRENT_OBJECT_TO_ADD = (INDEX_CURRENT_OBJECT_TO_ADD == 0) ?  
                                   NUMBER_OBJECT_EXISTING : INDEX_CURRENT_OBJECT_TO_ADD - 1;
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
      engine.getWorld().addBox(boxToAdd.get(INDEX_CURRENT_OBJECT_TO_ADD));
      makeListObject();
    }
    else if(removeClick){
      int wallRemoveIndex = world.IsWall(mouseX,mouseY);
      if(wallRemoveIndex != -1){
        world.removeBoxAt(wallRemoveIndex);
      }
    }
  }
}

private void objectPanel(){
  stroke(0);
  rect(5, 830, 70, 70); 
  if((!correctCords || removeClick) && boxToAdd.get(INDEX_CURRENT_OBJECT_TO_ADD).isWall()){
    boxToAdd.get(INDEX_CURRENT_OBJECT_TO_ADD).displayVertex();
  }
  else{
    boxToAdd.get(INDEX_CURRENT_OBJECT_TO_ADD).display(); 
  }
}

public static Box2DProcessing getBox2D(){
   return box2d;
}

public void makeListObject(){
  boxToAdd.clear();
      
  Wall wall = new Wall(xAdd,yAdd,hAdd,wAdd,rotate);
  Target target = new Target(xAdd+20,yAdd+10,hAdd,wAdd,rotate,rAdd);
  
  boxToAdd.add(wall);
  boxToAdd.add(target); 
}

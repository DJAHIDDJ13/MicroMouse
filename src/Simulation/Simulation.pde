import shiffman.box2d.*;
import org.jbox2d.common.*;
import org.jbox2d.dynamics.joints.*;
import org.jbox2d.collision.shapes.*;
import org.jbox2d.collision.shapes.Shape;
import org.jbox2d.common.*;
import org.jbox2d.dynamics.*;
import org.jbox2d.callbacks.RayCastCallback;


// A reference to our box2d world
public static Box2DProcessing box2d;
SimulationController simCon;

// My vars
BackTracking BT;
Cell cell, next, cell1, cell2, current;
Stack stack = new Stack();
boolean tour = true;

void setup(){
  size(1500,920);
  // smooth();
  
  // Initialize box2d physics and create the world
  box2d = new Box2DProcessing(this, 10.0f);
  Vec2 gravity = new Vec2(0, 0);
  box2d.createWorld(gravity);
  
  simCon = new SimulationController(16);
  simCon.setController(new ControlP5(this));
  simCon.createControllers();
  
  //MY CODE
  BT = new BackTracking(800,800,40,10);
  current = BT.mat[0][0];
  cell = BT.mat[0][5];
  cell1 = BT.mat[1][2];
  cell2 = BT.mat[1][1];
  BT.randomVoisin(cell);
}

void draw() {
  background(150);
  stroke(0);
  frameRate(60800);
  // We must always step through time!
  box2d.step();
  simCon.update();

  //simCon.getMaze().display();
  //simCon.display();
  
  //MY CODE
  //BT.randomChange();
  //BT.display();
  //BT.mat[4][4].display();
  //BT.mat[4][5].display();
  //next = BT.randomVoisin(cell);
  //BT.removeWall(cell1,cell2);
  //next.display();
  
  /* ######### Test du BackTracking ########*/
  tour = !tour;

  BT.display(); 
  
  //La cellule corrante et marquée comme visitée
  current.visited = true;
  
  // election d'une cellule voisine nos visitée de façon aléatoir
  Cell next = BT.randomVoisin(current);
  
  if(next==null && stack.empty()){
    return;
  }
  else if(next==null){
    current = (Cell)stack.pop();
  }
  else{
    stack.push(current);
    // supprimmer mur
    BT.removeWall(current,next);
    current = next;
  }
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
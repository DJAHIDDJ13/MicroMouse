// This seems to be broken with the Box2D 2.1.2 version I'm using
import shiffman.box2d.*;
import org.jbox2d.common.*;
import org.jbox2d.dynamics.joints.*;
import org.jbox2d.collision.shapes.*;
import org.jbox2d.collision.shapes.Shape;
import org.jbox2d.common.*;
import org.jbox2d.dynamics.*;

Semaphore semaphore = new Semaphore(1);

Communication listener = new Listener(semaphore);
Communication writer = new Writer(semaphore);


void setup(){
  /*
  try {
        listener.join();
        writer.join();
    } catch (InterruptedException e) {
        e.printStackTrace(); 
        System.out.println(e); 
    }
    */
  size(1500,920);
  smooth();
}

void draw() {
  background(150);
  stroke(0);
}

void mousePressed() {
  //System.out.println("TEST TX : ");
  writer.write_fifo("PING");
  //comm.read_fifo();
  //System.out.println(comm.getOutput());
}

// This seems to be broken with the Box2D 2.1.2 version I'm using
import shiffman.box2d.*;
import org.jbox2d.common.*;
import org.jbox2d.dynamics.joints.*;
import org.jbox2d.collision.shapes.*;
import org.jbox2d.collision.shapes.Shape;
import org.jbox2d.common.*;
import org.jbox2d.dynamics.*;

import java.io.File;
import java.nio.file.Files;
import java.util.Arrays;
import java.nio.ByteBuffer;
import java.nio.ByteOrder;

public static final long  STARTING_TIME = System.currentTimeMillis();


Semaphore semaphore = new Semaphore(1);


Listener listener = new Listener(semaphore);
Writer writer = new Writer(semaphore);

/* MESSAGE */
HeaderData testHeader = new HeaderData();
SensorData testSensor = new SensorData();

File file = new File("/tmp/c_tx");
byte[] fileContent;

void setup(){

  /* ERROR TEST */
  /*
  int[] invalid = new int[10];
  testHeader.setMazeData(invalid);
  */
  /* DATA TEST */
  /*
  int[] testMaze = new int[] {500, 500};
  int[] testInit = new int[] {0, 0, 0};
  int[] testTar = new int[] {500, 500};

  testHeader.setMazeData(testMaze);
  testHeader.setInitialPosData(testInit);
  testHeader.setTargetPosData(testTar);

  testHeader.setContent();
  */

  float[] testDist = new float[] {1.23, 4.56, 7.89, 12.23};
  float[] testAcc = new float[] {1.23, 4.56, 7.89, 12.23, 45.67, 89.12};

  testSensor.setDistanceData(testDist);
  testSensor.setAccelerometerData(testAcc);

  testSensor.setContent();

  //testSensor.dumpContent();

  /*
  System.out.println(test.getFlag());
  try {
    fileContent = Files.readAllBytes(file.toPath());
    //for (byte val : fileContent)
    //System.out.println(String.format("0x%02X", val));
    byte[] sliced = Arrays.copyOfRange(fileContent, 1, 5);
    for (byte val : sliced)
      System.out.println(String.format("0x%02X", val));
    float f = ByteBuffer.wrap(sliced).order(ByteOrder.LITTLE_ENDIAN).getFloat();
    System.out.println("FLOAT = " + f);
  } catch(IOException e) {
    System.out.println(e.getMessage());
  }
  */
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
  writer.writeFifo(testSensor);
  //comm.readFifo();
  //System.out.println(comm.getOutput());
}

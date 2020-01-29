import java.io.File;
import java.io.FileInputStream;
import java.io.FileOutputStream;
import java.io.IOException;

public class Communication extends Thread {
  
  final String FIFO_PATH = "/tmp/";
  final String FIFO_TX_FILENAME = "java_tx";
  final String FIFO_RX_FILENAME = "c_tx";
  
  FileOutputStream txStream;
  FileInputStream rxStream;
  
  String input, output;
  
  public Communication() {
    this.setName("Communication process");
    this.setDaemon(true);
    this.start();
  }
  
  public void run() {
    //
  }

  String getOutput() {
    return this.output; 
  }
  
  String getInput() {
    return this.input; 
  }

  public void read_fifo() {
    try {
      rxStream = new FileInputStream(FIFO_PATH + FIFO_RX_FILENAME);
      int character = 0;
      this.output = "";
      while ((character = rxStream.read()) != -1)
        this.output += (char) character;
      rxStream.close();
    } catch(Exception e) {
      e.printStackTrace(); 
      System.out.println(e); 
    }
  }

  public void write_fifo(String input) {
    try {
      txStream = new  FileOutputStream(FIFO_PATH + FIFO_TX_FILENAME);
      byte stringToByte[] = input.getBytes();
      txStream.write(stringToByte);
      txStream.close();
    } catch(Exception e) {
      e.printStackTrace(); 
      System.out.println(e); 
    }
  }
}

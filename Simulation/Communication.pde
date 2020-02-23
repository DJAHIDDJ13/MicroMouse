import java.io.File;
import java.io.FileInputStream;
import java.io.FileOutputStream;
import java.io.IOException;
import java.util.concurrent.*;

public abstract class Communication extends Thread {
  
  final String FIFO_PATH = "/tmp/";
  final String FIFO_TX_FILENAME = "java_tx";
  final String FIFO_RX_FILENAME = "c_tx";
  
  Semaphore semaphore;

  public abstract void run();
  public abstract void read_fifo();
  public abstract void write_fifo(String input);

}

import java.io.File;
import java.io.FileInputStream;
import java.io.FileOutputStream;
import java.io.IOException;
import java.util.concurrent.*;

public abstract class Communication extends Thread {

  public abstract void run();
}
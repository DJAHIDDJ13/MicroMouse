import java.io.File;
import java.io.FileInputStream;
import java.io.FileOutputStream;
import java.io.IOException;
import java.util.concurrent.*;

public class Writer extends Thread {
    protected File txFile;
    protected FileOutputStream txStream;
    protected Message txMessage;

    public Writer() {
        this.txFile = new File(CommunicationUtility.FIFO_PATH + CommunicationUtility.FIFO_TX_FILENAME); 
        this.setName("Writer process");
        this.setDaemon(true);
        this.start();
    }

    public void run() {
        if (!this.txFile.exists()) {
            if (osName.toLowerCase().contains("linux") || osName.toLowerCase().contains("macos")) {
                try {
                    Process p = Runtime.getRuntime().exec("mkfifo " + CommunicationUtility.FIFO_PATH + CommunicationUtility.FIFO_TX_FILENAME);
                } catch(Exception e) {
                    e.printStackTrace(); 
                    System.out.println(e); 
                }
              
            }
        }
      
        CommunicationUtility.logMessage("INFO", "Writer", "run", "Starting writer...");
        while (true) {
            this.suspend();
            writeFifo();
        }
    }

    /***************************************************************************************************************************
     * GLOBAL FORMAT (in bytes)
     * +----------+-----------------+
     * | FLAG (1) | CONTENT (16-40) |
     * +----------+-----------------+
     *
     * CONTENT :
     *      FLAG=HEADER
     *          - MAZE# = maze dimension
     *          - INIT# = micromouse initial position information
     *          - TAR#  = target position
     *          - BOX# = box size (cells dimension)
     * +-----------+-----------+-----------+-----------+-----------+-----------+-----------+-----------+-----------+
     * | MAZEL (4) | MAZEH (4) | INITX (4) | INITY (4) | INITA (4) | TARX  (4) | TARY  (4) | BOXW  (4) | BOXH  (4) |
     * +-----------+-----------+-----------+-----------+-----------+-----------+-----------+-----------+-----------+
     *      FLAG=DATA_SENSOR
     *          - DIST# = distances
     *          - F_ACC#  = forward accelerometer values
     *          - A_ACC# = angular accelerometer values
     * +-----------+-----------+-----------+-----------+-----------+-----------+-----------+-----------+-----------+-----------+
     * | DIST1 (4) | DIST2 (4) | DIST3 (4) | DIST4 (4) | F_ACC1(4) | F_ACC2(4) | F_ACC3(4) | A_ACC1(4) | A_ACC2(4) | A_ACC3(4) |
     * +-----------+-----------+-----------+-----------+-----------+-----------+-----------+-----------+-----------+-----------+
     **************************************************************************************************************************/
     public void writeFifo(Message msg) {
        try {
            this.txMessage = msg;
            this.resume();
        } catch(Exception e) {
            e.printStackTrace();  
            System.out.println(e); 
        }
    }

    protected void writeFifo() {
        try {
            String logMsg = "";
            logMsg += "Sending : ";
            logMsg += this.txMessage.flag + " ";
            logMsg += this.txMessage.dumpContent();
            txStream = new FileOutputStream(CommunicationUtility.FIFO_PATH + CommunicationUtility.FIFO_TX_FILENAME);
            txStream.write(this.txMessage.getFlag());
            txStream.write(this.txMessage.getContent());
            txStream.close();
            CommunicationUtility.logMessage("INFO", "Writer", "writeFifo", logMsg);
        } catch(Exception e) {
            e.printStackTrace();  
            System.out.println(e); 
        }
    }
}

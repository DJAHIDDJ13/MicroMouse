import java.io.File;
import java.nio.file.Files;
import java.util.Arrays;

public class Listener extends Communication {
    File rxFile;
    FileInputStream rxStream;

    public Listener(Semaphore semaphore) {
        this.rxFile = new File(CommunicationUtility.FIFO_PATH + CommunicationUtility.FIFO_RX_FILENAME);
        this.semaphore = semaphore;
        this.setName("Listener process");
        this.setDaemon(true);
        this.start();
    }

    public void run() {
        CommunicationUtility.logMessage("INFO", "Listener", "run", "Starting listener...");
        while (true) {
            System.out.println("JAVA - LISTENING...");
            readFifo();
        }
    }


    /* ########## DEPRECATED ##########
    public void readFifo() {
        try {
            //this.semaphore.acquire();

            // RESET VALUES
            rxStream = new FileInputStream(CommunicationUtility.FIFO_PATH + CommunicationUtility.FIFO_RX_FILENAME);
            int character = 0;
            this.output = "";
            
            // READ PIPE
            while ((character = rxStream.read()) != -1)
              this.output += (char) character;
            
            // CLEAN UP
            rxStream.close();
            //this.semaphore.release();
        } catch(Exception e) {
            e.printStackTrace(); 
            System.out.println(e); 
        }
    }
    */

    /***************************************************************************************************************************
    * GLOBAL FORMAT (in bytes)
    * +----------+-------------+
    * | FLAG (1) | CONTENT (8) |
    * +----------+-------------+
    *
    * CONTENT :
    *      FLAG=MOTOR
    *          - MOTOR# = motor power
    * +------------+------------+
    * | MOTORL (4) | MOTORR (4) |
    * +------------+------------+
    ***************************************************************************************************************************/
    public void readFifo() {
        try {
            //this.semaphore.acquire();

            /* RESET VALUES */
            rxStream = new FileInputStream(CommunicationUtility.FIFO_PATH + CommunicationUtility.FIFO_RX_FILENAME);
            byte[] rawData = new byte[CommunicationUtility.MAX_MSG_SIZE], sliced;
            byte fileByte = 0;
            int cursor = 0;

            /* READ PIPE */
            while ((fileByte = (byte) rxStream.read()) != -1 && cursor < 50) {
              rawData[cursor] = fileByte;
              cursor++;
            }

            /* rawData[0] = FLAG */
            switch (rawData[0]) {
                case CommunicationUtility.MOTOR_FLAG:
                    sliced = Arrays.copyOfRange(rawData, 1, CommunicationUtility.MOTOR_CONTENT_SIZE + 1);
                    float floatVal = 0;
                    byte[] floatByte = new byte[4];
                    cursor = 0;
                    for (byte value : sliced) {
                        if (cursor < 4) {
                            floatByte[cursor] = value;
                            cursor++;
                        }
                        if (cursor == 4) {
                            floatVal = ByteBuffer.wrap(floatByte).order(ByteOrder.LITTLE_ENDIAN).getFloat();
                            System.out.println(floatVal); // SUBTITUTE TO SERIALIZABLE OBJECT
                            floatByte = new byte[4];
                            cursor = 0;
                        }
                        
                    }
                    break;
                default:
                    CommunicationUtility.logMessage("ERROR", "Listener", "readFifo", "No matching flag found.");
            }
            /*
            for (byte value : rawData)
              System.out.println(value);
            */
            // CLEAN UP
            rxStream.close();
            //this.semaphore.release();
        } catch(Exception e) {
            e.printStackTrace(); 
            System.out.println(e); 
        }
    }
}

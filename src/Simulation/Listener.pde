import java.io.File;
import java.io.FileInputStream;
import java.io.FileOutputStream;
import java.io.IOException;
import java.util.concurrent.*;

public class Listener extends Thread {
    
    protected File rxFile;
    protected FileInputStream rxStream;
    protected Message rxMessage;
    private String osName;

    public Listener() {
        this.rxFile = new File(CommunicationUtility.FIFO_PATH + CommunicationUtility.FIFO_RX_FILENAME);
        this.setName("Listener process");
        this.setDaemon(true);
        this.start();
        osName = System.getProperty("os.name");
    }

    public Message getRxMessage() {
        return this.rxMessage;
    }

    public void run() {
        if (!this.rxFile.exists()) {
            if (osName.toLowerCase().contains("linux") || osName.toLowerCase().contains("mac")) {
                try {
                    Runtime.getRuntime().exec("mkfifo " + CommunicationUtility.FIFO_PATH + CommunicationUtility.FIFO_RX_FILENAME);
                } catch(Exception e) {
                    e.printStackTrace(); 
                    System.out.println(e); 
                }
              
            }
        }

        CommunicationUtility.logMessage("INFO", "Listener", "run", "Starting listener...");
        while (true) {
            /*CommunicationUtility.logMessage("INFO", "Listener", "run", "Listening...");*/
            readFifo();
        }
    }

    /***************************************************************************************************************************
    * GLOBAL FORMAT (in bytes)
    * +----------+-------------+
    * | FLAG (1) | CONTENT (N) |
    * +----------+-------------+
    *
    * CONTENT :
    *      FLAG=MOTOR
    *          - MOTOR# = motor power
    * +------------+------------+
    * | MOTORL (4) | MOTORR (4) |
    * +------------+------------+
    * 
    *      FLAG=WALL
    *          - CELL# = cell coord.
    *          - WALL = wall indicator
    * +------------+------------+------------+
    * | CELLX (4)  | CELLY  (4) | WALL (4)   |
    * +------------+------------+------------+
    ***************************************************************************************************************************/
    public void readFifo() {
        try {
            /* RESET VALUES */
            rxStream = new FileInputStream(CommunicationUtility.FIFO_PATH + CommunicationUtility.FIFO_RX_FILENAME);
            byte[] rawData = new byte[CommunicationUtility.MAX_MSG_SIZE], sliced;
            byte fileByte = 0;
            int cursor = 0;
            String logMsg = "";
            int i = 0;

            /* READ PIPE */
            while ((fileByte = (byte) rxStream.read()) != -1 && cursor < 50) {
              rawData[cursor] = fileByte;
              cursor++;
            }

            /* rawData[0] = FLAG */
            logMsg += "Received : ";
            switch (rawData[0]) {
                case CommunicationUtility.MOTOR_FLAG:
                    sliced = Arrays.copyOfRange(rawData, 1, CommunicationUtility.MOTOR_CONTENT_SIZE + 1);
                    this.rxMessage = new MotorData();
                    MotorData motorDataMsg = new MotorData();
                    motorDataMsg.setContent(sliced);
                    motorDataMsg.formatMessage();
                    motorDataMsg.setLeftPowerMotor();
                    motorDataMsg.setRightPowerMotor();
                    this.rxMessage = motorDataMsg;
                    /* LOGS */
                    logMsg += rawData[0] + " " + this.rxMessage.getLeftPowerMotor() + " " + this.rxMessage.getRightPowerMotor();
                    break;
                case CommunicationUtility.PING_FLAG:
                    sliced = Arrays.copyOfRange(rawData, 1, CommunicationUtility.PING_CONTENT_SIZE + 1);
                    this.rxMessage = new RequestPingData();
                    RequestPingData requestPingDataMsg = new RequestPingData();
                    requestPingDataMsg.setContent(sliced);
                    requestPingDataMsg.setRandomSequence();
                    this.rxMessage = requestPingDataMsg;
                    /* LOGS */
                    logMsg += rawData[0] + " ";
                    for (i = 0; i < 10; i++)
                        logMsg += this.rxMessage.getRandomSequence()[i] + " ";
                    break;
                case CommunicationUtility.WALL_FLAG:
                    sliced = Arrays.copyOfRange(rawData, 1, CommunicationUtility.WALL_CONTENT_SIZE + 1);
                    this.rxMessage = new WallData();
                    WallData wallData = new WallData();
                    wallData.setContent(sliced);
                    wallData.formatMessage();
                    this.rxMessage = wallData;
                    /* LOGS */
                    logMsg += rawData[0] + " " + this.rxMessage.getCell().x + " " + this.rxMessage.getCell().y + " " + this.rxMessage.getWallIndicator() + " ";
                    break;
                default:
                    CommunicationUtility.logMessage("ERROR", "Listener", "readFifo", "No matching flag found.");
            }
            CommunicationUtility.logMessage("INFO", "Listener", "readFifo", logMsg);
            // CLEAN UP
            rxStream.close();
        } catch(Exception e) {
            e.printStackTrace(); 
            System.out.println(e); 
        }
    }
}

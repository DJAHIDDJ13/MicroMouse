public class Listener extends Communication {
    File rxFile;
    FileInputStream rxStream;
    Message rxMessage;

    public Listener() {
        this.rxFile = new File(CommunicationUtility.FIFO_PATH + CommunicationUtility.FIFO_RX_FILENAME);
        this.setName("Listener process");
        this.setDaemon(true);
        this.start();
    }

    public Message getRxMessage() {
        return this.rxMessage;
    }

    public void run() {
        CommunicationUtility.logMessage("INFO", "Listener", "run", "Starting listener...");
        while (true) {
            CommunicationUtility.logMessage("INFO", "Listener", "run", "Listening...");
            readFifo();
        }
    }

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
            /* RESET VALUES */
            rxStream = new FileInputStream(CommunicationUtility.FIFO_PATH + CommunicationUtility.FIFO_RX_FILENAME);
            byte[] rawData = new byte[CommunicationUtility.MAX_MSG_SIZE], sliced;
            byte fileByte = 0;
            int cursor = 0;
            String logMsg = "";

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
                    float floatVal = 0;
                    byte[] floatByte = new byte[4];
                    cursor = 0;
                    
                    this.rxMessage = new MotorData();
                    this.rxMessage = (MotorData) this.rxMessage;
                    MotorData motorDataMsg = new MotorData();
                    motorDataMsg.setContent(sliced);
                    motorDataMsg.formatMessage();
                    motorDataMsg.setLeftPowerMotor();
                    motorDataMsg.setRightPowerMotor();
                    this.rxMessage = motorDataMsg;

                    
                    
                    /*
                    for (byte value : sliced) {
                        if (cursor < 4) {
                            floatByte[cursor] = value;
                            cursor++;
                        }
                        if (cursor == 4) {
                            floatVal = ByteBuffer.wrap(floatByte).order(ByteOrder.LITTLE_ENDIAN).getFloat();
                            //System.out.println(floatVal); // SUBTITUTE TO SERIALIZABLE OBJECT
                            logMsg += floatVal + " ";
                            floatByte = new byte[4];
                            cursor = 0;
                        } 
                    }
                    */
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

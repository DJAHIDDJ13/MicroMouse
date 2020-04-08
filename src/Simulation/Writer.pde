public class Writer extends Communication {
    protected FileOutputStream txStream;
    protected Message txMessage;

    public Writer() {
        this.setName("Writer process");
        this.setDaemon(true);
        this.start();
    }

    public void run() {
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
     * +-----------+-----------+-----------+-----------+-----------+-----------+-----------+
     * | MAZEL (2) | MAZEH (2) | INITX (2) | INITY (2) | INITA (2) | TARX  (2) | TARY  (2) |
     * +-----------+-----------+-----------+-----------+-----------+-----------+-----------+
     *      FLAG=DATA_SENSOR
     *          - DIST# = distances
     *          - ACC#  = accelerometer values
     * +-----------+-----------+-----------+-----------+-----------+-----------+-----------+-----------+-----------+-----------+
     * | DIST1 (4) | DIST2 (4) | DIST3 (4) | DIST4 (4) | ACC1  (4) | ACC2  (4) | ACC3  (4) | ACC4  (4) | ACC5  (4) | ACC6  (4) |
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

/*
    public void writeFifo(HeaderData msg) {
        try {
            String logMsg = "";
            logMsg += "Sending : ";
            logMsg += msg.flag + " ";
            for (float data : msg.mazeData)
                logMsg += data + " ";
            for (float data : msg.initialPosData)
                logMsg += data + " ";
            for (float data : msg.targetPosData)
                logMsg += data + " ";
            txStream = new FileOutputStream(CommunicationUtility.FIFO_PATH + CommunicationUtility.FIFO_TX_FILENAME);
            txStream.write(msg.getFlag());
            txStream.write(msg.getContent());
            txStream.close();
            CommunicationUtility.logMessage("INFO", "Writer", "writeFifo", logMsg);
        } catch(Exception e) {
            e.printStackTrace();  
            System.out.println(e); 
        }
    }

    public void writeFifo(SensorData msg) {
        try {
            String logMsg = "";
            logMsg += "Sending : ";
            logMsg += msg.flag + " ";
            for (float data : msg.distanceData)
                logMsg += data + " ";
            for (float data : msg.accelerometerData)
                logMsg += data + " ";
            txStream = new FileOutputStream(CommunicationUtility.FIFO_PATH + CommunicationUtility.FIFO_TX_FILENAME);
            txStream.write(msg.getFlag());
            txStream.write(msg.getContent());
            txStream.close();
            CommunicationUtility.logMessage("INFO", "Writer", "writeFifo", logMsg);
        } catch(Exception e) {
            e.printStackTrace();  
            System.out.println(e); 
        }
    }
*/
}

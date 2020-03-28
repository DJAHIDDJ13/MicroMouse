public static class CommunicationUtility {

    public static final String FIFO_PATH = "/tmp/";
    public static final String FIFO_TX_FILENAME = "java_tx";
    public static final String FIFO_RX_FILENAME = "c_tx";

    public static final int MAX_MSG_SIZE = 50;
    public static final byte HEADER_FLAG = 11;
    public static final byte HEADER_CONTENT_SIZE = 16;
    public static final byte SENSOR_FLAG = 10;
    public static final byte SENSOR_CONTENT_SIZE = 40;
    public static final byte MOTOR_FLAG = 20;
    public static final byte MOTOR_CONTENT_SIZE = 8;

    public static void logMessage(String logLevel, String process, String function, String msg) {
        String format = "%-40s%s%n";
        System.out.printf(format,
                            "[" + (float) (System.currentTimeMillis() - STARTING_TIME)/1000 + "] " + 
                            process + 
                            " - " + function + "()",
                            "[" + logLevel + "] : " + 
                            msg);
        if (logLevel.equals("ERROR"))
            System.exit(0); 
    }

}

public static class CommunicationUtility {

    public static final String FIFO_PATH = "/tmp/";
    public static final String FIFO_TX_FILENAME = "java_tx";
    public static final String FIFO_RX_FILENAME = "c_tx";

    public static final byte PING_FLAG = 66;
    public static final byte PING_CONTENT_SIZE = 40;
    public static final int MAX_MSG_SIZE = 50;
    public static final byte HEADER_FLAG = 11;
    public static final byte HEADER_CONTENT_SIZE = 40;
    public static final byte SENSOR_FLAG = 10;
    public static final byte SENSOR_CONTENT_SIZE = 40;
    public static final byte MOTOR_FLAG = 20;
    public static final byte MOTOR_CONTENT_SIZE = 8;
    public static final byte GOAL_REACHED_FLAG = 33;
    public static final byte GOAL_REACHED_CONTENT_SIZE = 1; 
    public static String consoleText = "";

    public static void logMessage(String logLevel, String process, String function, String msg) {
        String format = "%-40s%s%n";
        
        consoleText = String.format(format,
                            "[" + (float) (System.currentTimeMillis() - STARTING_TIME)/1000 + "] " + 
                            process + 
                            " - " + function + "()",
                            "[" + logLevel + "] : " + 
                            msg);
        /*
        if (logLevel.equals("ERROR"))
          System.exit(0);
        */
    }
    
    public static byte[] packFloatArray(float[] arr) {
      ByteArrayOutputStream byteStream = new ByteArrayOutputStream();
      // byteBuffer reused for every element in floatArray
      ByteBuffer byteBuffer = ByteBuffer.allocate(4);
      // go through the elements in the float array writing its
      // byte equivalent  to the stream
      try {
        for(float element : arr) {
          byteBuffer.clear();
          byteBuffer.order(ByteOrder.LITTLE_ENDIAN).putFloat(element);
          byteStream.write(byteBuffer.array());
        }
      } catch(IOException e) {
        e.printStackTrace(); 
      }
      return byteStream.toByteArray();
    }
    
    public static float byteToFloat(byte[] bytes) {
      if(bytes.length % 4 != 0) {
        throw new IllegalArgumentException("Byte array length must be 4");
      }
      return ByteBuffer.wrap(bytes).order(ByteOrder.LITTLE_ENDIAN).getFloat(); 
    }
    
    public static float[] extractByteArray(byte[] bytes) {
      if(bytes.length % 4 != 0) {
        throw new IllegalArgumentException("Byte array length must be a multiple of 4");
      }
      int arrSize = bytes.length / 4;
      float[] arr = new float[arrSize];
      for(int i = 0; i < arrSize; i++) {
        arr[i] = byteToFloat(Arrays.copyOfRange(bytes, 4 * i, 4 * (i+1)));
      }
      
      return arr;
    }
    
    public static float[] concatAllFloat(float[] first, float[]... rest) {
      int totalLength = first.length;
      for (float[] array : rest) {
        totalLength += array.length;
      }
      float[] result = Arrays.copyOf(first, totalLength);
      int offset = first.length;
      for (float[] array : rest) {
        System.arraycopy(array, 0, result, offset, array.length);
        offset += array.length;
      }
      return result;
    }
}

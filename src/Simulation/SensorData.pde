/* MESSAGE TYPE : TX */
public class SensorData extends Message {

  float[] distanceData;
  float[] accelerometerData;
  float[] encoderData;
  float[] time_stamp;
  public SensorData() {
    this.flag = CommunicationUtility.SENSOR_FLAG;
    this.content = new byte[CommunicationUtility.SENSOR_CONTENT_SIZE];
  }

  public SensorData(float[] distanceData, float[] accelerometerData) {
    this.flag = CommunicationUtility.SENSOR_FLAG;
    if (distanceData.length != 4 || accelerometerData.length != 6) {
      CommunicationUtility.logMessage("ERROR", "SensorData", "Constructor", "Array sizes not matching.");
    } else {
      this.distanceData = distanceData;
      this.accelerometerData = accelerometerData;
    }
  }

  public void setDistanceData(float[] distanceData) {
    if (distanceData.length != 4)
      CommunicationUtility.logMessage("ERROR", "SensorData", "setDistanceData", 
        "distanceData array size not matching : is " 
        + distanceData.length + " - should be 4.");
    else
      this.distanceData = distanceData;
  }

  public void setAccelerometerData(float[] accelerometerData) {
    if (accelerometerData.length != 6)
      CommunicationUtility.logMessage("ERROR", "SensorData", "setAccelerometerData", 
        "accelerometerData array size not matching : is " 
        + accelerometerData.length + " - should be 6.");
    else
      this.accelerometerData = accelerometerData;
  }

  public void setEncoderData(float[] encoderData) {
    if (encoderData.length != 2)
      CommunicationUtility.logMessage("ERROR", "SensorData", "setEncoderrData", 
        "encoderData array size not matching : is " 
        + encoderData.length + " - should be 2.");
    else
      this.encoderData = encoderData;
  }

  public void setTimeStamp(float time_stamp) {
    if (encoderData.length != 2)
      CommunicationUtility.logMessage("ERROR", "time_stamp", "setTimeStamp", 
        "time_stamp array size not matching : is " 
        + encoderData.length + " - should be 1.");
    else
      this.time_stamp = new float[] {time_stamp};
  }

    public void setContent() {
    if (distanceData == null || distanceData.length == 0 ||
      accelerometerData == null || accelerometerData.length == 0) {
      CommunicationUtility.logMessage("ERROR", "SensorData", "setContent", 
        "Cannot format message content because data are incomplete.");
    } else {
      this.content = CommunicationUtility.packFloatArray(CommunicationUtility.concatAllFloat(distanceData, accelerometerData, encoderData, time_stamp));
    }
  }

  public String dumpContent() {
    if (this.content == null || this.content.length == 0) {
      CommunicationUtility.logMessage("INFO", "SensorData", "dumpContent", "Content is empty.");
      return "";
    } else {
      String strContent = "";

      float[] arr = CommunicationUtility.extractByteArray(content);
      for (float f : arr) {
        strContent += f + " ";
      }
      return strContent;
    }
  }

  public void setContent(byte[] content) {
    this.content = content;
  }

  /* TO_DO */
  public void setContent(String strContent) {
  }
}

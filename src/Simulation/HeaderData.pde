import java.io.ByteArrayOutputStream;

/* MESSAGE TYPE : TX */
public class HeaderData extends Message {
    
    float[] mazeData;
    float[] initialPosData;
    float[] targetPosData;
    float[] cellSizeData;
    float[] encoderData;
    float[] sensorsPos;
    float[] originPos;
    
    public HeaderData() {
        this.flag = CommunicationUtility.HEADER_FLAG;
        this.content = new byte[CommunicationUtility.HEADER_CONTENT_SIZE];
    }

    public HeaderData (float[] mazeData, float[] initialPosData, float[] targetPosData) {
        this.flag = CommunicationUtility.HEADER_FLAG;
        if (mazeData.length != 2 || initialPosData.length != 3 || targetPosData.length != 2) {
            CommunicationUtility.logMessage("WARNING", "HeaderData", 
                                            "Constructor", "Array sizes not matching.");  
        } else {
            this.mazeData = mazeData;
            this.initialPosData = initialPosData;
            this.targetPosData = targetPosData;
        }
    }

    public void setMazeData(float[] mazeData) {
        if (mazeData.length != 2)
            CommunicationUtility.logMessage("WARNING", "HeaderData", "setMazeData", 
                                            "mazeData array size not matching : is " 
                                            + mazeData.length + " - should be 2.");
        else
            this.mazeData = mazeData;
    }

    public void setInitialPosData(float[] initialPosData) {
        if (initialPosData.length != 3)
            CommunicationUtility.logMessage("WARNING", "HeaderData", "setInitialPosData", 
                                            "initialPosData array size not matching : is " 
                                            + initialPosData.length + " - should be 3.");
        else
            this.initialPosData = initialPosData;
    }

    public void setTargetPosData(float[] targetPosData) {
        if (targetPosData.length != 2)
            CommunicationUtility.logMessage("WARNING", "HeaderData", "targetPosData", 
                                            "targetPosData array size not matching : is " 
                                            + targetPosData.length + " - should be 2.");
        else
            this.targetPosData = targetPosData;
    }
    
    public void setEncoderLinesPerRevolution(float[] encoderData) {
      this.encoderData = encoderData;
    }

    public void setCellSizeData(float[] cellSizeData) {
        if (cellSizeData.length != 2)
            CommunicationUtility.logMessage("WARNING", "HeaderData", "cellSizeData", 
                                            "cellSizeData array size not matching : is " 
                                            + cellSizeData.length + " - should be 2.");
        else
            this.cellSizeData = cellSizeData;
    }

    /* x, y, angle */
    public void setSensorsPos(float[] sensorsPos) {
        if (sensorsPos.length != 12)
            CommunicationUtility.logMessage("WARNING", "HeaderData", "sensorsPos", 
                                            "sensorsPos array size not matching : is " 
                                            + sensorsPos.length + " - should be 12.");
        else
            this.sensorsPos = sensorsPos;
    }
    
    public void setOriginPos(float[] originPos) {
        if (originPos.length != 2)
            CommunicationUtility.logMessage("WARNING", "HeaderData", "originPos", 
                                            "originPos array size not matching : is " 
                                            + originPos.length + " - should be 2.");
        else
            this.originPos = originPos;
    }

    public void setContent() {
        if (mazeData == null || mazeData.length == 0 ||
            initialPosData == null || initialPosData.length == 0 ||
            targetPosData == null || targetPosData.length == 0 ||
            cellSizeData == null || cellSizeData.length == 0 ||
            sensorsPos == null || sensorsPos.length == 0) {
              
                CommunicationUtility.logMessage("ERROR", "HeaderData", "setContent", 
                                                "Cannot format message content because data are incomplete.");
        } else {
            this.content = CommunicationUtility.packFloatArray(CommunicationUtility.concatAllFloat(mazeData, 
                                                               initialPosData, targetPosData, cellSizeData, 
                                                               encoderData, sensorsPos, originPos));
        }
    }

    public String dumpContent() {
        if (this.content == null || this.content.length == 0) {
            CommunicationUtility.logMessage("INFO", "HeaderData", "dumpContent", "Content is empty");
            return "";
        } else {
            String strContent = "";

            float[] arr = CommunicationUtility.extractByteArray(content);
            for(float f: arr) {
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

import java.io.ByteArrayOutputStream;

/* MESSAGE TYPE : TX */
public class PositionData extends Message {
    float[] posData;

    public PositionData() {
        this.flag = CommunicationUtility.POSITION_FLAG;
        this.content = new byte[CommunicationUtility.POSITION_CONTENT_SIZE];
    }

    public PositionData (float[] posData) {
        this.flag = CommunicationUtility.POSITION_FLAG;
        if (posData.length != 3) {
            CommunicationUtility.logMessage("WARNING", "PositionData", 
                                            "Constructor", "Array sizes not matching.");  
        } else {
            this.posData = posData;
        }
    }

    public void setPosData(float[] posData) {
        if (posData.length != 3)
            CommunicationUtility.logMessage("WARNING", "PositionData", "setPosData", 
                                            "posData array size not matching : is " 
                                            + posData.length + " - should be 3.");
        else
            this.posData = posData;
    }

    public void setContent() {
        if (posData == null || posData.length != 3) {

                CommunicationUtility.logMessage("ERROR", "PositionData", "setContent", 
                                                "Cannot format message content because data are incomplete.");
        } else {
            this.content = CommunicationUtility.packFloatArray(posData);
        }
    }

    public String dumpContent() {
        if (this.content == null || this.content.length == 0) {
            CommunicationUtility.logMessage("INFO", "PositionData", "dumpContent", "Content is empty");
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

    public void setContent(String strContent) {

    }
}

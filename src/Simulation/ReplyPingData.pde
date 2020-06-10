 import java.io.ByteArrayOutputStream;

/* MESSAGE TYPE : TX */
public class ReplyPingData extends Message {
    
    float[] randomSequence;
    
    public ReplyPingData() {
        this.flag = CommunicationUtility.PING_FLAG;
        this.content = new byte[CommunicationUtility.PING_CONTENT_SIZE];
    }

    public void setRandomSequence(float[] randomSequence) {
        if (randomSequence.length != 10)
            CommunicationUtility.logMessage("WARNING", "RequestPingData", "setRandomSequence", 
                                            "randomSequence array size not matching : is " 
                                            + randomSequence.length + " - should be 10.");
        else
            this.randomSequence = randomSequence;
    }

    public void setContent() {
        if (randomSequence == null || randomSequence.length == 0 ) {
                CommunicationUtility.logMessage("ERROR", "RequestPingData", "setContent", 
                                                "Cannot format message content because data are incomplete.");
        } else {
            this.content = CommunicationUtility.packFloatArray(CommunicationUtility.concatAllFloat(randomSequence));
        }
    }

    public String dumpContent() {
        if (this.content == null || this.content.length == 0) {
            CommunicationUtility.logMessage("INFO", "RequestPingData", "dumpContent", "Content is empty");
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

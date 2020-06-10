 import java.io.ByteArrayOutputStream;

/* MESSAGE TYPE : RX */
public class RequestPingData extends Message {
    
    float[] randomSequence;
    
    public RequestPingData() {
        this.flag = CommunicationUtility.PING_FLAG;
        this.content = new byte[CommunicationUtility.PING_CONTENT_SIZE];
    }

    public float[] getRandomSequence() {
        return this.randomSequence;
    }

    protected void setRandomSequence() {
        if (this.content == null || this.content.length == 0) {
            CommunicationUtility.logMessage("WARNING", "ReplyPingData", "setRandomSequence", "Content is empty - no data has been received.");
        } else {
            int i = 0;
            byte[] sliced = new byte[4];
            this.randomSequence = new float[10];
            /* According to data format : [0:4]bytes */
            for (i = 0; i < 10; i++) {
                sliced = Arrays.copyOfRange(this.content, i * 4, (i + 1) * 4);
                this.randomSequence[i] = ByteBuffer.wrap(sliced).order(ByteOrder.LITTLE_ENDIAN).getFloat();
            }
        }
    }

    public void formatMessage() {
        setRandomSequence();
    }

    public void setRandomSequence(float[] randomSequence) {
        this.randomSequence = randomSequence;
    }

    public void setContent(byte[] content) {
        this.content = content;
    }

    /* TO_DO or REMOVE */
    public void setContent() {
        /**/
    }
    
    public void setContent(String strContent) {
        /**/ 
    }
    
    public String dumpContent() {
        /**/
        return "";
    }
}

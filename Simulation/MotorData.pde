/**************************************************** MESSAGE TYPE : RX ****************************************************
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
public class MotorData extends Message {
    float leftPowerMotor;
    float rightPowerMotor;

    public MotorData() {
        this.flag = CommunicationUtility.MOTOR_FLAG;
        this.content = new byte[CommunicationUtility.MOTOR_CONTENT_SIZE];
    }
    
    public MotorData(byte[] content) {
        this.flag = CommunicationUtility.MOTOR_FLAG;
        if (content == null || content.length != CommunicationUtility.MOTOR_CONTENT_SIZE)
            CommunicationUtility.logMessage("WARNING", "MotorData", "Constructor", "Content size not matching : is " + content.length + " - should be " + CommunicationUtility.MOTOR_CONTENT_SIZE + ".");
        else
            this.content = content;
    }

    protected void setLeftPowerMotor() {
        if (this.content == null || this.content.length == 0) {
            CommunicationUtility.logMessage("WARNING", "MotorData", "setLeftPowerMotor", "Content is empty - no data has been received.");
        } else {
            /* According to data format : left power motor = [0:4]bytes */
            byte[] sliced = new byte[4];
            sliced = Arrays.copyOfRange(this.content, 0, 4);
            this.leftPowerMotor = ByteBuffer.wrap(sliced).order(ByteOrder.LITTLE_ENDIAN).getFloat();
        }
    }

    protected void setRightPowerMotor() {
        if (this.content == null || this.content.length == 0) {
            CommunicationUtility.logMessage("WARNING", "MotorData", "setLeftPowerMotor", "Content is empty - no data has been received.");
        } else {
            /* According to data format : right power motor = [4:8]bytes */
            byte[] sliced = new byte[4];
            sliced = Arrays.copyOfRange(this.content, 4, 8);
            this.rightPowerMotor = ByteBuffer.wrap(sliced).order(ByteOrder.LITTLE_ENDIAN).getFloat();
        }
    }
    
    public void setContent(byte[] content) {
        this.content = content;
    }
    
    public void formatMessage() {
        setLeftPowerMotor();
        setRightPowerMotor();
    }
    
    /* TO_DO or REMOVE */
    public void setContent() {
        /**/
    }
    
    public void setContent(String strContent) {
        /**/ 
    }
    
    public void dumpContent() {
        /**/ 
    }
}

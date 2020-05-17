import java.util.Arrays;
import java.nio.ByteBuffer;
import java.nio.ByteOrder;

public abstract class Message {
  
  byte flag;
  byte[] content;

  public void setFlag(byte flag) {
    this.flag = flag;
  }

  public byte getFlag() {
    return this.flag;
  }

  /* MOTOR DATA */
  public float getLeftPowerMotor() {
      return -999; 
  }

  public float getRightPowerMotor() {
      return -999; 
  }

  public abstract void setContent();
  public abstract void setContent(byte[] content);
  public abstract String dumpContent();
  /* TO_DO */
  public abstract void setContent(String strContent);

  public byte[] getContent() {
    return this.content;
  }

  protected byte[] intToBytes(int toConvert) {
    byte[] intToByte = new byte[2];
    for (int i = 0; i < 2; i++)
      intToByte[i] = (byte) ((toConvert >> i*8) & 0xFF);

    return intToByte;
  }
}

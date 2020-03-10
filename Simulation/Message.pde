public abstract class Message {
  byte flag;
  byte[] content;

  public void setFlag(byte flag) {
    this.flag = flag;
  }

  public byte getFlag() {
    return this.flag;
  }

  public abstract void setContent();
  /* TO_DO */
  public abstract void setContent(String strContent);
  public abstract void dumpContent();

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

public class Message {
  
  String flag;
  String content;
  
  public Message() {
    this.flag = "";
    this.content = "";
  }
  
  public Message(String output) {
    String[] tmp_array = output.split(":", 2);
    this.flag = tmp_array[0];
    this.content = tmp_array[1];
  }
  
  String getFlag() {
    return this.flag; 
  }
  
  String getContent() {
    return this.content;
  }
}

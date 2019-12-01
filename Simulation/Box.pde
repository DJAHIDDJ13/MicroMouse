// A rectangular box
class Box{
 
  private Coordinates position;
  private BoxType type;
  
  // Constructor
  Box(Coordinates position, BoxType type){
    this.position = position;
    this.type = type;
  }
  
  Coordinates getPosition(){
    return this.position;
  }
  
  void setPosition(Coordinates newPosition){
    this.position = newPosition;
  }
  
  BoxType getType(){
    return type;
  }
  
  void setBoxType(BoxType type){
    this.type = type;
  }
  
  boolean isFreeBox(){
    return this.type.isFree();
  }
}

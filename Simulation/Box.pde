abstract class Box{
 
  private Coordinates position;
  
  Box(Coordinates position){
    this.position = position;
  }
  
  Coordinates getPosition(){
    return this.position;
  }
  
  void setPosition(Coordinates newPosition){
    this.position = newPosition;
  }
  
  abstract boolean isFree();
  
}

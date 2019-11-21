class FreeBox extends Box{
  
  FreeBox(Coordinates position){
   super(position); 
  }
  
  boolean isFree(){
    return true;
  }
}

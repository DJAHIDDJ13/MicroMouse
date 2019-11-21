class TakenBox extends Box{
  
  TakenBox(Coordinates position){
   super(position); 
  }
  
  boolean isFree(){
   return false; 
  }
  
}

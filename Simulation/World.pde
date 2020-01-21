public class World{
  private float worldH,worldW;
  private ArrayList<Box> boxes;
  private boolean haveTarget;
  private Box target;
  
  public World(float worldH, float worldW){
    this.worldH = worldH;
    this.worldW = worldW;
    boxes = new ArrayList<Box>();
    haveTarget = false;
  }
    
  public Box getTarget(){
    return target;
  }
  
  public void setTarget(Box target){
    haveTarget = true;
    this.target = target; 
  }
    
  public boolean haveTarget(){
    return haveTarget;
  }
  
  public void setHaveTarget(boolean haveTarget){
    this.haveTarget = haveTarget;
  }
  
  public float getWorldH(){
    return worldH;
  }
  
  public void setWorldH(float worldH){
    this.worldH = worldH;
  }
  
  public float getWorldW(){
    return worldW;
  }
  
  public void setWorldW(float worldW){
    this.worldW = worldW;
  }
  
  public ArrayList<Box> getBoxes(){
    return boxes;
  }
  
  public void setBoxes(ArrayList<Box> boxes){
    this.boxes = boxes;
  }
  
  public Box getBoxAt(int i){
   Box box = null;
     if(i < boxes.size())
       box = boxes.get(i);
   return box;
  }
  
  public void removeBoxAt(int i){
     if(getBoxAt(i) != null){
       boxes.get(i).killBody();
       boxes.remove(i);
     }
  }
  
  public void removeBox(Box box){
     int i = 0;
     
     while(i < boxes.size() && !getBoxAt(i).equals(box))
       i++;
     
     if(i < boxes.size())
       removeBoxAt(i);
  }
  
  public boolean BoxExist(Box box){
    int i;
      for(i = 0; i < boxes.size() && !box.equals(boxes.get(i)); i++);
    return i < boxes.size();
  }
  
  public void addBox(Box box){
    if(!BoxExist(box)){
       boxes.add(box);
    }
  }
  
  public int IsWall(float mX, float mY){
   int index = -1;
   for(int i = 0; i < boxes.size() && index == -1; i++)
     if(boxes.get(i).coordinatesInPerimeter(mX,mY))
       index = i;
   return index;
  }
  
  public boolean IsTarget(float mX, float mY){
    if(target == null)
      return false;
    else
     return target.coordinatesInPerimeter(mX,mY);
  }
  
  // Drawing the grid
  public void display(float shiftX, float shiftY){
    float size = SimulationUtility.WORLD_SIZE;
    float shiftx = SimulationUtility.WORLD_SHIFTX+7;
    float shifty = SimulationUtility.WORLD_SHIFTY+7;
    
    strokeWeight(2);
    rect(shiftX, shiftY, worldW, worldH);
    
    for(Box box : boxes){
      box.display();
    }
    
    if(target != null)
      target.display();
    
    stroke(255);
    line(0, size+shifty, size+shiftx, size+shifty);
    line(size+shiftx, size+shifty, size+shiftx, 0);
  } 
}

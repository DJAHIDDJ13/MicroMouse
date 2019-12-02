class World{
  float worldH;
  float worldW;
  ArrayList<Object> objects;
  
  World(float worldH, float worldW){
    this.worldH = worldH;
    this.worldW = worldW;
    objects = new ArrayList<Object>();
  }
  
  float getWorldH(){
    return worldH;
  }
  
  void setWorldH(float worldH){
    this.worldH = worldH;
  }
  
  float getWorldW(){
    return worldW;
  }
  
  void setWorldW(float worldW){
    this.worldW = worldW;
  }
  
  ArrayList<Object> getObjects(){
    return objects;
  }
  
  void setObjects(ArrayList<Object> objects){
    this.objects = objects;
  }
  
  Object getObjectAt(int i){
   Object object = null;
     if(i < objects.size())
       object = objects.get(i);
   return object;
  }
  
  void removeObjectAt(int i){
     if(getObjectAt(i) != null)
       objects.remove(i);
  }
  
  void removeObject(Object object){
     int i = 0;
     
     while(i < objects.size() && !getObjectAt(i).equals(object))
       i++;
     
     if(i < objects.size())
       removeObjectAt(i);
  }
  
  void addObject(Object object){
     if(!objects.contains(object))
       objects.add(object);
  }
  
  // Drawing the grid
  void display(){
    strokeWeight(2);
    rect(5, 5, worldW, worldH);
  }
}

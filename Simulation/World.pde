public class World{
  float worldH,worldW;
  ArrayList<Object> objects;
  
  public World(float worldH, float worldW){
    this.worldH = worldH;
    this.worldW = worldW;
    objects = new ArrayList<Object>();
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
  
  public ArrayList<Object> getObjects(){
    return objects;
  }
  
  public void setObjects(ArrayList<Object> objects){
    this.objects = objects;
  }
  
  public Object getObjectAt(int i){
   Object object = null;
     if(i < objects.size())
       object = objects.get(i);
   return object;
  }
  
  public void removeObjectAt(int i){
     if(getObjectAt(i) != null)
       objects.remove(i);
  }
  
  public void removeObject(Object object){
     int i = 0;
     
     while(i < objects.size() && !getObjectAt(i).equals(object))
       i++;
     
     if(i < objects.size())
       removeObjectAt(i);
  }
  
  public boolean ObjectExist(Object object){
    int i;
      for(i = 0; i < objects.size() && !object.equals(objects.get(i)); i++);
    return i < objects.size();
  }
  
  public void addObject(Object object){
    if(!ObjectExist(object)){
       objects.add(object);
    }
  }
  
  public int IsWall(float mX, float mY){
   int index = -1;
   for(int i = 0; i < objects.size() && index == -1; i++)
     if(objects.get(i).coordinatesInPerimeter(mX,mY))
       index = i;
   return index;
  }
  
  // Drawing the grid
  public void display(float shiftX, float shiftY){
    float dh,dw;
    float dx,dy;
    float alpha;
    float worldS = 1;
    strokeWeight(2);
    rect(shiftX, shiftY, worldW, worldH);
    
    Object obj;
    for(int i = 0; i < objects.size(); i++){
      obj = objects.get(i);
      dw=obj.getW()/(worldS*2);
      dh=obj.getH()/(worldS*2);      
      if(obj.isWall())
        fill(127,0,0);
        dx = obj.getX()+obj.getW()/2;
        dy = obj.getY()+obj.getH()/2;
        alpha = obj.getAlpha();
        beginShape();
          vertex(dx+(int)floor(0.5+dw*cos(alpha))-(int)floor(0.5+dh*sin(alpha)),
                dy+(int)floor(0.5+dh*cos(alpha))+(int)floor(0.5+dw*sin(alpha)));
          vertex(dx-(int)floor(0.5+dw*cos(alpha))-(int)floor(0.5+dh*sin(alpha)),
                dy+(int)floor(0.5+dh*cos(alpha))-(int)floor(0.5+dw*sin(alpha)));
          vertex(dx-(int)floor(0.5+dw*cos(alpha))+(int)floor(0.5+dh*sin(alpha)),
                dy-(int)floor(0.5+dh*cos(alpha))-(int)floor(0.5+dw*sin(alpha)));
          vertex(dx+(int)floor(0.5+dw*cos(alpha))+(int)floor(0.5+dh*sin(alpha)),
                dy-(int)floor(0.5+dh*cos(alpha))+(int)floor(0.5+dw*sin(alpha)));
          vertex(dx+(int)floor(0.5+dw*cos(alpha))-(int)floor(0.5+dh*sin(alpha)),
                dy+(int)floor(0.5+dh*cos(alpha))+ (int)floor(0.5+dw*sin(alpha)));
        endShape();
      fill(255);
    }
    
    stroke(255);
    line(0, 812, 812, 812);
    line(812, 812, 812, 0);
  } 
}

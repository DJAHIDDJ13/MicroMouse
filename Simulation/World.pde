class World{
  float worldH;
  float worldW;
  
  World(float worldH, float worldW){
    this.worldH = worldH;
    this.worldW = worldW;
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
  
  // Drawing the grid
  void display(){
    strokeWeight(2);
    rect(5, 5, worldW, worldH);
  }
}

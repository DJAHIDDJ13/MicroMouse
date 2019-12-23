public class Wall extends Object{
 
  // Constructor
  public Wall(float x, float y, float h, float w, float alpha){
    super(x,y,h,w,alpha);
  }
  
  public boolean isWall(){
    return true;
  }
  
  public void display(){
    float dh,dw;
    float dx,dy;
    float alpha;
    float worldS = 1;   
    
    dw=getW()/(worldS*2);
    dh=getH()/(worldS*2);      
    
    pushMatrix();
    fill(127,0,0);
    dx = getX()+getW()/2;
    dy = getY()+getH()/2;
    alpha = getAlpha();
    
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
   popMatrix();
  }
}

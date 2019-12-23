import controlP5.*;

public class SimulationControler{

  private ControlP5 cp5;
  
  public SimulationControler(){  
    
  }
  
 public void setControler(ControlP5 cp5){
   this.cp5 = cp5;
 }
 
 public ControlP5 getControler(){
   return this.cp5;
 }
  
 public void createControlers(){
    cp5.addButton("Turn+")
       .setValue(1)
       .setPosition(90,830)
       .setSize(40,30)
       ;
    
    cp5.addButton("Turn-")
       .setValue(2)
       .setPosition(90,870)
       .setSize(40,30)
       ;
       
    cp5.addButton("Add")
       .setValue(3)
       .setPosition(140,855)
       .setSize(40,30)
       ;
    
    cp5.addButton("Remove")
       .setValue(4)
       .setPosition(190,855)
       .setSize(40,30)
       ;
  
    cp5.addButton("Refresh")
       .setValue(5)
       .setPosition(772,855)
       .setSize(40,30)
       ;
    
    cp5.addNumberbox("Size")
       .setPosition(240,855)
       .setSize(40,30)
       .setScrollSensitivity(1.1)
       .setDirection(Controller.HORIZONTAL)
       .setValue(16)
       .setRange(8, 32)
       ;
  } 
}

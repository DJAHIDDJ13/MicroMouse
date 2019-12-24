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
    cp5.addButton("+")
       .setValue(1)
       .setPosition(80,840)
       .setSize(20,20)
       ;
    
    cp5.addButton("-")
       .setValue(2)
       .setPosition(80,870)
       .setSize(20,20)
       ;
       
   cp5.addButton("Turn+")
       .setValue(1)
       .setPosition(110,830)
       .setSize(40,30)
       ;
    
    cp5.addButton("Turn-")
       .setValue(2)
       .setPosition(110,870)
       .setSize(40,30)
       ;
       
    cp5.addButton("Add")
       .setValue(3)
       .setPosition(160,855)
       .setSize(40,30)
       ;
    
    cp5.addButton("Remove")
       .setValue(4)
       .setPosition(210,855)
       .setSize(40,30)
       ;
  
    cp5.addButton("Refresh")
       .setValue(5)
       .setPosition(772,855)
       .setSize(40,30)
       ;
    
    cp5.addNumberbox("Size")
       .setPosition(260,855)
       .setSize(40,30)
       .setScrollSensitivity(1.1)
       .setDirection(Controller.HORIZONTAL)
       .setValue(16)
       .setRange(8, 32)
       ;
  } 
}

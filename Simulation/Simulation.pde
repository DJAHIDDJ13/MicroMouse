
void setup(){
  size(200, 200);
}

void draw(){
  fill(0, 255, 0);
  ellipse(100, 100, 150, 150);
  
  fill(255);
  ellipse(75, 85, 30, 20);
  ellipse(125, 85, 30, 20);

  fill(0);
  ellipse(75, 85, 10, 10);
  ellipse(125, 85, 10, 10);

  fill(255, 0, 0);
  arc(100, 125, 80, 50, 0, 3.14);
  line(60, 125, 140, 125);
}

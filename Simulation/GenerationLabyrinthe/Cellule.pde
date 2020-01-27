class Cellule
{
  // Position de la cellule identifiée par x et y
  int x,y;
  
  // Cellule visitée ou pas
  boolean visited;
  
  //Object characteristics
  static final int w = MazeGenerator.w;
  
  // Murs de la cellule
  public boolean haut,bas,droite,gauche;
          
  //Constructeur
  Cellule(int x, int y)
  {
    this.x=x*w;
    this.y=y*w;
    this.haut = true;
    this.bas = true;
    this.gauche = true;
    this.droite = true;
    this.visited = false;
  }
  
  // Affichage de la cellule
  public void affichageCellule()
  {  
    if(visited)
    {
      fill(#2E8B57);
      noStroke();
      rect(x,y,w,w);
      noFill();
    }
    
    strokeWeight(3);
    stroke(1);
    if(haut)
      line(x,  y,  x+w,  y);
    if(bas)
      line(x,  y+w,  x+w,  y+w);
    if(droite)
      line(x+w,  y,  x+w,  y+w);
    if(gauche)
      line(x,  y,  x,  y+w);
  }
  
}

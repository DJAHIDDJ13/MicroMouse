class Cellule
{
  // Position de la cellule identifiée par x et y
  int x,y;
  
  // Cellule visitée ou pas
  boolean visited;
  
  // Taille de la cellule
  static final int taille = 30;
  
  // Murs de la cellule
  public boolean haut,bas,droite,gauche;
          
  //Constructeur
  Cellule(int x, int y)
  {
    this.x=x*taille;
    this.y=y*taille;
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
      rect(x,y,taille,taille);
      noFill();
    }
    
    strokeWeight(3);
    stroke(1);
    if(haut)
      line(x,  y,  x+taille,  y);
    if(bas)
      line(x,  y+taille,  x+taille,  y+taille);
    if(droite)
      line(x+taille,  y,  x+taille,  y+taille);
    if(gauche)
      line(x,  y,  x,  y+taille);
  }
  
}

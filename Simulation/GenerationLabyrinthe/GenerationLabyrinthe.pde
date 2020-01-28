import java.util.Stack;
static final int hauteur = 10;        // nombre de lignes
static final int largeur = 10;        // nombre de colonnes


Stack stack = new Stack();
static Cellule mat[][];
Cellule current;
int debug =0;

void setup()

{

  size(800,800);
  background(255);

 
  mat = new Cellule[largeur][hauteur];
 
 
  // On initialise notre matrice
  for(int i=0;i<largeur;i++)
    for(int j=0;j<hauteur;j++)
      mat[i][j] = new Cellule(i,j);
  
    current = mat[0][0];
}

void draw()

{
  //frameRate(15);
  affichageLabyrinthe();
  fill(0,255,0,100);
  rect(current.x,current.y,current.taille,current.taille);
  noFill();
  
  //La cellule corrante et marquée comme visitée
  current.visited = true;
  
  // election d'une cellule voisine nos visitée de façon aléatoir
  Cellule next = randomVoisin(current);
  
  if(next==null && stack.empty()){
    return;
  }
  else if(next==null){
    current = (Cellule)stack.pop();
  }
  else{
    stack.push(current);
    // supprimmer mur
    removeWall(current,next);
    current = next;
  }
}

void affichageLabyrinthe()
{
  background(255);
  for(int i=0;i<mat.length;i++)
    for(int j=0;j<mat[0].length;j++)
      mat[i][j].affichageCellule();
}

// supprimer mur
void removeWall(Cellule current, Cellule next)
{
  int app = current.x-next.x;
  if(app>0)
    {current.gauche=false; next.droite=false;}
  else if(app<0)
    {current.droite=false; next.gauche=false;}
  
  app = current.y-next.y;
  if(app>0)
    {current.haut=false; next.bas=false;}
  if(app<0)
    {current.bas=false; next.haut=false;}
}

// Retourne une cellule voisine aléatoire qui n'a pas encore été visitée
// On stack toutes les cellules vosines non visitées
// On retourne une d'entre elle de manière aléatoire
  public Cellule randomVoisin(Cellule current)
  {
    int i=current.x/current.taille, 
        j=current.y/current.taille;
    Stack neighbours = new Stack();
    
    // Cellule de haut existe et non visitée
    if(j-1>=0 && !mat[i][j-1].visited) neighbours.push(mat[i][j-1]);
    
    // Cellule de bas existe et non visitée
    if(j+1<hauteur && !mat[i][j+1].visited) neighbours.push(mat[i][j+1]);
    
    // Cellule de gauche existe et non visitée
    if(i-1>=0 && !mat[i-1][j].visited) neighbours.push(mat[i-1][j]);
    
    // Cellule de droite existe et non visitée
    if(i+1<largeur && !mat[i+1][j].visited) neighbours.push(mat[i+1][j]);
   
    
    if(!neighbours.empty())
      return (Cellule)neighbours.elementAt((int)random(neighbours.size()));
    else
      return null;
  }
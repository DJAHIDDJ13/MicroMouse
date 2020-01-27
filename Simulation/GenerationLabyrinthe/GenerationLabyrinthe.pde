import java.util.Stack;
static final int w = 30;   // taille de chaque cellule
static final int hauteur = 10;        // nombre de lignes
static final int largeur = 10;        // nombre de colonnes


//Declaration of stack and maze matrix
Stack stack = new Stack();
static Cellule mat[][];
Cellule current;
int debug =0;

void setup()

{
  //Change dimensions to make screen bigger or smaller
  size(400,400);
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
  //saveFrame("output/frame######.png");
  //frameRate(15);
  affichageLabyrinthe();
  
  //Fill rectangle of current Cellule
  fill(0,255,0,100);
  rect(current.x,current.y,w,w);
  noFill();
  
  //Mark current as visited
  current.visited = true;
  
  //Pick randomly the next cell
  //Cellule next = current.pickNeighbour();
  Cellule next = randomVoisin(current);
  
  if(next==null && stack.empty()){
    return;
  }
  else if(next==null){
    current = (Cellule)stack.pop();
  }
  else{
    stack.push(current);
    //Remove Wall between current and next cell
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

//Remove wall between two cells
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

 //Randomly choose a neighbour cell among the accesible ones
  public Cellule randomVoisin(Cellule current)
  {
    int i=current.x/w, 
        j=current.y/w;
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

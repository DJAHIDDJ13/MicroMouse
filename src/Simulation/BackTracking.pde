public class BackTracking {
  
  // Maze and Cells constants
  public static final float mazeWidth  = 800.0;
  public static final float mazeHeight = 800.0;;
  public static final float wallWidth  = 50;
  public static final float wallHeight = 10;
 
  public Cell mat[][];
  
  // Constructor and generation of the initial maze
  public BackTracking()
  { 
    int lignes = (int)(mazeHeight/wallWidth);
    int colonnes = (int)(mazeWidth/wallWidth);
    
    this.mat = new Cell[lignes][colonnes];
    /*System.out.println("mazeH  "+mazeHeight);
    System.out.println("mazeW  "+mazeWidth);
    System.out.println("wallH  "+wallHeight);
    System.out.println("wallW  "+wallWidth);
    System.out.println("ligne  "+lignes);
    System.out.println("colonnes  "+colonnes);*/
    
   for(int x = 0; x < lignes; x++)
   {   
    for(int y = 0; y < colonnes; y++) 
    {
      // Cell upper left : 4 walls
      if(x == 0 && y == 0) {
        this.mat[x][y] = new Cell(x,y,true,true,true,true); }
      
      // Cell of the first line : No left walls 
      else if(x==0 && y>=1) {
        this.mat[x][y] =new Cell(x,y,true,true,true,false); }
      
      // Cell of the first column : No top wall 
      else if(x>=1 && y==0) {
      this.mat[x][y] = new Cell(x,y,false,true,true,true); }
      
      // Else no top and no left wall
      else {
       this.mat[x][y] = new Cell(x,y,false,true,true,false);}
    }
   }
   
   // Entrance and exit of the maze 
   this.mat[0][0].haut = false;
   this.mat[lignes-1][colonnes-1].bas = false;
  }
  
  // Display maze : We loop over the cells inside the mat and we show them 
  public void display()
  {
    int lignes = (int)(this.mazeHeight/this.wallWidth);
    int colonnes = (int)(this.mazeWidth/this.wallWidth);
    
  for(int x = 0; x < lignes; x++)  
   {   
    for(int y = 0; y < colonnes; y++)
    {
      this.mat[x][y].display();
    }
   }
  }
  
  public void randomChange()
  {
    Random r = new Random();
    int i = r.nextInt((9 - 0) + 1) + 0;
    int j = r.nextInt((9- 0) + 1) + 0;
    this.mat[i][j].setCellWalls(false,false,false,false);
  }
  
  // Retourne une cellule voisine aléatoire qui n'a pas encore été visitée
  // On stack toutes les cellules vosines non visitées
  // On retourne l'une d'entre elle de manière aléatoire
  public Cell randomVoisin(Cell current)
  {
    int i=current.jCell/(int)this.wallWidth, j=current.iCell/(int)this.wallWidth;
    //System.out.println("i is :"+i+" and j is : "+j);
    Stack neighbours = new Stack();
    Cell next;
    
    // Top Cell exist and not visited 
    if(i-1>=0 && !this.mat[i-1][j].visited) { 
      neighbours.push(mat[i-1][j]); }

    // Bottom Cell exist and not visited
    if(i+1<(int)(this.mazeHeight/this.wallWidth) && !mat[i+1][j].visited) { 
      neighbours.push(mat[i+1][j]); }
    
    // Left Cell exist and not visited
    if(j-1>=0 && !mat[i][j-1].visited) { 
      neighbours.push(mat[i][j-1]); }
    
    // Right Cell exist and not visited
    if(j+1<(int)(this.mazeWidth/this.wallWidth) && !mat[i][j+1].visited) { 
      neighbours.push(mat[i][j+1]); }
   
    
    if(!neighbours.empty()) {
      next = (Cell) neighbours.elementAt((int)random(neighbours.size()));
      System.out.println("ligne : "+next.jCell/(int)this.wallWidth+"    colonne is : "+next.iCell/(int)this.wallWidth);
      return next; }
    else {
      return null; }
  }
  
  
// Delete a wall between two cells 
public void removeWall(Cell current, Cell next)
{
  int currentI = current.jCell/(int)this.wallWidth; 
  int currentJ = current.iCell/(int)this.wallWidth;
  int nextI=next.jCell/(int)this.wallWidth;
  int nextJ=next.iCell/(int)this.wallWidth;
  
  System.out.println("Current i : "+currentI+","+"Current j : "+currentJ);
  System.out.println("Next i : "+nextI+","+"Next j : "+nextJ);
  
  
  int decal = currentI - nextI;
  
  // We go top 
  if(decal>0) {
  current.haut=false; next.bas=false; }
 
  // We go down
  else if(decal<0)
    {current.bas=false; next.haut=false;}
  
  decal = currentJ - nextJ;
  
  // We go left
  if(decal>0)
    {current.gauche=false; next.droite=false;}
  
  // We go right
  if(decal<0)
    {current.droite=false; next.gauche=false;
  }
}
  
  
}

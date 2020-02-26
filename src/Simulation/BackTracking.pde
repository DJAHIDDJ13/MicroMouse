public class BackTracking {
  
  // Maze and Cells constants
  public static final float mazeWidth  = 800.0;
  public static final float mazeHeight = 800.0;;
  public static final float wallWidth  = 50;
  public static final float wallHeight = 10;
  public Cell mat[][];
  
  
  // Constructor and generation maze
  public BackTracking()
  { 
    int lignes = (int)(mazeHeight/wallWidth);
    int colonnes = (int)(mazeWidth/wallWidth);
    this.mat = new Cell[lignes][colonnes];
  
  // First we generate a simple grill of cell 
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
   
   // Center of the maze
   // Empty rect in the middle of the maze which represent the Micromouse's target
   this.mat[7][7].visited = true;
   this.mat[7][8].visited = true;
   this.mat[8][7].visited = true;
   this.mat[8][8].visited = true;
   this.mat[7][7].droite = false;
   this.mat[7][7].bas = false;
   this.mat[7][8].bas = false;
   this.mat[8][7].droite = false;
   this.mat[8][8].bas = false;
   
   // Now we apply the BackTracking algorithm to get a random maze
   Cell next, current;
   Stack stack = new Stack();
   
   current= this.mat[0][0];
   
   while(allVisited(this.mat) == false)
   {
     // Current Cell marked as visited
     current.visited = true;
     
     // Election d'un voisin aleatoir de current
     next = randomVoisin(current);
     
    if(next==null && stack.empty()) {
       return; }
       
    else if(next==null) {
    current = (Cell)stack.pop(); }
    
    else{
    stack.push(current);
    // supprimmer mur
    removeWall(current,next);
    current = next; }
   }
 }
   
  
 
  // We loop over the cells insi mat and we show them 
  public void display()
  {
    int lignes = (int)(mazeHeight/wallWidth);
    int colonnes = (int)(mazeWidth/wallWidth);
    
  for(int x = 0; x < lignes; x++)   {   
    for(int y = 0; y < colonnes; y++) {
      this.mat[x][y].display();
    }
   }
   
  }
  
 
  // Retourne une cellule voisine aléatoire qui n'a pas encore été visitée
  // On stack toutes les cellules vosines non visitées
  // On retourne l'une d'entre elle de manière aléatoire
  public Cell randomVoisin(Cell current)
  {
    int i=current.jCell/(int)wallWidth, j=current.iCell/(int)wallWidth;
    //System.out.println("i is :"+i+" and j is : "+j);
    Stack neighbours = new Stack();
    Cell next;
    
    // Top Cell exist and not visited 
    if(i-1>=0 && !this.mat[i-1][j].visited) { 
      neighbours.push(mat[i-1][j]); }

    // Bottom Cell exist and not visited
    if(i+1<(int)(mazeHeight/wallWidth) && !mat[i+1][j].visited) { 
      neighbours.push(mat[i+1][j]); }
    
    // Left Cell exist and not visited
    if(j-1>=0 && !mat[i][j-1].visited) { 
      neighbours.push(mat[i][j-1]); }
    
    // Right Cell exist and not visited
    if(j+1<(int)(mazeWidth/wallWidth) && !mat[i][j+1].visited) { 
      neighbours.push(mat[i][j+1]); }
   
    
    if(!neighbours.empty()) {
      next = (Cell) neighbours.elementAt((int)random(neighbours.size()));
     //System.out.println("ligne : "+next.jCell/(int)wallWidth+"    colonne is : "+next.iCell/(int)wallWidth);
      return next; }
    else {
      return null; }
  }
  
  
// Delete a wall between two cells 
public void removeWall(Cell current, Cell next)
{
  int currentI = current.jCell/( int )wallWidth; 
  int currentJ = current.iCell/( int )wallWidth;
  int nextI=next.jCell/( int )wallWidth;
  int nextJ=next.iCell/( int )wallWidth;
  int decal = currentI - nextI;
  
  //System.out.println("Current i : "+currentI+","+"Current j : "+currentJ);
  //System.out.println("Next i : "+nextI+","+"Next j : "+nextJ);
  
  // We go top 
  if(decal>0) {
   current.haut=false; next.bas=false; }
  // We go down
  else if(decal<0) {
   current.bas=false; next.haut=false; }
    
   decal = currentJ - nextJ;
  // We go left
  if(decal>0) {
   current.gauche=false; next.droite=false;}
  // We go right
  if(decal<0) {
   current.droite=false; next.gauche=false; }
}

// Check if all the cell of the maze have been visited
public boolean allVisited(Cell matrix[][]) {
  
 int lignes = (int)(mazeHeight/wallWidth);
 int colonnes = (int)(mazeWidth/wallWidth);
    
  for(int x = 0; x < lignes; x++)
  {   
    for(int y = 0; y < colonnes; y++) 
    {
       if( matrix[x][y].visited == false) {
         return false; }
    }
  }
return true;
}
  


}

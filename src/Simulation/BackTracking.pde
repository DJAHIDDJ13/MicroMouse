public class BackTracking {

  public float mazeWidth;
  public float mazeHeight;
  public float wallWidth;
  public float wallHeight;
  
  public Cell mat[][];
  
  // Constructor and initial generation of our Maze
  public BackTracking(float mazeWidth, float mazeHeight, float wallWidth, float wallHeight)
  {

    this.mazeWidth = mazeWidth;
    this.mazeHeight = mazeHeight;
    this.wallWidth = wallWidth;
    this.wallHeight = wallHeight;
    
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
    int min = 0;
    int max = 10;
    Random r = new Random();
    int i = r.nextInt((9 - 0) + 1) + 0;
    int j = r.nextInt((9- 0) + 1) + 0;
    this.mat[i][j].setCellWalls(false,false,false,false);
    
  }
  
  // Retourne une cellule voisine aléatoire qui n'a pas encore été visitée
  // On stack toutes les cellules vosines non visitées
  // On retourne une d'entre elle de manière aléatoire
  public Cell randomVoisin(Cell current)
  {
    int i=current.yCell/(int)this.wallWidth, j=current.xCell/(int)this.wallWidth;
    //System.out.println("i is :"+i+" and j is : "+j);
    Stack neighbours = new Stack();
    Cell next;
    
    
    // Cellule de haut existe et non visitée
    if(i-1>=0 && !this.mat[i-1][j].visited) { 
      neighbours.push(mat[i-1][j]); }

    // Cellule de bas existe et non visitée
    if(i+1<(int)(this.mazeHeight/this.wallWidth) && !mat[i+1][j].visited) { 
      neighbours.push(mat[i+1][j]); }
    
    // Cellule de gauche existe et non visitée
    if(j-1>=0 && !mat[i][j-1].visited) { 
      neighbours.push(mat[i][j-1]); }
    
    // Cellule de droite existe et non visitée
    if(j+1<(int)(this.mazeWidth/this.wallWidth) && !mat[i][j+1].visited) { 
      neighbours.push(mat[i][j+1]); }
   
    
    if(!neighbours.empty()) {
      next = (Cell) neighbours.elementAt((int)random(neighbours.size()));
      System.out.println("ligne : "+next.yCell/(int)this.wallWidth+"    colonne is : "+next.xCell/(int)this.wallWidth);
      return next; }
    else {
      return null; }
  }
  
  
}

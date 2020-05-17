public class MazeCell {
  
  int x, y;
  
  // Constructor
  public MazeCell(int x, int y) {   
    this.x = x;
    this.y = y;
  }
  
  public WallOrientation relativeOrientation(MazeCell other) {
    if(x == other.x && y == other.y - 1) {
      return WallOrientation.TOP_WALL;
    }

    if(x == other.x && y == other.y + 1) {
      return WallOrientation.BOTTOM_WALL;
    }

    if(x == other.x - 1 && y == other.y) {
      return WallOrientation.LEFT_WALL;
    }

    if(x == other.x + 1 && y == other.y) {
      return WallOrientation.RIGHT_WALL;
    }
    return null;
  }
  
  public float distanceCells(int x2, int y2)
  {
   return sqrt( pow(this.x - x2,2) + pow(this.y - y2,2) );
  }
  
  public boolean equals(MazeCell other)
  {
    if (this.x == other.x && this.y==other.y) {
      return true; }
      else {
        return false;
      }
  }
}

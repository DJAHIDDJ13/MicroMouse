public enum WallOrientation {
  
  TOP_WALL(0), BOTTOM_WALL(1), RIGHT_WALL(2), LEFT_WALL(3);
  
  private final int value;
  private WallOrientation(int value) {
    this.value = value;
  }

  public int getValue() {
    return value;
  }
  
  public static WallOrientation wallOf(int i) {
    switch(i) {
      case 0: return TOP_WALL;
      case 1: return BOTTOM_WALL;
      case 2: return RIGHT_WALL;
      case 3: return LEFT_WALL;
    }
    return null;
  }
}

public class EdgeShapesCallback implements RayCastCallback {
  
  private Fixture m_fixture;
  private Vec2 m_point;
  private Vec2 m_normal;
  
  public EdgeShapesCallback() {
    m_fixture = null;
    m_point = new Vec2();
    m_normal = new Vec2();
  }
  
  public float reportFixture(Fixture fixture, final Vec2 point, final Vec2 normal, float fraction) {
    Body body = fixture.getBody();
    Object userData = body.getUserData();
    
    // ignore the vehicle's body and wheels
    if(userData != null && (userData instanceof Integer) && userData.equals(1)) {
      return -1;
    }
    m_fixture = fixture;
    m_point = point;
    m_normal = normal;
    return fraction;
  }
  
  public Vec2 getM_point() {
    // for some reason the object returned by the report fixture method is the same, 
    // this caused some problems between the sensors, where they had the same value because it's the same object
    // TODO: find a cleaner way to fix this idk
    return new Vec2(m_point.x, m_point.y);
  }
  
  public void setM_point(Vec2 m_point) {
    this.m_point = m_point;
  }
  
  public Vec2 getM_normal() {
    return m_normal;
  }
  
  public void setM_normal(Vec2 m_normal) {
    this.m_normal = m_normal;
  }
  
  public Fixture getM_fixture() {
    return m_fixture;
  }
  
  public void setM_fixture(Fixture m_fixture) {
    this.m_fixture = m_fixture;
  } 
}

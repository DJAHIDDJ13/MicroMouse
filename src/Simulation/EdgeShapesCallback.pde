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
    return m_point;
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

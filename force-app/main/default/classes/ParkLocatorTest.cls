@isTest
private class ParkLocatorTest {
  @IsTest
  static void testCallOut() {
    Test.setMock(WebServiceMock.class, new ParkServiceMock());
    String country = 'USA';
    System.assertEquals(new List<String>{ 'Me', 'You', 'Him' }, ParkLocator.country(country));
  }
}

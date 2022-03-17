@isTest
public with sharing class AnimalLocatorTest {
  public AnimalLocatorTest() {
  }

  @isTest
  static void AnimalLocatorMock1() {
    Test.setMock(HttpCalloutMock.class, new AnimalLocatorMock());
    string result = AnimalLocator.getAnimalNameById(1);
    String expectedResult = 'chicken';
    System.assertEquals(result, expectedResult);
  }
}
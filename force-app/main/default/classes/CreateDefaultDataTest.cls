@isTest
private class CreateDefaultDataTest {
  @isTest
  static void createData_test() {
    Test.startTest();
    CreateDefaultData.CreateData();
    List<Vehicle__c> vehicles = [SELECT Id FROM Vehicle__c];
    List<Product2> equipment = [SELECT Id FROM Product2];
    List<Case> maintenanceRequest = [SELECT Id FROM Case];
    List<Equipment_Maintenance_Item__c> joinRecords = [SELECT Id FROM Equipment_Maintenance_Item__c];

    System.assertEquals(3, vehicles.size(), '3 vehicles created');
    System.assertEquals(3, equipment.size(), '3 equipment created');
    System.assertEquals(300, maintenanceRequest.size(), '2 maintenance request created');
    System.assertEquals(900, joinRecords.size(), '6 equipment maintenance items created');
  }

  @isTest
  static void updateCustomSetting_test() {
    How_We_Roll_Settings__c customSetting = How_We_Roll_Settings__c.getOrgDefaults();
    customSetting.Is_Data_Created__c = false;
    upsert customSetting;

    customSetting.Is_Data_Created__c = true;
    upsert customSetting;

    System.assertEquals(true, CreateDefaultData.dataCreated(), 'The custom setting  should be true');
  }
}

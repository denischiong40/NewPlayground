@isTest
private with sharing class MaintenanceRequestHelperTest {
  @testSetup
  static void setup() {
    // Create common test data
    CreateDefaultData.CreateData();
  }

  @isTest
  static void test1() {
    Case[] caseList10 = [SELECT Id, Type, Status FROM Case LIMIT 10];

    for (Case cs : caseList10) {
      cs.Status = 'Closed';
      cs.Type = 'Repair';
    }

    Test.startTest();
    Database.SaveResult[] result = Database.update(caseList10, false);
    Test.stopTest();

    for (Database.SaveResult db : result) {
      system.assert(db.isSuccess());
    }

    Case[] allCases = [SELECT id FROM case];
    system.assertEquals(310, allCases.size(), 'Not all the cases have been inserted');
  }

  @isTest
  static void test2() {
    Case[] caseList10 = [SELECT Id, Type, Status FROM Case LIMIT 10];
    for (Case cs : caseList10) {
      cs.Status = 'Closed';
      cs.Type = 'Electrical';
    }

    Test.startTest();
    Database.SaveResult[] result = Database.update(caseList10, false);
    Test.stopTest();

    Case[] allCases = [SELECT id FROM case];
    system.assertEquals(300, allCases.size());
  }

  @isTest
  static void test3() {
    Map<String, Case> caseList300 = new Map<String, Case>(
      [
        SELECT
          Id,
          Type,
          Status,
          Vehicle__r.id,
          (SELECT Quantity__c, Equipment__c, Equipment__r.Maintenance_Cycle__c FROM Equipment_Maintenance_Items__r)
        FROM Case
        LIMIT 300
      ]
    );

    for (Case cs : caseList300.values()) {
      cs.Status = 'Closed';
      cs.Type = 'Repair';
    }

    SObject[] soCaseList300 = (List<Case>) caseList300.values();
    Test.startTest();
    Database.SaveResult[] result = Database.update(soCaseList300, false);
    Test.stopTest();

    Map<String, Case> totalCreatedCases = new Map<String, Case>(
      [
        SELECT Id, Status, Vehicle__c, (SELECT Equipment__c FROM Equipment_Maintenance_Items__r)
        FROM Case
        WHERE Status != 'Closed'
      ]
    );
    for (Case cs : totalCreatedCases.values()) {
      system.assertEquals(true, cs.Equipment_Maintenance_Items__r.size() > 0);
      system.assertEquals(true, cs.isSet('Vehicle__c'));

      for (Equipment_Maintenance_Item__c eq : Cs.Equipment_Maintenance_Items__r) {
        system.assertEquals(true, eq.isSet('Equipment__c'));
      }
    }

    system.assertEquals(300, totalCreatedCases.size());
  }
}

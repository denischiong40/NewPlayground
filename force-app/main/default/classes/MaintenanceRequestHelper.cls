public with sharing class MaintenanceRequestHelper {
  public static void createNewRequest() {
    List<case> newCasesList = new List<case>();
    Integer avgAmountInt = 10000;

    List<Equipment_Maintenance_Item__c> newEMI = new List<Equipment_Maintenance_Item__c>();

    List<case> listCase = [
      SELECT id, Subject, Vehicle__c, ProductID, Product__c, (SELECT id FROM Equipment_Maintenance_Items__r)
      FROM case
      WHERE status = 'Closed' AND Type IN ('Repair', 'Routine Maintenance') AND ID IN :Trigger.new
    ];

    Map<id, Equipment_Maintenance_Item__c> equip = new Map<id, Equipment_Maintenance_Item__c>(
      [
        SELECT ID, Quantity__c, Equipment__c, Equipment__r.id, Equipment__r.Maintenance_Cycle__c
        FROM Equipment_Maintenance_Item__c
      ]
    );
    //Loop over cases
    for (case c : listCase) {
      case newItemCase = new Case();
      newItemCase.Type = 'Routine Maintenance';
      newItemCase.Vehicle__c = c.Vehicle__c;
      newItemCase.Subject = String.isBlank(c.Subject) ? 'Routine Maintenance Request' : c.Subject;
      newItemCase.Date_Reported__c = Date.today();
      newItemCase.ProductId = c.ProductId;
      newItemCase.Product__c = c.Product__c;
      newItemCase.parentID = c.Id;
      newItemCase.Status = 'New';

      for (Equipment_Maintenance_Item__c equipMan : c.Equipment_Maintenance_Items__r) {
        avgAmountInt = Math.min(
          avgAmountInt,
          Integer.valueOf(equip.get(equipMan.id).Equipment__r.Maintenance_Cycle__c)
        );
        newEMI.add(
          new Equipment_Maintenance_Item__c(
            Equipment__c = equip.get(equipMan.id).Equipment__c,
            Maintenance_Request__c = c.id,
            Quantity__c = equip.get(equipMan.id).Quantity__c
          )
        );
      }
      Date dueDate = Date.TODAY().adddays(avgAmountInt);
      newItemCase.Date_Due__c = dueDate;
      newCasesList.add(newItemCase);
    }
    if (newCasesList.size() > 0) {
      Database.insert(newCasesList, false);
    }

    for (Case c2 : newCasesList) {
      for (Equipment_Maintenance_Item__c emi2 : newEmi) {
        if (c2.parentID == emi2.Maintenance_Request__c) {
          emi2.Maintenance_Request__c = c2.id;
        }
      }
    }

    if (newEmi.size() > 0) {
      Database.insert(newEmi, false);
    }
  }
}

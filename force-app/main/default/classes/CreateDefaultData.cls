public with sharing class CreateDefaultData {
  static final String TYPE_ROUTINE_MAINTENANCE = 'Routine Maintenance';
  @AuraEnabled
  public static Boolean dataCreated() {
    How_We_Roll_Settings__c customSetting = How_We_Roll_Settings__c.getOrgDefaults();
    return true;
  }

  public static void CreateData() {
    List<Vehicle__c> vehicles = createVH();
    List<Product2> equipment = createEquip();
    List<Case> maintenanceRequest = maintenanceRequest(vehicles);
    List<Equipment_Maintenance_Item__c> joinRecords = createJoinRecords(equipment, maintenanceRequest);

    uptCustomSetting(true);
  }

  public static void uptCustomSetting(Boolean dataCreated) {
    How_We_Roll_Settings__c customSetting = How_We_Roll_Settings__c.getOrgDefaults();
    customSetting.Is_Data_Created__c = dataCreated;
    upsert customSetting;
  }

  public static List<Vehicle__c> createVH() {
    List<Vehicle__c> vehicles = new List<Vehicle__c>();
    vehicles.add(
      new Vehicle__c(Name = 'Lada', Air_Conditioner__c = false, Bathrooms__c = 1, Bedrooms__c = 1, Model__c = 'Lada')
    );
    vehicles.add(
      new Vehicle__c(Name = 'Mosk', Air_Conditioner__c = true, Bathrooms__c = 2, Bedrooms__c = 2, Model__c = 'Mosk')
    );

    vehicles.add(
      new Vehicle__c(Name = 'BMW', Air_Conditioner__c = true, Bathrooms__c = 1, Bedrooms__c = 1, Model__c = 'BMW')
    );
    Database.insert(vehicles);
    return vehicles;
  }

  public static List<Product2> createEquip() {
    List<Product2> equipments = new List<Product2>();

    equipments.add(
      new Product2(name = 'frwewe', Replacement_Part__c = true, Cost__c = 1000, Maintenance_Cycle__c = 30)
    );
    equipments.add(
      new Product2(name = 'asdasdC', Replacement_Part__c = true, Cost__c = 100, Maintenance_Cycle__c = 15)
    );
    equipments.add(
      new Product2(name = 'gserwqre96', Replacement_Part__c = true, Cost__c = 20, Maintenance_Cycle__c = 6)
    );
    insert equipments;
    return equipments;
  }

  public static List<Case> maintenanceRequest(List<Vehicle__c> vehicles) {
    List<Case> maintenanceRequests = new List<Case>();
    for (integer i = 0; i < 300; i++) {
      if (math.mod(i, 2) == 0) {
        maintenanceRequests.add(
          new Case(Vehicle__c = vehicles.get(1).Id, Type = TYPE_ROUTINE_MAINTENANCE, Date_Reported__c = Date.today())
        );
      } else {
        maintenanceRequests.add(
          new Case(Vehicle__c = vehicles.get(2).Id, Type = TYPE_ROUTINE_MAINTENANCE, Date_Reported__c = Date.today())
        );
      }
    }

    insert maintenanceRequests;
    return maintenanceRequests;
  }

  public static List<Equipment_Maintenance_Item__c> createJoinRecords(
    List<Product2> equipment,
    List<Case> maintenanceRequest
  ) {
    List<Equipment_Maintenance_Item__c> joinRecords = new List<Equipment_Maintenance_Item__c>();

    for (integer i = 0; i < maintenanceRequest.size(); i++) {
      joinRecords.add(
        new Equipment_Maintenance_Item__c(
          Equipment__c = equipment.get(0).Id,
          Quantity__c = 100,
          Maintenance_Request__c = maintenanceRequest.get(i).Id
        )
      );
      joinRecords.add(
        new Equipment_Maintenance_Item__c(
          Equipment__c = equipment.get(1).Id,
          Quantity__c = 100,
          Maintenance_Request__c = maintenanceRequest.get(i).Id
        )
      );
      joinRecords.add(
        new Equipment_Maintenance_Item__c(
          Equipment__c = equipment.get(2).Id,
          Quantity__c = 100,
          Maintenance_Request__c = maintenanceRequest.get(i).Id
        )
      );
    }

    insert joinRecords;
    return joinRecords;
  }
}

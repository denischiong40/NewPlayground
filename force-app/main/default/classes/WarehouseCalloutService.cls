public with sharing class WarehouseCalloutService implements Queueable, Database.AllowsCallouts {
  public List<product2> equip = new List<product2>();
  private static final String WAREHOUSE_ENDPOINT = 'https://th-superbadge-apex.herokuapp.com/equipment';

  public void execute(QueueableContext context) {
    Http h = new Http();
    HttpRequest httpReq = new HttpRequest();
    httpReq.setHeader('Content-Type', 'application/json');
    httpReq.setEndpoint(WAREHOUSE_ENDPOINT);
    httpReq.setMethod('GET');

    HttpResponse res = h.send(httpReq);
    List<Object> results = (List<Object>) JSON.deserializeUntyped(res.getBody());
    System.debug('ASSSSSSSSSSSSSS' + results.size());

    for (Object resultItem : results) {
      Map<String, Object> entry = (Map<String, Object>) resultItem;
      System.debug('ASSSSSSSSSSSSSS' + resultItem);
      equip.add(
        new product2(
          QuantityUnitOfMeasure = String.valueOf(entry.get('quantity') + ''),
          Replacement_Part__c = Boolean.valueOf(entry.get('replacement') + ''),
          StockKeepingUnit = String.valueOf(entry.get('sku') + ''),
          Warehouse_SKU__c = String.valueOf(entry.get('_id') + ''),
          Cost__c = Decimal.valueOf(entry.get('cost') + ''),
          Lifespan_Months__c = Decimal.valueOf(entry.get('lifespan') + ''),
          Maintenance_Cycle__c = Decimal.valueOf(entry.get('maintenanceperiod') + ''),
          Name = String.valueOf(entry.get('name') + '')
        )
      );
    }
    if (!equip.isEmpty()) {
      upsert equip Warehouse_SKU__c;
      system.debug('list got updated. Size: ' + equip.size());
    }
  }
}

public class BillingCalloutService {
  public static final String BILLING_SERVICE_CREDENTIAL_NAME = 'BillingServiceCredential';
  static final ServiceCredentials__c credential = ServiceCredentials__c.getInstance(BILLING_SERVICE_CREDENTIAL_NAME);

  public static void callBillingService(List<Project__c> newProjects, Map<Id, Project__c> oldProjectsMap) {
    List<Project__c> projectsToUpdated = new List<Project__c>();

    for (Project__c proj : newProjects) {
      Project__c oldProject = oldProjectsMap.get(proj.Id);
      if (proj.Status__c == 'Billable' && proj.Status__c != oldProject.Status__c) {
        projectsToUpdated.add(proj);
      }
    }

    if (projectsToUpdated.size() > 0) {
      makeCallout(JSON.serialize(projectsToUpdated));
    }
  }

  @future(callout=true)
  static void makeCallout(String serializedProjects) {
    List<Project__c> projects = (List<Project__c>) JSON.deserialize(serializedProjects, List<Project__c>.class);
    List<Project__c> projectsToUpdate = new List<Project__c>();

    for (Project__c proj : projects) {
      BillingServiceProxy.InvoicesPortSoap11 invoicePort = new BillingServiceProxy.InvoicesPortSoap11();
      BillingServiceProxy.project extProject = SyncProjects(proj);
      String response = invoicePort.billProject(extProject);

      if (response == 'OK') {
        proj.Status__c = 'Billed';
        projectsToUpdate.add(proj);
      }
    }

    if (projectsToUpdate.size() > 0) {
      update projectsToUpdate;
    }
  }

  static BillingServiceProxy.project SyncProjects(Project__c proj) {
    BillingServiceProxy.project extProject = new BillingServiceProxy.project();
    extProject.projectid = proj.ProjectRef__c;
    extProject.billAmount = proj.Billable_Amount__c;
    extProject.username = credential.Username__c;
    extProject.password = credential.Password__c;

    return extProject;
  }
}

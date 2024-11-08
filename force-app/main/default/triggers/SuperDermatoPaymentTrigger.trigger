trigger SuperDermatoPaymentTrigger on Payments__c (after insert, after update) {

      for(Payments__c p:Trigger.New){
          Contact currentContact = [SELECT Id, AccountId, number_of_payments__c, Total_Payment__c, Average_Payment__c FROM Contact WHERE Id = :p.Contact__c];
          Account currentAccount = [SELECT Id, Daily_revenue__c FROM Account WHERE Id = :currentContact.AccountId];
          
     
          if (Trigger.isInsert) {
               currentContact.number_of_payments__c = currentContact.number_of_payments__c != NULL ? currentContact.number_of_payments__c + 1 : 1;
               currentContact.Total_Payment__c = currentContact.Total_Payment__c != NULL ? currentContact.Total_Payment__c += p.Final_Amount__c : p.Final_Amount__c;
               currentContact.Average_Payment__c = currentContact.Total_Payment__c != NULL && currentContact.number_of_payments__c != NULL ? currentContact.Total_Payment__c / currentContact.number_of_payments__c : 0;
              
           	  currentAccount.Daily_revenue__c = currentAccount.Daily_revenue__c != NULL ? currentAccount.Daily_revenue__c += p.Final_Amount__c : p.Final_Amount__c;
          }

            
           // if (Trigger.isUpdate) {}
                    
         update currentContact;
        // update currentAccount;
      }
}
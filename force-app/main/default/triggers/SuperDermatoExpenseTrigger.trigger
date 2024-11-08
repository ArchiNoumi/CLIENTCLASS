trigger SuperDermatoExpenseTrigger on Expense__c (after insert, after update) {
    for(Expense__c e:Trigger.New){
            Account currentAccount = [SELECT Id, Daily_expenses__c FROM Account WHERE Id = :e.Account__c];
            
            if (Trigger.isInsert) {
                currentAccount.Daily_expenses__c = currentAccount.Daily_expenses__c != NULL ? currentAccount.Daily_expenses__c += e.Amount__c : e.Amount__c;
            }
                 
            update currentAccount;
    }
}
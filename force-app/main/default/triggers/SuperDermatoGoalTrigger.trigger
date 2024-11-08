/****
 * Ajouter le Recordtype dans la requête
 * Récupérer aussi le Compte Parent !! (Tu vas le créé avec le User Dermato dans le Salesforce et RT Dermato (Recordt Type))
 * Aussi récupérer les champs du Account à updater
 * Puis faire la mise à jour après avoir sommer tous les amounts
 * */
trigger SuperDermatoGoalTrigger on Goal__c (before insert, before update) {
    
    for(Goal__c g:Trigger.New){
        if(g.is_active__c){
            // Disable olds goals.
           	List<Goal__c> oldGoals = new List<Goal__c>();
            List<Goal__c> goalList = new List<Goal__c>([SELECT Id, Type__c, is_active__c FROM Goal__c WHERE Type__c = :g.Type__c AND is_active__c = true]);
            
            for(Goal__c goal :goalList){
                goal.is_active__c = false;
                oldGoals.add(goal);
            }
            if(oldGoals.size() > 0){
        		update oldGoals;
    		}
            
            // Update Account
            Account currentAccount = [SELECT Id FROM Account WHERE Id = :g.Account__c];
            
            String typeGoal = g.Type__c.toLowerCase();
            if(typeGoal == 'journalier'){
                //currentAccount.Daily_Goal__c = g.Amount__c;
            }
            if(typeGoal == 'hebdomadaire'){
                currentAccount.Weekly_Goal__c = g.Amount__c;
            }
            if(typeGoal == 'mensuel'){
                currentAccount.Monthly_Goal__c = g.Amount__c;
            }
            if(typeGoal == 'trimestriel'){
                currentAccount.Quarterly_Goal__c = g.Amount__c;
            }
            if(typeGoal == 'annuel'){
                currentAccount.Annual_Goal__c = g.Amount__c;
            }
            
            update currentAccount;
        }
    }
    
 
}
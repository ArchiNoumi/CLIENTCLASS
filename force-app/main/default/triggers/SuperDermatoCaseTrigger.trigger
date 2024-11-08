trigger SuperDermatoCaseTrigger on Case (before insert, before update) {
    
    for(Case c:Trigger.New){
        if(c.description.toLowercase().indexOf('urgent') != -1){
           c.priority = 'High';
        }
    }
}
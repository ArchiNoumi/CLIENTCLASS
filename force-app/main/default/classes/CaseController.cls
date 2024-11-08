public with sharing class CaseController {
    @AuraEnabled
    public static List<Case> addCases(String payload){
        List<Case> payloadObject = (List<Case>) JSON.deserialize(payload, Case.class);

        System.debug('[add cases]' + payloadObject);
        List<Case> newCases = new List<Case>();
        for(Case c:payloadObject){
            Case newCase = new Case();
            newCase.origin = c.origin;
            newCase.status = c.status;
            newCase.description = c.description;

            newCases.add(newCase);
        }
     
        insert newCases;  

        return newCases;
    }
}
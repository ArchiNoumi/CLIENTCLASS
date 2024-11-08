@isTest
public class UpdateParentAccountTest {

    @testSetup
    static void setup(){
        List<Account> accList = new List<Account>(); 
        accList.add(new Account(Name='Parent'));
            for(Integer i=0; i<100; i++){
                accList.add(new Account(name='Test Account'+i));
            }
        insert accList;
    }
    
    @isTest
    private static void testQueueable(){
        Id parentId = [select id from Account where Name='Parent'][0].Id;
        
        List<Account> accList = [select Id, Name from Account
                                where Name Like 'Test Account%'];
    
    	UpdateParentAccount updateJob = new UpdateParentAccount(accList, parentId);
        test.startTest();
        	System.enqueueJob(updateJob);
        test.stopTest();
        
        System.assertEquals(100, [select count() from Account where parentId =:parentId]);
        
    
    }
}
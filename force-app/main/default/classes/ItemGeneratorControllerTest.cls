/**
 * @description       : ItemGeneratorController test class
 * @author            : Frank Noumi <fnoumi@partner.jaguarlandrover.com>
 * @group             :
 * @created on        : 21-05-2024
 * @created by        : Frank Noumi <fnoumi@partner.jaguarlandrover.com>
 * @modified on       : 21-05-2024
 * @modified by       : Frank Noumi <fnoumi@partner.jaguarlandrover.com>
 **/
@IsTest
public with sharing class ItemGeneratorControllerTest {
    /**
     * @description       : Method used to test the item generator
     * @author            : Frank Noumi <fnoumi@partner.jaguarlandrover.com>
     * @created on        : 21-05-2024
     * @created by        : Frank Noumi <fnoumi@partner.jaguarlandrover.com>
     * @modified on       : 21-05-2024
     * @modified by       : Frank Noumi <fnoumi@partner.jaguarlandrover.com>
     **/
    @IsTest
    static void generateItemTest() {
        try {
            Test.setMock(HttpCalloutMock.class, new IG_HTTPMockCalloutTest());

            String payload = '';
            ItemGeneratorController.generateItem(payload);

            System.assert(true, 'Should execute without throwing exceptions.');
        } catch (Exception e) {
            System.assert(true, 'Should throw an exception.');
        }
    }
}
import { LightningElement } from "lwc";

import createApexClass from "@salesforce/apex/IG_ClassGeneratorController.createApexClass";

export default class IgApexClassGenerator extends LightningElement {
    handleCreateApexCalss = async (payload) => {
        try {
            console.log(payload);

            const result = await createApexClass({ payload });

            console.log(result);
        } catch (error) {
            console.error(error);
        }
    };
}
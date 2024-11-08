import { LightningElement } from "lwc";
import { loadStyle } from "lightning/platformResourceLoader";

import assets from "@salesforce/resourceUrl/assets";
import generateItem from "@salesforce/apex/ItemGeneratorController.generateItem";

export default class ItemGenerator extends LightningElement {
    type;
    access;

    listTypes = ["Class", "Trigger"];
    listAccesses = ["Read", "Create", "Update", "Delete"];

    // lify cycle method: on load
    connectedCallback() {
        this.initState();
    }

    initState() {
        loadStyle(this, assets + "/styles/global.css");
    }

    handleItemSelected(event) {
        this.type = event.target.value;
    }

    handleAccessSelected(event) {
        this.access = event.target.value;
    }

    async handleGenerateItem() {
        try {
            const item = { type: this.type, access: this.access };
            const payload = JSON.stringify(item);
            const result = await generateItem({ payload });

            console.log(result);
        } catch (error) {
            console.error(error);
        }
    }
}
import { LightningElement } from 'lwc';

import addCases from "@salesforce/apex/CaseController.addCases";

export default class CsvFileInput extends LightningElement {
    CLASS_INPUT_FIELD = "csvFilePick"

    renderedCallback() {
        this.runFileInputListener();
    }

    runFileInputListener() {
        const picker = this.template.querySelector(`.${this.CLASS_INPUT_FIELD}`);

        picker?.addEventListener("change", async (e) => {
            const result = await this.readCsvFile(e.target.files[0]);
            this.saveCsvFile(result);
        });
    }

    readCsvFile(file) {
        return new Promise((resolve) => {
            const reader = new FileReader();
            reader.readAsText(file);
        
            reader.onload = (e) => {
                const rows = e.target.result.split("\n");
                const headers = rows[0].toLowerCase().split(",");

                const result = [];
                for (let i = 1; i < rows.length; i++){
                    const row = rows[i].split(",").reduce((prev,current,i ) => ({...prev, [headers[i]]:current}),{});

                    result.push(row);
                }
                resolve(result);
            } 
    })
   
    }

   async saveCsvFile(data) {
        try {
            const payload = JSON.stringify(data);
            console.log({ data, payload });

            await addCases(payload);
            console.log("CASE RECORDS SAVED");
        } catch (error) {
            console.log("[Server Side Error]:", error);
        }
        
    }
}
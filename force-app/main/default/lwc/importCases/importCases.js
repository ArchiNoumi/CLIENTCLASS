import {LightningElement, track} from 'lwc';
import { loadScript } from 'lightning/platformResourceLoader';
import assetsPath from '@salesforce/resourceUrl/assetsPath';
import { createRecord } from 'lightning/uiRecordApi';
import CASE_OBJECT from '@salesforce/schema/Case';
import STATUS_FIELD from '@salesforce/schema/Case.Status';
import ORIGIN_FIELD from '@salesforce/schema/Case.Origin';
import DESCRIPTION_FIELD from '@salesforce/schema/Case.Description';

export default class ImportCases extends LightningElement {
    parserInitialized = false;
    loading = false;
    @track _results;
    @track _rows;


    async renderedCallback() {
        try {
            if (this.parserInitialized) return;
                await loadScript(this, `${assetsPath}/assets/js/papaparse.min.js`)
                this.parserInitialized = true;

            } catch (error) {
                console.error(error)
            }
    }
    
    get columns(){
        const columns = [
            { fieldName: 'Status', label: 'Status' },
            { fieldName: 'Origin', label: 'Origin' },
            { fieldName: 'Description', label: 'Description' }
        ];
        if(this.results.length){
            columns.push({ fieldName: 'Result',label: 'result' });
        }
        return columns;
    }
    get rows(){
        if (!this._rows) return [];

        return this._rows.map((row, index) => {
            row.key = index;
            if(this.results[index]){
                row.result = this.results[index].id || this.results[index].error;
            }
            return row;
        })
    }

    
    get results(){
        if(this._results){
            return this._results.map(r => {
                const result = {};
                result.success = r.status === 'fulfilled';
                result.id = result.success ? r.value.id : undefined;
                result.error = !result.success ? r.reason.body.message : undefined;
                return result;
            });
        }
        return [];
    }

    handleInputChange(event) {
        if (!event.target.files.length) return;

        const file = event.target.files[0];
        this.loading = true;
        Papa.parse(file, {
            quoteChar: '"',
            header: 'true',
            complete: (results) => {
                this._rows = results.data;
                this.loading = false;
            },
            error: (error) => {
                console.error(error);
                this.loading = false;
            }
        })
        
    }

    createCases(){
        const casesToCreate = this.rows.map(row => {
            const fields = {};
            fields[STATUS_FIELD.fieldApiName] = row.Status;
            fields[ORIGIN_FIELD.fieldApiName] = row.Origin;
            fields[DESCRIPTION_FIELD.fieldApiName] = row.Description;

            const recordInput = { apiName: CASE_OBJECT.objectApiName, fields };
            return createRecord(recordInput);
        });

        if (!casesToCreate.length) return;
        
        this.loading = true;
        Promise.allSettled(casesToCreate)
            .then(results => this._results = results)
            .catch(error => console.error(error))
            .finally(() => this.loading = false);
    
    }

    cancel(){
        this._rows = undefined;
        this._results = undefined;
    }
}
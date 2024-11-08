import { LightningElement, api } from "lwc";

export default class IgButton extends LightningElement {
    @api loading = false;
    @api handleClick;
}
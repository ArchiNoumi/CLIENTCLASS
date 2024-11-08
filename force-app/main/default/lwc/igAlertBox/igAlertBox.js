import { LightningElement, api } from "lwc";

export default class IgAlertBox extends LightningElement {
    // props

    @api type = "success";
    @api message = "";
    @api closeBox;

    // computed
    get isErrorAlert() {
        return this.type === "error";
    }
    get notifyInnerBoxClass() {
        return this.type === "error"
            ? "slds-notify slds-notify_toast slds-theme_error"
            : "slds-notify slds-notify_toast slds-theme_success";
    }

    // lifecycle
    connectedCallback() {
        this.handleAutoClose();
    }

    // handlers
    handleAutoClose = () => {
        setTimeout(() => {
            this.message && this.closeBox?.();
        }, 10000);
    };
}
import { LightningElement, api } from "lwc";

export default class IgApexClassForm extends LightningElement {
    // props
    @api saveApexClass;

    // constants
    listAccessibilities = ["public", "private", "protected", "global"];

    // variables
    className = "";
    classAccessibility = "";
    currentAttribute = attributeFactory();
    currentMethod = methodFactory();
    attributes = [];
    methods = [];

    isLoading = false;
    alertMessage = { type: "", message: "" };

    // computed
    get areAttributesAvailable() {
        return this.attributes.length > 0;
    }
    get areMethodsAvailable() {
        return this.methods.length > 0;
    }
    get isAlertMessageAvailable() {
        return this.alertMessage.message.trim().length > 0;
    }

    // handlers
    handleFormInputChange = (event) => {
        try {
            switch (event.target.name) {
                case "class_name_field": {
                    this.className = event.target.value.trim();
                    console.log(this.className);
                    console.log(event.target.value.trim());
                    break;
                }
                case "class_accessibility_field": {
                    this.classAccessibility = event.target.value;
                    break;
                }

                case "attribute_name_field": {
                    this.currentAttribute.name = event.target.value.trim();
                    break;
                }
                case "attribute_value_field": {
                    this.currentAttribute.value = event.target.value;
                    break;
                }
                case "attribute_type_field": {
                    this.currentAttribute.type = event.target.value.trim();
                    break;
                }
                case "attribute_accessibility_field": {
                    this.currentAttribute.accessibility = event.target.value;
                    break;
                }
                case "static_attribute_field": {
                    this.currentAttribute.isStatic = event.target.checked;
                    break;
                }

                case "method_name_field": {
                    this.currentMethod.name = event.target.value.trim();
                    break;
                }
                case "method_body_field": {
                    this.currentMethod.body = event.target.value;
                    break;
                }

                default:
                    break;
            }
        } catch (error) {
            console.error(error.message);
        }
    };

    handleSaveApexClass = async () => {
        try {
            this.isLoading = true;
            if (!this.className.trim()) throw new Error(`Missing required field: Class Name`);

            const payload = { name: this.className, body: this.parseClass() };
            await this.saveApexClass(JSON.stringify(payload));

            this.alertMessage = { message: "Class created successfully" };

            this.attributes = [];
            this.methods = [];
            this.className = "";
            this.classAccessibility = "public";
        } catch (error) {
            this.alertMessage = { message: error.message, type: "error" };
            console.error(error.message);
        } finally {
            this.isLoading = false;
        }
    };

    parseClass = () => {
        const apexClasstring = `
            
            ${this.classAccessibility || ""} with sharing class ${this.className} {


            ${this.attributes
                .map(
                    (attribute) => `
            ${attribute.accessibility || "public"} ${attribute.isStatic ? "static" : ""} ${attribute.type} ${attribute.name} ${attribute.value ? " = " + attribute.value : ""};
            `
                )
                .join("   ")}


                ${this.methods.map((method) => method.body).join("   ")}
            }
            `;

        return apexClasstring;
    };

    handlAddAttribute = () => {
        try {
            const requiredField = ["name", "type"];
            for (let field of requiredField) {
                if (this.currentAttribute[field].trim()) continue;
                throw new Error(`Missing required field: ${field}`);
            }

            if (this.currentAttribute.type.toLocaleLowerCase() === "string") {
                this.currentAttribute.value = `'${this.currentAttribute.value}'`;
            }

            this.attributes.push(this.currentAttribute);
            this.currentAttribute = attributeFactory();
        } catch (error) {
            this.alertMessage = { message: error.message, type: "error" };
            console.error(error.message);
        }
    };

    handleAddMethod = () => {
        try {
            const requiredField = ["name", "body"];
            for (let field of requiredField) {
                if (this.currentMethod[field].trim()) continue;
                throw new Error(`Missing required field: ${field}`);
            }

            this.methods.push(this.currentMethod);
            this.currentMethod = methodFactory();
        } catch (error) {
            this.alertMessage = { message: error.message, type: "error" };
            console.error(error.message);
        }
    };

    handleDeleteAttribute = (event) => {
        try {
            const row = event.target.closest("tr");
            const itemId = row.dataset.id;
            if (!itemId) return;

            this.attributes = this.attributes.filter((a) => a.id !== itemId);
        } catch (error) {
            this.alertMessage = { message: error.message, type: "error" };
            console.error(error.message);
        }
    };

    handleDeleteMethod = (event) => {
        try {
            const row = event.target.closest("tr");
            const itemId = row.dataset.id;
            if (!itemId) return;

            this.methods = this.methods.filter((m) => m.id !== itemId);
        } catch (error) {
            this.alertMessage = { message: error.message, type: "error" };
            console.error(error.message);
        }
    };

    handleClearAlertMessage = () => {
        this.alertMessage = { type: "", message: "" };
    };
}

// helpers ------------------------------
function attributeFactory() {
    const newAttribute = {
        id: `a-${Date.now()}`,
        name: "",
        value: "",
        type: "",
        accessibility: "public",
        isStatic: false
    };

    return newAttribute;
}

function methodFactory() {
    const newMethod = {
        id: `m-${Date.now()}`,
        name: "",
        body: ""
    };

    return newMethod;
}
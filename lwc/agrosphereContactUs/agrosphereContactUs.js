import { LightningElement,api,track,wire } from 'lwc';
import isguest from '@salesforce/user/isGuest';
import createCase from '@salesforce/apex/AgrosphereController.createCase'
export default class AgrosphereContactUs extends LightningElement {
    @track isAuthenticated = !isguest;
    @track firstName = '';
    @track lastName = '';
    @track email = '';
    @track issueDescription = '';
    @track isSubmitted = false;
    @track caseNumber;
    spinner = false;

    @track errors = {
        firstName: '',
        lastName: '',
        email: '',
        issueDescription: ''
    };

    // Handle input changes
    handleInputChange(event) {
        const { name, value } = event.target;
        this[name] = value.trim();
        if (this.errors[name] && name != 'email') {
            this.errors[name] = '';
        } else if (this.errors[name] && name == 'email') {
            if (/^[^\s@]+@[^\s@]+\.[^\s@]+$/.test(this.email)) {
                this.errors[name] = '';
            }
        }
    }

    validateForm() {
        let isValid = true;
        if (!this.isAuthenticated) {
            if (this.firstName == '') {
                this.errors.firstName = 'First Name is required.';
                isValid = false;
            } else {
                this.errors.firstName = '';
                isValid = true;
            }
            if (!this.lastName) {
                this.errors.lastName = 'Last Name is required.';
                isValid = false;
            } else {
                this.errors.lastName = '';
                isValid = true;
            }
            if (!this.email || !/^[^\s@]+@[^\s@]+\.[^\s@]+$/.test(this.email)) {
                this.errors.email = 'A valid Email is required.';
                isValid = false;
            } else {
                this.errors.email = '';
                isValid = true;
            }
        }
        if (!this.issueDescription) {
            this.errors.issueDescription = 'Issue Description is required.';
            isValid = false;
        } else {
            this.errors.issueDescription = '';
            isValid = true;
        }

        return isValid;
    }

    async handleSubmit(event) {
        this.validateForm();
        event.preventDefault();

        if (!this.validateForm()) {
            return;
        }

        const caseDetails = {
            firstName: this.firstName,
            lastName: this.lastName,
            email: this.email,
            issueDescription: this.issueDescription
        };
        this.spinner = true;
        createCase({name:this.firstName +' ' +this.lastName,email:this.email,message:this.issueDescription}).then(res=>{
            this.caseNumber = res;
            this.isSubmitted = true;
            this.spinner = false;
        }).catch(err=>{
            console.log(err)
        })
    }

    handleBackButton(){
        this.isSubmitted = false;
        this.firstName = '';
        this.lastName = '';
        this.email = '';
        this.issueDescription = '';
    }
}
import { LightningElement, track, wire } from 'lwc';
import createWebFormInstance from '@salesforce/apex/DocusignCalloutController.createWebFormInstance'
import getInstanceStatus from '@salesforce/apex/DocusignCalloutController.getInstanceStatus'
import refreshInstanceStatus from '@salesforce/apex/DocusignCalloutController.refreshInstanceStatus'
import isEmailExist from '@salesforce/apex/AgrosphereController.isEmailExist';
import registerUser from '@salesforce/apex/AgrosphereController.registerUser';
import licenseCheck from '@salesforce/apex/AgrosphereController.licenseCheck';

export default class AgrosphereUserRegistration extends LightningElement {
    @track email = '';
    @track hasError = false;
    @track errorMessage = '';
    @track successMessage = '';
    hideForm = false;
    myWindow;
    instanceId;
    isProcessing = false;
    showClosedMessage = false;
    @track allLicenseUsed = false;

    @track wiredRecords = [];
    @wire(licenseCheck) recList(result) {
        this.wiredRecords = result;
        if (result.data) {
            console.log(result.data)
            this.allLicenseUsed = result.data.TotalLicenses == result.data.UsedLicenses; 
        } else if (result.error) {
            console.error(error);
        }
    }

    handleEmailChange(event) {
        this.email = event.target.value.trim();
    }
    handleReopen() {
        this.isProcessing = true;
        this.showClosedMessage = false;
        refreshInstanceStatus({ instanceId: this.instanceId }).then(res => {
            console.log(res)
            this.myWindow = window.open(res.formUrl + '#instanceToken=' + res.instanceToken, "_blank", "toolbar=yes,scrollbars=yes,resizable=yes,top=500,left=500,width=900,height=900");
            let intrvl = setInterval(async () => {
                if (this.myWindow.closed) {
                    getInstanceStatus({ instanceId: this.instanceId }).then(data => {
                        console.log(data)
                        if (data.status != 'SUBMITTED') {
                            this.showClosedMessage = true;
                            this.isProcessing = false;

                        } else {
                            let fullName = this.splitName(data.formValues.User_name)
                            let firstName = fullName.firstName
                            let lastName = fullName.lastName != '' ? fullName.lastName : 'User';
                            let address = data.formValues.Address;
                            let email = data.formValues.User_email;
                            let phone = data.formValues.Phone;
                            let username = email + '.agrosphere';

                            registerUser({ firstName, lastName, username, email, address, phone })
                                .then((result) => {
                                    if (result) {
                                        console.log(result)
                                        this.successMessage = `Registration successful! Your email "${this.email}" has been registered.`;
                                        this.showClosedMessage = false;
                                        this.isProcessing = false;
                                    }
                                })
                                .catch((error) => {
                                    console.log('error-', error);
                                });
                        }
                    }).catch(error => {
                        console.log(error)
                    })
                    clearInterval(intrvl);
                }
            }, 500);
        })
    }

    handleSubmit() {
        if (!this.validateEmail(this.email)) {
            this.hasError = true;
            this.errorMessage = 'Please enter a valid email address.';
            return;
        }

        this.hasError = false;
        this.errorMessage = '';
        this.successMessage = '';

        isEmailExist({ username: this.userName })
            .then((result) => {
                console.log('login result---' + result, typeof result);
                // Check if the email exists in the dummy data
                if (result != null && result != undefined && result == true) {
                    this.successMessage = 'This email already exists in our database. Please log in!';
                } else {
                    this.hideForm = true;
                    this.isProcessing = true;

                    createWebFormInstance({ clientUserId: this.email }).then(res => {
                        console.log(res)
                        this.instanceId = res.id
                        this.myWindow = window.open(res.formUrl + '#instanceToken=' + res.instanceToken, "_blank", "toolbar=yes,scrollbars=yes,resizable=yes,top=500,left=500,width=900,height=900");
                        let intrvl = setInterval(async () => {
                            if (this.myWindow.closed) {
                                getInstanceStatus({ instanceId: this.instanceId }).then(data => {
                                    console.log(data)
                                    if (data.status != 'SUBMITTED') {
                                        this.showClosedMessage = true;
                                        this.isProcessing = false;

                                    } else {
                                        let fullName = this.splitName(data.formValues.User_name)
                                        let firstName = fullName.firstName
                                        let lastName = fullName.lastName != '' ? fullName.lastName : 'User';
                                        let address = data.formValues.Address;
                                        let email = data.formValues.User_email;
                                        let phone = data.formValues.Phone;
                                        let username = email + '.agrosphere';

                                        registerUser({ firstName, lastName, username, email, address, phone })
                                            .then((result) => {
                                                if (result) {
                                                    console.log(result)
                                                    this.successMessage = `Registration successful! Your email "${this.email}" has been registered.`;
                                                    this.showClosedMessage = false;
                                                    this.isProcessing = false;
                                                }
                                            })
                                            .catch((error) => {
                                                console.log('error-', error);
                                            });
                                    }
                                }).catch(error => {
                                    console.log(error)
                                })
                                clearInterval(intrvl);
                            }
                        }, 500);
                    }).catch(err => {
                        console.log(err)
                    })
                }
            })
    }
    validateEmail(email) {
        const emailPattern = /^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$/;
        return emailPattern.test(email);
    }
    splitName(fullName) {
        fullName = fullName.trim();
        const nameParts = fullName.split(' ');
        if (nameParts.length === 1) {
            return { firstName: nameParts[0], lastName: '' };
        }
        const lastName = nameParts.pop();
        const firstName = nameParts.join(' ');
        return { firstName, lastName };
    }
}
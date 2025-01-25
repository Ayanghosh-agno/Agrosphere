import { LightningElement, track } from 'lwc';
import isguest from '@salesforce/user/isGuest';
import getCase from '@salesforce/apex/AgrosphereController.getCase';
import sendEmailForOTP from '@salesforce/apex/AgrosphereController.sendEmailForOTP';


export default class AgrosphereTrackCase extends LightningElement {
    authenticated = !isguest;
    @track caseNumber = '';
    @track otp = '';
    @track showCaseInput = true;
    @track showOTPInput = false;
    @track caseDetails = false;
    @track noResults = false;
    caseId;
    spinner = false;

    // Dummy data for cases
    dummyCases = [
        {
            CaseNumber: 'C12345',
            Email: 'user1@example.com',
            Status: 'Open',
            Priority: 'High',
            Subject: 'Issue with product',
        },
        {
            CaseNumber: 'C67890',
            Email: 'user2@example.com',
            Status: 'Resolved',
            Priority: 'Medium',
            Subject: 'Billing issue',
        },
    ];

    // OTP simulation
    generatedOTP = null;

    // Handle case number input
    handleCaseInput(event) {
        this.caseNumber = event.target.value;
    }

    // Handle OTP input
    handleOTPInput(event) {
        this.otp = event.target.value;
    }

    // Step 1: Track case
    trackCase() {
        if (!this.caseNumber) {
            alert('Please enter a case number.');
            return;
        }

        getCase({ caseNumber: this.caseNumber }).then(res => {
            if (res.length > 0) {
                console.log(res)
                this.caseId = res[0].Id

                this.noResults = false;
                if (this.authenticated) {
                    this.showCaseInput = false;
                    this.showOTPInput = false;
                    this.caseDetails = true;
                } else {
                    this.spinner = true;
                    this.generatedOTP = this.generateOtp(6);
                    sendEmailForOTP({ ranString: this.generatedOTP, toMail: res[0].SuppliedEmail != '' ? res[0].SuppliedEmail : res[0].Contact.Email }).then(resu => {
                        this.showOTPInput = true;
                        this.showCaseInput = false;
                        this.spinner = false;
                    }).catch(err => {
                        console.log(JSON.stringify(err))
                    })
                }

            } else {
                this.noResults = true;
                this.caseDetails = false;
            }
        }).catch(err => {
            console.log(JSON.stringify(err))
        })

    }
    generateOtp(length) {
        const digits = '0123456789';
        let otp = '';
        for (let i = 0; i < length; i++) {
            otp += digits[Math.floor(Math.random() * digits.length)];
        }
        return otp;
    }

    // Step 2: Verify OTP
    verifyOTP() {
        if (this.otp === this.generatedOTP) {
             this.caseDetails = true;
            this.noResults = false;
            this.showOTPInput = false;
        } else {
            alert('Invalid OTP. Please try again.');
        }
    }
}
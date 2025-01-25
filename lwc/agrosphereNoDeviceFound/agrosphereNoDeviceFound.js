import { LightningElement } from 'lwc';
import insertDeviceInContact from '@salesforce/apex/AgrosphereController.insertDeviceInContact'

export default class AgrosphereNoDeviceFound extends LightningElement {
    deviceId = ''; // Stores the user input for DeviceId
    spinner = false
    // Handles input changes and updates the deviceId property
    handleInputChange(event) {
        this.deviceId = event.target.value.trim();
    }

    // Handles form submission
    handleSubmit(event) {
        event.preventDefault(); // Prevents the default form submission behavior
        this.spinner = true
        if (this.deviceId) {
            insertDeviceInContact({deviceId:this.deviceId}).then(res=>{
                alert('Device uploading status - '+res);
                if(res=='success !'){
                    console.log('Device ID submitted:', this.deviceId);
                    window.location.reload();
                }
            }).catch(err=>{
                this.spinner = false;
                console.log(err)
                alert('There is an error connecting your device. Please try after sometime !');
            })
            
        } else {
             this.spinner = false;
            alert('Please enter a valid Device ID.');
        }
    }

    // Handles the cancel button click
    handleCancel() {
        // Navigate back or clear the form
        console.log('User canceled the operation.');
        alert('Operation canceled.');
    }
}
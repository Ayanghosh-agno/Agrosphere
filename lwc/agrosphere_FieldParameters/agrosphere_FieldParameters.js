import { LightningElement, track, wire } from 'lwc';
import Sensor_Icons from "@salesforce/resourceUrl/SensorIcon";
//System.schedule('Cancel Unsigned Agreements', '0 0 * * * ?', new CancelUnsignedAgreementsScheduler());
import fetchLatestSensorData from '@salesforce/apex/AgrosphereController.fetchLatestSensorData'
import sendSensorNotification from '@salesforce/apex/AgrosphereController.sendSensorNotification'
import { ShowToastEvent } from 'lightning/platformShowToastEvent';


export default class Agrosphere_FieldParameters extends LightningElement {
    localTime;
    selectedOption = 'latest'
    modalActive = false;
    modalHeader = ''
    phoneNum = ''
    emailId = ''
    @track isLoading = false;
    @track errors = {};
    @track allSensorData = {
        'latest': {
            'AtmosphereTemperature': 'Please wait...',
            'AtmosphereHumidity': 'Please wait...',
            'RainPercentage': 'Please wait...',
            'LightIntensity': 'Please wait...',
            'SoilElectricConductivity': 'Please wait...',
            'SoilMoisture': 'Please wait...',
            'SoilNitrogen': 'Please wait...',
            'SoilPhosphorus': 'Please wait...',
            'SoilTemperature': 'Please wait...',
            'SoilPotassium': 'Please wait...',
            'SoilPh': 'Please wait...',
            'TransmitterBattery': 'Please wait...'
        }, '30days': {
            'AtmosphereTemperature': 'No data.',
            'AtmosphereHumidity': 'No data.',
            'RainPercentage': 'No data.',
            'LightIntensity': 'No data.',
            'SoilElectricConductivity': 'No data.',
            'SoilMoisture': 'No data.',
            'SoilNitrogen': 'No data.',
            'SoilPhosphorus': 'No data.',
            'SoilTemperature': 'No data.',
            'SoilPotassium': 'No data.',
            'SoilPh': 'No data.',
            'TransmitterBattery': 'No data.'
        }
    }

    get disable_submitbtn() {
        return Object.keys(this.errors).length == 0 && (this.emailId != '' || this.phoneNum != '') ? false : true;
    }
    get emailField() {
        return this.modalHeader.includes('email')
    }
    get phoneField() {
        return this.modalHeader.includes('mobile')
    }

    closeModal() {
        this.modalActive = false;
        this.emailId = ''
        this.phoneNum = ''
    }
    handleInputChange(event) {
        console.log(event.target.name)
        const value = event.target.value;
        if (event.target.name == 'email') {
            this.validateEmailFormat(value);
        } else if (event.target.name == 'phone') {
            this.validatePhoneFormat(value);
        }
    }
    validateEmailFormat(email) {
        const emailRegex = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
        if (!emailRegex.test(email)) {
            this.errors.email = 'Please enter a valid email address';
        } else {
            this.emailId = email;
            delete this.errors.email;
        }
    }
    validatePhoneFormat(phone) {
        const phoneRegex = /^\+(\d{2})\d{10,}$/;
        if (!phoneRegex.test(phone)) {
            this.errors.phone = 'Please enter phone number in valid format starting with + followed by number. Eg: +919898767483';
        } else {
            this.phoneNum = phone;
            delete this.errors.phone;
        }
    }

    submitModal() {
        this.isLoading = true;
        sendSensorNotification({ isEmail: this.emailField, isPhone: this.phoneField, phoneNumber: this.phoneNum, email: this.emailId, localDateTime: this.localTime })
            .then(res => {
                this.modalActive = false;
                var notType = this.emailField ? 'email.' : 'phone.'
                const event = new ShowToastEvent({
                    title: 'Update Sent !',
                    message: 'Update has been sent to your ' + notType,
                    variant: 'success',
                    mode: 'dismissable'
                });
                this.dispatchEvent(event);
                this.emailId = ''
                this.phoneNum = ''
            }).catch(err => {
                console.log(err)
            }).finally(fin => {
                this.isLoading = false;
            })
    }

    @track wiredRecords = [];
    @wire(fetchLatestSensorData) recList(result) {
        this.wiredRecords = result;
        if (result.data) {
            console.log(result.data)
            try {
                const utcDate = new Date(result.data.latestData.CreatedDate);
                const localDateString = utcDate.toLocaleString();
                this.localTime = localDateString;
                this.allSensorData['latest'] = {
                    'AtmosphereTemperature': Number(result.data.latestData.Atmosphere_Temperature__c).toFixed(2),
                    'AtmosphereHumidity': Number(result.data.latestData.Atmosphere_Humidity__c).toFixed(2),
                    'RainPercentage': Number(result.data.latestData.Rain_Percentage__c).toFixed(2),
                    'LightIntensity': Number(result.data.latestData.Light_Intensity__c).toFixed(2),
                    'SoilElectricConductivity': Number(result.data.latestData.Soil_Electric_Conductivity__c).toFixed(2),
                    'SoilMoisture': Number(result.data.latestData.Soil_Moisture_Percentage__c).toFixed(2),
                    'SoilNitrogen': Number(result.data.latestData.Soil_Nitrogen__c).toFixed(2),
                    'SoilPhosphorus': Number(result.data.latestData.Soil_Phosphorus__c).toFixed(2),
                    'SoilTemperature': Number(result.data.latestData.Soil_Temperature__c).toFixed(2),
                    'SoilPotassium': Number(result.data.latestData.Soil_Potassium__c).toFixed(2),
                    'SoilPh': Number(result.data.latestData.Soil_Ph__c).toFixed(2),
                    'TransmitterBattery': Number(result.data.latestData.Transmitter_Battery__c).toFixed(2)
                }
                if (result.data.monthAvg.Atmosphere_Temperature__c != undefined) {
                    this.allSensorData['30days'] = {
                        'AtmosphereTemperature': Number(result.data.monthAvg.Atmosphere_Temperature__c).toFixed(2),
                        'AtmosphereHumidity': Number(result.data.monthAvg.Atmosphere_Humidity__c).toFixed(2),
                        'RainPercentage': Number(result.data.monthAvg.Rain_Percentage__c).toFixed(2),
                        'LightIntensity': Number(result.data.monthAvg.Light_Intensity__c).toFixed(2),
                        'SoilElectricConductivity': Number(result.data.monthAvg.Soil_Electric_Conductivity__c).toFixed(2),
                        'SoilMoisture': Number(result.data.monthAvg.Soil_Moisture_Percentage__c).toFixed(2),
                        'SoilNitrogen': Number(result.data.monthAvg.Soil_Nitrogen__c).toFixed(2),
                        'SoilPhosphorus': Number(result.data.monthAvg.Soil_Phosphorus__c).toFixed(2),
                        'SoilTemperature': Number(result.data.monthAvg.Soil_Temperature__c).toFixed(2),
                        'SoilPotassium': Number(result.data.monthAvg.Soil_Potassium__c).toFixed(2),
                        'SoilPh': Number(result.data.monthAvg.Soil_Ph__c).toFixed(2),
                        'TransmitterBattery': Number(result.data.monthAvg.Transmitter_Battery__c).toFixed(2)
                    }
                }

            } catch (e) {
                console.log(e.message)
            }
        } else if (result.error) {
            console.error(error);
        }
    }

    get selectedData() {
        return this.selectedOption == 'latest' ? this.localTime : '30 days average'
    }

    get getSensorValues() {
        return this.selectedOption == 'latest' ? this.allSensorData['latest'] : this.allSensorData['30days']
    }

    get parameterDataImg() {
        return {
            AtmosphereTemperature: `${Sensor_Icons}/Sensor-Icons/Atmosphere_Temp.jpg`,
            AtmosphereHumidity: `${Sensor_Icons}/Sensor-Icons/Humidity.png`,
            RainPercentage: `${Sensor_Icons}/Sensor-Icons/Rain.png`,
            LightIntensity: `${Sensor_Icons}/Sensor-Icons/Light.png`,
            SoilElectricConductivity: `${Sensor_Icons}/Sensor-Icons/Soil_EC.png`,
            SoilMoisture: `${Sensor_Icons}/Sensor-Icons/Soil_Moisture.png`,
            SoilNitrogen: `${Sensor_Icons}/Sensor-Icons/Soil_N.png`,
            SoilPhosphorus: `${Sensor_Icons}/Sensor-Icons/Soil_P.jpeg`,
            SoilTemperature: `${Sensor_Icons}/Sensor-Icons/Soil_Temp.Png`,
            SoilPotassium: `${Sensor_Icons}/Sensor-Icons/Soil_K.png`,
            SoilPh: `${Sensor_Icons}/Sensor-Icons/Soil_Ph.png`,
            TransmitterBattery: `${Sensor_Icons}/Sensor-Icons/Battery_Volt.Png`,
        }
    }

    handleDataSelection(event) {
        this.selectedOption = event.target.value;
    }

    latestDataHandler(event) {
        let fieldData = JSON.parse(event.detail);
        console.log(JSON.stringify(fieldData))
        const utcDate = new Date();
        const localDateString = utcDate.toLocaleString();
        this.localTime = localDateString;
        this.allSensorData['latest'] = {
            'AtmosphereTemperature': Number(fieldData.Atmosphere_Temperature__c).toFixed(2),
            'AtmosphereHumidity': Number(fieldData.Atmosphere_Humidity__c).toFixed(2),
            'RainPercentage': Number(fieldData.Rain_Percentage__c).toFixed(2),
            'LightIntensity': Number(fieldData.Light_Intensity__c).toFixed(2),
            'SoilElectricConductivity': Number(fieldData.Soil_Electric_Conductivity__c).toFixed(2),
            'SoilMoisture': Number(fieldData.Soil_Moisture_Percentage__c).toFixed(2),
            'SoilNitrogen': Number(fieldData.Soil_Nitrogen__c).toFixed(2),
            'SoilPhosphorus': Number(fieldData.Soil_Phosphorus__c).toFixed(2),
            'SoilTemperature': Number(fieldData.Soil_Temperature__c).toFixed(2),
            'SoilPotassium': Number(fieldData.Soil_Potassium__c).toFixed(2),
            'SoilPh': Number(fieldData.Soil_Ph__c).toFixed(2),
            'TransmitterBattery': Number(fieldData.Transmitter_Battery__c).toFixed(2)
        }
    }
    handleNotificationSendEmail() {
        this.modalActive = true;
        this.modalHeader = 'Please enter your email address.';
    }
    handleNotificationSendSMS() {
        this.modalActive = true;
        this.modalHeader = 'Please enter your mobile number.';
    }


}
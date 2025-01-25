import { LightningElement, track, api } from 'lwc';
import getapplianceData from '@salesforce/apex/AgrosphereController.getapplianceData';
import updateapplianceData from '@salesforce/apex/AgrosphereController.updateapplianceData';

export default class AgrospherePumpControl extends LightningElement {

    @api applianceName = 'Default Appliance Name'
    @api pinNumber = '1'
    @track pumpStatus = false;
    @track timePumpOn = '00:00:00';
    @track lastActivationTime = 'Not activated';
    @track lastRuntime = '00:00:00';
    @track rawlastActivationTime;
    pumpTimer;
    lastActivationTimestamp;

    connectedCallback() {
        getapplianceData({ name: this.applianceName }).then(res => {
            try {
                if (res.length > 0) {
                    res[0].Last_Activated__c == undefined ? 'Not activated' : this.lastActivationTime = new Date(res[0].Last_Activated__c).toLocaleString();
                    res[0].Last_Runtime__c == undefined ? '00:00:00' : this.lastRuntime = res[0].Last_Runtime__c;
                    this.pumpStatus = res[0].Status__c;

                    if (this.pumpStatus) {
                        const currentDate = new Date(res[0].Last_Activated__c);
                        this.rawlastActivationTime = currentDate;
                        const timestamp = currentDate.getTime();
                        this.lastActivationTimestamp = timestamp
                        this.startPumpTimer();
                    }
                }

            } catch (e) {
                console.log(e.message)
            }
        })
    }
    get pumpStatusText() {
        return this.pumpStatus ? 'On' : 'Off';
    }

    get pumpButtonLabel() {
        return this.pumpStatus ? 'Turn Off ' + this.applianceName : 'Turn On ' + this.applianceName;
    }

    get buttonClass() {
        return this.pumpStatus ? 'on' : 'off';
    }

    togglePump() {
        this.pumpStatus = !this.pumpStatus;

        if (this.pumpStatus) {
            this.boltCallON();
            this.lastActivationTime = new Date().toLocaleString();
            this.rawlastActivationTime = new Date();
            this.lastActivationTimestamp = Date.now();
            this.startPumpTimer();
            updateapplianceData({ name: this.applianceName, lastrun: '', status: this.pumpStatus, lastActivated: this.rawlastActivationTime })

        } else {
            this.boltCallOFF();
            clearInterval(this.pumpTimer);
            const runtime = Date.now() - this.lastActivationTimestamp;
            this.lastRuntime = this.formatRuntime(Math.floor(runtime / 1000));
            updateapplianceData({ name: this.applianceName, lastrun: this.lastRuntime, status: this.pumpStatus, lastActivated: this.rawlastActivationTime })
            this.timePumpOn = '00:00:00';
        }
    }

    startPumpTimer() {
        this.pumpTimer = setInterval(() => {
            const currentTime = Date.now();
            const timeDifference = currentTime - this.lastActivationTimestamp;
            this.timePumpOn = this.formatTime(Math.floor(timeDifference / 1000));
        }, 1000);
    }

    formatTime(time) {
        const hours = Math.floor(time / 3600);
        const minutes = Math.floor((time % 3600) / 60);
        const seconds = time % 60;

        return (
            String(hours).padStart(2, '0') +
            ':' +
            String(minutes).padStart(2, '0') +
            ':' +
            String(seconds).padStart(2, '0')
        );
    }

    formatRuntime(totalSeconds) {
        const hours = Math.floor(totalSeconds / 3600);
        const minutes = Math.floor((totalSeconds % 3600) / 60);
        const seconds = totalSeconds % 60;

        const formattedHours = hours > 0 ? hours + ' hour(s) ' : '';
        const formattedMinutes = minutes > 0 ? minutes + ' minute(s) ' : '';
        const formattedSeconds = seconds > 0 ? seconds + ' second(s)' : '';

        return formattedHours + formattedMinutes + formattedSeconds;
    }

    boltCallON() {
        let pinnumber = this.pinNumber
        const apiUrl = `https://cloud.boltiot.com/remote/${Device_api}/digitalWrite?deviceName=${Device_name}&pin=${pinnumber}&state=LOW`;
        fetch(apiUrl)
            .then((response) => {
                if (!response.ok) {
                    throw new Error('Network response was not ok');
                }
                return response.json();
            })
            .then((data) => {
                console.log(data);
            })
            .catch((error) => {
                console.error('Error fetching weather data:', error);
            });

    }

    boltCallOFF() {
        let pinnumber = this.pinNumber
        const apiUrl = `https://cloud.boltiot.com/remote/${Device_api}/digitalWrite?deviceName=${Device_name}&pin=${pinnumber}&state=HIGH`;
        fetch(apiUrl)
            .then((response) => {
                if (!response.ok) {
                    throw new Error('Network response was not ok');
                }
                return response.json();
            })
            .then((data) => {
                console.log(data);
            })
            .catch((error) => {
                console.error('Error fetching weather data:', error);
            });

    }

}
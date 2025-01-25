import { LightningElement,api,track } from 'lwc';
export default class AgrosphereCountdown extends LightningElement {
    @api createdDate; // Pass the UTC CreatedDate as a parameter
    @track remainingTime = { hours: 0, minutes: 0, seconds: 0 };
    @track isExpired = false;

    timerId;

    connectedCallback() {
        this.startCountdown();
    }

    disconnectedCallback() {
        // Clear the timer when the component is removed
        clearInterval(this.timerId);
    }

    startCountdown() {
        // Parse the UTC CreatedDate
        const createdTimestampUTC = new Date(this.createdDate).getTime();

        // Convert UTC CreatedDate to the local timezone
        const localCreatedDate = new Date(createdTimestampUTC);
        const expirationTimestamp = localCreatedDate.getTime() + 60 * 60 * 1000; // Add 1 hour

        this.timerId = setInterval(() => {
            const currentTime = new Date().getTime(); // Get current local time
            const timeDiff = expirationTimestamp - currentTime;

            if (timeDiff <= 0) {
                this.isExpired = true;
                clearInterval(this.timerId);
            } else {
                this.remainingTime = this.calculateRemainingTime(timeDiff);
            }
        }, 1000); // Update every second
    }

    calculateRemainingTime(milliseconds) {
        const totalSeconds = Math.floor(milliseconds / 1000);
        const hours = Math.floor(totalSeconds / 3600);
        const minutes = Math.floor((totalSeconds % 3600) / 60);
        const seconds = totalSeconds % 60;

        return { hours, minutes, seconds };
    }
}
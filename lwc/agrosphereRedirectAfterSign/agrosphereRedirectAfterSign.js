import { LightningElement } from 'lwc';
export default class AgrosphereRedirectAfterSign extends LightningElement {
    isValidPage = false;
    countdown = 5;
    errorMessage = 'Sorry, you are on the wrong page!';
    intervalId;

    connectedCallback() {
        const urlParams = new URLSearchParams(window.location.search);
        const envelopeId = urlParams.get('envelopeId');

        if (envelopeId) {
            this.isValidPage = true;
            this.startCountdown();
        }
    }

    startCountdown() {
        this.intervalId = setInterval(() => {
            if (this.countdown > 1) {
                this.countdown -= 1;
            } else {
                clearInterval(this.intervalId);
                this.closeWindow();
            }
        }, 1000); // Decrement every second
    }

    closeWindow() {
        window.close();
    }
}
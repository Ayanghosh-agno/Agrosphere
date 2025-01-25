import { LightningElement,track } from 'lwc';
export default class AgrosphereAddPostingProcess extends LightningElement {
@track currentStep = 1; // Track current step in the process

    // Class names for each step based on the current step
    get stepOneClass() {
        return this.currentStep >= 1 ? 'step active' : 'step';
    }

    get stepTwoClass() {
        return this.currentStep >= 2 ? 'step active' : 'step';
    }

    get stepThreeClass() {
        return this.currentStep >= 3 ? 'step active' : 'step';
    }

    // Progress bar style to indicate completion
    get progressStyle() {
        return `width: ${(this.currentStep / 3) * 100}%`;
    }

    connectedCallback() {
        // Automatically move through the steps every 2 seconds
        this.autoProgressInterval = setInterval(() => {
            if (this.currentStep < 3) {
                this.currentStep += 1;
            } else {
                // Reset to Step 1 when Step 3 is reached
                this.currentStep = 1;
            }
        }, 2000); // 2-second interval
    }

    disconnectedCallback() {
        // Clear the interval when the component is removed from the DOM
        clearInterval(this.autoProgressInterval);
    }
}
import { LightningElement } from 'lwc';
import arrowToTop from "@salesforce/resourceUrl/SensorIcon";
export default class AgrosphereScrollToTop extends LightningElement {
    arrow = `${arrowToTop}/Sensor-Icons/freeTopArrow.webp`;
    buttonClicked() {
        const event = new CustomEvent('goToTopButton', {
            detail: 'buttonClicked',
            bubbles: true, // Allows the event to bubble up through the DOM
            composed: true // Allows the event to cross the shadow DOM boundary
        });
        this.dispatchEvent(event);
        //document.dispatchEvent(new new CustomEvent('goToTopButton', {detail: 'buttonClicked'}));
    }
    connectedCallback() {
        window.addEventListener('enableTopButton', this.scrollHandler, true);
    }
    
    scrollHandler = (event) => {
        //console.log(event)
        if (event.detail == 'true') {
            const tmp = this.template.querySelector('.goToTopbtn');
            tmp.classList.add("show");
        } else {
            const tmp = this.template.querySelector('.goToTopbtn');
            tmp.classList.remove("show");
        }
    }
    disconnectedCallback() {
        window.removeEventListener('enableTopButton', this.scrollHandler, true);
    }
}
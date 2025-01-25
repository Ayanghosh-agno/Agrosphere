import { LightningElement } from 'lwc';
import isguest from '@salesforce/user/isGuest';
import agrosphereImage from "@salesforce/resourceUrl/Agrosphere";
import { NavigationMixin } from 'lightning/navigation';

export default class AgrosphereBody extends NavigationMixin(LightningElement) {
    isguest = isguest;
    bodypic1 = `${agrosphereImage}/weather-icons/bodypic.jpg`
    bodypic2 = `${agrosphereImage}/weather-icons/bodypic2.jpg`
    loginNow() {
        this.navigateTo('/agrospehre/s/login')
    }
    goToDashboard() {
        this.navigateTo('/agrospehre/s/marketplace')
    }
    goToMarketplace() {
        this.navigateTo('/agrospehre/s/farm-overview')
    }

    navigateTo(url){
        this[NavigationMixin.Navigate]({
            type: 'standard__webPage',
            attributes: {
                url: url 
            }
        });
    }
}
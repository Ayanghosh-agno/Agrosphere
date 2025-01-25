import { LightningElement,api } from 'lwc';
export default class Agrosphere_dashboardVideo extends LightningElement {

@api videoSrc;

renderedCallback() {
        const ss = this.template.querySelector('video');
        if (ss.paused && ss.getAttribute('src')!='') {
            console.log(ss)
            document.addEventListener('click', () => {
                ss.play()
            })

        }
    }
}
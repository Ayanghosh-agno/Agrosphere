import { LightningElement } from 'lwc';
import isguest from '@salesforce/user/isGuest';

export default class Agrosphere_header extends LightningElement {
    isLoggedIn = !isguest; // This will be dynamically set based on user login status
    menuClass = 'display:none';

    toggleMenu() {
        this.menuClass = this.menuClass === 'display:none' ? 'display:block' : 'display:none';
    }

    get toggleCross() {
        return this.menuClass == 'display:none';
    }

    logout() {
        window.location.href = 'https://agno-dev-ed.develop.my.site.com/agrospehre/secur/logout.jsp'
    }

    openSignIn() {
        window.location.href = 'https://agno-dev-ed.develop.my.site.com/agrospehre/s/login'
    }

    openSignUp() {
        window.location.href = 'https://agno-dev-ed.develop.my.site.com/agrospehre/s/login/SelfRegister'
    }
    renderedCallback() {
        this.navlinkColor();
        const navItems = this.template.querySelectorAll('.nav-list li');
        navItems.forEach((item) => {
            item.addEventListener('click', this.menuOperation.bind(this));
        })
    }
    menuOperation(event) {
        const navItems = this.template.querySelectorAll('.nav-list li');
        navItems.forEach((item) =>{
            const page = item.dataset.page;
            if(event.target.dataset.page == page){
                item.classList.add('active-navbar')
            }else{
                item.classList.remove('active-navbar')
            }
        } );
    }

    navlinkColor() {
        const currentPath = window.location.pathname;
        const isHomePage = currentPath.endsWith('/s/') || currentPath.endsWith('/s');
        const navItems = this.template.querySelectorAll('.nav-list li');
        console.log(navItems)
        navItems.forEach((item) => {
            const page = item.dataset.page;
            if (currentPath.includes(page)) {
                item.classList.add('active-navbar');
            } else if (isHomePage && page === 'home') {
                item.classList.add('active-navbar');
            } else {
                item.classList.remove('active-navbar');
            }
        });
    }
}
import { LightningElement, track, wire } from 'lwc';
import getSigningURL from '@salesforce/apex/DocusignCalloutController.docusign_esign';
import getRecordFiles from '@salesforce/apex/AgrosphereController.getMarketProducts';
import agrosphereImage from "@salesforce/resourceUrl/Agrosphere";
import updateMarketProducts from '@salesforce/apex/AgrosphereController.updateMarketProducts';
import { refreshApex } from '@salesforce/apex';
import isguest from '@salesforce/user/isGuest';

export default class AgrosphereMarketPlace extends LightningElement {
    isguest = isguest;
    @track products = [];
    @track wiredRecords = [];


    @wire(getRecordFiles) recList(result) {
        this.wiredRecords = result;
        if (result.data) {

            this.products = result.data.map((file) => ({
                id: file.Id,
                isUnderReview: file.Status__c == 'Agreement being reviewed',
                name: file.Product_Title__c,
                desc: file.Product_Description__c,
                price: file.Product_price__c,
                category: file.Category__c,
                isLease: file.For_Lease__c,
                tenure: file.Lease_tenure_in_months__c,
                image: file.Category__c == 'Supplies' ? `${agrosphereImage}/weather-icons/Equipments.jpg` : file.Category__c == 'Crops' ? `${agrosphereImage}/weather-icons/Crops.jpg` : `${agrosphereImage}/weather-icons/Supplies.jpeg`,
            }));
            this.filteredProducts = [...this.products]
        } else if (result.error) {
            console.error(error);
        }
    }

    @track filteredProducts = [];

    loginNow() {
        window.location.href = 'https://agno-dev-ed.develop.my.site.com/agrospehre/s/login'
    }

    handleSearch(event) {
        const searchValue = event.target.value.toLowerCase();
        this.filterProducts(searchValue);
    }

    handleCategoryFilter(event) {
        const category = event.target.value;
        this.filterProducts('', category);
    }

    filterProducts(searchValue = '', category = 'All') {
        const isAllCategory = category === 'All';
        this.filteredProducts = this.products.filter((product) => {
            const matchesSearch = product.name.toLowerCase().includes(searchValue);
            const matchesCategory = isAllCategory || product.category === category;
            const leaseCheck = !this.showLeaseItems ? true : product.isLease == true;
            return matchesSearch && matchesCategory && leaseCheck;
        });
    }

    handleViewDetails(event) {
        const productId = event.target.dataset.id;
        this.selectedProduct = this.products.find(product => product.id === productId);
        this.isModalOpen = true;
    }

    handleAddProduct() {
        window.location.href = 'https://agno-dev-ed.develop.my.site.com/agrospehre/s/post-an-add'
    }

    isDetails = true
    isGenerating = false
    isSigning = false
    isThankYou = false
    @track showLeaseItems = false

    @track isModalOpen = false;
    @track selectedProduct = {};

    // Close the modal
    closeModal() {
        this.selectedProduct = {}
        this.isModalOpen = false;
        this.isDetails = true
        this.isGenerating = false
        this.isSigning = false
        this.isThankYou = false
    }
    handleLeaseCheckbox(event) {
        this.showLeaseItems = event.target.checked;
        this.filterProducts('', 'All');
    }
    handleNavigateToMyPurchase() {
        window.location.href = 'https://agno-dev-ed.develop.my.site.com/agrospehre/s/my-purchases';
    }
    refreshData() {
        refreshApex(this.wiredRecords);
    }

    errorCallback(error, stack) {
        console.log(error)
        console.log(stack)
    }

    myWindow;
    // Handle "Buy Now" button click
    handleBuyNow(event) {

        const productId = event.target.dataset.id;

        this.isDetails = false
        this.isGenerating = true
        this.isSigning = false
        this.isThankYou = false



        updateMarketProducts({ productId }).then(data => {
            refreshApex(this.wiredRecords);
            getSigningURL({ productId, agreementId: data }).then(res => {
                this.isDetails = false
                this.isGenerating = false
                this.isSigning = true
                this.isThankYou = false

                this.myWindow = window.open(res, "_blank", "toolbar=yes,scrollbars=yes,resizable=yes,top=500,left=500,width=400,height=400");
                let intrvl = setInterval(async () => {
                    if (this.myWindow.closed) {
                        clearInterval(intrvl);
                        this.isDetails = false
                        this.isGenerating = false
                        this.isSigning = false
                        this.isThankYou = true
                    }
                }, 500);
            }).catch(err => {
                console.log(err)
            })
        }).catch(err => {
            console.log(err)
        })



    }
}
import { LightningElement, track, wire } from 'lwc';
import getRecordFiles from '@salesforce/apex/AgrosphereController.getAgreementsOfLoggedInUser';
import getSigningUrl from '@salesforce/apex/DocusignCalloutController.getSigningUrl'
import getDocURL from '@salesforce/apex/AgrosphereController.getDocumentUrl'
import { refreshApex } from '@salesforce/apex';
import { NavigationMixin } from 'lightning/navigation';

export default class AgrosphereMyPurchaseV2 extends  NavigationMixin(LightningElement) {

    @track purchases = []
    @track filteredPurchases = []
    modalHeader;
    docLink;
    showModal = false;


    @track wiredRecords = [];
    @wire(getRecordFiles) recList(result) {
        this.wiredRecords = result;
        if (result.data) {
            console.log(result.data)
            this.purchases = result.data.map((file) => ({
                id: file.Envelop_Id__c,
                productId: file.Product__c,
                productName: file.Product__r.Product_Title__c,
                price: file.Product__r.Product_price__c,
                isAgreementComplete: file.Signing_Completed_By_Both_Party__c,
                isPendingWithFarmer: (file.Seller_Sent__c && !file.Seller_Signed__c) || (file.Buyer_Signed__c && !file.Seller_Signed__c),
                isPendingWithBuyer: file.Buyer_Sent__c && !file.Buyer_Signed__c,
                createdDate: file.CreatedDate
            }));
            this.filteredPurchases = [...this.purchases]
            this.spinner = false
        } else if (result.error) {
            console.error(error);
        }
    }

    refreshdata() {
        console.log('refresh data')
        this.spinner = true
        this.spinnertext = ''
        refreshApex(this.wiredRecords);
    }

    get totalPurchases() {
        return this.purchases.length;
    }
    get completedAgreements() {
        return this.purchases.filter(
            (purchase) => purchase.isAgreementComplete
        ).length;
    }

    get pendingAgreements() {
        return this.purchases.filter(
            (purchase) => !purchase.isAgreementComplete
        ).length;
    }

    handleSearch(event) {
        const searchTerm = event.target.value.toLowerCase();
        this.filteredPurchases = this.purchases.filter((purchase) =>
            purchase.productName.toLowerCase().includes(searchTerm)
        );
    }

    handleFilterChange(event) {
        const filter = event.target.value;
        if (filter === "") {
            this.filteredPurchases = [...this.purchases];
        } else if (filter === "completed") {
            this.filteredPurchases = this.purchases.filter(
                (purchase) => purchase.isAgreementComplete
            );
        } else if (filter === "pendingFarmer") {
            this.filteredPurchases = this.purchases.filter(
                (purchase) => purchase.isPendingWithFarmer
            );
        } else if (filter === "pendingBuyer") {
            this.filteredPurchases = this.purchases.filter(
                (purchase) => purchase.isPendingWithBuyer
            );
        }
    }

    handleViewDocument(event) {
        this.showModal = true;
        const purchaseId = event.target.dataset.id;
        getDocURL({ envelopeId: purchaseId }).then(res => {
            console.log(res);
            this.docLink = res
        })
        this.modalHeader = 'Agreement Signed'
        // alert(`Viewing document for purchase ID: ${purchaseId}`);
    }
    spinner = false;
    myWindow;
    spinnertext;

    closeModal() {
        this.showModal = false;
        this.modalHeader = '';
        this.docLink = '';
    }

    handleSignNow(event) {

        this.spinner = true
        this.spinnertext = 'Getting your signing link'

        const purchaseId = event.target.dataset.id;

        getSigningUrl({ envelopeId: purchaseId, agreementId: '' }).then(res => {
            console.log(res)
            //this.docLink = res
            this.spinnertext = 'Waiting for your sign..'
            this.myWindow = window.open(res, "_blank", "toolbar=yes,scrollbars=yes,resizable=yes,top=500,left=500,width=400,height=400");
            let intrvl = setInterval(async () => {
                if (this.myWindow.closed) {
                    this.spinnertext = 'Thanks..'
                    this.spinner = false
                    clearInterval(intrvl);
                }
            }, 500);

        }).catch(err => {
            console.log(err)
        })
        //alert(`Signing agreement for purchase ID: ${purchaseId}`);
    }

    handleContactSupport() {
       this[NavigationMixin.Navigate]({
            type: 'standard__webPage',
            attributes: {
                url: '/agrospehre/s/contact-us' 
            }
        });
    }


}
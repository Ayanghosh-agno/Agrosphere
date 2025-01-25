import { LightningElement, track } from 'lwc';
import submitProduct from '@salesforce/apex/AgrosphereController.submitProduct';
import sendAgreementForSignature from '@salesforce/apex/AgrosphereController.sendAgreementForSignature';

export default class AgrospherePostAnAdd extends LightningElement {
    @track productTitle = '';
    @track productDescription = '';
    @track category = '';
    @track productPrice = '';
    @track sellerName = '';
    @track sellerAddress = '';
    @track sellerEmail = '';
    @track sellerPhone = '';
    @track transactionType = '';
    @track leaseTenure = '';
    @track errorMessages = [];
    trackingId;
    spinner = false;

    showLeaseTenure = false;
    showModal = false;
    // Dropdown options
    categories = [
        { label: 'Crops', value: 'Crops' },
        { label: 'Equipments', value: 'Equipments' },
        { label: 'Supplies', value: 'Supplies' },
    ];

    transactionTypes = [
        { label: 'Sell', value: 'Sell' },
        { label: 'Lease', value: 'Lease' }
    ];

    // Handle input changes
    handleInputChange(event) {
        const field = event.target.name;
        this[field] = event.target.value;
    }

    // Handle transaction type changes
    handleTransactionChange(event) {
        this.transactionType = event.target.value;
        this.showLeaseTenure = this.transactionType === 'Lease';
    }
    get hasError() {
        return this.errorMessages.length > 0;
    }
    // Validate form inputs
    validateForm() {
        this.errorMessages = []; // Clear previous error messages

        if (!this.productTitle.trim()) this.errorMessages.push('Product Title is required.');
        if (!this.productDescription.trim()) this.errorMessages.push('Product Description is required.');
        if (!this.category) this.errorMessages.push('Category is required.');
        if (!this.productPrice)
            this.errorMessages.push('Valid Product Price is required.');
        if (!this.sellerName.trim()) this.errorMessages.push('Seller Name is required.');
        if (!this.sellerAddress.trim()) this.errorMessages.push('Seller Address is required.');
        if (!this.sellerEmail.trim() || !/^\S+@\S+\.\S+$/.test(this.sellerEmail))
            this.errorMessages.push('Valid Seller Email is required.');
        if (!this.sellerPhone.trim() || !/^\+(\d{2})\d{10,}$/.test(this.sellerPhone))
            this.errorMessages.push('Valid 10-digit Seller Phone is required.');
        if (!this.transactionType) this.errorMessages.push('Transaction Type is required.');
        if (this.transactionType === 'Lease' && (!this.leaseTenure || isNaN(this.leaseTenure) || this.leaseTenure <= 0))
            this.errorMessages.push('Valid Lease Tenure is required when transaction type is Lease.');

        return this.errorMessages.length === 0;
    }

    connectedCallback() {
        document.addEventListener('TandCDocuSignAgreed', this.tandcAgreed, true);
    }
    disconnectedCallback() {
        document.removeEventListener('TandCDocuSignAgreed', this.tandcAgreed, true);
    }

    tandcAgreed = (event) => {
        console.log('here')
        const productDetails = {
            productTitle: this.productTitle,
            productDescription: this.productDescription,
            category: this.category,
            productPrice: this.productPrice,
            sellerName: this.sellerName,
            sellerAddress: this.sellerAddress,
            sellerEmail: this.sellerEmail,
            sellerPhone: this.sellerPhone,
            transactionType: this.transactionType,
            leaseTenure: this.leaseTenure
        };
        submitProduct({ productDetails })
            .then(res => {
                this.showModal = true;
                this.spinner = false;
                this.trackingId = res.Name;
                this.resetForm();
                sendAgreementForSignature({ recordId: res.Id, recipientEmail: res.SellerEmail, recipientName: res.SellerName })
            })
            .catch((error) => {
                console.log(error)
            });

    }

    // Handle form submission
    handleSubmit() {
        if (this.validateForm()) {
            this.spinner = true;
            this.errorMessages = [];
            var today = new Date();
            var dd = String(today.getDate()).padStart(2, '0');
            var mm = String(today.getMonth() + 1).padStart(2, '0'); //January is 0!
            var yyyy = today.getFullYear();
            today = mm + '/' + dd + '/' + yyyy;
            document.dispatchEvent( new CustomEvent('openAgeeTandCDocuSignCLick', { detail: { 'SellerName': this.sellerName, 'SellerEmail': this.sellerEmail, 'Date': today } }));
        } else {
            console.log(this.errorMessages.join('\n'));
        }
    }

    // Reset the form
    resetForm() {
        this.productTitle = '';
        this.productDescription = '';
        this.category = '';
        this.productPrice = '';
        this.sellerName = '';
        this.sellerAddress = '';
        this.sellerEmail = '';
        this.sellerPhone = '';
        this.transactionType = '';
        this.leaseTenure = '';
        this.showLeaseTenure = false;
        this.errorMessages = [];
    }
    closeModal() {
        this.showModal = false;
    }
}
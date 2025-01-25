public class DetailedAgreementPageController {
    // Properties
    public String agreementId { get; set; }
    public String productId { get; set; }
    public String agreementName { get; set; }
    public String currentDate { get; set; }
    public String buyerName { get; set; }
    public String buyerContact { get; set; }
    public String buyerAddress { get; set; }
    public String farmerName { get; set; }
    public String farmerContact { get; set; }
    public String farmerAddress { get; set; }
    public String amount { get; set; }
    public String paymentMethod { get; set; }
    public String paymentDueDate { get; set; }
    public String leasedUpto { get; set; }
    public Boolean isBuy { get; set; } 
    public Boolean isLease { get; set; }
    
    public String productName { get; set; }
    public String productDescription { get; set; }
    public String productPrice { get; set; }
    
    
    
    // Constructor
    public DetailedAgreementPageController() {
        // Fetch agreementId from VF page parameters
        productId = ApexPages.currentPage().getParameters().get('productId');
        agreementId = ApexPages.currentPage().getParameters().get('agreementId');
        
        // Fetch agreement details dynamically
        fetchAgreementDetails();
    }
    
    private void fetchAgreementDetails() {

        DocusignAgreementDetail__c agreement = [
            SELECT Name FROM DocusignAgreementDetail__c WHERE Id=:agreementId];

        Agrosphere_Market__c product = [
            Select Id,Category__c,For_Lease__c,
            Lease_tenure_in_months__c,Product_Description__c,
            Product_price__c, Product_Title__c,Seller_Address__c,
            Seller_Email__c, Seller_Name__c, Seller_Phone__c,Status__c
            FROM Agrosphere_Market__c WHERE Id =:productId];
        
        // Example Data (Replace with actual data or parameters)
        productName = product.Product_Title__c;
        productDescription = product.Product_Description__c;
        productPrice = product.Product_price__c;
        
        agreementName = agreement.Name ;
        currentDate = String.valueOf(System.today());
        buyerName = UserInfo.getName();
        buyerContact = UserInfo.getUserEmail();
        buyerAddress = '123 Main Street, Springfield';
        farmerName = product.Seller_Name__c;
        farmerContact = product.Seller_Email__c;
        farmerAddress = product.Seller_Address__c;
        amount = 'Rs. 500';
        paymentMethod = 'Bank Transfer';
        paymentDueDate = String.valueOf(System.today().addDays(7));
        isBuy = !product.For_Lease__c; 
        isLease = product.For_Lease__c;
        if(isLease){
            leasedUpto = String.valueOf(Date.today().addMonths(Integer.valueOf(product.Lease_tenure_in_months__c))); 
        }
    }
}
/**
* @File Name : DocusignWebhook.cls
* @Description :
* @Author :
* @Last Modified By :
* @Last Modified On : January 1, 2025
* @Modification Log :
*==============================================================================
* Ver | Date | Author | Modification
*==============================================================================
* 1.0 | January 1, 2025 |   | Initial Version
**/
public class ProductApprovalController {
    // Properties
    public String todayDate { get; set; }
    public String farmerName { get; set; }
    public String farmerContact { get; set; }
    public String farmerAddress { get; set; }
    
    public String productName { get; set; }
    public String productDescription { get; set; }
    public String productPrice { get; set; }
	public String productId { get; set; }
    public String marketId { get; set; }
    public String transactionType { get; set; }
    public Decimal Leaseduration { get; set; }
    public Boolean isLease { get; set; }
    
    // Constructor
    public ProductApprovalController() {
       	todayDate = String.valueOf(System.today());
        productId = ApexPages.currentPage().getParameters().get('productId');
		Agrosphere_Market__c agroMarket = [
            SELECT Id,Name,Category__c,For_Lease__c,
            Lease_tenure_in_months__c,Product_Description__c,
            Product_price__c, Product_Title__c,Seller_Address__c,
            Seller_Email__c, Seller_Name__c, Seller_Phone__c,Status__c
            FROM Agrosphere_Market__c WHERE Id =:productId];

        marketId = agroMarket.Name;
        Leaseduration = agroMarket.Lease_tenure_in_months__c;
        isLease = agroMarket.For_Lease__c;
        transactionType = isLease ? 'For lease' : 'For sell';
        farmerName = agroMarket.Seller_Name__c;
        farmerContact = agroMarket.Seller_Email__c + ' / '+agroMarket.Seller_Phone__c;
        farmerAddress =  agroMarket.Seller_Address__c;
        productName = agroMarket.Product_Title__c;
        productDescription = agroMarket.Product_Description__c;
        productPrice = agroMarket.Product_price__c;
    }
}
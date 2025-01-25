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


public without sharing class DocusignCalloutController {
    
    
    @AuraEnabled
    public static String docusign_esign(String productId,String agreementId){
        
        List<Agrosphere_Market__c> agroMarket = [Select Id,Category__c,For_Lease__c,Lease_tenure_in_months__c,Product_Description__c,Product_price__c, Product_Title__c,Seller_Address__c,Seller_Email__c, Seller_Name__c, Seller_Phone__c,Status__c from Agrosphere_Market__c Where Id =:productId];

        
        String buyerEmail= UserInfo.getUserEmail();
        String buyerName = UserInfo.getName();
        String subject= 'Agreement of buying '+agroMarket[0].Product_Title__c+ ' from AGROSPHERE';
        Pagereference PDFval = Page.AgrosphereDetailedAgreementPage;
        PDFval.getParameters().put('productId', agroMarket[0].Id);
        PDFval.getParameters().put('agreementId', agreementId);
        String documentBase64 = EncodingUtil.base64Encode(PDFval.getContentAsPDF());
        // Step 2: Create the request body
        Map<String, Object> payload = new Map<String, Object>();
        payload.put('emailSubject', subject);
        payload.put('status', 'sent');
        
        // Define recipients
        List<Object> signers = new List<Object>();
        String farmerEmail = agroMarket[0].Seller_Email__c;
        String farmerName = agroMarket[0].Seller_Name__c;
        // Buyer
        Map<String, Object> buyer = new Map<String, Object>();
        buyer.put('email', buyerEmail);
        buyer.put('name', buyerName);
        buyer.put('recipientId', '1');
        buyer.put('routingOrder', '1');
        buyer.put('clientUserId', '1');
        buyer.put('roleName', 'Buyer');
        buyer.put('tabs', new Map<String, Object>{
            'signHereTabs' => new List<Object>{
                new Map<String, Object>{
                    'anchorString' => 'Buyer Signature',
                        'anchorXOffset' => '-10',
                        'anchorYOffset' => '-30',
                        'anchorUnits' => 'pixels',
                        'documentId' => '1',
                        'pageNumber' => '1'
                        }
            }
        });
        signers.add(buyer);
        
        // Farmer
        Map<String, Object> farmer = new Map<String, Object>();
        farmer.put('email', farmerEmail);
        farmer.put('name', farmerName);
        farmer.put('recipientId', '2');
        farmer.put('routingOrder', '2');
        farmer.put('roleName', 'Farmer');
        farmer.put('tabs', new Map<String, Object>{
            'signHereTabs' => new List<Object>{
                new Map<String, Object>{
                    'anchorString' => 'Farmer Signature',
                        'anchorXOffset' => '-10',
                        'anchorYOffset' => '-30',
                        'anchorUnits' => 'pixels',
                        'documentId' => '1',
                        'pageNumber' => '1'
                        }
            }
        });
        signers.add(farmer);
        
        payload.put('recipients', new Map<String, Object>{'signers' => signers});
        
        // Define document
        List<Object> documents = new List<Object>();
        documents.add(new Map<String, Object>{
            'documentId' => '1',
                'name' => 'Agreement.pdf',
                'fileExtension' => 'pdf',
                'documentBase64' => documentBase64
                });
        payload.put('documents', documents);
        
        HttpRequest req = new HttpRequest();
        req.setEndpoint('callout:Docusign_Esign/restapi/v2.1/accounts/31571403/envelopes');
        req.setMethod('POST');
        req.setHeader('Content-Type','application/json');
        req.setBody(JSON.serialize(payload));
        Http http = new Http();
        HttpResponse res = http.send(req);
        Map<String, Object> responseBodyMap = (Map<String, Object>) JSON.deserializeUntyped(res.getBody());
        
        return getSigningUrl((String)responseBodyMap.get('envelopeId'),agreementId);
        
    }
    
    public static void checkEnvelopeStatus(String envelopeId) {
        try {            
            
            Http http = new Http();
            HttpRequest request = new HttpRequest();
            request.setEndpoint('callout:Docusign_Esign/restapi/v2.1/accounts/31571403/envelopes/'+envelopeId);
            request.setMethod('GET');
            request.setHeader('Content-Type', 'application/json');
            
            HttpResponse response = http.send(request);
            system.debug(response.getBody());
            if (response.getStatusCode() == 200) {
                Map<String, Object> responseBody = (Map<String, Object>) JSON.deserializeUntyped(response.getBody());
                String status = (String) responseBody.get('status');
                String statusDateTime = (String) responseBody.get('statusChangedDateTime');
                
                System.debug('Envelope Status: ' + status);
                System.debug('Status Changed On: ' + statusDateTime);
            } else {
                System.debug('Failed to get envelope status. Status: ' + response.getStatus() + ', Response: ' + response.getBody());
            }
        } catch (Exception ex) {
            System.debug('Error: ' + ex.getMessage());
        }
    }
    
    //@future(callout=true)
    public static void fetchSignedDocument(String envelopeId, String parentId) {
        try {
            // Step 1: Define the API endpoint and access token
            String endpoint = 'callout:Docusign_Esign/restapi/v2.1/accounts/31571403/envelopes/' + envelopeId + '/documents/combined';
            
            // Step 2: Set up the HTTP request
            Http http = new Http();
            HttpRequest request = new HttpRequest();
            request.setEndpoint(endpoint);
            request.setMethod('GET');
            request.setHeader('Content-Type', 'application/json');
            
            // Step 3: Send the HTTP request
            HttpResponse response = http.send(request);
            
            // Step 4: Handle the response
            if (response.getStatusCode() == 200) {
                // Get the signed document as a Blob
                Blob pdfBlob = response.getBodyAsBlob();
                // Step 5: Save the document to Salesforce as a ContentVersion record
                
                
                List<ContentDocumentLink> chckforDocuments = [Select id from ContentDocumentLink where LinkedEntityId =:parentId];
                //List<DocusignAgreementDetail__c> docAgree = [Select Id, SignedDocumentURL__c from DocusignAgreementDetail__c where Id =:parentId];
                
                ContentVersion objCV = new ContentVersion(Title = 'Agrosphere Signed Document - ' + envelopeId,PathOnClient = 'SignedDocument.pdf',VersionData = pdfBlob,firstPublishLocationId=UserInfo.getUserId() );
                insert objCV;
                objCV = [SELECT ContentDocumentId FROM ContentVersion WHERE Id =: objCV.Id];
                
                if(!chckforDocuments.isEmpty()){
                    ContentDocumentLink objCDL = new ContentDocumentLink(Id=chckforDocuments[0].Id,ContentDocumentId = objCV.ContentDocumentId,LinkedEntityId = parentId,Visibility = 'AllUsers');
                    update objCDL;
                }else{
                    ContentDocumentLink objCDL = new ContentDocumentLink(ContentDocumentId = objCV.ContentDocumentId,LinkedEntityId = parentId,Visibility = 'AllUsers');
                    insert objCDL;
                }    
                
                System.debug('Signed document saved successfully.');
            } else {
                System.debug('Failed to fetch signed document. Status: ' + response.getStatus() + ', Response: ' + response.getBody());
            }
        } catch (Exception ex) {
            System.debug('Error: ' + ex.getMessage());
        }
    }    
    @AuraEnabled
    public static String getSigningUrl(String envelopeId,String agreementId) {
        try {
            // Step 1: Define the DocuSign API endpoints
            String baseUrl = 'callout:Docusign_Esign/restapi/v2.1/accounts/31571403/envelopes/'+ envelopeId + '/views/recipient';
            
            // Step 2: Create the JSON payload for recipient view
            Map<String, Object> recipientView = new Map<String, Object>();
            recipientView.put('returnUrl', 'https://agno-dev-ed.develop.my.site.com/agrospehre/s/docusign-completed?envelopeId='+envelopeId); // Redirect after signing
            recipientView.put('authenticationMethod', 'none');
            recipientView.put('email', UserInfo.getUserEmail());
            recipientView.put('userName', UserInfo.getName());
            recipientView.put('clientUserId', '1'); // Unique ID for recipient to enable embedded signing
            
            // Convert the payload to JSON
            String requestBody = JSON.serialize(recipientView);
            
            // Step 3: Set up the HTTP request
            HttpRequest request = new HttpRequest();
            request.setEndpoint(baseUrl);
            request.setMethod('POST');
            request.setHeader('Content-Type', 'application/json');
            request.setBody(requestBody);
            
            // Step 4: Send the HTTP request
            Http http = new Http();
            HttpResponse response = http.send(request);
            System.debug(response.getBody());
            // Step 5: Handle the response
            insertDocuSignEnvelop(envelopeId,agreementId);
            if (response.getStatusCode() == 201) {
                Map<String, Object> responseBody = (Map<String, Object>) JSON.deserializeUntyped(response.getBody());
                String signingUrl = (String) responseBody.get('url');
                return signingUrl; // Return the signing URL
            } else {
                System.debug('Failed to create signing view. Status: ' + response.getStatus());
                System.debug('Response: ' + response.getBody());
                return null;
            }
        } catch (Exception ex) {
            System.debug('Error: ' + ex.getMessage());
            return null;
        }
    }
    
    @future
    public static void insertDocuSignEnvelop(String envId,String agreementId){
        if(agreementId != ''){
            DocusignAgreementDetail__c isDocExist = [select Id,Envelop_Id__c,Buyer_Sent__c,Buyer__c from DocusignAgreementDetail__c where Id=:agreementId];
            isDocExist.Envelop_Id__c = envId;
            update isDocExist;
        }
    }

    @Future(Callout=true)
    public static void sendAgreementForSignature(String recordId, String recipientEmail, String recipientName) {
        // Prepare the document (replace with actual document generation logic)
       Blob agreementPdf = generateAgreementPdf(recordId);
        
        // Base64 encode the PDF
        String base64Doc = EncodingUtil.base64Encode(agreementPdf);
        
        // Create the envelope request
        Map<String, Object> envelopeRequest = new Map<String, Object>{
            'emailSubject' => 'Product approval request',
            'documents' => new List<Object>{
                new Map<String, Object>{
                    'documentBase64' => base64Doc,
                    'name' => 'Approval of Product.pdf',
                    'fileExtension' => 'pdf',
                    'documentId' => '1'
                }
            },
            'recipients' => new Map<String, Object>{
                'signers' => new List<Object>{
                    new Map<String, Object>{
                        'email' => recipientEmail,
                        'name' => recipientName,
                        'recipientId' => '1',
                        'tabs' => new Map<String, Object>{
                            'signHereTabs' => new List<Object>{
                                new Map<String, Object>{
                                    'anchorString' => 'Signature', // Match text in the document
                                    'anchorXOffset' => '80',
                                    'anchorYOffset' => '0',
                                    'anchorUnits' => 'pixels',
                                    'anchorIgnoreIfNotPresent' => 'true',
                                    'anchorCaseSensitive' => 'false'
                                }
                            },
                            'dateSignedTabs' => new List<Object>{
                                new Map<String, Object>{
                                    'anchorString' => 'Signed On',
                                    'anchorXOffset' => '50',
                                    'anchorYOffset' => '0',
                                    'anchorUnits' => 'pixels',
                                    'anchorIgnoreIfNotPresent' => 'true',
                                    'anchorCaseSensitive' => 'false'
                                }
                            }
                        }
                    }
                }
            },
            'status' => 'sent' // Send immediately
        };



        HttpRequest req = new HttpRequest();
        req.setEndpoint('callout:Docusign_Esign/restapi/v2.1/accounts/31571403/envelopes');
        req.setMethod('POST');
        req.setHeader('Content-Type','application/json');
        req.setBody(JSON.serialize(envelopeRequest));
        Http http = new Http();
        HttpResponse res = http.send(req);
        Map<String, Object> responseBodyMap = (Map<String, Object>) JSON.deserializeUntyped(res.getBody());
        updateMarketProduct((String)responseBodyMap.get('envelopeId'),recordId);
        //(String)responseBodyMap.get('envelopeId')
    }
    
    // Generate agreement PDF (placeholder, replace with actual VF page rendering)
    private static Blob generateAgreementPdf(String recordId) {
        // Replace with your VF page URL
        String vfPageUrl = 'https://agno-dev-ed.develop.my.site.com/agrospehre/apex/AgrosphereProductApproval?productId=' + recordId;
        PageReference pageRef = new PageReference(vfPageUrl);
        return pageRef.getContentAsPDF();
    }

    public static void updateMarketProduct(String envId,String productId){
        if(productId != ''){
            Agrosphere_Market__c agroMarket = [SELECT Id,Verification_Env_Id__c FROM Agrosphere_Market__c WHERE Id =:productId];
            agroMarket.Verification_Env_Id__c = envId;
            update agroMarket;
        }
    }

    @future(callout=true)
    public static void voidEnvelopesInBulk(String envelopeId) {
        
        HttpRequest req = new HttpRequest();
        req.setEndpoint('callout:Docusign_Esign/restapi/v2.1/accounts/31571403/envelopes/' + envelopeId);
        req.setMethod('PUT');
        req.setHeader('Content-Type','application/json');
        Map<String, Object> setBodyMap = new Map<String, Object>();
            setBodyMap.put('voidedReason', 'Buyer did not sign within 1 hour.');
            setBodyMap.put('status', 'voided'); 
            String requestBody = JSON.serialize(setBodyMap);
        req.setBody(requestBody);
        Http http = new Http();
        HttpResponse res = http.send(req);
        Map<String, Object> responseBodyMap = (Map<String, Object>) JSON.deserializeUntyped(res.getBody());
    }

    @AuraEnabled
    public static Map<String, Object> createWebFormInstance(String clientUserId) {

        String endpoint = 'callout:Docusign_Webforms/api/webforms/v1.1/accounts/2f3fb936-de7c-42ce-b946-f7041ff3b123/forms/ad7e2be4-8200-4961-932b-0e8ff2aa2dc7/instances';
        Map<String, Object> requestBody = new Map<String, Object>();
        requestBody.put('clientUserId', clientUserId);
        requestBody.put('returnUrl', 'https://agno-dev-ed.develop.my.site.com/agrospehre/s/docusign-completed?envelopeId='+clientUserId);
        requestBody.put('formValues', new Map<String, Object>{
            'User_email' => clientUserId
        });
        
        HttpRequest request = new HttpRequest();
        request.setEndpoint(endpoint);
        request.setMethod('POST');
        request.setHeader('Content-Type', 'application/json');
        request.setBody(JSON.serialize(requestBody));

        Http http = new Http();
        HttpResponse response;
        response = http.send(request);

        if (response.getStatusCode() == 201 || response.getStatusCode() == 200) {
            Map<String, Object> responseMap = (Map<String, Object>) JSON.deserializeUntyped(response.getBody());
            return responseMap;
        } else {
            throw new CalloutException('Failed to create WebForm instance. Status Code: ' + response.getStatusCode() + ', Response: ' + response.getBody());
        }
    }

    @AuraEnabled
    public static Map<String, Object> getInstanceStatus(String instanceId) {
        String endpoint =  'callout:Docusign_Webforms/api/webforms/v1.1/accounts/2f3fb936-de7c-42ce-b946-f7041ff3b123/forms/ad7e2be4-8200-4961-932b-0e8ff2aa2dc7/instances/'+instanceId;
        HttpRequest request = new HttpRequest();
        request.setEndpoint(endpoint);
        request.setMethod('GET');
        request.setHeader('Content-Type', 'application/json');

        Http http = new Http();
        HttpResponse response;
        response = http.send(request);
        
        if (response.getStatusCode() == 201 || response.getStatusCode() == 200) {
            Map<String, Object> responseMap = (Map<String, Object>) JSON.deserializeUntyped(response.getBody());
            return responseMap;
        } else {
            throw new CalloutException('Failed to get WebForm instance. Status Code: ' + response.getStatusCode() + ', Response: ' + response.getBody());
        }
    }

    @AuraEnabled
    public static Map<String, Object> refreshInstanceStatus(String instanceId) {
        String endpoint =  'callout:Docusign_Webforms/api/webforms/v1.1/accounts/2f3fb936-de7c-42ce-b946-f7041ff3b123/forms/ad7e2be4-8200-4961-932b-0e8ff2aa2dc7/instances/'+instanceId+'/refresh';
        HttpRequest request = new HttpRequest();
        request.setEndpoint(endpoint);
        request.setMethod('POST');
        request.setHeader('Content-Type', 'application/json');

        Http http = new Http();
        HttpResponse response;
        response = http.send(request);
        
        if (response.getStatusCode() == 201 || response.getStatusCode() == 200) {
            Map<String, Object> responseMap = (Map<String, Object>) JSON.deserializeUntyped(response.getBody());
            return responseMap;
        } else {
            throw new CalloutException('Failed to get WebForm instance. Status Code: ' + response.getStatusCode() + ', Response: ' + response.getBody());
        }
    }
    


}
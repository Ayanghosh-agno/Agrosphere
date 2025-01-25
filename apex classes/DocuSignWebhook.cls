/**
* @File Name : DocusignWebhook.cls
* @Description :
* @Author :
* @Last Modified By :
* @Last Modified On : January 9, 2025
* @Modification Log :
*==============================================================================
* Ver | Date | Author | Modification
*==============================================================================
* 1.0 | January 9, 2025 |   | Initial Version
**/

@RestResource(urlMapping='/docusignWebhook')
global without sharing class DocuSignWebhook {
    @HttpPost
    global static void handleWebhook() {
        RestRequest req = RestContext.request;
        String requestBody = req.requestBody.toString();
        System.debug('Received DocuSign Webhook: ' + requestBody);
        Map<String, Object> payload = (Map<String, Object>) JSON.deserializeUntyped(requestBody);
        updateDocAgreementStat(payload);
        system.debug(payload);
    }

    public static void updateDocAgreementStat(Map<String, Object> payload){
        Map<String,Object> payloadData = (Map<String,Object>) payload.get('data');
        Map<String,Object> envelopSummary = (Map<String,Object>) payloadData.get('envelopeSummary');
        String emailSubject = (String) envelopSummary.get('emailSubject');
        String envelopStatus = (String) envelopSummary.get('status');
        String recipientId = (String) payloadData.get('recipientId');

        Map<String, Object> recipients = (Map<String, Object>) envelopSummary.get('recipients');
        List<Object> signers = (List<Object>) recipients.get('signers');

        String envelopId = (String)payloadData.get('envelopeId');
        List<DocusignAgreementDetail__c> docAgree = [Select Id,Buyer_Sent__c,Buyer_Signed__c,Buyer_Viewed__c,Seller_Sent__c,Seller_Signed__c,Seller_Viewed__c,Signing_Completed_By_Both_Party__c from DocusignAgreementDetail__c where Envelop_Id__c =:envelopId];
        if(!docAgree.isEmpty()){
            if(envelopStatus == 'completed'){
            docAgree[0].Signing_Completed_By_Both_Party__c = true;
            docAgree[0].Seller_Signed__c = true;
            docAgree[0].Seller_Viewed__c = true;
            docAgree[0].Seller_Sent__c = true;
            DocusignCalloutController.fetchSignedDocument(envelopId,docAgree[0].Id);
        }else{
            Boolean isBuyer = false;
            Boolean isSent = false;
            Boolean isDelivered = false;
            Boolean isSigned = false;
            for (Object signerObj : signers) {
                Map<String, Object> signer = (Map<String, Object>) signerObj;
                String signerRecipientid = (String) signer.get('recipientId');
                String roleName = (String) signer.get('roleName');
                String status = (String) signer.get('status');

                
                if(roleName == 'Buyer' && recipientId == signerRecipientid){
                    isBuyer = true;
                    if(status == 'completed'){
                        isSigned = true;
                    }else if(status == 'delivered'){
                        isDelivered = true;
                    }else{
                        isSent = true;
                    }
                }

                if(roleName == 'Farmer' && recipientId == signerRecipientid){
                    isBuyer = false;
                    if(status == 'completed'){
                        isSigned = true;
                    }else if(status == 'delivered'){
                        isDelivered = true;
                    }else{
                        isSent = true;
                    }
                }
            } 
            if(isBuyer){
                if(isSent){
                    docAgree[0].Buyer_Sent__c = true;
                    docAgree[0].Buyer_Signed__c = false;
                    docAgree[0].Buyer_Viewed__c = false;

                }else if(isDelivered){
                   
                   //DocusignCalloutController.fetchSignedDocument('25341e96-7f2c-46ba-a31e-1febe04fd4b0','a0FJ1000002bFwUMAU');
                    docAgree[0].Buyer_Sent__c = true;
                    docAgree[0].Buyer_Signed__c = false;
                    docAgree[0].Buyer_Viewed__c = true;

                }else{
                    docAgree[0].Buyer_Sent__c = true;
                    docAgree[0].Buyer_Signed__c = true;
                    docAgree[0].Buyer_Viewed__c = true;
                }
            }else{
                if(isSent){
                    docAgree[0].Seller_Sent__c = true;
                    docAgree[0].Seller_Signed__c = false;
                    docAgree[0].Seller_Viewed__c = false;

                }else if(isDelivered){
                    docAgree[0].Seller_Sent__c = true;
                    docAgree[0].Seller_Signed__c = false;
                    docAgree[0].Seller_Viewed__c = true;

                }else{
                    docAgree[0].Seller_Sent__c = true;
                    docAgree[0].Seller_Signed__c = true;
                    docAgree[0].Seller_Viewed__c = true;
                }
            }

        }   
        update docAgree;
        }
        
        if(emailSubject=='Complete with Docusign: User registration - Agrosphere' && envelopStatus =='completed'){
            //registration form operations.
            Map<String, Object> signer = (Map<String, Object>) signers[0];
            String newUserEmail = (String) signer.get('email');
            Contact c = [SELECT Id,EnvelopId__c FROM Contact where Email = :newUserEmail limit 1];
            c.EnvelopId__c = envelopId;
            update c;
            DocusignCalloutController.fetchSignedDocument(envelopId,c.Id);
        }



        if(emailSubject=='Product approval request' && envelopStatus =='completed'){
            List<Agrosphere_Market__c> agroMarket = [SELECT Id,Seller_Phone__c,Seller_Name__c,Verification_Env_Id__c,Status__c FROM Agrosphere_Market__c WHERE Verification_Env_Id__c =:envelopId AND Status__c != 'Verified'];
            if(!agroMarket.isEmpty()){
                for(Agrosphere_Market__c eachProd : agroMarket){
                    eachProd.Status__c = 'Verified';
                }
                
                DocusignCalloutController.fetchSignedDocument(envelopId,agroMarket[0].Id);
                update agroMarket;
                AgrosphereController.notifiSeller((String) agroMarket[0].Seller_Phone__c,(String) agroMarket[0].Seller_Name__c,'productVerified');
            }
           
        }
        
    }
}
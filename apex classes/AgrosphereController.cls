/**
* @File Name : AgrosphereController.cls
* @Description :
* @Author :
* @Last Modified By :
* @Last Modified On : January 7, 2025
* @Modification Log :
*==============================================================================
* Ver | Date | Author | Modification
*==============================================================================
* 1.0 | January 7, 2025 |   | Initial Version
**/

public without sharing class AgrosphereController {
	@AuraEnabled(cacheable=true)
        public static String getSessionId() {
        return UserInfo.getSessionId();
    }

    private static String messageBodySelector(String bodyType,String personName){

        String bodyMsg = '';
        if(bodyType == 'productSubmitted'){
            bodyMsg ='Dear '+personName+', your product listing has been successfully submitted. Our team will review it shortly. Thank you for your contribution to AgroSphere! If you have any questions, feel free to contact us.';          
        }else if(bodyType == 'productVerified'){
            bodyMsg = 'Good news, '+personName+'! Your product listing has been verified and is now live on AgroSphere. You can now start receiving potential buyers. Thank you for your trust in AgroSphere!';
        }else if(bodyType == 'buyerAgreementViewed'){
            bodyMsg = 'Hello '+personName+', someone has viewed the agreement for your product on AgroSphere. Please stay tuned for further updates. If you have any questions, don\'t hesitate to reach out.';
        }else if(bodyType == 'buyerAgreementSignedForSeller'){
            bodyMsg ='Hi '+personName+', the buyer has signed the agreement for your product on AgroSphere. The document has now been sent to you for your confirmation. Please review and sign at your earliest convenience. Thank you for choosing AgroSphere!';
        }else if(bodyType == 'buyerAgreementSignedForBuyer'){
            bodyMsg = 'Hello '+personName+', your agreement for purchasing the product has been successfully signed. We are now awaiting confirmation from the seller. You will receive a final update soon. Thank you for using AgroSphere!';
        }else if(bodyType == 'sellerAgreementSignedForBuyer'){
            bodyMsg = 'Good news! The seller has confirmed the agreement for your product purchase. The transaction is now complete. You can go to the \'My Purchase\' section of your account to see the signed copy of the agreement. Thank you for being a part of AgroSphere!';
        }else if(bodyType == 'sellerAgreementSignedForSeller'){
            bodyMsg = 'Good news, '+personName+'! The agreement for your product has been signed by both the parties. The transaction is now completed. You will receive further instructions soon. Thank you for using AgroSphere!';
        }
        return bodyMsg;
    }



	@future(callout=true)
	public static void notifiSeller(String phoneNumber,String personName,String bodyType){
        String message = messageBodySelector(bodyType,personName);
        sendSmsRestAPI (phoneNumber,message);
    }

    private static void sendSmsRestAPI (String phoneNumber,String message){

        phoneNumber=phoneNumber.trim().right(10);
        phoneNumber='91'+phoneNumber;
        String api_key = 'b77c8a23';  // change with your api key
        String api_secret= 'VSKqC5yD8ZQ5zeTG'; // change with your api secret
        string fromNumber='9800374139';

        HttpRequest req = new HttpRequest();
        req.setEndpoint('https://rest.nexmo.com/sms/json');
        req.setMethod('POST'); 
        req.setHeader('Content-Type','application/json');
        req.setHeader('Content-Type','application/x-www-form-urlencoded');

        if(string.isNotBlank(fromNumber) && string.isNotBlank(phoneNumber) && string.isNotBlank(message))
        {
            string jsonString='from='+EncodingUtil.urlEncode(fromNumber, 'UTF-8')+'&text='+EncodingUtil.urlEncode(message, 'UTF-8')+
                '&to='+EncodingUtil.urlEncode(phoneNumber, 'UTF-8')
                +'&api_key='+EncodingUtil.urlEncode(api_key, 'UTF-8')+'&api_secret='+EncodingUtil.urlEncode(api_secret, 'UTF-8')+'';
            	req.setBody(jsonString);
            system.debug('jsonString:'+jsonString);
            try{
                Http http = new Http();
                HTTPResponse res = http.send(req);
                if(res.getStatusCode()==200)
                {
                    system.debug('SMS Sent to '+fromNumber);
                }
                else{
                    system.debug('SMS Failed to sent :'+fromNumber);
                }
            }
            catch(Exception e){
                System.debug(e.getMessage());
            } 
    	}

    }


        @AuraEnabled(cacheable=true)
        public static List<DocusignAgreementDetail__c> getAgreementsOfLoggedInUser(){
            List<DocusignAgreementDetail__c> docAgree = [Select Id,Product__r.Product_price__c,Product__r.Product_Title__c,Product__c,Buyer_Sent__c,Envelop_Id__c,Buyer_Signed__c,Buyer_Viewed__c,Seller_Sent__c,Seller_Signed__c,Seller_Viewed__c,Signing_Completed_By_Both_Party__c,CreatedDate from DocusignAgreementDetail__c where Buyer__c =:UserInfo.getUserId() AND isVoid__c = false];
            return docAgree;
        }
        @AuraEnabled
        public static String getDocumentUrl(String envelopeId){
            String docUrl ='';
            String docTitle = 'Agrosphere Signed Document - ' + envelopeId;
            List<DocusignAgreementDetail__c> docAgree = [Select Id, SignedDocumentURL__c from DocusignAgreementDetail__c where Envelop_Id__c =:envelopeId];

            List<ContentVersion> objCV = [Select Id from ContentVersion where Title =:docTitle];
            if(objCV.isEmpty()){
                DocusignCalloutController.fetchSignedDocument(envelopeId,docAgree[0].Id);
                objCV = [Select Id from ContentVersion where Title =:docTitle];
            }
            List<ContentDistribution> listCd = [Select id From ContentDistribution where ContentVersionId =:objCV[0].Id ];

            if(listCd.isEmpty()){
                
                
                ContentDistribution cd = new ContentDistribution();
                cd.Name = 'Agrosphere Signed Share - ' + envelopeId;
                cd.ContentVersionId = objCV[0].Id;
                cd.PreferencesAllowViewInBrowser= true;
                cd.PreferencesLinkLatestVersion=true;
                cd.PreferencesNotifyOnVisit=false;
                cd.PreferencesPasswordRequired=false;
                cd.PreferencesAllowOriginalDownload= true;
                insert cd;

                docUrl = [SELECT DistributionPublicUrl FROM ContentDistribution WHERE Id =: cd.Id].DistributionPublicUrl;
                docAgree[0].SignedDocumentURL__c = docUrl;
                update docAgree;

            }else{
               docUrl = docAgree[0].SignedDocumentURL__c;
            }

            return docUrl;
        }

        @AuraEnabled(cacheable=true)
        public static List<Agrosphere_Market__c> getMarketProducts(){
            List<String> statusList = new List<String>{'Verified','Agreement being reviewed'};
            List<Agrosphere_Market__c> agroMarket = [Select Id,Category__c,For_Lease__c,Lease_tenure_in_months__c,Product_Description__c,Product_price__c, Product_Title__c,Seller_Address__c,Seller_Email__c, Seller_Name__c, Seller_Phone__c,Status__c from Agrosphere_Market__c where Status__c IN :statusList];
            return agroMarket;
        }
        @AuraEnabled
        public static Id updateMarketProducts(String productId){
            List<Agrosphere_Market__c> agroMarket = [Select Id, Status__c from Agrosphere_Market__c where Id =: productId];
            agroMarket[0].Status__c = 'Agreement being reviewed';
            update agroMarket;
            DocusignAgreementDetail__c docAgree = new DocusignAgreementDetail__c (Buyer_Sent__c=true,Buyer__c=UserInfo.getUserId(),Product__c=agroMarket[0].Id);
            insert docAgree;
            return docAgree.Id;
        }

    @AuraEnabled
    public static Map<String,Object> submitProduct(Map<String, Object> productDetails) {
            Agrosphere_Market__c newProduct = new Agrosphere_Market__c();
            newProduct.Product_Title__c = (String) productDetails.get('productTitle');
            newProduct.Product_Description__c = (String) productDetails.get('productDescription');
            newProduct.Product_price__c = (String) productDetails.get('productPrice');
            newProduct.Category__c = (String) productDetails.get('category');
            newProduct.Seller_Name__c = (String) productDetails.get('sellerName');
            newProduct.Seller_Address__c = (String) productDetails.get('sellerAddress');
            newProduct.Seller_Email__c = (String) productDetails.get('sellerEmail');
            newProduct.Seller_Phone__c = (String) productDetails.get('sellerPhone');
            newProduct.For_Lease__c = (String) productDetails.get('transactionType') == 'Lease';
            newProduct.Lease_tenure_in_months__c =(String)productDetails.get('leaseTenure') != '' ? Integer.valueOf(productDetails.get('leaseTenure')) : 0;
            newProduct.Status__c = 'Verifying';
            insert newProduct;
            return new Map<String,Object> {'SellerName'=> productDetails.get('sellerName'),'SellerEmail'=> productDetails.get('sellerPhone'),'Id'=>newProduct.Id, 'Name'=> [SELECT Name FROM Agrosphere_Market__c WHERE Id =:newProduct.Id].Name};
    }

    @AuraEnabled
    public static void sendAgreementForSignature(String recordId, String recipientEmail, String recipientName) {
        notifiSeller(recipientEmail,recipientName,'productSubmitted');
        Contact admin = [SELECT Id,Name,Email FROM Contact where Department ='Agrosphere Product Approver' Limit 1];
        DocusignCalloutController.sendAgreementForSignature(recordId,admin.Email,admin.Name);
    }

    public static void cancelUnsignedAgreements() {
		List<DocusignAgreementDetail__c> agreementsToCancel = [
			SELECT Id,Product__c,Buyer_Sent__c,Envelop_Id__c,
			Buyer_Signed__c,Void_Reason__c,isVoid__c
				FROM DocusignAgreementDetail__c 
				WHERE Buyer_Signed__c = false AND isVoid__c = false
				AND CreatedDate <= :System.now().addHours(-1)];
		
		if (!agreementsToCancel.isEmpty()) {
			List<String> envelopeIds = new List<String>();
			List<String> productIds = new List<String>();
			for (DocusignAgreementDetail__c agreement : agreementsToCancel) {
				if (String.isNotBlank(agreement.Envelop_Id__c)) {
					envelopeIds.add(agreement.Envelop_Id__c);
				}
                if (String.isNotBlank(agreement.Product__c)) {
					productIds.add(agreement.Product__c);
				}
                agreement.Void_Reason__c = 'Buyer did not sign within 1 hour.';
                agreement.isVoid__c = true;
			}

            update agreementsToCancel;

			if (!productIds.isEmpty()) {
				List<Agrosphere_Market__c> agroMarket = [SELECT Id,Status__c from Agrosphere_Market__c where Id IN :productIds];
				for(Agrosphere_Market__c eachProd : agroMarket){
					eachProd.Status__c = 'Verified';
				}
				if (!agroMarket.isEmpty()) {
					update agroMarket;
				}

			}

			if (!envelopeIds.isEmpty()) {

				try {
                    for(String eachId : envelopeIds){
                        DocusignCalloutController.voidEnvelopesInBulk(eachId);
                    }
					
					System.debug('Successfully sent bulk void request for envelopes.');
				} catch (Exception e) {
					System.debug('Error voiding envelopes in bulk: ' + e.getMessage());
				}
			} else {
				System.debug('No valid envelope IDs found.');
			}
		} else {
			System.debug('No agreements found that meet the criteria.');
		}
	}

    @AuraEnabled
    public static String registerUser(String firstName, String lastName, String username, String email, String address,String phone){
            String communityNickname = firstName;
            Set<String> communityNicknameSet = new Set<String>();
            for(User usr : [Select Id, CommunityNickname From User Where CommunityNickname != null]){
                communityNicknameSet.add(usr.CommunityNickname);
            }

            String uniqueCommunityNickName;
            if(communityNicknameSet.isEmpty()){
                if(communityNickname.length() > 4){
                    uniqueCommunityNickName = communityNickname.substring(0, 4) + String.valueOf( Integer.valueOf(Math.random() * 10000) );
                } else {
                    uniqueCommunityNickName = communityNickname + String.valueOf( Integer.valueOf(Math.random() * 10000) );
                }
            } else {
                for(Integer i=1; i <= 9999 ; i++){
                    if(communityNickname.length() > 4){
                        uniqueCommunityNickName = communityNickname.substring(0, 4) + String.valueOf( Integer.valueOf(Math.random() * 10000) );
                    } else {
                        uniqueCommunityNickName = communityNickname + String.valueOf( Integer.valueOf(Math.random() * 10000) );
                    }
                    if(!communityNicknameSet.contains(uniqueCommunityNickName)){
                        break;
                    }
                }
            }
            
            User u = new User();
            u.firstName = firstName;
            u.lastName = lastName;
            u.Username = username;
            u.Email = email;
            u.MobilePhone = phone;
            u.CommunityNickname = uniqueCommunityNickName;   
            u.User_Address__c = address;     
            String accountId='001J100000Rs2sPIAR';
            String userId = Site.createPortalUser(u, accountId, '');
            if (userId != null) {              
                //String emailResult = sendWelcomeMail(u, userId);             
                    return '/CheckPasswordResetEmail';
            }
            return 'false';
    }

    @AuraEnabled
    public static boolean isEmailExist(String username){
        try {
            List<User> userList = new List<User>();
            userList = [Select Id, Name From User Where Username = :username];
            return !userList.isEmpty();
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }

    @AuraEnabled
    public static string sendWelcomeMail(User usr, String userId){
            Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
            List<EmailTemplate> welcomeTemplate = new List<EmailTemplate>([Select Id from EmailTemplate where name = 'Welcome Email Agrosphere']);
            mail.setSenderDisplayName('Agrosphere');
            mail.setTargetObjectId(userId);
            mail.setTemplateId(welcomeTemplate[0].Id);
            mail.setSaveAsActivity(false);
            Messaging.sendEmail( new List<Messaging.SingleEmailMessage>{mail} );
            return 'success';
    }

    @AuraEnabled(cacheable=true)
    public static SensorDataDisplay fetchLatestSensorData (){
        List<Agrosphere_24_Hour_Data__c> agrosphereDaily = [SELECT Id,Atmosphere_Temperature__c,Atmosphere_Humidity__c,
                                                                Soil_Phosphorus__c,Rain_Percentage__c,Soil_Temperature__c,Light_Intensity__c,
                                                                Soil_Potassium__c,Soil_Electric_Conductivity__c,Soil_Ph__c,Soil_Nitrogen__c,
                                                                Soil_Moisture_Percentage__c,Transmitter_Battery__c,CreatedDate
                                                                FROM Agrosphere_24_Hour_Data__c ORDER BY CreatedDate Desc limit 1];

        List<AggregateResult> results = [ SELECT AVG(Atmosphere_Temperature__c) avgAtmTemp, AVG(Atmosphere_Humidity__c) avgAtmHum,
                                                AVG(Soil_Phosphorus__c) avgSoilP,AVG(Rain_Percentage__c) avgRain, AVG(Soil_Temperature__c) avgSoilT,
                                                AVG(Light_Intensity__c) avgLight,AVG(Soil_Potassium__c) avgSoilK, AVG(Soil_Electric_Conductivity__c) avgSoilEC,
                                                AVG(Soil_Ph__c) avgSoilPh, AVG(Soil_Nitrogen__c) avgSoilN, AVG(Soil_Moisture_Percentage__c) avgSoilM ,
                                                AVG(Transmitter_Battery__c) avgTransBat 
                                                FROM Agrosphere_daily_logs__c]; //WHERE CreatedDate < LAST_N_DAYS:30
                                                
        Agrosphere_daily_logs__c agrosphere = new Agrosphere_daily_logs__c();
                agrosphere.Atmosphere_Temperature__c= (Decimal) results[0].get('avgAtmTemp');
                agrosphere.Atmosphere_Humidity__c = (Decimal) results[0].get('avgAtmHum');	
                agrosphere.Soil_Phosphorus__c = (Decimal) results[0].get('avgSoilP');
                agrosphere.Rain_Percentage__c= (Decimal) results[0].get('avgRain');
                agrosphere.Soil_Temperature__c= (Decimal) results[0].get('avgSoilT');
                agrosphere.Light_Intensity__c= (Decimal) results[0].get('avgLight');
                agrosphere.Soil_Potassium__c= (Decimal) results[0].get('avgSoilK');
                agrosphere.Soil_Electric_Conductivity__c= (Decimal) results[0].get('avgSoilEC');
                agrosphere.Soil_Ph__c= (Decimal) results[0].get('avgSoilPh');
                agrosphere.Soil_Nitrogen__c = (Decimal) results[0].get('avgSoilN');
                agrosphere.Soil_Moisture_Percentage__c = (Decimal) results[0].get('avgSoilM');
                agrosphere.Transmitter_Battery__c = (Decimal) results[0].get('avgTransBat');

        SensorDataDisplay agrosphereFieldDataDisplay = new SensorDataDisplay ();
        agrosphereFieldDataDisplay.monthAvg = agrosphere;
        agrosphereFieldDataDisplay.latestData = agrosphereDaily[0];
                                  
        return agrosphereFieldDataDisplay;
    }

    public class SensorDataDisplay{
        @AuraEnabled
        public Agrosphere_24_Hour_Data__c latestData { get; set; }
        @AuraEnabled
        public Agrosphere_daily_logs__c  monthAvg { get; set; }
    }

    @AuraEnabled
    public static String insertDeviceInContact(String deviceId){
        deviceId = 'Agro-Device-'+deviceId;
        List<Agrosphere_Device_List_Connection__c> agroDevice = [SELECT Id from Agrosphere_Device_List_Connection__c where Name = :deviceId];
        if(agroDevice.isEmpty()){
            return 'no device found !';
        }else{
            String contactId = [SELECT ContactId FROM User WHERE Id = :UserInfo.getUserId()].ContactId;
            if(String.isEmpty(contactId)){
                return 'site user can only add device !';
            }else{
                List<Contact> con = [SELECT Id,Agrosphere_Device__c FROM Contact where ID = :contactId];
                con[0].Agrosphere_Device__c = agroDevice[0].Id;
                update con;
                return 'success !';
            }
        }
    }
    @AuraEnabled
    public static void sendSensorNotification(Boolean isEmail, Boolean isPhone, String phoneNumber,String email,String localDateTime){
         List<Agrosphere_24_Hour_Data__c> agrosphereDaily = [SELECT Id,Atmosphere_Temperature__c,Atmosphere_Humidity__c,
         Soil_Phosphorus__c,Rain_Percentage__c,Soil_Temperature__c,Light_Intensity__c,
         Soil_Potassium__c,Soil_Electric_Conductivity__c,Soil_Ph__c,Soil_Nitrogen__c,
         Soil_Moisture_Percentage__c,Transmitter_Battery__c,CreatedDate
         FROM Agrosphere_24_Hour_Data__c ORDER BY CreatedDate Desc limit 1];
        if(isEmail){
            String contactId = [SELECT ContactId FROM User WHERE Id = :UserInfo.getUserId()].ContactId;
            EmailTemplate et = [SELECT Id,Subject, Body FROM EmailTemplate WHERE Name ='Agrosphere email update'];
            Messaging.SingleEmailMessage mymail = new Messaging.SingleEmailMessage();
            String[] toaddresses = new String[] {email}; 
            OrgWideEmailAddress[] owea = [select Id from OrgWideEmailAddress where Address ='debopriyamunu974@gmail.com'];
            mymail.setOrgWideEmailAddressId(owea.get(0).Id);
            mymail.setToAddresses(toAddresses);
            mymail.setWhatId(agrosphereDaily[0].Id);
            mymail.setTargetObjectId(contactId);
            mymail.setSaveAsActivity(false);
            mymail.setTemplateId(et.id);
            Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mymail });
        }
        if(isPhone){
            String message = 'Hello ' + UserInfo.getName() + ',\n\n' +
                            'Here\'s an update on your field’s conditions:\n' +
                            '- Atmosphere Temp: ' + agrosphereDaily[0].Atmosphere_Temperature__c + 'C \n' +
                            '- Atmosphere Humidity: ' + agrosphereDaily[0].Atmosphere_Humidity__c + '% \n' +
                            '- Light Intensity: ' + agrosphereDaily[0].Light_Intensity__c + 'LUX \n' +
                            '- Rain: ' + agrosphereDaily[0].Rain_Percentage__c + '% \n' +
                            '- Soil EC: ' +agrosphereDaily[0].Soil_Electric_Conductivity__c + 'u/cm \n' +
                            '- Soil Moisture: ' + agrosphereDaily[0].Soil_Moisture_Percentage__c + '% \n' +
                            '- Soil Nitrogen: ' + agrosphereDaily[0].Soil_Nitrogen__c + 'mg/Kg \n' +
                            '- Soil Phosphorus: ' + agrosphereDaily[0].Soil_Phosphorus__c + 'mg/Kg \n' +
                            '- Soil Potassium: ' + agrosphereDaily[0].Soil_Potassium__c + 'mg/Kg \n' +
                            '- Soil pH: ' + agrosphereDaily[0].Soil_Ph__c + '\n' +
                            '- Soil Temp: ' + agrosphereDaily[0].Soil_Temperature__c + 'C \n' +
                            '- Battery: ' + agrosphereDaily[0].Transmitter_Battery__c + '% \n\n' +
                            'Check your full report at: https://agno-dev-ed.develop.my.site.com/agrospehre/s/farm-overview\n\n' +
                            'Thank you,\nTeam AgroSphere';
            sendSmsRestAPI (phoneNumber,message);
        }
    }

    @AuraEnabled(cacheable=true)
    public static Map<String,Object> getCaseMessage(String caseId){
        List<Case_Agent_Customer_Chat__c> caseMessages = [SELECT Chat_message__c,Sent_by__c,CreatedDate FROM Case_Agent_Customer_Chat__c WHERE Case__c =:caseId order by CreatedDate Asc];
        Map<String,Object> resultMap = new Map<String,Object> {'UserName'=>UserInfo.getName(),'MessageInfo'=>caseMessages};
        return resultMap;
    }
    @AuraEnabled
    public static void insertCaseMessage(Boolean isAgent,String caseMessage,String caseId){
        Case_Agent_Customer_Chat__c casemsgToinsert = new Case_Agent_Customer_Chat__c(Chat_message__c=caseMessage,Sent_by__c=isAgent?'Agent':'User',Case__c=caseId);
        insert casemsgToinsert;
    }

    @AuraEnabled
    public static List<Case> getCase(String caseNumber){
        List<Case> allCases = [SELECT Id,Contact.Email,SuppliedEmail FROM Case WHERE CaseNumber =:caseNumber];
        return allCases;
    }

    @AuraEnabled
    public static void sendEmailForOTP(String ranString,String toMail){
        Messaging.reserveSingleEmailCapacity(1);        

            String contactId = [SELECT Id FROM Contact WHERE email = 'ayanghosh974@gmail.com'].Id;
            EmailTemplate et = [SELECT Id,Subject, Body FROM EmailTemplate WHERE Name ='Agrosphere case OTP'];
            OrgWideEmailAddress[] owea = [select Id from OrgWideEmailAddress where Address ='debopriyamunu974@gmail.com'];
            
            String[] toAddresses = new String[]{toMail};

            Messaging.SingleEmailMessage mymail = new Messaging.SingleEmailMessage();
            mymail.setOrgWideEmailAddressId(owea.get(0).Id);
            mymail.setToAddresses(toAddresses);
            mymail.setTargetObjectId(contactId);
            mymail.setSaveAsActivity(false);
            mymail.setTemplateId(et.id);

            Savepoint sp = Database.setSavepoint();
            Messaging.sendEmail(new Messaging.SingleEmailMessage[] {mymail});
            Database.rollback(sp);

            String mailTextBody = mymail.getPlainTextBody();
            String mailHtmlBody = mymail.getHTMLBody();
            String mailSubject = mymail.getSubject();

            mailHtmlBody = mailHtmlBody.replace('{OTP_VALUE}',ranString);

            Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
            mail.setToAddresses(toAddresses);
            mail.setSubject(mailSubject);
            mail.setHtmlBody(mailHtmlBody);
            mail.setSaveAsActivity(false);
            mail.setOrgWideEmailAddressId(owea.get(0).Id);
            try {
                Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
            } catch (Exception e) {
                System.debug('Error sending email: ' + e.getMessage());
            }

    }

    @AuraEnabled
    public static String createCase(String name,String email,String message){
        Case ca =new Case();
        String userName;
        String userEmail;
        if(!String.isEmpty(name)){
           ca.SuppliedName=name;
           userName = name;
        }else{
            userName = UserInfo.getName();
        }

        if(String.isEmpty(email)){
            userEmail = UserInfo.getUserEmail();
            ca.ContactId=[SELECT ContactId FROM User where Id =:UserInfo.getUserId()].ContactId;
        }else{
            userEmail = email;
            ca.SuppliedEmail=email;
        }
        ca.Subject='(AGROSPHERE CASE) - '+name;
        ca.Description=message;
        ca.Status='New';
        ca.Origin='Web';
        insert ca;

        Case_Agent_Customer_Chat__c casemsgToinsert = new Case_Agent_Customer_Chat__c(Chat_message__c='Hey '+userName+', we have received your case. We will try to resolve ASAP. Thank you for contacting AGROSHERE.',Sent_by__c='Agent',Case__c=ca.Id);
        insert casemsgToinsert;

        String contactId = [SELECT Id FROM Contact WHERE email = 'ayanghosh974@gmail.com' limit 1].Id;
        EmailTemplate et = [SELECT Id,Subject, Body FROM EmailTemplate WHERE Name ='Agrosphere case confirmation'];
        OrgWideEmailAddress[] owea = [select Id from OrgWideEmailAddress where Address ='debopriyamunu974@gmail.com'];

        if(String.isEmpty(email)){
            contactId = ca.ContactId;
        }

        Messaging.SingleEmailMessage mymail = new Messaging.SingleEmailMessage();
        String[] toaddresses = new String[] {userEmail}; 
		mymail.setOrgWideEmailAddressId(owea.get(0).Id);
        mymail.setToAddresses(toAddresses);
        mymail.setWhatId(ca.Id);
        mymail.setTargetObjectId(contactId);
        mymail.setSaveAsActivity(false);
        mymail.setTemplateId(et.id);
        Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mymail });

        return String.valueOf([SELECT id,CaseNumber from Case where Id = :ca.id].CaseNumber);
    }
    @AuraEnabled(cacheable=true)
    public static UserLicense licenseCheck(){
        UserLicense ul = [select TotalLicenses,Name, UsedLicenses from UserLicense where Name = 'Customer Community Plus'];
        return ul;
    }

    @AuraEnabled(cacheable=true)
    public static List<IoTAppliance__c> getapplianceData(String name) {
        List<IoTAppliance__c> appliancedata = [Select Id,Last_Activated__c,Last_Runtime__c,Status__c from IoTAppliance__c where Name = :name limit 1];
        return appliancedata;
    }
    @AuraEnabled
    public static void updateapplianceData(String name,String lastrun, Boolean status, DateTime lastActivated) {
        List<IoTAppliance__c> appliancedata = [Select Id,Last_Activated__c,Last_Runtime__c,Status__c from IoTAppliance__c where Name = :name limit 1];
        if(appliancedata.isEmpty()){
            IoTAppliance__c iotNew = new IoTAppliance__c(Name=name,Last_Activated__c=lastActivated,Last_Runtime__c=lastrun,Status__c=status);
            insert iotNew;

        }else{
            appliancedata[0].Last_Activated__c=lastActivated;
            appliancedata[0].Last_Runtime__c=lastrun;
            appliancedata[0].Status__c=status;
            update appliancedata;
        }
    }

    @AuraEnabled
    public static Map<String, Object> makeWatsonCallout() {
        // Define the JSON payload 
        String plantationTime = '2 Months';
        List<Agrosphere_24_Hour_Data__c> agrosphereDaily = [SELECT Id,Atmosphere_Temperature__c,Atmosphere_Humidity__c,
                                                                Soil_Phosphorus__c,Rain_Percentage__c,Soil_Temperature__c,Light_Intensity__c,
                                                                Soil_Potassium__c,Soil_Electric_Conductivity__c,Soil_Ph__c,Soil_Nitrogen__c,
                                                                Soil_Moisture_Percentage__c,Transmitter_Battery__c,CreatedDate
                                                                FROM Agrosphere_24_Hour_Data__c ORDER BY CreatedDate Desc];
        Map<String, Object> jsonMap = new Map<String, Object>{
            'input' => '<|start_header_id|>user<|end_header_id|>\n\nI have an agricultural land with the following details, Current Atmosphere Temperature is '+agrosphereDaily[0].Atmosphere_Temperature__c+' C, Humidity '+agrosphereDaily[0].Atmosphere_Humidity__c+' % , Rain '+agrosphereDaily[0].Rain_Percentage__c+' % , Soil Phosphorus is '+agrosphereDaily[0].Soil_Phosphorus__c+' mg/Kg, Soil Potassium is '+agrosphereDaily[0].Soil_Potassium__c+' mg/kg , Soil Nitrogen is '+agrosphereDaily[0].Soil_Nitrogen__c+' mg/Kg, Soil Ph '+agrosphereDaily[0].Soil_Ph__c+', Soil Moisture '+agrosphereDaily[0].Soil_Moisture_Percentage__c+'%, Soil EC is '+agrosphereDaily[0].Soil_Electric_Conductivity__c+' us/cm,Soil Temperature '+agrosphereDaily[0].Soil_Temperature__c+' C.\nCan you tell me the advices for best farming practice. also Mention the Best Crop for this Land,Best Fertilizer as paragraphs and header point. Donot use number formating<|eot_id|>',
                'parameters' => new Map<String, Object>{
                    'decoding_method' => 'greedy',
                        'max_new_tokens' => 900,
                        'min_new_tokens' => 0,
                        'stop_sequences' => new List<Object>(),
                        'repetition_penalty' => 1
                        },
                            'model_id' => 'meta-llama/llama-3-8b-instruct',
                            'project_id' => '08e47659-fa70-4816-9b62-2f49eb3ad52e',
                            'moderations' => new Map<String,Object> {
                                'hap' => new Map<String,Object> {
                                    'input' => new Map<String,Object> {
                                        'enabled' => true,
                                        'threshold' => 0.5,
                                        'mask' => new Map<String,Object> {
                                            'remove_entity_value' => true
                                        }

                                    },
                                    'output' => new Map<String,Object> {
                                        'enabled' => true,
                                        'threshold' => 0.5,
                                        'mask' => new Map<String,Object> {
                                            'remove_entity_value' => true
                                        }

                                    }
                                }
                            }
                            };
                                
                                String jsonPayload = JSON.serialize(jsonMap);
        
        
        // Define the endpoint URL
        String endpoint = 'https://us-south.ml.cloud.ibm.com/ml/v1/text/generation?version=2023-05-29';
        
        // Create an HTTP request
        HttpRequest request = new HttpRequest();
        request.setEndpoint(endpoint);
        request.setMethod('POST');
        request.setHeader('Content-Type', 'application/json');
        request.setHeader('Authorization', 'Bearer '+ getAuthToken());
        request.setBody(jsonPayload);
        
        // Create an HTTP object to send the request
        Http http = new Http();
        Map<String, Object> generatedText = new Map<String, Object>();
        try {
            // Send the request and get a response
            HttpResponse response = http.send(request);
            
            // Parse the response
            if (response.getStatusCode() == 200) {
                Map<String, Object> responseBodyMap = (Map<String, Object>) JSON.deserializeUntyped(response.getBody());
                List<Object> parameters = (List<Object>) responseBodyMap.get('results');
                generatedText = (Map<String, Object>) responseBodyMap;
                // Handle successful response
                System.debug('HTTP Response Body: ' + response.getBody());
            } else {
                // Handle error response
                System.debug('HTTP Error Response: ' + response.getStatusCode() + ' ' + response.getStatus());
            }
        } catch (Exception e) {
            // Handle exception
            System.debug('HTTP Callout Error: ' + e.getMessage());
        }
        return generatedText;
    }

    private static String getAuthToken() {
        HttpRequest req = new HttpRequest();
        req.setEndpoint('https://iam.cloud.ibm.com/identity/token');
        req.setMethod('POST');
        req.setHeader('Content-Type', 'application/x-www-form-urlencoded');
        String requestBody = 'grant_type=urn:ibm:params:oauth:grant-type:apikey&apikey='+API_KEY;
        req.setBody(requestBody);
        Http http = new Http();
        HttpResponse res = http.send(req);
        if (res.getStatusCode() == 200) {
            Map<String, Object> responseMap = (Map<String, Object>) JSON.deserializeUntyped(res.getBody());
            return (String) responseMap.get('access_token');
        } else {
            return null;
        }
    }



}
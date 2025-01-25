/**
* @File Name : AgrosphereVoidAgreement.cls
* @Description :
* @Author :
* @Last Modified By :
* @Last Modified On : January 13, 2025
* @Modification Log :
*==============================================================================
* Ver | Date | Author | Modification
*==============================================================================
* 1.0 | January 13, 2025 |   | Initial Version
**/

global class CancelUnsignedAgreementsScheduler implements Schedulable {
    global void execute(SchedulableContext sc) {
        AgrosphereController.cancelUnsignedAgreements();
    }
}
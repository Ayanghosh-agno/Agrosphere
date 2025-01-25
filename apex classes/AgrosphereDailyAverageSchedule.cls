/**
* @File Name : AgrosphereDailyAverageSchedule.cls
* @Description :
* @Author :
* @Last Modified By :
* @Last Modified On : January 17, 2025
* @Modification Log :
*==============================================================================
* Ver | Date | Author | Modification
*==============================================================================
* 1.0 | January 17, 2025 |   | Initial Version

String cronExpression = '0 5 0 * * ?';
System.schedule('Agrosphere Daily Sensor Data Averaging', cronExpression, new AgrosphereDailyAverageSchedule());

**/

global class AgrosphereDailyAverageSchedule implements Schedulable {
	global void execute(SchedulableContext sc) {

        List<Agrosphere_24_Hour_Data__c> agrosphereDate = [Select Id FROM Agrosphere_24_Hour_Data__c order by createddate desc Limit 1];

        if(agrosphereDate.size() > 0){
            List<AggregateResult> results = [ SELECT AVG(Atmosphere_Temperature__c) avgAtmTemp, AVG(Atmosphere_Humidity__c) avgAtmHum,
                                                AVG(Soil_Phosphorus__c) avgSoilP,AVG(Rain_Percentage__c) avgRain, AVG(Soil_Temperature__c) avgSoilT,
                                                AVG(Light_Intensity__c) avgLight,AVG(Soil_Potassium__c) avgSoilK, AVG(Soil_Electric_Conductivity__c) avgSoilEC,
                                                AVG(Soil_Ph__c) avgSoilPh, AVG(Soil_Nitrogen__c) avgSoilN, AVG(Soil_Moisture_Percentage__c) avgSoilM ,
                                                AVG(Transmitter_Battery__c) avgTransBat 
                                                FROM Agrosphere_24_Hour_Data__c WHERE CreatedDate = YESTERDAY];

            if(results.size() > 0){
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
				agrosphere.Average_Of__c = Date.today().addDays(-1);
				agrosphere.DeviceId__c = 'AGROSPHERE-2025';
                insert agrosphere;
            }

            delete [SELECT Id FROM Agrosphere_24_Hour_Data__c];
        } 
    }
}
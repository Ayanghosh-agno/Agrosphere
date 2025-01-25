// Include the DHT11 library for interfacing with the sensor.
#include <DHT11.h>
#include <SoftwareSerial.h>
#include <Arduino.h>
#include <ESP8266WiFi.h>
#include <ESP8266HTTPClient.h>
#include <WiFiClientSecureBearSSL.h>
#include <Arduino_JSON.h>
#include <Wire.h>

// Replace with your network credentials
const char* ssid = "WIFISSID";
const char* password = "WIFIPASS";
String authtoken;

// Define the RX and TX pins for Software Serial 2
#define NPK_RX 12
#define NPK_TX 14

const byte temp[] = {0X01,0X03, 0X00,0X12,0X00,0X02,0x64,0x0E};
const byte soil_ph[] = {0x01,0x03, 0x00, 0x06, 0x00, 0x01, 0x64, 0x0B};
const byte ec[] = {0x01,0x03, 0x00, 0x15, 0x00, 0x01, 0x95, 0xCE};
const byte nitro[] = { 0x01, 0x03, 0x00, 0x1E, 0x00, 0x01, 0xE4, 0x0C };
const byte phos[] = { 0x01, 0x03, 0x00, 0x1f, 0x00, 0x01, 0xb5, 0xcc };
const byte pota[] = { 0x01, 0x03, 0x00, 0x20, 0x00, 0x01, 0x85, 0xc0 };

SoftwareSerial mod(NPK_RX,NPK_TX);////// TX AND RX

DHT11 dht11(2);


#define MAX_ADC_READING           1023
#define ADC_REF_VOLTAGE           5.0
#define REF_RESISTANCE            130     
#define LUX_CALC_SCALAR           12518931 
#define LUX_CALC_EXPONENT         -1.405

float humidity_val = 0;
float temperature_val = 0;
float potassium_val = 0;
float nitrogen_val = 0;
float phosphorus_val = 0;
float electrical_conductivity_val = 0;
float ph_val = 0;

void setup() {
  mod.begin(9600);
  Serial.begin(9600);
  pinMode(D0,OUTPUT);
  Serial.println();
  Serial.println();
  Serial.println();

  //Connect to Wi-Fi
  WiFi.mode(WIFI_STA);
  WiFi.begin(ssid, password);
  Serial.print("Connecting to WiFi ..");
  while (WiFi.status() != WL_CONNECTED) {
    digitalWrite(D0,HIGH);
    delay(500);
    digitalWrite(D0,LOW);
    delay(500);
  Serial.print('.');
  }

  if ((WiFi.status() == WL_CONNECTED)) {
  digitalWrite(D0,LOW);
  Serial.print("Wifi Connected..!");

  std::unique_ptr<BearSSL::WiFiClientSecure>client(new BearSSL::WiFiClientSecure);
  // Ignore SSL certificate validation
  client->setInsecure();
  //create an HTTPClient instance
  HTTPClient https;
  //Initializing an HTTPS communication using the secure client
  Serial.print("[HTTPS] begin...\n");
  //Salesforce login endpoint
  if (https.begin(*client, "https://login.salesforce.com/services/oauth2/token")) { 
    Serial.print("GETTING Salesforce Access Token...\n");
    // start connection and send HTTP header
    https.addHeader("Content-Type","application/x-www-form-urlencoded");
    //salesforce authorisation
    String httpRequestData = "grant_type=password&client_id={CLIENT_ID}&client_secret={CLIENT_SECRET}&username={USERNAME}&password={PASS}";           
    int httpCode = https.POST(httpRequestData);
    // httpCode will be negative on error
    if (httpCode > 0) {
      // get the status code
      Serial.printf("[HTTPS] Status Code: %d\n", httpCode);
      // Record insertion has been successful
      if (httpCode == HTTP_CODE_OK || httpCode == HTTP_CODE_MOVED_PERMANENTLY) {
        String payload = https.getString();
        JSONVar myObject = JSON.parse(payload);
        if (JSON.typeof(myObject) == "undefined") {
          Serial.println("Parsing input failed!");
          return;
        }
        authtoken=String(myObject["access_token"]);
        Serial.println(myObject["access_token"]);
      }
    } else {Serial.printf("[HTTPS] Inserting record... failed, error: %s\n", https.errorToString(httpCode).c_str());}
    https.end();
    } else {Serial.printf("[HTTPS] Unable to connect\n");}
  }
  Serial.println();
  Serial.println("Waiting 10secs before the next round...");
  delay(10000);
}




void loop(void) {
  int temperature = 0;
  int humidity = 0;
  int result = dht11.readTemperatureHumidity(temperature, humidity);

  int   ldrRawData;
  float resistorVoltage, ldrVoltage;
  float ldrResistance;
  float ldrLux;

  ldrRawData = analogRead(A0);
  resistorVoltage = (float)ldrRawData / MAX_ADC_READING * ADC_REF_VOLTAGE;
  ldrVoltage = ADC_REF_VOLTAGE - resistorVoltage;
  ldrResistance = ldrVoltage / resistorVoltage * REF_RESISTANCE;
  ldrLux = LUX_CALC_SCALAR * pow(ldrResistance, LUX_CALC_EXPONENT);

  delay(250);
  stemp_shum();
  delay(250);
  nitogen_sensor();
  delay(250);
  p_sensor();
  delay(250);
  k_sensor();
  delay(250);
  ph();
  delay(250);
  econd();
  delay(250);

  if ((WiFi.status() == WL_CONNECTED) && authtoken != "") {

  digitalWrite(D0,LOW);
  std::unique_ptr<BearSSL::WiFiClientSecure>client(new BearSSL::WiFiClientSecure);
  client->setInsecure();
  HTTPClient https;
  Serial.print("Sensor data sending begin...\n");
  if (https.begin(*client, "https://agno-dev-ed.develop.my.salesforce.com/services/data/v40.0/sobjects/Agrosphere_IoT__e")) {  
    Serial.print("Preparing to send data...\n");
    https.addHeader("Authorization", "Bearer "+authtoken);
    https.addHeader("Content-Type", "application/json");
    String httpRequestData = "{";
    httpRequestData += "\"Atmosphere_Temperature__c\":" + String(temperature) + ",";
    httpRequestData += "\"Atmosphere_Humidity__c\":" + String(humidity) + ",";
    httpRequestData += "\"Soil_Nitrogen__c\":" + String(nitrogen_val) + ",";
    httpRequestData += "\"Soil_Phosphorus__c\":" + String(phosphorus_val) + ",";
    httpRequestData += "\"Soil_Potassium__c\":" + String(potassium_val) + ",";
    httpRequestData += "\"Soil_Ph__c\":" + String(ph_val) + ",";
    httpRequestData += "\"Soil_Moisture_Percentage__c\":" + String(humidity_val) + ","; // 1.8
    httpRequestData += "\"Soil_Temperature__c\":" + String(temperature_val) + ",";
    httpRequestData += "\"Soil_Electric_Conductivity__c\":" + String(electrical_conductivity_val)+",";
    httpRequestData += "\"Rain_Percentage__c\":0,";
    httpRequestData += "\"Light_Intensity__c\":" + String(ldrLux)+",";
    httpRequestData += "\"Transmitter_Battery__c\":90,";
    httpRequestData += "\"DeviceId__c\":\"AGROSPHERE-2025\"";
    httpRequestData += "}";
    Serial.println(httpRequestData);
    int httpCode = https.POST(httpRequestData);
    if (httpCode > 0) {
      Serial.printf("[HTTPS] Send data status ... code: %d\n", httpCode);
      if (httpCode == HTTP_CODE_OK || httpCode == HTTP_CODE_MOVED_PERMANENTLY || httpCode == 201) {
        String payload = https.getString();
        Serial.println(payload);
      }else{
      }
    } else {
      Serial.printf("[HTTPS] Send Data... failed, error: %s\n", https.errorToString(httpCode).c_str());
    }
    https.end();
  } else {Serial.printf("[HTTPS] Unable to connect\n");}
  Serial.println();
  Serial.println("Waiting 15secs before the next round...");
  delay(25000);
  }else if(authtoken == ""){
    delay(200); 
  }else{
  digitalWrite(D0,HIGH);
  delay(500);
  digitalWrite(D0,LOW);
  delay(500);
}
delay(1000);
}


 void stemp_shum(){
  byte receivedData[9];
  delay(10);
  if(mod.write(temp,sizeof(temp))==8){
    mod.readBytes(receivedData,sizeof(receivedData));
    unsigned int humidity = (receivedData[3]<<8|receivedData[4]);
    unsigned int tempe = (receivedData[5]<<8|receivedData[6]);
    tempe = tempe/10;
    humidity = humidity/10;
    humidity_val = (float) humidity;
    temperature_val = (float) tempe;
  }
}

 void nitogen_sensor(){
  byte receivedData[9];
  delay(10);
  if(mod.write(nitro,sizeof(nitro))==8){
    mod.readBytes(receivedData,sizeof(receivedData));
    unsigned int nitrogetn = (receivedData[3]<<8|receivedData[4]);
    nitrogen_val = (float) nitrogetn;
  }
}


 void p_sensor(){
  byte receivedData[9];
  delay(10);
  if(mod.write(phos,sizeof(phos))==8){
    mod.readBytes(receivedData,sizeof(receivedData));
    unsigned int phosphorus = (receivedData[3]<<8|receivedData[4]);
    phosphorus_val = (float) phosphorus;
  }
}

 void k_sensor(){
  byte receivedData[9];
  delay(10);
  if(mod.write(pota,sizeof(pota))==8){
    mod.readBytes(receivedData,sizeof(receivedData));
    unsigned int potassium = (receivedData[3]<<8|receivedData[4]);
    potassium_val = (float) potassium;
  }
}


void ph(){
  byte receivedData[9];
  delay(10);
  if(mod.write(soil_ph,sizeof(soil_ph))==8){
    mod.readBytes(receivedData,sizeof(receivedData));
    unsigned int ph_val_sensor = (receivedData[3]<<8|receivedData[4]);
    ph_val = (float) ph_val_sensor/100;
  }
}



void econd(){
  byte receivedData[9];
  delay(10);
  if(mod.write(ec,sizeof(ec))==8){
    mod.readBytes(receivedData,sizeof(receivedData));
    unsigned int ec_soil = (receivedData[3]<<8|receivedData[4]);
    electrical_conductivity_val = (float) ec_soil;
  }
}

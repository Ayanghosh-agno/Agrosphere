<h1 align="center"<a name="title"></a>AGROSPHERE</h1>
<div align="center">
  
  >"AgroSphere – Revolutionizing Smart Farming"
>
</div>
<h1 align="center"</a></h1>

  - [Project Summary](#project-summary)
      - [The issue we are hoping to solve](#issue-we-are-solving)
      - [How our technology solution can help](#technology-solution)
  
  - [Technology we have used](#technology-implementation)
      - [Docusign product(s) used](#docusign-services-used)
      - [Other service(s) used](#other-services-used)
      - [Solution Architecture](#solution-architecture)

  -  [Detailed Description](#detail-materials)
      -  [Agrosphere Hardware](#agrosphere-transmitter)
      -  [Agrosphere Website](#agrosphere-website)
          - [Home Page](#home-page)
          - [Farm Overview Page](#farm-overview-page)
          - [MarketPlace Page](#market-place-page)
          - [Post an Add Page](#Post-an-add-page)
          - [My Purchase Page](#my-purchase-page)
          - [Contact Us/Case track Page](#contact-us-page)
          - [Registation Page](#registration-page)

  - [Presentation materials](#presentation-materials)
      - [Solution Demo Video](#solution-demo-video)
     
  - [Additional Details](#additional-details)
      - [Live Demo](#Live-Demo)
            
  - [About](#about)
      - [Authors](#Authors)
      - [License](#license)
   
<h2 align="center"> Project Summary <a name="project-summary"></a> </h2>
   
### The Issue we are hoping to solve <a name="issue-we-are-solving"></a>

AgroSphere addresses several critical challenges faced by the farming community, particularly small and marginalized farmers:

  -  <strong> Environmental and Agricultural Challenges </strong>

     -  <strong> Inefficient Resource Utilization: </strong> Overuse or underuse of water, fertilizers, and pesticides due to a lack of real-time field data.
    
     -  <strong> Climate Uncertainty: </strong> Farmers struggle to adapt to unpredictable weather patterns and changing environmental conditions.
    
     -  <strong> Soil Health Mismanagement: </strong> Lack of awareness about soil nutrient levels results in poor crop yields and soil degradation.
    
  - <strong> Economic Challenges </strong>
  
    -  <strong> Limited Market Access: </strong> Farmers often lack platforms to directly sell or lease their equipment, produce, or resources.
      
    -  <strong> Complex Purchase Agreements: </strong> Lack of digitized and secure processes for lease and sale agreements creates inefficiencies.
      
  - <strong> Technology Gap </strong>
  
    -  <strong> Limited Access to AI-Driven Insights: </strong> Small-scale farmers lack the tools to receive actionable recommendations based on their field conditions.
      
    -  <strong> Real-Time Monitoring Deficit: </strong> Lack of live data on soil and environmental factors hampers decision-making.
      
  -  <strong> Administrative Inefficiencies </strong>
    
      -  <strong> Manual Approval Processes: </strong> Time-consuming and error-prone approval processes for posting products or tracking purchases.
        
      -  <strong> Poor Case Management: </strong> Difficulty in resolving user issues promptly and securely.


#### Data Facts:

- <strong> Soil Degradation: </strong> 33% of soil is moderately to highly degraded [Watch Here For Details](https://www.fao.org/fileadmin/user_upload/newsroom/docs/FAO-world-soils-report-SUMMARY.pdf)

- <strong> Water Scarcity:</strong> Agriculture accounts for 70% of global freshwater withdrawals, and inefficient irrigation systems lead to significant wastage [Watch Here For Details](https://blogs.worldbank.org/en/opendata/chart-globally-70-freshwater-used-agriculture).
  
- <strong> Climate Change:</strong> Unpredictable weather patterns adversely affect crop yields. The Intergovernmental Panel on Climate Change [Watch Here For Details](https://www.ipcc.ch/srccl/chapter/chapter-5/) projects a decrease in crop production by up to 2% per decade, while demand is expected to increase by 14% per decade.

These issues underscore the need for a comprehensive, technology-driven solution to optimize farming practices, improve soil health, and ensure efficient resource utilization.

### How our technology solution can help <a name="technology-solution"></a>

AgroSphere is designed to bridge these gaps with an integrated approach combining IoT, AI, and Salesforce technologies:

  -  <strong>Optimizing Resources and Yields</strong>
    
      -  <strong>Real-Time Data Monitoring:</strong> IoT hardware continuously captures key metrics such as soil nutrients, moisture, and atmospheric conditions. Farmers can make informed decisions to optimize water and fertilizer usage.
    
      -  <strong>AI-Driven Insights:</strong> WatsonX AI analyzes field data to provide personalized farming recommendations, helping improve productivity and sustainability.
    
  -  <strong>Empowering Farmers Economically</strong>
    
      -  <strong>Marketplace for Farmers:</strong> A dedicated platform allows farmers to list and lease equipment, sell produce, or purchase items from peers, promoting fair trade and economic growth.
    
      -  <strong>Streamlined Transactions:</strong> Integration with DocuSign APIs ensures secure and legally binding agreements for all marketplace transactions.
    
  -  Simplifying Technology Adoption

      -  <strong>User-Friendly Interfaces:</strong> AgroSphere’s website, powered by Salesforce Experience Cloud, provides an intuitive and accessible platform for farmers of all technological backgrounds.
    
      -  <strong>Seamless Case Management:</strong> With OTP-based secure case tracking and real-time communication, users can address issues without delays.
    
  -  <strong>Improving Administrative Efficiency</strong>
    
      -  <strong>Automated Approval Workflows:</strong> Product and purchase approvals are digitized using DocuSign eSign API, ensuring quick and reliable processing.
    
      -  <strong>Centralized Monitoring:</strong> Salesforce Service Cloud allows admins to manage user issues, purchase agreements, and field data in one unified system.
    
  -  <strong>Addressing Climate Challenges</strong>
    
      - <strong>Proactive Decision-Making:</strong> Farmers can adapt quickly to changing weather conditions with AI-generated insights and weather updates.
    
      - <strong>Sustainable Farming Practices:</strong> The solution encourages soil health monitoring and efficient resource usage, promoting long-term sustainability.
     
By empowering farmers with tools to monitor, manage, and monetize their agricultural operations, AgroSphere creates a sustainable and inclusive ecosystem for modern agriculture.

<h2 align="center"> Technology we have used <a name="technology-implementation"></a> </h2>

### Docusign product(s) used <a name="docusign-services-used">

**Featured Docusign Services**

- [DocuSign Click API:](https://developers.docusign.com/docs/click-api/) -

    - Used for presenting and capturing user consent during the product posting process in the marketplace.
    - Ensures that users agree to terms and conditions before submitting their products. [Watch Here For Details](#docusign-click)
 
- [DocuSign eSignature API:](https://developers.docusign.com/docs/esign-rest-api/) -

    - Facilitates secure and seamless signing of purchase and lease agreements between buyers and sellers in the marketplace.
    - Handles admin approvals for posted products by generating and routing approval documents.
    - Enables signing completion notifications for users and sellers. [Watch Here For Details](#docusign-click)

 - [DocuSign WebForms API:](https://developers.docusign.com/docs/web-forms-api/) -

    - Integrated into the user registration process to capture user details dynamically.
    - Automatically generates documents for signing to confirm user registration and terms acceptance. [Watch Here For Details](#docusign-click)
  
 - [Docusign Webhooks:](https://developers.docusign.com/platform/webhooks/)

   - Used to track real-time updates on the status of signing agreements.

   - Automatically triggers notifications or updates in AgroSphere, such as notifying users or sellers about agreement completions or pending actions or getting information for registration.

### Other services used <a name="other-services-used"></a>


  - IBM Cloud WatsonX AI:
    
    - Analyzes real-time sensor data from fields to provide AI-driven farming recommendations.
      
    - Generates actionable insights for sustainable farming practices.
      
  - Salesforce Experience Cloud:
    
    - Hosts the AgroSphere website, enabling a seamless interface for authenticated and unauthenticated users.
      
    - Manages marketplace features like product browsing, posting, and purchases.

    - Farm insights and control in one place.
      
  - Salesforce Service Cloud:
    
    - Sensor Data Storage: Real-time data from AgroSphere hardware is stored in a custom object.

    - Daily Averages: Scheduled Apex runs at 12:00 AM daily to calculate and store average sensor data.
      
    - Agreement Expiry Management: Scheduled Apex runs hourly to void agreements pending for more than 1 hour.
      
    - Case Management: Tracks user-reported issues and enables agent-user communication.
      
    - DocuSign Webhook Integration: Receives real-time updates on agreement statuses and updates Salesforce records.
      
    - Document Storage: Stores signed agreements and approval documents in the related Salesforce records.
      
    - Notification System: Sends SMS and email alerts for key actions like agreement approvals, voids, and case updates.
    
      
  - NEXMO API SMS Services:
    
    - Sends updates to users for critical events, such as product posting acknowledgments and approvals.
      
    - Notifies buyers and sellers during the agreement signing process.
      
    - Notifies user about their field conditions

      
  - IoT Hardware Integration(Esp32 & Bolt-Iot):
    
    - Captures real-time data on soil nutrients, moisture, temperature, and other field conditions.
      
    - Sends data directly to Salesforce through platform events for real-time monitoring and insights.
      
    - Handles controlling command to operate farm utensils(pumps/lights) using bolt-cloud/device.
      
  - OpenWeatherMap API:
    
    - Provides real-time weather updates integrated into the field overview dashboard.
      
    - Helps users make informed decisions based on local weather conditions of the farmers location.


### Solution Architecture <a name="solution-architecture"></a>

![Solution Architecture]()

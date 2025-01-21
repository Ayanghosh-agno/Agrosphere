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

-  [Detailed Description](#detail-description)
    -  [What does AGROSPHERE do](#agrosphere-aim)
    -  [Accomplishments We're Proud of](#proud-of)
    -  [What we learned](#what-we-learned)
    -  [What's next for Agrosphere](#future-goals)

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

---

### How our technology solution can help <a name="technology-solution"></a>

AgroSphere is designed to bridge these gaps with an integrated approach combining IoT, AI, and Salesforce technologies:

-  <strong>Optimizing Resources and Yields</strong>
  
    -  <strong>Real-Time Data Monitoring:</strong> IoT hardware continuously captures key metrics such as soil nutrients, moisture, and atmospheric conditions. Farmers can make informed decisions to optimize water and fertilizer usage.
    -  <strong>AI-Driven Insights:</strong> WatsonX AI analyzes field data to provide personalized farming recommendations, helping improve productivity and sustainability.
  
-  <strong>Empowering Farmers Economically</strong>
  
    -  <strong>Marketplace for Farmers:</strong> A dedicated platform allows farmers to list and lease equipment, sell produce, or purchase items from peers, promoting fair trade and economic growth.
    -  <strong>Streamlined Transactions:</strong> Integration with DocuSign APIs ensures secure and legally binding agreements for all marketplace transactions.
  
-  <strong>Simplifying Technology Adoption</strong>

    -  <strong>User-Friendly Interfaces:</strong> AgroSphere’s website, powered by Salesforce Experience Cloud, provides an intuitive and accessible platform for farmers of all technological backgrounds.
    -  <strong>Seamless Case Management:</strong> With OTP-based secure case tracking and real-time communication, users can address issues without delays.
  
-  <strong>Improving Administrative Efficiency</strong>
  
    -  <strong>Automated Approval Workflows:</strong> Product and purchase approvals are digitized using DocuSign eSign API, ensuring quick and reliable processing.
    -  <strong>Centralized Monitoring:</strong> Salesforce Service Cloud allows admins to manage user issues, purchase agreements, and field data in one unified system.
  
-  <strong>Addressing Climate Challenges</strong>
  
    - <strong>Proactive Decision-Making:</strong> Farmers can adapt quickly to changing weather conditions with AI-generated insights and weather updates.
    - <strong>Sustainable Farming Practices:</strong> The solution encourages soil health monitoring and efficient resource usage, promoting long-term sustainability.
   
By empowering farmers with tools to monitor, manage, and monetize their agricultural operations, AgroSphere creates a sustainable and inclusive ecosystem for modern agriculture.

---

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

---

### Other services used <a name="other-services-used"></a>


- <strong>IBM Cloud WatsonX AI:</strong>
  
  - Analyzes real-time sensor data from fields to provide AI-driven farming recommendations.
    
- <strong>Salesforce Experience Cloud:</strong>
  
  - Hosts the AgroSphere website, enabling a seamless interface for authenticated and unauthenticated users.
    
- <strong>Salesforce Service Cloud:</strong>
  
  - Operation, storing and backend stuffs are handled here.
  
- <strong>NEXMO API SMS Services:</strong>
  
  - Sends updates to users for critical events, such as product posting acknowledgments and approvals.
    
- <strong>IoT Hardware Integration(Esp32 & Bolt-Iot):</strong>

  - Captures real-time data on soil nutrients, moisture, temperature, and other field conditions.
  - Sends data directly to Salesforce through platform events for real-time monitoring and insights.
  - Handles controlling command to operate farm utensils(pumps/lights) using bolt-cloud/device.
    
- <strong>OpenWeatherMap API:</strong>
  
  - Provides real-time weather updates integrated into the field overview dashboard.

---

### Solution Architecture <a name="solution-architecture"></a>

![Solution Architecture](https://github.com/Ayanghosh-agno/Agrosphere/blob/main/Agrosphere%20Readme%20Images/Agrosphere%20architecture.png)


<h2 align="center"> Detailed Description<a name="detailed-description"></a> </h2>

### What does AGROSPHERE do ? <a name="agrosphere-aim"></a>

Agrosphere is an integrated platform designed to transform modern farming by combining real-time environmental monitoring, AI-driven insights, and a connected marketplace to empower farmers with the tools and knowledge they need to improve productivity, sustainability, and profitability. By leveraging IoT sensors, artificial intelligence, and cloud-based solutions, Agrosphere addresses key challenges faced by farmers and provides comprehensive solutions to optimize farm management. Here’s an overview of what Agrosphere does, broken down into its core functions:

1. #### Real-Time Environmental Monitoring
   -    Agrosphere employs IoT-based hardware devices that are installed on farms to capture a wide range of environmental and soil conditions. These devices measure crucial parameters such as:
         - Soil moisture
         - Soil temperature
         - Soil pH
         - Soil nutrients (Nitrogen, Phosphorus, Potassium, etc.)
         - Atmospheric temperature
         - Humidity
         - Light Lux

    -    The data collected by these sensors is transmitted to the platform, where it is stored and analyzed in real-time. This allows farmers to access live updates on their farm's conditions, making it easier to track performance, identify issues early, and take preventive actions.

2. #### AI-Driven Insights
   
    -    Agrosphere uses WatsonX AI to analyze the sensor data and provide personalized recommendations for farmers. The platform offers insights such as:

          -    Irrigation recommendations: Based on soil moisture levels and weather data, AI suggests optimal irrigation schedules to ensure crops receive the right amount of water at the right time.
          -    Farming best practices: AI analyzes the data to provide actionable recommendations on crop rotation, fertilization, pest control, and planting strategies.
          -    Weather predictions: Agrosphere also provides localized weather updates to help farmers anticipate any changes in the environment and adjust their operations accordingly.

    -    These AI-powered insights not only help farmers optimize their daily operations but also enable them to make data-driven decisions that maximize crop yield, reduce costs, and improve sustainability.

4. #### Control of Farm Equipment
   
    -    Agrosphere gives farmers the ability to control essential farm equipment remotely, including pumps, lights, and other machinery. The platform tracks when each device was last turned on and how long it was used, offering an overview of energy consumption and performance. This remote control feature is especially useful for automating irrigation systems, lighting for crop protection, or controlling machinery for field operations. The goal is to provide farmers with better control over their farm's operations, making it more efficient and cost-effective.

5. #### Marketplace for Agricultural Products
   
    -    Agrosphere hosts a marketplace where farmers and businesses can buy, sell, and lease agricultural products and equipment. This feature includes:
          
          - Product Listings: Farmers can list items like seeds, fertilizers, tools, and even agricultural land. They can also offer farm equipment like pumps and lights for lease or sale.
          - Product Categories: The marketplace allows users to filter products by category, price, or type of product, making it easier to find what they need.
          - Smart Contracts & Agreements: Agrosphere integrates with DocuSign to streamline the buying and leasing process. When a user decides to purchase an item, they are prompted to sign a DocuSign agreement for a secure transaction. The system ensures that both parties (buyer and seller) fulfill their obligations before the deal is completed.
          - Tracking: After a product is purchased or leased, the buyer can track their order and receive updates regarding the shipment or product approval.

5. #### Case Management & Communication

    -    For users who encounter issues or have inquiries related to products, Agrosphere provides a Case Management System. This allows users to raise a case for any concerns they might have about their orders, equipment, or other farm-related challenges.
          -    Case Tracking: After submitting a case, users can track its status, get updates on progress, and communicate with the support agents via a built-in messaging system.
          -    OTP Verification: To ensure privacy and security, unauthenticated users must verify their identity via an OTP sent to their registered email address before they can interact with their cases.
          -    Case Resolution: Support agents can interact with the users to resolve issues and update the case status. Users will also receive notifications (via email and SMS) about the case progress and resolution.

6. #### User Registration and Authentication
   
    -    Agrosphere supports a seamless user registration process, where users can sign up for the platform by providing their email and other details. After filling out a registration form, users are asked to sign an agreement via DocuSign, confirming their acceptance of terms and conditions. Upon successful registration and agreement signing, users receive:

    -    Confirmation email to reset their password.
    -    Access to the platform, where they can view real-time updates, interact with the marketplace, control their farm equipment, and receive AI insights.
7. #### Salesforce Integration
    -    To enhance its operational capabilities, Agrosphere integrates with Salesforce in two key areas:
          -    Salesforce Experience Cloud: This is used for providing an interactive and user-friendly interface for farmers. It allows farmers to view and manage their accounts, track cases, and access key insights into their farm operations. It also powers the marketplace where users can buy and lease equipment.
          -    Salesforce Service Cloud: This is used for managing internal operations. Here, cases are logged, tracked, and resolved by agents. Additionally, sensor data from the farm equipment is stored in custom objects within Salesforce, and automated processes like scheduled reports and voiding agreements are handled via Scheduled Apex classes.

8. #### Notifications and Alerts

    -    Agrosphere provides notifications to keep users informed about critical activities on their farm:
          -    Sensor Alerts: Users receive alerts when sensor readings go beyond set thresholds (e.g., soil moisture too low, temperature too high).
          -    Equipment Alerts: If equipment malfunctions or requires attention, users are notified.
          -    Case Updates: Users receive email and SMS updates about their case statuses, including when they are submitted, processed, or closed.

#### Conclusion

Agrosphere is a comprehensive platform that integrates hardware, AI-driven insights, and an online marketplace to empower farmers with better control, actionable data, and smarter tools for farm management. By combining modern technology with user-friendly interfaces and deep insights, Agrosphere is helping farmers across the world optimize their operations, increase productivity, and contribute to more sustainable agricultural practices.

---

### Accomplishments That We're Proud Of <a name="produd-of"></a>

- **Successful Integration of IoT and AI**  
  Successfully combined IoT hardware with AI analytics, enabling farmers to monitor real-time farm data and receive actionable insights for better crop management.

- **Empowering Farmers with a Marketplace**  
  Built a robust marketplace for farmers to buy, sell, and lease agricultural products and equipment, creating a bridge between farmers and businesses.

- **Automation in Farm Equipment Control**  
  Implemented remote control for farm equipment like pumps and lights, along with real-time tracking and historical usage data for enhanced efficiency.

- **Seamless Salesforce Integration**  
  Leveraged Salesforce for case management, customer interaction tracking, and efficient data storage, ensuring a seamless user experience.

- **AI-Powered Recommendations for Smart Farming**  
  Provided AI-driven recommendations for irrigation, fertilization, pest control, and crop management, empowering farmers with data-driven decision-making.

- **Security and Compliance**  
  Integrated secure document signing via **DocuSign** and identity verification via OTP, ensuring data security and trust among users.

- **Impactful Communication via Case Management**  
  Enabled easy issue reporting and resolution tracking through case management, enhancing support services for farmers.

---

### What We Learned

- **User-Centric Design**  
  Prioritized simplicity and accessibility, ensuring even non-tech-savvy farmers could easily adopt and use the platform.

- **Real-Time Data is Essential**  
  Understood the critical importance of real-time data for decision-making in modern farming, driving the implementation of instant alerts and data processing.

- **Collaboration with Third-Party Services**  
  Learned the value of integrating trusted services like **DocuSign** and **Salesforce**, allowing us to focus on core features while ensuring quality and security.

- **Scaling with Cloud Technologies**  
  Gained insights into the scalability benefits of cloud platforms like **Salesforce** and **IBM WatsonX AI**, which enable growth without compromising performance.

- **IoT Device Reliability**  
  Addressed challenges in hardware integration, learning the importance of rigorous testing and calibration for seamless farm operations.

---

### What's Next for Agrosphere

- **Expanding Hardware Capabilities**  
  Plan to add more IoT sensors for tracking air quality, rainfall, pest activity, and other critical parameters to provide comprehensive farm insights.

- **Machine Learning for Predictive Analytics**  
  Introduce predictive analytics using machine learning to forecast future conditions and offer advanced recommendations.

- **Enhanced Marketplace Features**  
  Expand the marketplace to include crop insurance, fertilizer management, and crop-specific advisory services for increased utility.

- **AI-Powered Farm Planning**  
  Develop tools for AI-driven farm planning to optimize planting, harvesting, and fertilization schedules based on real-time data.

- **Improved Mobile App Experience**  
  Enhance mobile app functionality to ensure farmers can manage their farms and access support on the go.

- **Global Expansion**  
  Extend Agrosphere’s reach globally, with multilingual support and localized insights tailored to specific regions.

- **Further Automation with Smart Farm Integration**  
  Explore integration with advanced smart farm technologies like drones and automated harvesting systems.

- **AI-Driven Market Insights**  
  Implement AI-powered market analytics to help farmers make informed decisions about pricing and selling their crops.

---

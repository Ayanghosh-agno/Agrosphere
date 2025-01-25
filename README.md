[![License](https://img.shields.io/badge/License-Apache2-blue.svg)](https://www.apache.org/licenses/LICENSE-2.0)

<h1 align="center"<a name="title"></a>AGROSPHERE</h1>
<div align="center">

>"AgroSphere – Revolutionizing Smart Farming"

<a href="https://agno-dev-ed.develop.my.site.com/agrospehre/s/">Visit Agrosphere now</a>
<h1 align="center"</a></h1>



</div>

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

### The Issue We Are Hoping to Solve <a name="issue-we-are-solving"></a>

**AgroSphere** addresses several critical challenges faced by the farming community, particularly small and marginalized farmers:

- **Environmental and Agricultural Challenges**
  - **Inefficient Resource Utilization:** Overuse or underuse of water, fertilizers, and pesticides due to a lack of real-time field data.
  - **Climate Uncertainty:** Farmers struggle to adapt to unpredictable weather patterns and changing environmental conditions.
  - **Soil Health Mismanagement:** Lack of awareness about soil nutrient levels results in poor crop yields and soil degradation.

- **Economic Challenges**
  - **Limited Market Access:** Farmers often lack platforms to directly sell or lease their equipment, produce, or resources.
  - **Complex Purchase Agreements:** Lack of digitized and secure processes for lease and sale agreements creates inefficiencies.

- **Technology Gap**
  - **Limited Access to AI-Driven Insights:** Small-scale farmers lack the tools to receive actionable recommendations based on their field conditions.
  - **Real-Time Monitoring Deficit:** Lack of live data on soil and environmental factors hampers decision-making.

- **Administrative Inefficiencies**
  - **Manual Approval Processes:** Time-consuming and error-prone approval processes for posting products or tracking purchases.
  - **Poor Case Management:** Difficulty in resolving user issues promptly and securely.

---

#### **Data Facts**
- **Soil Degradation:** 33% of soil is moderately to highly degraded. [Read More](https://www.fao.org/fileadmin/user_upload/newsroom/docs/FAO-world-soils-report-SUMMARY.pdf)
- **Water Scarcity:** Agriculture accounts for 70% of global freshwater withdrawals, with inefficient irrigation systems leading to significant wastage. [Read More](https://blogs.worldbank.org/en/opendata/chart-globally-70-freshwater-used-agriculture)
- **Climate Change:** Unpredictable weather patterns adversely affect crop yields. The Intergovernmental Panel on Climate Change projects a decrease in crop production by up to 2% per decade, while demand is expected to increase by 14% per decade. [Read More](https://www.ipcc.ch/srccl/chapter/chapter-5/)

---

These issues highlight the urgent need for a comprehensive, technology-driven solution to:
- Optimize farming practices.
- Improve soil health.
- Ensure efficient resource utilization.
- Empower farmers to adapt to modern challenges with sustainable tools and practices.

---

### How Our Technology Solution Can Help <a name="technology-solution"></a>

**AgroSphere** bridges critical gaps in agriculture through an integrated approach combining IoT, AI, and Salesforce technologies to address the challenges faced by modern farmers. Here’s how it helps:

- **Optimizing Resources and Yields**
  - **Real-Time Data Monitoring:** IoT hardware captures key metrics like soil nutrients, moisture, and atmospheric conditions in real-time, enabling farmers to optimize water and fertilizer usage effectively.
  - **AI-Driven Insights:** WatsonX AI analyzes field data to provide personalized farming recommendations, improving productivity and promoting sustainable practices.

- **Empowering Farmers Economically**
  - **Marketplace for Farmers:** A dedicated platform for listing and leasing equipment, selling produce, and purchasing items from peers fosters fair trade and economic growth.
  - **Streamlined Transactions:** DocuSign API integration ensures secure and legally binding agreements for all marketplace transactions.

- **Simplifying Technology Adoption**
  - **User-Friendly Interfaces:** Powered by Salesforce Experience Cloud, AgroSphere provides an intuitive platform accessible to farmers of all technological backgrounds.
  - **Seamless Case Management:** Secure case tracking with OTP-based authentication and real-time communication ensures quick issue resolution.

- **Improving Administrative Efficiency**
  - **Automated Approval Workflows:** Product and purchase approvals are digitized using DocuSign eSign API for faster and more reliable processing.
  - **Centralized Monitoring:** Salesforce Service Cloud provides a unified system for admins to manage user issues, purchase agreements, and field data.

- **Addressing Climate Challenges**
  - **Proactive Decision-Making:** Farmers receive AI-generated insights and weather updates to adapt quickly to changing conditions.
  - **Sustainable Farming Practices:** By encouraging soil health monitoring and efficient resource use, AgroSphere promotes long-term environmental sustainability.

By equipping farmers with tools to monitor, manage, and monetize their agricultural operations, AgroSphere fosters a sustainable and inclusive ecosystem for modern agriculture.

---

<h2 align="center"> Technology we have used <a name="technology-implementation"></a> </h2>

### DocuSign Product(s) Used <a name="docusign-services-used"></a>

#### **Featured DocuSign Services**

- **[DocuSign Click API](https://developers.docusign.com/docs/click-api/)**
  - Used for presenting and capturing user consent during the product posting process in the marketplace.
  - Ensures that users agree to terms and conditions before submitting their products. (Used out-of-the-box click api calling format)

- **[DocuSign eSignature API](https://developers.docusign.com/docs/esign-rest-api/)**
  - Facilitates secure and seamless signing of purchase and lease agreements between buyers and sellers in the marketplace.
  - Handles admin approvals for posted products by generating and routing approval documents.
  - Enables signing completion notifications for users and sellers. [Code Pointer - Line 17 to Line 332](https://github.com/Ayanghosh-agno/Agrosphere/blob/main/apex%20classes/DocusignCalloutController.cls)

- **[DocuSign WebForms API](https://developers.docusign.com/docs/web-forms-api/)**
  - Integrated into the user registration process to dynamically capture user details.
  - Automatically generates documents for signing to confirm user registration and terms acceptance. [Code Pointer - Line 332 to Line 404](https://github.com/Ayanghosh-agno/Agrosphere/blob/main/apex%20classes/DocuSignWebhook.cls)

- **[DocuSign Webhooks](https://developers.docusign.com/platform/webhooks/)**
  - Tracks real-time updates on the status of signing agreements.
  - Automatically triggers notifications or updates in AgroSphere, such as:
    - Notifying users or sellers about agreement completions or pending actions.
    - Capturing real-time registration information updates. [Code Pointer - Full class](https://github.com/Ayanghosh-agno/Agrosphere/blob/main/apex%20classes/DocuSignWebhook.cls)

---

### Other Services Used <a name="other-services-used"></a>

- **IBM Cloud WatsonX AI**  
  - Analyzes real-time sensor data from fields to provide AI-driven farming recommendations, helping farmers optimize productivity and sustainability.

- **Salesforce Experience Cloud**  
  - Hosts the AgroSphere website, offering a seamless and user-friendly interface for both authenticated and unauthenticated users to access features and services.

- **Salesforce Service Cloud**  
  - Manages backend operations, including:
    - Storing IoT sensor data in custom objects.
    - Scheduling processes to calculate daily averages and void expired agreements.

- **NEXMO API SMS Services**  
  - Sends timely SMS updates to users for critical events, such as:
    - Product posting acknowledgments.
    - Agreement signing status updates.
    - Approval notifications for marketplace transactions.

- **IoT Hardware Integration (ESP32 & Bolt-IoT)**  
  - Captures real-time data on soil nutrients, moisture, temperature, and other field conditions.
  - Sends data directly to Salesforce using platform events for real-time monitoring and actionable insights.
  - Enables remote control of farm utensils (e.g., pumps and lights) through Bolt Cloud, including:
    - Viewing the last operation time.
    - Monitoring total active time for each device.

- **OpenWeatherMap API**  
  - Provides real-time weather updates that are seamlessly integrated into the field overview dashboard, helping farmers make informed decisions based on weather conditions.

---

### Solution Architecture <a name="solution-architecture"></a>

![Solution Architecture](https://github.com/Ayanghosh-agno/Agrosphere/blob/main/Agrosphere%20Readme%20Images/Agrosphere%20architecture.png)


<h2 align="center"> Detailed Description<a name="detailed-description"></a> </h2>

### What Does AgroSphere Do? <a name="agrosphere-aim"></a>

AgroSphere is an integrated platform that combines real-time environmental monitoring, AI-driven insights, and a connected marketplace to empower farmers. It addresses critical challenges in modern farming by optimizing productivity, sustainability, and profitability. Below is an overview of its core functionalities:

---

#### 1. Real-Time Environmental Monitoring  
- **IoT-based sensors** installed on farms capture and transmit key environmental and soil data, including:
  - Soil moisture, temperature, pH, and nutrients (Nitrogen, Phosphorus, Potassium).
  - Atmospheric conditions like temperature, humidity, and light lux levels.  
- **Real-time data** allows farmers to track performance, identify issues early, and take preventive actions effectively.

---

#### 2. AI-Driven Insights  
Powered by **IBM WatsonX AI**, AgroSphere delivers actionable insights, such as:  
- **Irrigation recommendations** based on soil moisture levels and weather data.  
- **Farming best practices** for crop rotation, fertilization, and pest control.  
- **Localized weather predictions** to help farmers adapt to environmental changes.

---

#### 3. Control of Farm Equipment  
- Remotely control essential farm equipment (e.g., pumps, lights, and machinery) via the platform.  
- Track device usage, including:
  - **Last operation time** and **total active time.**  
- Automate processes like irrigation and field operations for efficiency and cost savings.

---

#### 4. Marketplace for Agricultural Products  
AgroSphere hosts a connected **marketplace** where farmers and businesses can:  
- **Buy, sell, or lease** agricultural products and equipment.  
- **Filter products** by category, price, or type.  
- **Secure transactions** using DocuSign for agreements.  
- **Track orders** and receive updates on shipment or approval status.

---

#### 5. Case Management & Communication  
AgroSphere includes a **Case Management System** for resolving user issues:  
- **Case tracking:** Users can monitor their case progress and interact with support agents.  
- **OTP verification** ensures security for unauthenticated users.  
- **Notifications:** Users receive SMS and email updates about case resolutions.

---

#### 6. User Registration and Authentication  
- **Simple sign-up process:** Users provide email and details.  
- **DocuSign integration:** Users sign an agreement during registration to confirm terms acceptance.  
- After successful registration:  
  - **Confirmation email** is sent for password reset.  
  - Access to the platform features is granted.

---

#### 7. Salesforce Integration  
- **Salesforce Experience Cloud**:
  - Provides an intuitive interface for farmers to manage accounts, cases, and insights.
  - Powers the marketplace for buying and leasing equipment.
- **Salesforce Service Cloud**:
  - Manages backend operations, including storing IoT data and automating processes like report generation and agreement voiding.

---

#### 8. Notifications and Alerts  
AgroSphere keeps users informed with timely notifications:  
- **Sensor Alerts:** Notifies when readings exceed thresholds (e.g., low soil moisture).  
- **Equipment Alerts:** Updates about malfunctions or required maintenance.  
- **Case Updates:** SMS and email updates about case submissions, progress, and resolutions.

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

<h2 align="center"> Presentation materials <a name="presentation-materials"></a> </h2>

### Solution Demo Video <a name="solution-demo-video"></a>

[![Solution Demo Video](https://github.com/Ayanghosh-agno/Agrosphere/blob/main/Agrosphere%20Readme%20Images/Agrosphere-Thumbnail.png)]()

---

### Live Demo <a name="Live-Demo"></a>

We can see live working of Agrosphere Website - [AGROSPHERE](https://agno-dev-ed.develop.my.site.com/agrospehre/s/)


<h2 align="center"> About <a name="about"></a> </h2>

### Author<a name="Authors"></a>

<img src="https://github.com/Ayanghosh-agno/Agrosphere/blob/main/Agrosphere%20Readme%20Images/Ayan%20Ghosh.png" style="max-width: 70px;">

   **Ayan Ghosh**


---

### License<a name="license"></a>
This project is licensed under the Apache 2 License - see the [LICENSE](LICENSE) file for details.

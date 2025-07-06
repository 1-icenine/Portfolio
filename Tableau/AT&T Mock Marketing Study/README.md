# 📊 AT&T Marketing Metrics Analysis

This project is a mock portfolio case study I did during my COOP fellowship with 3 other colleagues. I analyzed AT&T's marketing performance with two datasets about campaign performance and user info. My goal was to uncover actionable insights by location to improve customer engagement and campaign effectiveness

## 🔍 Project Overview

**Objective:**  
- Clean and prepare a dataset of 700+ entries to ensure it can be joined with another dataset containing user demographic info
- Analyze and visualize key marketing metrics (vCPM, CTR, viewability, and viewable impressions) for AT&T to evaluate campaign performance, customer demographics, and engagement trends

**Tools Used:**
- Excel – data cleaning and preprocessing
  - [📈 Campaign and User Demographic Datasets](https://github.com/1-icenine/Portfolio/tree/main/Tableau/AT%26T%20Mock%20Marketing%20Study/Dataset)
- Tableau – trend analysis via dual charts
  - [📶 Tableau Public Link](https://public.tableau.com/app/profile/nicholas.louie/viz/NicksSpatialAnalysisCTRCPMvCPMViewability/vCPMvsViewabilityDualChart)
- Canva – presentation to mock stakeholders
  - [📽️ Presentation Slide Deck](https://github.com/1-icenine/Portfolio/blob/main/Tableau/AT%26T%20Mock%20Marketing%20Study/Presentation/C515%20Capstone%20Project.pdf)

## ⚙️ Process Breakdown

### 1. Data Cleaning (Excel)
- Extracted `creative_size` and `user_id` from a combined column using the `SPLIT` function with "|" as the delimiter
- Renamed columns for clarity (e.g., `creative_size` → `creative_size_px`, `gross_cost` → `gross_cost_USD`)
- Formatted `gross_cost_USD` as currency (note: removed "$" to avoid issues when importing to SQL)
- Identified and removed duplicate `campaign_id` entries (used conditional formatting)
- Removed rows with missing critical KPIs
- Validated `campaign_id` consistency using `LEN()` to ensure uniform formatting
- Reviewed column filters to check for spelling inconsistencies (none found)
- Cleaned up special characters (e.g., replaced "Â»" with "-" in `audience_segment`)

### 2. Data Analysis (Tableau)
- Compared vCPM against CTR, viewability, and viewable impression count across states
- Identified trends among the top 5 and bottom 5 states by average gross campaign budget
- Created impactful visualizations for stakeholder exploration and presentation

### 3. Stakeholder Presentation
- Delivered a visual summary of insights to 4 mock stakeholders
- Highlighted performance gaps between high-budget and low-budget regions
- Proposed targeted optimizations based on data-driven findings

## 📌 Key Insights

- California, Arizona, and Colorado emerged as top-performing states, with strong conversion rates and relatively low costs
- Viewable impressions and overall viewability appear to correlate more closely with state population size and campaign frequency than cost

## My Slide Visuals
![462949202-4ac60f4b-5d1f-44df-84c1-d410921c8742](https://github.com/user-attachments/assets/1d0eb2bd-3b22-4a82-a963-7285a2cdaa0b)
![462949214-fa585ae7-5c7c-41e2-99ac-b1c3d31d48fe](https://github.com/user-attachments/assets/b09981c6-6c95-4abb-9e1e-c878795f4355)
![462949223-979ead2a-4390-4a33-b30f-43a81999ba3b](https://github.com/user-attachments/assets/670ebd57-ed5f-482c-8e84-592559f88d99)
![462949181-b3fb5c05-73e7-4f46-ac43-58cb8ef15c07](https://github.com/user-attachments/assets/2aa938ef-1864-4c94-b736-b64ef084e9b3)




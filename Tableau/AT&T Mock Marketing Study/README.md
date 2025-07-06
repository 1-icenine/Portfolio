# 📊 AT&T Marketing Metrics Analysis

This project is a mock portfolio case study I did during my COOP fellowship. I analyzed AT&T's marketing performance with a dataset provided for educational purposes. My goal was to uncover actionable insights by location to improve customer engagement and campaign effectiveness

## 🔍 Project Overview

**Objective:**  
- Clean and prepare a dataset of 700+ entries to ensure it can be joined with another dataset containing user demographic info
- Analyze and visualize key marketing metrics (vCPM, CTR, viewability, and viewable impressions) for AT&T to evaluate campaign performance, customer demographics, and engagement trends

**Tools Used:**
- Excel – data cleaning and preprocessing
  - [📈 Click here for the campaign and user demographic datasets](https://github.com/1-icenine/Portfolio/tree/main/Tableau/AT%26T%20Mock%20Marketing%20Study/Dataset)
  - [🧹 Click here for my cleaning process for campaign dataset](https://github.com/1-icenine/Portfolio/blob/main/Tableau/AT%26T%20Mock%20Marketing%20Study/Dataset/Nick's%20Data%20Cleanup%20Process.pdf)
- Tableau – trend analysis via dual charts
  - [📶 Click here for my Tableau visualizations](https://public.tableau.com/app/profile/nicholas.louie/viz/NicksSpatialAnalysisCTRCPMvCPMViewability/vCPMvsViewabilityDualChart)
  - [🖼️ Click here for my presentation slides](https://github.com/1-icenine/Portfolio/tree/main/Tableau/AT%26T%20Mock%20Marketing%20Study/Visuals)
- Canva – presentation to mock stakeholders
  - [📽️ Click here for the presentation](https://github.com/1-icenine/Portfolio/blob/main/Tableau/AT%26T%20Mock%20Marketing%20Study/Presentation/C515%20Capstone%20Project.pdf)

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

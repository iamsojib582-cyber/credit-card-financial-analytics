# Credit Card Analytics & Business Intelligence Dashboard

SQL-based data analysis with Power BI visualizations for customer credit card insights.

---

## 📌 Overview

Analysis of 10K+ customers and 10K+ credit card transactions to identify spending patterns, risk assessment, and revenue optimization opportunities.

**Data**: 2 SQL tables (customer_data + card_data)  
**Tools**: SQL + Power BI  
**Queries**: 22 (Basic to Advanced)  
**Dashboards**: 2 (Interactive Power BI pages)

---

## 📊 Dashboards

### 1️⃣ Customer Risk & Behavior Analysis
- Total customers: 10K
- Risk customers identified: 482
- Critical risk customers: 614
- Customer satisfaction score: 3.19/5
- Visualizations:
  - Transaction amount by education level
  - Customer distribution by age & gender
  - Interest earned by job category
  - Geographic distribution (US map)
  - Revenue by age group
  - Satisfaction vs delinquency analysis

### 2️⃣ Credit Card Portfolio Performance
- Total revenue: $10.8M
- Total interest earned: $7.8M
- Total transaction amount: $44.5M
- Average utilization: 27.5%
- Delinquency rate: 6.1%
- Visualizations:
  - Monthly transaction & revenue trends
  - Week-over-week performance analysis
  - Revenue by card category
  - Delinquency by expense type
  - Transaction amount by gender
  - Weekly interest income trend

---

## 🗄️ Database Tables

**customer_data** (10K records)
- client_num, age, gender, income, education, job, state, satisfaction score, etc.

**card_data** (10K records)
- client_num, card_category, annual_fees, credit_limit, total_trans, avg_utilization, delinquent, etc.

---

## 📋 SQL Queries (22 Total)

| Level | Count | Topics |
|-------|-------|--------|
| Level 1 | 5 | Basic reporting, revenue tracking, demographics |
| Level 2 | 4 | Joins, aggregations, customer segmentation |
| Level 3 | 4 | Complex filtering, risk assessment, correlations |
| Level 4 | 4 | Window functions, CTEs, trend analysis |
| Level 5 | 5 | Strategic insights, growth opportunities |

---

## 🔑 Key Findings

- 482 high-risk customers identified (4.8% of base)
- Age group 40-50 generates highest revenue ($4.8M)
- Delinquency concentrated in low-income segments
- Blue card category dominates revenue ($9.1M)
- Geographic hotspots: California, Texas, New York
- Graduation holders show 30% higher spending
- Businessmen category most profitable
- Week 5-7 show highest transaction decline trends
- Female customers: slightly higher utilization (28%)
- Chip technology correlates with lower delinquency

---

## ⚙️ Setup

### Clone Repository
```bash
git clone https://github.com/yourusername/credit-card-analytics.git
```

### Database Setup
1. Create database
2. Import `customer_data.csv` and `card_data.csv`
3. Run SQL queries from `/SQL_Queries` folder

### Power BI
1. Open `Dashboard.pbix` in Power BI Desktop
2. Update data source connections
3. Refresh data

---

## 📁 Project Structure

```
credit-card-analytics/
├── README.md
├── SQL_Queries/
│   ├── Level_1_Basic.sql
│   ├── Level_2_Intermediate.sql
│   ├── Level_3_Advanced.sql
│   ├── Level_4_Expert.sql
│   └── Level_5_Strategic.sql
├── Power_BI/
│   ├── Dashboard.pbix
│   └── Screenshots/
├── Data/
│   ├── customer_data.csv
│   └── card_data.csv
└── Documentation/
    └── Key_Insights.md
```

---

## 📈 Dashboard Filters

Both dashboards support filtering by:
- Card Category (Blue, Silver, Gold, Platinum)
- Time Period (Date range)
- Geographic Region (State)
- Customer Segment

---

## 🎯 Business Outcomes

✅ Identified high-risk customers for intervention  
✅ Discovered premium customer segments  
✅ Revenue trends by demographics  
✅ Delinquency risk assessment  
✅ Geographic expansion opportunities  
✅ Product optimization insights  

---

## 🛠️ Tech Stack

- **Database**: SQL Server / MySQL / PostgreSQL
- **Query Language**: SQL (Advanced - Joins, Window Functions, CTEs)
- **Visualization**: Power BI Desktop
- **Version Control**: Git/GitHub

---

## 📞 Contact

- **Author**: [Your Name]
- **Email**: [your.email@example.com]
- **GitHub**: [@yourusername](https://github.com/yourusername)

---

## 📄 License

MIT License - feel free to use for learning & development

---

**Last Updated**: February 2026  
**Status**: ✅ Complete  
**Version**: 1.0

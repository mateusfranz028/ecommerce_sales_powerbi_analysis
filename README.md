# E-Commerce Sales & Logistics Analytics Dashboard


<img width="1478" height="831" alt="gif dashboard" src="https://github.com/user-attachments/assets/709025b5-7b98-457d-9af9-c38a5bed2ec1" />

---

### Introduction

This e-commerce sales and logistics dashboard was created to help retail executives and operations teams track commercial performance, identify regional shipping bottlenecks, and understand product-level sales dynamics.

The data is from the Brazilian E-Commerce Public Dataset by Olist, covering orders made between 2016 and 2018. It contains detailed transaction logs, shipping metrics, customer locations, and product catalog records that are visualized here.

### Project Files
* **Interactive Power BI Report:** [ecommerce_sales_powerbi_analysis.pbix](ecommerce_sales_powerbi_analysis.pbix)
* **SQL Extraction Script:** [data_extraction_and_cleaning.sql](data_extraction_and_cleaning.sql)
* **Exploratory Excel Audit:** [ecommerce_exploratory_audit.xlsx](ecommerce_exploratory_audit.xlsx)

## Skills Used

The following technical skills were utilized across the end-to-end pipeline:
* 🐘 **PostgreSQL:** Multi-table relational joins, data aggregation, and order status filtering (`WHERE o.order_status = 'delivered'`)
* 📊 **Excel & Power Query:** Locale-based decimal conversion, data type auditing, and pivot-table cross-validation
* 📐 **DAX & Modeling:** Custom explicit measures, dynamic aggregations, and dimensional date transformations
* 📉 **Power BI Visuals:** Cross-filtering, clustered bar charts, monthly trend lines, and geographic matrices

## E-Commerce Dataset

The dataset used for this project contains real-world Brazilian marketplace transactions (~108k order items totaling R$ 13.05M in gross merchandise value). It includes detailed records on:
* 📦 **Order IDs & Timestamps:** Purchase, approval, and fulfillment delivery dates
* 💰 **Financials:** Item prices, freight costs, and gross order values
* 🏷️ **Product Catalog:** Categories, descriptions, and catalog dimensions
* 📍 **Geographic Data:** Customer cities and states (UF) across Brazil

---

## Business Questions Answered

1. **Revenue & Volume:** What is the consolidated gross revenue, order volume, and average order value (AOV)?
2. **Product Catalog Mix:** Which categories drive the bulk of revenue, and what operational roles do they play (high turnover vs. high margin)?
3. **Logistics Friction:** How does geographical concentration impact shipping costs, and which regions face conversion friction due to freight?
4. **Seasonality & Outliers:** Can historical sales spikes be attributed to organic scale (e.g., Black Friday) or isolated corporate order anomalies?

---

## Technical Pipeline & Implementation

### 1. Relational Data Extraction (SQL)

The analytical dataset was consolidated in PostgreSQL by joining transactional, customer, and catalog tables while filtering out non-commercial order statuses (cancels and non-deliveries).

```sql
SELECT 
    o.order_id,
    o.order_purchase_timestamp AS data_compra,
    o.order_delivered_customer_date AS data_entrega,
    p.product_category_name AS categoria,
    c.customer_city AS cidade_cliente,
    c.customer_state AS uf_cliente,
    oi.price AS preco,
    oi.freight_value AS frete,
    (oi.price + oi.freight_value) AS valor_total
FROM olist_orders_dataset o
JOIN olist_order_items_dataset oi ON o.order_id = oi.order_id
JOIN olist_customers_dataset c ON o.customer_id = c.customer_id
JOIN olist_products_dataset p ON oi.product_id = p.product_id
WHERE o.order_status = 'delivered';
```

### 2. Data Auditing & Sanity Checks (Excel & Power Query)
Before visualization, the dataset underwent an exploratory audit:

Locale & Type Sanitation: Handled UTF-8 encoding and decimal separators (. vs. ,) to prevent scale distortions.

Granularity Audit: Verified total volume (108,652 line items across 95,140 unique orders) and audited total revenue (R$ 13,049,522.30) to establish a trusted baseline.

Temporal Decomposition: Handled timestamp strings into year-month cohorts to distinguish structural Black Friday demand from single-ticket bulk outliers.

### 3. Metric Architecture & Data Modeling (DAX)

A dedicated _Medidas table was constructed in Power BI Desktop to compute dynamic metrics:

```
Receita Total = SUM(olist_base_analitica[preco])
Total Pedidos = DISTINCTCOUNT(olist_base_analitica[order_id])
Ticket Medio  = DIVIDE([Receita Total], [Total Pedidos], 0)
Total Frete   = SUM(olist_base_analitica[frete])
% Frete       = DIVIDE([Total Frete], [Receita Total], 0)
ano_mes       = LEFT(olist_base_analitica[data_compra], 7)
```

### Key Insights & Visual Deep Dives
Executive KPIs

- Consolidated Revenue: R$ 13.05M

- Unique Orders: 95.14K

- Average Order Value (AOV): R$ 137.16

- Average Freight Burden: 16.64% of product price

  <img width="1477" height="216" alt="image" src="https://github.com/user-attachments/assets/03a6c494-9f9c-4688-bba9-fe6838455887" />


### Top Categories by Revenue

- Volume Engine: beleza_saude leads overall sales (R$ 1.23M) driven by strong repurchase frequency and a accessible average ticket (R$ 130.28).

- High-Ticket Segments: relogios_presentes (R$ 1.17M) and cama_mesa_banho (R$ 1.02M) form the remaining core revenue pillars, combining to represent over a quarter of platform sales.

### Monthly Revenue Trend & Seasonality

- Inflection Point: Sales accelerated rapidly from modest monthly runs (~R$ 40K–R$ 100K) early in 2017 to sustained runs of R$ 800K–R$ 950K/month in 2018.

- Black Friday Impact: November 2017 represented the platform's primary scale inflection, nearly doubling month-over-month transactional volume (~8.3k orders).

- Outlier Isolation: Identifying and isolating bulk commercial orders in September 2017 confirmed that long-term scale was volume-driven rather than ticket-inflated.

### Regional Concentration & Logistics Burden

- The São Paulo Hub: SP accounts for 38.3% of platform revenue (R$ 5.00M) with the lowest freight burden in Brazil (14% ratio to product price), acting as the central logistics anchor.

- Long-Haul Friction: Customers in the North and Northeast face severe logistics friction, with shipping costs reaching 23%–26% of cart value (e.g., Maranhão at 26%, Piauí at 24%), representing a major conversion drop-off factor.

### Strategic Recommendations

- Regional Freight Subsidies: Introduce tiered free-shipping thresholds for light, high-turnover items (beleza_saude) in Northeast capitals to lower regional checkout abandonment.

- Cross-Sell Funnels: Leverage the large customer base of beleza_saude by creating automated post-purchase recommendations for higher-margin goods (relogios_presentes, perfumaria).

- Q4 Inventory Lead Time: Secure fulfillment center buffer stock for the top 3 categories 60 days ahead of November to prevent inventory stockouts during peak promotional events.

### Conclusion
This project highlights a complete data analytics pipeline, bridging the gap between low-level relational queries and executive decision-making. By combining SQL extraction, Excel-based data auditing, and Power BI visual storytelling, the analysis isolated true seasonal demand, exposed geographical logistics friction, and delivered actionable commercial recommendations.  

# E-Commerce Sales & Logistics Analytics (Power BI)

## Dashboard Overview

![Olist Executive Dashboard](assets/dashboard_screenshot.png)

Interactive Power BI dashboard evaluating commercial performance, regional logistics costs, product categories, and temporal seasonality on the public Olist e-commerce dataset (~108k orders, totaling R$ 13.05M in gross merchandise value).

### Dashboard File
Download the interactive Power BI file: [ecommerce_sales_powerbi_analysis.pbix](ecommerce_sales_powerbi_analysis.pbix)

---

## Business Questions

1. **Revenue & Volume:** What is the total accumulated revenue, average order value (AOV), and total order volume?
2. **Top Categories:** Which product categories drive the highest revenue versus transactional volume?
3. **Regional Concentration & Logistics Friction:** Which Brazilian states generate the most revenue, and how does freight share vary across regions?
4. **Seasonality & Outliers:** Were historical revenue spikes driven by transactional anomalies (outliers) or organic scale (e.g., Black Friday)?

## Dashboard Build

### 1. Core KPIs & DAX Measures

A dedicated `_Medidas` table was built to compute dynamic business metrics:

```dax
Receita Total = SUM(olist_base_analitica[preco])
Total Pedidos = DISTINCTCOUNT(olist_base_analitica[order_id])
Ticket Medio  = DIVIDE([Receita Total], [Total Pedidos], 0)
% Frete       = DIVIDE(SUM(olist_base_analitica[frete]), [Receita Total], 0)

```

* **Total Revenue:** R$ 13.05M
* **Total Orders:** 95.14K unique transactions
* **Average Ticket (AOV):** R$ 137.16
* **Average Freight Burden:** 16.64% of product price

---

### 2. Top 10 Product Categories by Revenue

* **Visual:** Horizontal Clustered Bar Chart filtered by Top 10 `Receita Total`.
* **Key Finding:** `beleza_saude` leads overall revenue (R$ 1.23M) driven by high turnover and recurring purchase frequency, closely followed by `relogios_presentes` (R$ 1.17M) and `cama_mesa_banho` (R$ 1.02M).

---

### 3. Monthly Revenue Evolution & Seasonality

* **Visual:** Temporal Line Chart aggregated monthly via custom DAX:
```dax
ano_mes = LEFT(olist_base_analitica[data_compra], 7)

```


* **Key Finding:** Organic business inflection occurred during Q4 2017 with Black Friday (November 2017) doubling transaction volume (~8.3k orders). Isolated ticket spikes (such as bulk corporate orders in September 2017) were effectively distinguished from organic demand surges.

---

### 4. Regional Concentration & Freight Friction by State (UF)

* **Visual:** Analytical Matrix ranked by descending revenue alongside freight share (`% Frete`):
* **São Paulo (SP):** Generates R$ 5.00M (38.3% of total volume) with the lowest national shipping friction (**14%** freight ratio), operating as the primary logistics hub.
* **North & Northeast Regions:** States such as Maranhão (26%), Piauí (24%), and Paraíba (23%) face significantly higher freight penalties, signaling a conversion bottleneck in long-haul fulfillment.



---

## Strategic Recommendations

1. **Logistics Subsidies in Northern Hubs:** Implement progressive shipping discounts on high-demand, low-weight categories (`beleza_saude`) to unlock conversion outside the Southeast.
2. **Cross-Selling Pathways:** Target repeat buyers from high-turnover segments with personalized promotions for higher-margin categories (`relogios_presentes`).
3. **Black Friday Inventory Lead Time:** Secure supplier lead times and warehouse stock for the top 3 categories 60 days prior to Q4 peaks to prevent stockouts.

## Conclusion
This project demonstrates an end-to-end data analytics pipeline, from data auditing and transformation in Power Query to relational modeling and dynamic metric generation using DAX in Power BI. The analysis provided actionable business clarity by isolating revenue outliers from organic growth drivers, uncovering critical logistics friction points across Brazilian regions, and establishing data-backed recommendations for inventory management and customer retention.

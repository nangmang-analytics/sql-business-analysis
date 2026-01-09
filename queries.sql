/* =========================================================
   SQL Business Analysis (starter queries)
   Dataset file: sales_data_sample.csv
   ========================================================= */

/* 1) Quick peek: how many rows? */
-- Note: In many SQL tools you load the CSV into a table first.
-- Assume your table name is: sales_data
SELECT COUNT(*) AS total_rows
FROM sales_data;


/* 2) Total revenue (sales) overall */
SELECT
  ROUND(SUM(sales), 2) AS total_revenue
FROM sales_data;


/* 3) Revenue by year */
SELECT
  year_id,
  ROUND(SUM(sales), 2) AS revenue
FROM sales_data
GROUP BY year_id
ORDER BY year_id;


/* 4) Top 10 customers by revenue */
SELECT
  customername,
  ROUND(SUM(sales), 2) AS revenue
FROM sales_data
GROUP BY customername
ORDER BY revenue DESC
LIMIT 10;


/* 5) Top 10 products by revenue */
SELECT
  productcode,
  ROUND(SUM(sales), 2) AS revenue
FROM sales_data
GROUP BY productcode
ORDER BY revenue DESC
LIMIT 10;


/* 6) Revenue by product line */
SELECT
  productline,
  ROUND(SUM(sales), 2) AS revenue
FROM sales_data
GROUP BY productline
ORDER BY revenue DESC;


/* 7) Order status breakdown (count + revenue) */
SELECT
  status,
  COUNT(*) AS rows_count,
  ROUND(SUM(sales), 2) AS revenue
FROM sales_data
GROUP BY status
ORDER BY revenue DESC;


/* 8) Average order value (AOV) — average sales per row */
SELECT
  ROUND(AVG(sales), 2) AS avg_order_value
FROM sales_data;


/* 9) Monthly revenue trend (year + month) */
SELECT
  year_id,
  month_id,
  ROUND(SUM(sales), 2) AS revenue
FROM sales_data
GROUP BY year_id, month_id
ORDER BY year_id, month_id;


/* 10) Best month per year (by revenue) */
WITH monthly AS (
  SELECT
    year_id,
    month_id,
    SUM(sales) AS revenue
  FROM sales_data
  GROUP BY year_id, month_id
),
ranked AS (
  SELECT
    year_id,
    month_id,
    revenue,
    DENSE_RANK() OVER (PARTITION BY year_id ORDER BY revenue DESC) AS rnk
  FROM monthly
)
SELECT
  year_id,
  month_id,
  ROUND(revenue, 2) AS revenue
FROM ranked
WHERE rnk = 1
ORDER BY year_id;


/* 11) Deal size impact */
SELECT
  dealsize,
  ROUND(SUM(sales), 2) AS revenue,
  ROUND(AVG(sales), 2) AS avg_sale
FROM sales_data
GROUP BY dealsize
ORDER BY revenue DESC;


/* 12) Territory / country revenue (top 10) */
SELECT
  country,
  ROUND(SUM(sales), 2) AS revenue
FROM sales_data
GROUP BY country
ORDER BY revenue DESC
LIMIT 10;

WITH c AS(
SELECT CASE WHEN MONTH(sale_date) IN(12,1,2) THEN 'Winter' WHEN MONTH(sale_date) IN(3,4,5) THEN 'Spring' WHEN MONTH(sale_date) IN(6,7,8) THEN 'Summer' ELSE 'Fall' END season,category,SUM(quantity) total_quantity,SUM(quantity*price) total_revenue FROM sales s JOIN products p USING(product_id) GROUP BY season,category),
r AS(
SELECT *,ROW_NUMBER() OVER(PARTITION BY season ORDER BY total_quantity DESC,total_revenue DESC,category) rn FROM c)
SELECT season,category,total_quantity,total_revenue FROM r WHERE rn=1 ORDER BY season;
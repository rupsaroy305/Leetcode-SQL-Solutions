WITH r AS(
SELECT *,ROW_NUMBER() OVER(PARTITION BY employee_id ORDER BY review_date DESC) rn
FROM performance_reviews),
t AS(
SELECT employee_id,
MAX(CASE WHEN rn=1 THEN rating END) r1,
MAX(CASE WHEN rn=2 THEN rating END) r2,
MAX(CASE WHEN rn=3 THEN rating END) r3
FROM r
WHERE rn<=3
GROUP BY employee_id)
SELECT e.employee_id,name,r1-r3 AS improvement_score
FROM t JOIN employees e USING(employee_id)
WHERE r1 IS NOT NULL AND r2 IS NOT NULL AND r3 IS NOT NULL
AND r3<r2 AND r2<r1
ORDER BY improvement_score DESC,name;
WITH c AS(
SELECT user_id,action_date,MIN(action) action
FROM activity
GROUP BY user_id,action_date
HAVING COUNT(*)=1
),
t AS(
SELECT *,DATE_SUB(action_date,INTERVAL ROW_NUMBER()OVER(PARTITION BY user_id,action ORDER BY action_date) DAY) g
FROM c
),
x AS(
SELECT user_id,action,COUNT(*) streak_length,MIN(action_date) start_date,MAX(action_date) end_date
FROM t
GROUP BY user_id,action,g
HAVING COUNT(*)>=5
),
r AS(
SELECT *,ROW_NUMBER()OVER(PARTITION BY user_id ORDER BY streak_length DESC) rn
FROM x
)
SELECT user_id,action,streak_length,start_date,end_date
FROM r
WHERE rn=1
ORDER BY streak_length DESC,user_id;
WITH cte AS (
SELECT *,ROW_NUMBER() OVER(PARTITION BY user_id ORDER BY event_date DESC) rn,
MIN(event_date) OVER(PARTITION BY user_id) first_dt,
MAX(event_date) OVER(PARTITION BY user_id) last_dt,
MAX(monthly_amount) OVER(PARTITION BY user_id) mx,
SUM(event_type='downgrade') OVER(PARTITION BY user_id) dg
FROM subscription_events
)
SELECT user_id,plan_name current_plan,monthly_amount current_monthly_amount,mx max_historical_amount,DATEDIFF(last_dt,first_dt) days_as_subscriber
FROM cte
WHERE rn=1 AND event_type<>'cancel' AND dg>0 AND monthly_amount<mx/2 AND DATEDIFF(last_dt,first_dt)>=60
ORDER BY days_as_subscriber DESC,user_id;
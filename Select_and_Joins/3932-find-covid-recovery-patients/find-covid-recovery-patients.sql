WITH p AS (SELECT patient_id,MIN(test_date) pos FROM covid_tests WHERE result='Positive' GROUP BY patient_id)
SELECT pa.patient_id,patient_name,age,DATEDIFF(MIN(c.test_date),pos) recovery_time
FROM p
JOIN covid_tests c ON p.patient_id=c.patient_id AND c.result='Negative' AND c.test_date>pos
JOIN patients pa ON p.patient_id=pa.patient_id
GROUP BY pa.patient_id,patient_name,age,pos
ORDER BY recovery_time,patient_name;
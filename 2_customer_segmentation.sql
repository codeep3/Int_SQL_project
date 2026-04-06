WITH customer_ltv AS (
	SELECT 
		ca.customerkey,
		ca.customer_name,
		SUM(ca.total_net_revenue) AS total_ltv
	FROM cohort_analysis AS ca
	GROUP BY 
		ca.customerkey,
		ca.customer_name),
		
	customer_segments AS(
	SELECT 
		PERCENTILE_CONT(0.25) WITHIN GROUP (ORDER BY total_ltv) AS ltv_25th_percentile,
		PERCENTILE_CONT(0.75) WITHIN GROUP (ORDER BY total_ltv) AS ltv_75th_percentile
	FROM 
		customer_ltv
	), 
	
	segement_values AS (
	SELECT 
		c.*,
		CASE 
			WHEN c.total_ltv<cs.ltv_25th_percentile THEN '1-LOW VALUE'
			WHEN c.total_ltv<=cs.ltv_75th_percentile THEN '2-MID VALUE'
			ELSE '3-HIGH VALUE'
		END AS customer_segment
	FROM 
		customer_ltv AS c ,
		customer_segments AS cs
	)
	
SELECT 
	customerkey,
	customer_name,
	total_ltv,
	customer_segment
FROM 
	segement_values 
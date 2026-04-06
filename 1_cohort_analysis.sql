SELECT 
	cohort_year,
	COUNT(DISTINCT customerkey) AS total_customers,
	ROUND(SUM(total_net_revenue)::NUMERIC,1) AS total_revenue,
	SUM(total_net_revenue)/COUNT(DISTINCT customerkey) AS customer_revenue
FROM 
	cohort_analysis
WHERE orderdate=first_purchase_date 
GROUP BY 
	cohort_year
ORDER BY 
	cohort_year,
	total_customers,
	total_revenue
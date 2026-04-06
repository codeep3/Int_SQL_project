WITH retention AS(
	SELECT 
		customerkey,
		MAX(first_purchase_date) AS first_purchase_date,
		MAX(customer_name) AS customer_name,
		MAX(orderdate) AS last_purchase_date,
		AGE('2024-04-20',MAX(orderdate)) AS purchase_time
	FROM	
		cohort_analysis
	GROUP BY 
		customerkey
	ORDER BY 
		customerkey
)

SELECT 
	customerkey,
	customer_name,
	first_purchase_date,
	last_purchase_date,
	CASE 
		WHEN purchase_time>INTERVAL '6 months' THEN 'CHURNED'
		ELSE 'ACTIVE'
	END AS customer_status
FROM 
	retention
WHERE	first_purchase_date < '2023-10-20'


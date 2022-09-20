-- Categorizing customers
SELECT *
FROM rfm_data;

SELECT CUSTOMERNAME, R, F, M,
	CASE
		WHEN (R = 3) AND (F = 3) AND (M = 3) THEN 'Soulmates' 
        WHEN (R >= 3) AND (F >= 2) AND (M >= 2) THEN 'Loyal Customers'
		WHEN (R >= 2) AND (F >= 2) AND (M >= 2) THEN 'Potential Loyal Customers'
        WHEN (R = 3) AND (F = 1) AND (M >= 2) THEN 'New Customers'
		WHEN (R >= 1) AND (F >= 2) AND (M >= 2) THEN 'Need Attention'
        WHEN (R >= 1) AND (F >= 1) AND (M >= 1) THEN 'Hibernating'
	END RFM_Segment
FROM rfm_data;
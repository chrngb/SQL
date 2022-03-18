WITH
    cte AS (
        SELECT *, fiscal_year / 10000 AS years FROM dividend
    ),
    cte2 AS (
        SELECT *,
		CASE
            WHEN lead(years) OVER (PARTITION BY company ORDER BY years) = years + 1
			AND lead(years,2) OVER (PARTITION BY company ORDER BY years) = years + 2
			THEN 'yes'
             WHEN lag(years) OVER (PARTITION BY company ORDER BY years) = years-1
			AND lag(years,2) OVER (PARTITION BY company ORDER BY years) = years-2
			THEN 'yes'
            WHEN lag(years) OVER (PARTITION BY company ORDER BY years) = years-1
			AND lead(years) OVER (PARTITION BY company ORDER BY years) = years + 1
            THEN 'yes'
			ELSE NULL
		END AS value
	FROM cte
    )
SELECT array_agg (DISTINCT company || ' ') AS value_stocks
FROM cte2
WHERE value = 'yes'

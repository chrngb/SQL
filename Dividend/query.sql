-- query to find companies that have given dividend for at least 3 consecutive year in the past

select company as value_stocks 
from(
	select *,
		case when lead(year) over (partition by company order by year) = year+1 
			and lead(year,2) over (partition by company order by year) = year+2
			then 'yes'
			else null
		end as value
	from(
		select *, 
			LEFT(fiscal_year,4) as year
		from dividend) new
)c
where c.value is not null

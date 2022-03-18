with join1 as (select d.name as department, e.name as employee, e.salary as salary
                from department d
                join employee e
                on d.id = e.departmentid),

    ranks as (select *,
                dense_rank() over(partition by department order by salary desc) as rank
                from join1)
       
select department, employee, salary 
from ranks                
where rank <=3

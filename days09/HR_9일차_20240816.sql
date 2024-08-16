
-- 안티조인
SELECT *
FROM employees
WHERE department_id NOT IN (
                            SELECT department_id
                            FROM departments
                            WHERE location_id = 1700
                            );
                            
-- 세미조인

SELECT *
FROM departments d 
WHERE EXISTS (
                SELECT *
                FROM  employees e
                WHERE d.department_id = e.department_id
                AND e.salary > 2500
                ); -- 2500 이상 받는 사원이 있는지 출력.



































































































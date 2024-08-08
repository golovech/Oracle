select last_name,rpad(' ', salary/1000/1,'*') "Salary" -- *로 막대그래프 그리겠다.
FROM employees
WHERE department_id = 80
ORDER BY last_name, "Salary"; 
--
SELECT last_name
    , salary ㄱ
    , salary/1000 ㄴ
    , ROUND(salary/1000) ㄷ -- 반올림
    , RPAD(' ',ROUND(salary/1000)+1,'*')
FROM employees;

UPDATE employees 
SET salary = salary * '100.00'
WHERE last_name = 'Perkins';

SELECT *
FROM employees 
WHERE last_name = 'Perkins';
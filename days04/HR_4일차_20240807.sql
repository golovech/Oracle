select last_name,rpad(' ', salary/1000/1,'*') "Salary" -- *�� ����׷��� �׸��ڴ�.
FROM employees
WHERE department_id = 80
ORDER BY last_name, "Salary"; 
--
SELECT last_name
    , salary ��
    , salary/1000 ��
    , ROUND(salary/1000) �� -- �ݿø�
    , RPAD(' ',ROUND(salary/1000)+1,'*')
FROM employees;

UPDATE employees 
SET salary = salary * '100.00'
WHERE last_name = 'Perkins';

SELECT *
FROM employees 
WHERE last_name = 'Perkins';
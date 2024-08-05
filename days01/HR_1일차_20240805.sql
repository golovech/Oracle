select *
from tabs;

-- SELECT  first_name + last_name  : ORA-01722: invalid number // + 써서!
-- 자바: 문자열 연결 연산자 +
-- 오라클: 문자열 연결 연산자 ||, ' ' 문자열, 날짜형을 전부 '  ' 안에 넣는다. 칼럼명의 별칭은 " " 이다.
SELECT  first_name as fname, first_name || ' ' || last_name AS "name"
, CONCAT(CONCAT (first_name, ' ' ) ,last_name ) AS name -- " " 없어도 됨.(문자열에 공백이 없다면)
, CONCAT(CONCAT (first_name, ' ' ) ,last_name ) name -- AS 생략가능
FROM employees;

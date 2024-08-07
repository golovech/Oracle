SELECT *
FROM dba_tables;
FROM all_users;
FROM user_table;
FROM tabs;

-- INSA table 구조 파악
DESC insa;
DESCRIBE insa;

-- INSA 테이블 모든 사원 정보 조회
SELECT *
FROM insa;
-- '01/10/11'  'RR/MM/DD'    'YY/MM/DD' 의 차이점?;
SELECT * 
FROM v$nls_parameters; -- nls 라는 뷰의 이름.
-- emp table에서 사원의 정보 조회 (사원번호, 사원명, 입사일자만)

1[ WITH]
6 SELECT 
2 FROM
3 WHERE
4 GROUP BY
5 HAVING
7 ORDER BY

-- 월급 = 기본급 + 수당 칼럼을 추가해서 조회.
SELECT empno, ename, hiredate
--    , sal, comm
--    , NVL(comm,0)
--    , NVL2(comm,comm,0)
    ,sal + NVL(comm,0) pay -- AS "pay"
    -- null값으로 연산하면 결괏값은 모두 null로 변한다.
    -- NVL(comm,0)함수 필요!
    -- NVL2(1,2,3)

FROM emp;
-- 1) 오라클 null이 어떤 의미? : 미확인된 값(있지만 확인되지 않은)
-- 2) comm(월급) 결괏값에 문제 있음.
-- emp tabs 에서 사원번호, 사원명, 직속상사 (mgr(manager))조회
-- 직속상사가 null이면? 'CEO'라고 출력
SELECT empno, ename
    -- , NVL(mgr, 'CEO') mgr : ORA-01722 : invalid number
    -- mgr의 자료형이 숫자니까, 문자로 형변환시켜야 함.
    -- TO_CHAR(mgr)   /   mgr || ''
    , NVL(TO_CHAR(mgr), 'CEO') mgr
    , NVL( mgr || '', 'CEO') mgr
FROM emp;
-- emp tabs 에서 이름은 'ㅇㅇ'이고, 직업은 ㅇㅇ 이다. 출력

SELECT '이름은 ' ''  || ename  || '' '이고, 직업은 '|| job ||'이다.'
-- 문자열에 '' 주려면... '''' 사용하면된다...
-- 김준석씨풀이  65 -> A  를 활용.
SELECT '이름은 '|| CHR(39) || ename|| CHR(39) || '이고, 직업은 '||job||'이다'
FROM emp;


-- emp tabs에서 부서번호가 10번인 사원들만 조회
SELECT *
FROM dept ;
-- emp 테이블에서 각 사원이 속해 있는 부서번호만 조회?
-- SELECT DISTINCT deptno -- DISTINCT 중복제거
SELECT *
FROM emp
WHERE deptno = 10;

-- 문제) emp 테이블에서 10번 부서원만 제외한 나머지 사원들 정보 조회
SELECT *
FROM emp
WHERE NOT (deptno = 10);
WHERE deptno > 10;
-- WHERE deptno != 10;
-- 자바  &&   ||   !
-- 오라  AND  OR  NOT
--
SELECT *
FROM emp
WHERE deptno IN (20,30,40); -- 아래 쿼리와 100% 같다.
WHERE deptno = 20 OR deptno = 30 OR deptno = 40;
-->  NOT IN (list)    SQL연산자

--[문제] emp_tabs에서 사원명이 ford인 사원의 모든 사원정보 출력.

SELECT *
FROM emp
WHERE ename = UPPER('Ford'); -- ORA-00904: "FORD": invalid identifier (홑따옴표 없어서 생기는 오류)
-- 값을 비교할때, 대소문자 정확하게 줘야 함.
-- LOWER, UPPER, INITCAP(앞글자만 대문자)
SELECT LOWER(ename) LOWER, INITCAP( job ) INITCAP
FROM emp;

-- emp 테이블에서 커미션이 null인 사원의 정보 출력?
SELECT *
FROM emp
WHERE comm is null;
-- is null (널 자체를 출력.)  = null을 검색하면 열이 null인 것을 검색함.


-- [문제] emp tabs 월급 2000이상 4000이하 (sal + comm)
SELECT e.*, (sal + NVL(comm,0)) pay
FROM emp e -- e 라는 알리야스를 준것.
WHERE (sal+NVL(comm,0)) >=2000 AND (sal+NVL(comm,0)) <=4000;

-- 아래 코딩이 더 간결하고 좋다.
WITH temp AS (
        SELECT emp.*, (sal + NVL(comm,0)) pay
        FROM emp
    )
SELECT *
FROM temp
WHERE pay >= 2000 AND pay <= 4000; 

-- WITH + BETWEEN
WITH temp AS (
    SELECT emp.*, (sal+NVL(comm,0)) pay
    FROM emp
    )
SELECT *
FROM temp
WHERE pay BETWEEN 2000 AND 4000;
-- with - from - where - select 순서대로 하니까 pay를 써도 됨.

-- 인라인뷰(inline view) : from절 뒤에 오는 서브쿼리
-- WHERE 절에 오는 서브쿼리란? : Nasted(중첩) 서브쿼리
-- correlated subquery : Nested subquery중에서 참조하는 테이블이 parent, child관계를 가지는 서브쿼리 
-- 서브쿼리란? : 절 뒤에 오는 (). 뒤에는 꼭 알리야스를 준다.

SELECT *
FROM (
         SELECT emp.*, (sal + NVL(comm,0)) pay
         FROM emp
        )e  -- 인라인뷰(라인안에 있는 뷰. 쿼리.)
WHERE pay >= 2000 AND pay <= 4000; 


-- between 1
SELECT e.*, (sal + NVL(comm,0)) pay
FROM emp e
WHERE (sal + NVL(comm,0)) BETWEEN 2000 AND 4000;

-- between 2 **
SELECT *
FROM (
         SELECT emp.*, (sal + NVL(comm,0)) pay
         FROM emp
        )e  
WHERE pay BETWEEN 2000 AND 4000; 


--[문제] INSA tabs 에서 70년대생 사원 정보 조회 / 이름, 사원명, 주민번호
-- REGEXP_


--SELECT name, ssn
--       ,SUBSTR(ssn,0,1)
--       ,SUBSTR(ssn,1,1)
--       ,SUBSTR(ssn,1,2)
--       ,INSTR(ssn,7)
--FROM insa
--WHERE INSTR(ssn,7) = 1;
--WHERE TO_NUMBER(SUBSTR(ssn,0,2)) BETWEEN 70 AND 79;
--WHERE SUBSTR(ssn,0,2) BETWEEN 70 AND 79;

-- SUBSTR() --
SELECT name, ssn
--    ,SUBSTR(ssn,0,8) || '******' RRN
--    ,CONCAT(SUBSTR(ssn,0,8), '******') RRN
--    ,RPAD(SUBSTR(ssn,0,8),14,'*') rrn
--    ,REPLACE(ssn, SUBSTR(ssn,-6),'******' ) rrn
    ,REGEXP_REPLACE(ssn,'(\d{6}-\d)\d{6}','\1******') rrn
FROM insa;

--내 풀이
--SELECT CONCAT(CONCAT(name, SUBSTR(ssn,0,8)),'******') RRN
--FROM insa;

SELECT name, ssn 
    , SUBSTR(ssn,0,6)
    , SUBSTR(ssn,0,2) YEAR
    , SUBSTR(ssn,3,2) MONTH
    , SUBSTR(ssn,5,2) "DATE" -- ORA-00923: FROM keyword not found where expected : DATE는 예약어다. int처럼...쓰려면 " " 붙여야함.
    , TO_DATE(SUBSTR(ssn,0,6)) birth
    , TO_CHAR(TO_DATE(SUBSTR(ssn,0,6)), 'YY') y
FROM insa
WHERE TO_CHAR(TO_DATE(SUBSTR(ssn,0,6)), 'YY') BETWEEN 70 AND 79;
WHERE TO_DATE(SUBSTR(ssn,0,6)) BETWEEN '70/01/01' AND '79/12/31';
-- BETWEEN 'a' AND 'b' 는 날짜에도 쓸 수 있다.
SELECT ename, hiredate
--    , SUBSTR(hiredate,0,2) YEAR
--    , SUBSTR(hiredate,4,2) MONTH
--    , SUBSTR(hiredate,-2,2) DAY -- -n 으로 가져오는게 더 편하다!
--    , TO_CHAR(hiredate, 'YEAR')
    , TO_CHAR(hiredate, 'YYYY') y
    , TO_CHAR(hiredate, 'DD') d -- 달의 날짜
    , TO_CHAR(hiredate, 'DY') d -- ㅁ
    , TO_CHAR(hiredate, 'DAY') d -- ㅁ요일
    
    -- EXTRACT() : 숫자로 출력됨.
    , EXTRACT( YEAR FROM hiredate ) year
    , EXTRACT( MONTH FROM hiredate ) mon
    , EXTRACT( DAY FROM hiredate ) day
FROM emp;

-- 오늘 날짜에서 년도,월,일,시간,분,초 얻어오려면?

SELECT SYSDATE a -- sysdate는 이 자체로 함수다.
    ,TO_CHAR(SYSDATE, 'Ds Ts') 
    ,CURRENT_TIMESTAMP
FROM emp;

-- insa tabs 의 70년대생 출생 조회. LIKE 
-- LIKE
-- REGEXT_LIKE 함수 사용(정규표현식)

SELECT *
FROM insa
WHERE regexp_LIKE(ssn,'^7[0-9]12');
WHERE regexp_LIKE(ssn,'^7\d12');
WHERE regexp_like(ssn,'^[78]');
WHERE regexp_like(ssn,'^7||8');
WHERE regexp_like(ssn,'^7');
WHERE ssn LIKE '7_12%';
WHERE ssn LIKE '______-1%';
WHERE ssn LIKE '%-1%';
WHERE name LIKE '%수';
WHERE name LIKE '%정%';
WHERE name LIKE '김%';

SELECT *
FROM insa
W
WHERE regexp_LIKE(name,'^[^김]');


-- [문제] insa 테이블에서 김씨 성을 제외한 모든 사원  출력
-- [문제]출신도가 서울, 부산, 대구 이면서 전화번호에 5 또는 7이 포함된 자료 출력하되
--      부서명의 마지막 부는 출력되지 않도록함. 
--      (이름, 출신도, 부서명, 전화번호)

SELECT name, city, LENGTH(buseo) 길이 ,SUBSTR(buseo,0,LENGTH(buseo)-1 ) 부서, tel
FROM insa
WHERE REGEXP_LIKE (city, '[서울|부산|대구]')
    AND
    REGEXP_LIKE (tel,'[57]');
-- 정규표현식은 []안에 있어야 한다. [57] // []안에 ^가 있으면 부정의 뜻이다.


WHERE REGEXP_LIKE(name, '^[^김이홍한장나]'); -- 이 성씨를 빼겠다. '^[^]'
WHERE name NOT LIKE '김%';





















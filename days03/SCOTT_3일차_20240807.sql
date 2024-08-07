SELECT job, empno, ename, hiredate
FROM emp;

-- 기억이 안남 -- HR에서 해야함.
SELECT first_name, last_name, ( first_name + last_name )name
FROM emp
WHERE ( first_name + last_name ) name;

--SELECT name, buseo 부서
--FROM insa;
SELECT DISTINCT buseo 부서
FROM insa
ORDER BY buseo; -- 오름차순이 기본.
ORDER BY buseo DESC; -- 내림차순
ORDER BY buseo ACS; -- 오름차순

SELECT  deptno, ename, ( sal + NVL(comm, 0) ) pay
FROM emp
ORDER BY 1 ASC, 3 DESC; 
ORDER BY deptno ASC, pay DESC; -- 2차 정렬
ORDER By pay DESC;

-- with절 별칭 : temp를 줘야함. 임시 공간이 필요하니까.
WITH temp AS(
    SELECT emp.*, ( sal + NVL(comm, 0) ) pay
    FROM emp
    WHERE deptno !=30
    )
SELECT *
FROM temp
WHERE pay BETWEEN 1000 AND 3000
ORDER BY ename ASC;

-- 인라인뷰 사용
SELECT *
FROM(
    SELECT emp.*, ( sal + NVL(comm, 0) ) pay
    FROM emp
    WHERE deptno !=30
) e
WHERE pay BETWEEN 1000 AND 3000 
ORDER BY ename ASC;

-- 9.

SELECT ename,NVL(TO_CHAR(mgr),'CEO') mgr, job, hiredate, sal, comm, deptno
FROM emp
WHERE mgr IS null;

desc insa; -- 인사팀 바이트 정보조회

SELECT insa.*, NVL(tel,'연락처 등록 안됨') 비고 -- 형변환 할 필요는 없다.
FROM insa
WHERE tel is null;

SELECT num, name, buseo, tel, NVL2(tel,'O','X') tel2
FROM insa
WHERE buseo LIKE '개발부'
ORDER BY tel2 DESC;

SELECT empno, ename, sal, NVL(comm,0) comm, sal + NVL(comm,0) pay
FROM emp;

SELECT emp.*
FROM emp
WHERE deptno IN (10,20);
WHERE deptno LIKE '10' OR deptno LIKE '20';

SELECT emp.*
FROM emp
WHERE ename = UPPER('KING'); -- 대소문자 구별. UPPER('KING')
WHERE ename LIKE UPPER('KING');

SELECT insa.*
FROM insa
WHERE REGEXP_LIKE(city,'^[^서울|경기|인천]');
WHERE city IN('서울','경기','인천');
WHERE city NOT IN('서울','경기','인천');

SELECT emp.*
FROM emp
WHERE REGEXP_LIKE(deptno,'^[^10]') AND REGEXP_LIKE(job, '^[CLERK]');

SELECT deptno, ename, sal, NVL(comm,0) comm, (sal + NVL(comm,0)) pay
FROM emp
WHERE REGEXP_LIKE(deptno,'^[30]') AND REGEXP_LIKE(comm,'^[0]');

SELECT ssn
    ,SUBSTR(ssn, 0,2) YEAR
    ,TO_CHAR(TO_DATE(SUBSTR(ssn, 0,6)), 'MM') MONTH
    ,EXTRACT(DAY FROM TO_DATE(SUBSTR(ssn, 0,6)) "DATE"
    ,SUBSTR(ssn, 8,1) gender
FROM insa;

-- 정규표현식
SELECT name, ssn
FROM insa
WHERE REGEXP_LIKE(ssn,'^7\d12')
ORDER BY ssn ASC;
-- LIKE
SELECT name, ssn
FROM insa
WHERE ssn LIKE '7_12%'
ORDER BY ssn;

-- 21. insa 테이블에서 70년대 남자 사원만 조회.   
-- 정규표현식 사용
SELECT insa.*
    , MOD(SUBSTR(ssn,-7,1),2) gender -- MOD사용한 나누기
FROM insa
WHERE ssn LIKE '7%' AND MOD(SUBSTR(ssn,-7,1),2)=1; -- MOD사용한 나누기.
WHERE REGEXP_LIKE(ssn,'^7\d{5}-[13579]'); -- 정규표현식
WHERE REGEXP_LIKE(ssn,'^\d\d\d\d\d\d-1');
-- SUBSTR 사용
SELECT *
FROM insa
WHERE SUBSTR(ssn,-7,1) = 1;
-- LIKE문
SELECT *
FROM insa
WHERE ssn LIKE '7______1%';



SELECT emp.*
FROM emp
WHERE REGEXP_LIKE(ename, 'la', 'i'); -- [i] [g] [m] : 대소문자 구분하지 않고. 
WHERE ename LIKE '%'|| UPPER('la') ||'%'; -- 기억해두기!!
WHERE ename LIKE UPPER('%la%'); -- UPPER('%la%')
WHERE ename LIKE '%%'; -- 모든 값이 가능하다.

-- 23.insa 테이블에서 남자는 'X', 여자는 'O' 로 성별(gender) 출력하는 쿼리 작성   
-- PL / SQL (DQL)
SELECT name, ssn
    -- ,MOD(SUBSTR(ssn,-7,1),2) = 1 GENDER
    ,NVL2 (NULLIF(MOD(SUBSTR(ssn,-7,1),2), 1), 'O', 'X' ) gender
FROM insa; -- DECODE() ,CASE() 함수 사용해도 가능.

-- 24. insa 테이블에서 2000년 이후 입사자 정보 조회하는 쿼리 작성
-- IBSADATE NOT NULL DATE 
--SELECT name, ibsadate
--FROM insa
--WHERE TO_CHAR(SUBSTR(ibsadate,0,0), )

SELECT SYSDATE EF
    --, SYSTIMESTAMP
--    , TO_CHAR(SYSDATE, 'YYYY') y
--    , TO_CHAR(SYSDATE, 'MM') m
--        , TO_CHAR(SYSDATE, 'DD') d
--            , TO_CHAR(SYSDATE, 'HH') h
--                , TO_CHAR(SYSDATE, 'MI') m
--                    , TO_CHAR(SYSDATE, 'SS') s
         -- HOUR~SECOND는 CAST로 형변환 해줘야 함!
          , EXTRACT(YEAR FROM SYSDATE)   year
          , EXTRACT(MONTH FROM SYSDATE) MON
          , EXTRACT(DAY FROM SYSDATE) DAY
          --, EXTRACT(HOUR FROM CURRENT_TIMESTAMP) Hㄴㄴ
          , EXTRACT(HOUR FROM CAST (SYSDATE AS TIMESTAMP)) Hㅇㅇ -- 이게 맞음
          --, EXTRACT(MINUTE FROM SYSTIMESTAMP) M
          , EXTRACT(MINUTE FROM CAST(SYSDATE AS TIMESTAMP)) M
         -- , EXTRACT(SECOND FROM SYSTIMESTAMP) S
          , EXTRACT(SECOND FROM CAST(SYSDATE AS TIMESTAMP)) S
FROM dual;


-- [ dual이란? ]
DESC DUAL;
-- DUMMY    VARCHAR2(1) 
SELECT DUMMY
FROM DUAL;
-- 레코드(행) 1개 뿐. // 더미값 X

SELECt SYSDATE
FROM dual;
-- 1개만 출력되게 하려고. 레코드 1개만 갖고 있으니깐!

SELECT *
FROM dual;
-- 왜 듀얼은.. sys.dual 을 안붙여도 되나?
-- 원래 SYS.dual 이라고 써야하나, 오라클이 시노님(public synonym)을 붙여서 공용의 테이블이 된것.
-- 시노님 : 별칭을 붙여준 것.

--26
SELECT *
FROM insa
WHERE REGEXP_LIKE(name, '^[김이]') AND REGEXP_LIKE(ssn, '^[7\d12\d%]')
ORDER BY name ASC;

--27
SELECT COUNT(*)
FROM insa;

------------------ 복습문제 풀이 끝 ----------------------

-- [LIKE 연산자의 ESCAPE 옵션 설명]
-- wildcard(%,_)를 일반 문자처럼 쓰고 싶은 경우에는 ESCAPE 옵션을 사용.
SELECT deptno, dname, loc
FROM dept;
-- dept table에 새로운 부서정보를 추가하려면?
-- 1. dept table 더블클릭해서 -> 데이터 클릭 -> 추가 -> 입력하고 커밋(커밋필수)
-- 2. DML : INSERT문!
-- ORA-00001: unique constraint (SCOTT.PK_DEPT) violated 
-- 같은 값이 이미 있다는 뜻. 50 값이 이미 존재해서. -> 60으로 바꿔!
INSERT INTO dept (deptno, dname, loc) VALUES (60, '한글_나라', 'KOREA'); 
INSERT INTO dept VALUES (60, '한글_나라', 'KOREA');-- (deptno, dname, loc) 생략가능
COMMIT;
ROLLBACK;

-- 부서명에 % 문자가 포함된 부서정보를 조회하려면?
SELECT dname
FROM dept
WHERE dname LIKE '%\%%' ESCAPE '\'; 
-- ESCAPE '\' 을 주면, LIKE뒤에 있는 와일드카드를 일반문자로 인식함.
WHERE REGEXP_LIKE(dname,'[%%%]'); -- 이것도 가능

-- DML(DELETE)
DELETE FROM dept
WHERE deptno = 60; -- 모든사람이 다 갖고있는 번호(deptno)를 프라이밋키로 줘서 삭제하면 됨.
DELETE FROM EMP; -- WHERE 조건절 없으면 모든 emp 삭제됨... 프라이밋키가 있어야함.

SELECT *
FROM emp; 

SELECT *
FROM dept;

-- DML(UPDATE)
UPDATE 테이블명
SET 칼럼명 = 칼럼값, 칼럼명 = 칼럼값, 칼럼명 = 칼럼값;

UPDATE dept
SET dname = 'QC';
ROLLBACK;

UPDATE dept
SET dname = SUBSTR(dname,0,2 ),loc = 'KOREA'
WHERE deptno = 50;

-- [문제] 40번 부서의 부서명, 지역명을 얻어와서
--        50번 부서의 부서명으로, 지역명으로 수정하는 쿼리 작성 (40번을 수정)
UPDATE dept
SET dname = (SELECT dname FROM dept WHERE deptno = 40)
    ,loc = (SELECT loc FROM dept WHERE deptno = 40)
WHERE deptno = 50;
-- 위 쿼리를 간단하게 쓰면?
-- 이렇게 하면 된다. 기억하기!
UPDATE dept
SET (dname, loc)  = (SELECT dname, loc FROM dept WHERE deptno = 50)
WHERE deptno = 50;

-- [문제] dept        50,60,70 deptno 삭제하려면?
DELETE FROM dept
WHERE deptno IN (50, 60, 70); -- == deptno = 50 OR deptno = 60 OR deptno = 70; in으로 변경가능 !!!!!
WHERE deptno BETWEEN 50 AND 70;
WHERE deptno = 50 OR deptno = 60 OR deptno = 70;
DELETE FROM dept;
COMMIT;

SELECT *
FROM dept;

-- [문제] emp테이블의 모든 사원의 sal 기본급을 pay 급여의 10% 인상하는 update문

UPDATE emp
SET sal = sal + (sal + NVL(comm,0))* 0.1 ; 

SELECT ename, sal, comm
    ,sal + (sal + NVL(comm,0)) * 0.1 "10% 인상액" -- 이 문장을 SET에 붙여넣으면 !
FROM emp;

-- 시노님 
-- 스키마.객체명 

-- PUBLIC 시노님 생성해보자.
CREATE PUBLIC SYNONYM arirang
FOR scott.emp;
-- ORA-01031: insufficient privileges : 권한이 없다? => DBA권한이 없기때문.

 -- select권한부여
GRANT SELECT ON emp TO hr;

-- 권한 회수할때 / REVOKE
REVOKE SELECT ON emp FROM HR CASCADE constraint;


---------------------------------------------------------------------------


-- [오라클 연산자(operator) 정리]

1) 비교 연산자 : =    !=  >   <   >=  <=
                WHERE 절에서 숫자, 문자, 날짜 비교시 사용한다.
                ANY, SOME, ALL 비교연산자 ->  SQL 연산자에 포함됨.

2) 논리 연산자 : AND, OR, NOT
                WHERE 절에서 조건을 결합할 때 사용한다.
                
3) SQL 연산자 : SQL 언어에만 존재.
                [NOT] IN (list)  
                [NOT] BETWEEN a AND b 
                [NOT] LIKE 
                IS [NOT] NULL 
                ANY, SOME , ALL     WHERE 절에서 사용 + (서브쿼리)
                TRUE/FALSE  EXISTS  WHERE 절에서 사용 + (서브쿼리)
                
4) NULL 연산자 : IS NULL, IS NOT NULL
5) 산술 연산자 : 덧셈, 곱셈, 뺄셈, 나눗셈
                  +     *     -       /

SELECT 5+3, 5*3, 5-3, 5/3
        , FLOOR(5/3) -- 몫(정수)를 구하는 함수 FLOOR
        , MOD(5,3)
FROM dual;






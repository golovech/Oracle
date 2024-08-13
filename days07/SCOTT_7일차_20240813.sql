-- EMP, DEPT
-- 사원이 존재하지 않는 부서의 부서번호, 부서명을 출력.
-- LEFT OUTER JOIN

-- 기본 풀이

SELECT D.DEPTNO, DNAME, COUNT(EMPNO) 부서인원수 
FROM EMP E RIGHT JOIN DEPT D -- EMP를 전부 출력하고 DEPT는 교집합만 출력. 
ON D.DEPTNO = E.DEPTNO
GROUP BY D.DEPTNO, DNAME
HAVING COUNT(EMPNO) = 0
ORDER BY D.DEPTNO;

-- 1. WITH절 풀이
WITH T AS (
            SELECT DEPTNO
            FROM DEPT
            MINUS
            SELECT DISTINCT DEPTNO
            FROM EMP
            )
SELECT T.DEPTNO, D.DNAME
FROM T JOIN DEPT D ON T.DEPTNO = D.DEPTNO; -- 차집합


-- 2. 인라인뷰 풀이
SELECT T.DEPTNO, D.DNAME
FROM
 (
            SELECT DEPTNO
            FROM DEPT
            MINUS
            SELECT DISTINCT DEPTNO
            FROM EMP
            ) T JOIN DEPT D ON T.DEPTNO = D.DEPTNO; -- 차집합


-- 3. SQL연산자를 이용한 풀이
SELECT M.DEPTNO, M.DNAME
FROM DEPT M
WHERE  NOT EXISTS (SELECT EMPNO FROM EMP WHERE DEPTNO = M.DEPTNO); -- 존재하지 않으면 출력한다.


-- 4. 상관서브쿼리 사용 (WHERE절의 서브쿼리)
SELECT M.DEPTNO, M.DNAME
FROM DEPT M
WHERE (SELECT COUNT(*) FROM EMP WHERE DEPTNO = M.DEPTNO) = 0;

-- INSA테이블에서 각 부서별 여자사원수 파악, 5명 이상인 부서 정보 출력.
-- COUNT MOD SUBSTR / WHERE  COUNT() >= 5

SELECT BUSEO, DECODE(MOD(SUBSTR(SSN,-7,1),2 ),1,'남','여' ) 성별, COUNT(BUSEO) 성별인원
FROM INSA
WHERE DECODE(MOD(SUBSTR(SSN,-7,1),2 ),1,'남','여' ) = '여'
HAVING COUNT(*) >= 5
GROUP BY BUSEO, DECODE(MOD(SUBSTR(SSN,-7,1),2 ),1,'남','여' );

------------

-- [문제] insa 테이블
--     [총사원수]      [남자사원수]      [여자사원수] [남사원들의 총급여합]  [여사원들의 총급여합] [남자-max(급여)] [여자-max(급여)]
------------ ---------- ---------- ---------- ---------- ---------- ----------
--        60                31              29           51961200                41430400                  2650000          2550000

SELECT COUNT(BUSEO)
, COUNT(DECODE(MOD(SUBSTR(SSN,-7,1),2 ),1,'남' )) 성별
, COUNT(DECODE(MOD(SUBSTR(SSN,-7,1),2 ),0,'여' ))
, SUM(DECODE(MOD(SUBSTR(SSN,-7,1),2 ),1,BASICPAY ))
, SUM(DECODE(MOD(SUBSTR(SSN,-7,1),2 ),0,BASICPAY ))
, MAX(DECODE(MOD(SUBSTR(SSN,-7,1),2 ),1,BASICPAY ))
, MIN(DECODE(MOD(SUBSTR(SSN,-7,1),2 ),0,BASICPAY ))

FROM INSA;

-- 다른 풀이

SELECT
      COUNT(*)
      , DECODE(MOD(SUBSTR(SSN,-7,1),2 ),0,'여자', 0, '남자', '전체' ) || '사원수'
      , SUM(BASICPAY)
      , MAX(BASICPAY)
FROM INSA
GROUP BY ROLLUP(MOD(SUBSTR(SSN,-7,1),2) );


-- [문제] emp 테이블에서~
--      각 부서의 사원수, 부서 총급여합, 부서 평균급여
결과)
    DEPTNO       부서원수       총급여합            평균
---------- ----------       ----------    ----------
        10          3          8750       2916.67
        20          3          6775       2258.33
        30          6         11600       1933.33 
        40          0         0             0


-- OUTER JOIN DEPT+EMP
-- 1.
SELECT D.DEPTNO
     , COUNT(EMPNO) 부서원수
     , NVL(SUM(SAL+NVL(COMM,0)),0) 총급여합
     , NVL(ROUND(AVG(SAL+NVL(COMM,0)),2),0) 평균
FROM DEPT D LEFT JOIN EMP E ON D.DEPTNO = E.DEPTNO
GROUP BY D.DEPTNO
ORDER BY D.DEPTNO;

-- 2.
SELECT D.DEPTNO
     , COUNT(EMPNO) 부서원수
     , NVL(SUM(SAL+NVL(COMM,0)),0) 총급여합
     , NVL(ROUND(AVG(SAL+NVL(COMM,0)),2),0) 평균
FROM EMP E, DEPT D
WHERE E.DEPTNO(+) = D.DEPTNO
GROUP BY D.DEPTNO
ORDER BY D.DEPTNO ASC;


-- [ ROLLUP, CUBE 절 ]
--GROUP BY 절에서 사용됨. 그룹별 소계를 추가로 보여주는 역할
--즉, 추가적인 집계 정보를 보여준다.
SELECT
     CASE MOD(SUBSTR(SSN,-7,1) ,2)
     WHEN 1 THEN '남자'
     WHEN 0 THEN '여자'
     END 성별
     , COUNT(*) 사원수

FROM INSA
GROUP BY MOD(SUBSTR(SSN,-7,1) ,2)

UNION ALL

SELECT '전체', COUNT(*)
FROM INSA;

-- GROUP BY ROLLUB / CUBE 사용
SELECT
     CASE MOD(SUBSTR(SSN,-7,1) ,2)
     WHEN 1 THEN '남자'
     WHEN 0 THEN '여자'
     ELSE '전체'
     END 성별
     , COUNT(*) 사원수

FROM INSA
GROUP BY CUBE (MOD(SUBSTR(SSN,-7,1) ,2));
GROUP BY ROLLUP (MOD(SUBSTR(SSN,-7,1) ,2));


-- [ROLLUP / CUBE의 차이점?]

SELECT BUSEO, JIKWI, COUNT(*) 사원수
FROM INSA
GROUP BY BUSEO, JIKWI
UNION ALL
SELECT BUSEO, NULL, COUNT(*) 사원수
FROM INSA
GROUP BY BUSEO
ORDER BY BUSEO, JIKWI;

-- 위와 같은 코딩. ROLLUP을 사용하면 간단함.
SELECT BUSEO, JIKWI, COUNT(*) 사원수
FROM INSA
GROUP BY CUBE(BUSEO, JIKWI) -- 부분부분 집계를 내주는 CUBE
ORDER BY BUSEO, JIKWI;

-- 2.
SELECT BUSEO, JIKWI, COUNT(*) 사원수
FROM INSA
GROUP BY BUSEO, JIKWI

UNION ALL

SELECT BUSEO, NULL, COUNT(*) 사원수
FROM INSA
GROUP BY BUSEO

UNION ALL

SELECT NULL, JIKWI, COUNT(*) 사원수
FROM INSA
GROUP BY JIKWI;


-- 분할 ROLLUP : ROLLUP에 칼럼 하나만 묶을 수 있음 
            -- -> 전체집계는 안 나오고, 묶지 않은 칼럼의 집계만 나옴.
SELECT BUSEO, JIKWI, COUNT(*) 사원수
FROM INSA
GROUP BY ROLLUP(JIKWI), BUSEO -- 부서 부분 집계만 나옴.
--GROUP BY ROLLUP(BUSEO), JIKWI -- 직위별 부분 집계만 나옴.
--GROUP BY ROLLUP(BUSEO, JIKWI) -- 1차 집계(부서별) -> 전체집계 나옴.
--GROUP BY CUBE(BUSEO, JIKWI) -- 1차 집계(부서별) -> 직위별 집계 -> 전체집계 나옴.
ORDER BY BUSEO, JIKWI;


-- [GROUPING SETS 함수] : 그루핑한 집계만 출력하는 함수.
SELECT BUSEO, '', COUNT(*) 사원수
FROM INSA
GROUP BY BUSEO

UNION ALL

SELECT '', JIKWI, COUNT(*) 사원수
FROM INSA
GROUP BY JIKWI;

--

SELECT BUSEO, JIKWI, COUNT(*) 사원수
FROM INSA
GROUP BY GROUPING SETS( BUSEO, JIKWI ) -- 그루핑한 집계만 출력된다.
ORDER BY BUSEO, JIKWI;

-- PIVOT

--1. 테이블 설계가 잘못된 상황 -> 프로젝트 진행 -> 쿼리 문제생겨 질문했던 내용

tbl_pivot
번호, 이름, 국영수 관리 테이블
-- DDL 문 사용해 CREATE해보자.

CREATE TABLE tbl_pivot
(
--    칼럼명 자료형(크기) 제약조건...
    NO NUMBER PRIMARY KEY -- 고유한키(PK) 제약조건
    , NAME VARCHAR2(20 BYTE) NOT NULL -- NOTNULL(NN) 제약조건 ( == 필수입력사항)
    , JUMSU NUMBER(3) -- NULL 허용
);
-- Table TBL_PIVOT이(가) 생성되었습니다.
SELECT *
FROM TBL_PIVOT; -- 결과 없음

-- 

INSERT INTO TBL_PIVOT ( no, name, jumsu ) VALUES ( 1, '박예린', 90 );  -- kor
INSERT INTO TBL_PIVOT ( no, name, jumsu ) VALUES ( 2, '박예린', 89 );  -- eng
INSERT INTO TBL_PIVOT ( no, name, jumsu ) VALUES ( 3, '박예린', 99 );  -- mat
 
INSERT INTO TBL_PIVOT ( no, name, jumsu ) VALUES ( 4, '안시은', 56 );  -- kor
INSERT INTO TBL_PIVOT ( no, name, jumsu ) VALUES ( 5, '안시은', 45 );  -- eng
INSERT INTO TBL_PIVOT ( no, name, jumsu ) VALUES ( 6, '안시은', 12 );  -- mat 
 
INSERT INTO TBL_PIVOT ( no, name, jumsu ) VALUES ( 7, '김민', 99 );  -- kor
INSERT INTO TBL_PIVOT ( no, name, jumsu ) VALUES ( 8, '김민', 85 );  -- eng
INSERT INTO TBL_PIVOT ( no, name, jumsu ) VALUES ( 9, '김민', 100 );  -- mat 

COMMIT; 

--- 위 드래그 후 실행

SELECT *
FROM TBL_PIVOT;

-- 질문) 피봇
--번호 이름   국,  영,  수
--1   박예린  90 89 99
--2   안시은  56 45 12
--3   김민    99 85 100


-- 과목당 연결된 숫자가 다라ㅡㅁ.
SELECT *
FROM 
    (SELECT TRUNC((NO-1)/3) + 1 NO
    , NAME 이름
    , JUMSU
    --, DECODE(MOD(NO,3),1,'국어',2,'영어',3,'수학') SUB
    , ROW_NUMBER() OVER (PARTITION BY NAME ORDER BY NO) SUB
    FROM TBL_PIVOT)
PIVOT (SUM(JUMSU) FOR SUB IN (1 AS "국어",2 AS "영어",3 AS "수학") )
ORDER BY NO;

-- 입사한 사원수 출력 / 년도별로,. EMP
-- PARTITION BY OUTER JOIN 사용
-- FROM INSA I PARTITION BY (BUSEO) RIGHT OUTER JOIN C ON I.CITY = C.CITY 참고
--ORA-01788: CONNECT BY clause required in this query block
SELECT LEVEL AS "MONTH" -- 순번(단계)
FROM DUAL
CONNECT BY LEVEL <= 12;

--

select empno, TO_CHAR(hiredate,'YYYY') year
     , TO_CHAR(hiredate,'MM') month
from emp;

-- 위 커리를 쪼인으로 합친다.
SELECT YEAR, M.MONTH, NVL(COUNT(EMPNO),0) N
FROM (
         select empno, TO_CHAR(hiredate,'YYYY') year
             , TO_CHAR(hiredate,'MM') month
         from emp
         ) e
         
         PARTITION BY (E.YEAR ) RIGHT OUTER JOIN -- 날짜출력되는 LEVEL을 RIGHT 조인함.(출력형식맞추려)
         
         ( 
        SELECT LEVEL AS "MONTH" -- 순번(단계)
        FROM DUAL
        CONNECT BY LEVEL <= 12
         ) m
         
 ON e.MONTH = M.MONTH
 GROUP BY YEAR, M.MONTH 
 ORDER BY YEAR, M.MONTH;

---------------

SELECT *
FROM(
        SELECT TO_CHAR(HIREDATE,'YYYY') H_YEAR , COUNT(*)
        FROM EMP
        GROUP BY TO_CHAR(HIREDATE,'YYYY')
        )
ORDER BY H_YEAR;


-- INSA 부서, 짇위별 사원
SELECT BUSEO, JIKWI, COUNT(*)
FROM INSA
GROUP BY BUSEO, JIKWI
ORDER BY BUSEO, JIKWI;
-- 부서별 직위별 최소사원수 최대사원수 조회
-- 사원이 젱리 많은 직위, 제일 적은 직위

--SELECT BUSEO, JIKWI, COUNT(JIKWI) -- 함수없이는 어렵다.
--     , DECODE()
--     , CASE 
--     WHEN  THEN
--     WHEN  THEN
--     END 직위
--FROM INSA
--WHERE COUNT 
--GROUP BY CUBE(BUSEO, JIKWI)
--ORDER BY BUSEO, JIKWI;

-- 2가지
-- 1) 분석함수 FIRST, LAST
--    집계함수(COUNT,SUM,AVG,MAX,MIN)와 함께 사용하여
--    주어진 그룹에 대해 내부적으로 순위를 매겨 결과를 산출함
SELECT *
FROM
(SELECT MAX(SAL)
     , MAX(ENAME) KEEP(DENSE_RANK first order by sal desc) max_ename
     , MIN(SAL)
     , MAX(ENAME) KEEP(DENSE_RANK last order by sal desc) min_ename
FROM EMP)
;

--

with a as
(
    select d.deptno, dname, count(empno) cnt
    from emp e right outer join dept d on d.deptno = e.deptno
    group by d.deptno, dname
)
select min(cnt), min(dname) keep(DENSE_RANK last order by cnt desc) min_dname
     , max(cnt), max(dname) keep(DENSE_RANK first order by cnt desc) max_dname
from a;

-- 2) SELF JOIN : 자기자신 테이블과 join하겠다.
-- ex) 나의 mgr = 직속상사의 이름을 가져오겠다. -> 공통적인 것 : 나의 mgr = 직속상사의 empno
select a.empno, a.ename, a.mgr, b.ename
from emp a join emp b on a.mgr = b.empno;

-- [ non equal join ] 논이퀄조인 : 공통된 칼럼이 없을 때
-- 이퀄조인 = 이너조인  from emp e inner join dete d on e.deptno = d.deptno
select *
from salgrade;
-- 논이퀄조인 예시
select empno, ename, sal --, grade 조인해야 나옴.
from emp e join salgrade s on e.sal BETWEEN s.losal and s.hisal ;

-- == 아래와 같다.

SELECT ename, sal 
   ,  CASE
        WHEN  sal BETWEEN 700 AND 1200 THEN  1
        WHEN  sal BETWEEN 1201 AND 1400 THEN  2
        WHEN  sal BETWEEN 1401 AND 2000 THEN  3
        WHEN  sal BETWEEN 2001 AND 3000 THEN  4
        WHEN  sal BETWEEN 3001 AND 9999 THEN  5
      END grade
FROM emp;

----

WITH t1 AS (
    SELECT buseo, jikwi, COUNT(num) tot_count
    FROM insa
    GROUP BY buseo, jikwi
)
  , t2 AS (
     SELECT buseo, MIN(tot_count) buseo_min_count
                 , MAX(tot_count) buseo_max_count
     FROM t1
     GROUP BY buseo
  )
SELECT a.buseo
     , b.jikwi 최소인원직위, b.tot_count 최소인원직위사원수
FROM t2 a, t1 b
where a.buseo = b.buseo AND a.buseo_min_count = b.tot_count ;

-- 위 코딩 first, last사용하여 풀어보자. 최대인원까지 구해보자.

-- 아래 선생님 풀이
WITH t AS (
    SELECT buseo, jikwi, COUNT(num) tot_count
    FROM insa
    GROUP BY buseo, jikwi
)
select t.buseo
     , min(t.jikwi) KEEP(DENSE_RANK FIRST ORDER BY t.tot_count asc) 최소직위
     , min(t.tot_count) 최소사원수
     , max(t.jikwi) KEEP(DENSE_RANK last ORDER BY t.tot_count asc) 최대직위
     , max(t.tot_count) 최대사원수
from t
group by t.buseo
order by t.buseo;


-- 문제) emp 테이블에서 가장 입사일자가 빠른 사원과, 가장 입사일자가 늦은 사원과의 입사일 차이
-- 

select max(hiredate) - min(hiredate)
from emp;

-- 분석함수 : CUME_DIST()
--            주어진 그룹에 대한 상대적인 누적 분포도 값 출력
--            분포도(비율)값    0 <     <=1

select deptno, ename, sal
     , CUME_DIST() OVER (order by sal asc) dept_list
     , CUME_DIST() OVER (PARTITION BY deptno order by sal asc) dept_list
from emp;


--  [ 분석함수 : PERCENT_RANK() ]
--     ㄴ 해당 그룹 내의 백분위 순위
--        0 <     사이의 값   <=1
--      * 백분위 순위란: 그룹 안에서 해당 행의 값보다 작은 값의 비율

-- [ NTILE() : (N타일) ]
--    파티션별로 (표현식)에 명시된만큼 분할한 결과를 출력하는 함수

SELECT DEPTNO, ENAME, SAL
     , NTILE(3) OVER (ORDER BY SAL ASC) NTILE
     , WIDTH_BUCKET(SAL, 1000, 4000, 4)
FROM EMP;

--

SELECT DEPTNO, ENAME, SAL
     , NTILE(4) OVER (PARTITION BY DEPTNO ORDER BY SAL ASC) NTILE
     
FROM EMP;

-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 

-- [ WIDTH_BUCKET() ] 함수 
-- : WIDTH_BUCKET(컬럼,최소값,최댓값,기준 숫자)
-- WIDTH_BUCKET(SAL, 1000, 4000, 4)


-- LAG(표현식, OFFSET, DEFAULT_VALUE)
--    ㄴ 주어진 그룹과 순서에 따라 다른 행에 있는 값을 참조할 때 사용하는 함수
--    ㄴ 선행 행    
--    ㄴ 행을 N줄 미리 땡겨오는 함수

-- LEAD(표현식, OFFSET, DEFAULT_VALUE)
--    ㄴ 주어진 그룹과 순서에 따라 다른 행에 있는 값을 참조할 때 사용하는 함수
--    ㄴ 후행(뒤) 행
--    ㄴ 행을 N줄 뒤로 밀어내는 함수

SELECT DEPTNO, ENAME, HIREDATE, SAL
     , LAG(SAL,3,0) OVER(ORDER BY HIREDATE) PRE_SAL
     , LEAD(SAL,1,-1) OVER(ORDER BY HIREDATE) NEXT_SAL
FROM EMP
WHERE DEPTNO = 30;

-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 

    --               [ 오라클 자료형 (DATE TYPE) ]
    
    --1) CHAR [ (SIZE [BYTE|CHAR]) ] 문자열자료형
    --   CHAR == CHAR(1 BYTE) == CHAR(1)
    --   CHAR(3 BYTE) = CHAR(3) 'ABC'  '한'
    --   CHAR(3 CHAR) 'ABC' '하둘셋'
    --   고정 길이의 문자열 자료형
    --   name CHAR(10 BYTE)
    --   2000 BYTE까지 크기 할당할 수 있다.
    --   예 ) 주민등록번호 (14), 학번, 우편번호, 전화번호 // 누구나 길이가 같은경우

-- TEST

CREATE TABLE TBL_CHAR
(
AA CHAR -- CHAR(1) == CHAR(1 BYTE)
, BB CHAR(3)
, CC CHAR (3 CHAR)

);
-- Table TBL_CHAR이(가) 생성되었습니다.
COMMIT;

DESC TBL_CHAR
INSERT INTO TBL_CHAR (AA,BB,CC) VALUES ('A','AA','AAA');
INSERT INTO TBL_CHAR (AA,BB,CC) VALUES ('B','한','한우리');
INSERT INTO TBL_CHAR (AA,BB,CC) VALUES ('C','한우리','한우리');


    -- 2) NCHAR
    --    N == UNICODE(유니코드)
    --    NCHAR[(SIZE)]
    --    NCHAR(1) == NCHAR
    --    NCHAR(10) // 알파벳,한자 뭐든 10글자 넣어도 된다.
    --    고정길이 문자열 자료형
    --    2000 BYTE까지 저장 가능.

CREATE TABLE TBL_NCHAR
(
AA CHAR(3) -- CHAR(3 BYTE 알3 한1)
, BB CHAR(3 CHAR)
, cc NCHAR (3) -- 뭐든 3문자 저장가능

);
COMMIT;
INSERT INTO TBL_nCHAR (AA,BB,cc) VALUES ('홍','길동','홍길동');
INSERT INTO TBL_nCHAR (AA,BB,CC) VALUES ('홍길동','홍길동','홍길동');


    -- 고정 길이 문자열
    -- 3) VAR + CHAR2 ==> VARCHAR
    --    가변 길이 문자열 자료형
    --    4000 BYTE 최대 크기
    --    VARCHAR2(SIZE BYTE|CHAR)
    --    VARCHAR2(1) = VARCHAR2(1 BYTE) = VARCHAR2
    --    NAME VARCHAR2(10) -> 5바이트 사용되면 남은 5바이트는 버림. (가변)
    
    -- 4) N + VAR + CHAR2
    --    유니코드 + 가변길이 + 문자열 자료형
    --    NVARCHAR2(SIZE)
    --    NVARCHAR2(1) = NVARCHAR2
    --    4000 BYTE 최대 크기

 5) NUMBER[(p[,s])]
            precision       scale
             정확도         규모
            전체자리수   소수점이하자릿수
             1~38          -85~ -127
    NUMBER = NUMBER(38,127)
    NUMBER(p) = NUMBER(p, 0)
    
    예시)
    CREATE TABLE TBL_NUMBER
    (
    NO NUMBER(2) NOT NULL PRIMARY KEY  -- NN + UK
    , NAME VARCHAR2( 30 ) NOT NULL
    , KOR NUMBER(3) --  -999 ~ 999
    , ENG NUMBER(3) --  0 <=  <= 100
    , MAT NUMBER(3) DEFAULT 0
    )
    COMMIT;
    INSERT INTO TBL_NUMBER (NO, NAME, KOR, ENG, MAT) VALUES (1, '홍길동', 90, 88, 67)
--        INSERT INTO TBL_NUMBER (NO, NAME, KOR, ENG, MAT) VALUES (2, '최사랑', 100, 98)
    INSERT INTO TBL_NUMBER (NO, NAME, KOR, ENG) VALUES (2, '최사랑', 100, 98)
    ROLLBACK;
    INSERT INTO TBL_NUMBER VALUES (3, '강아지', 60, 95, 100);
    INSERT INTO TBL_NUMBER (NAME,NO, KOR, ENG,MAT) VALUES ( '고양이',4, 80, 55, 100);
    INSERT INTO TBL_NUMBER (NO, NAME, KOR, ENG, MAT) VALUES (5, '햄스터', 110, 56.934, -333); -- 실수인데 반올림 알아서 되네...
    
    
    SELECT *
    FROM TBL_NUMBER;
    -- 1283.34569
    -- 만약 NUMBER(4,5)처럼 scale이 precision보다 크다면, 이는 첫자리에 0이 놓이게 된다. < 무슨 말?
    
    --    6) FLOAT [(p)] : 내부적으로 NUMBER 처럼 나타낸다.
    --    7) LONG     가변길이(VAR) 나타내는 문자열 자료형 / 2GB 까지 저장가능
    --    8) DATE     날짜, 시간(초)  고정길이 7 BYTE
    --       TIMESTAMP[(n)] : n = 밀리세컨드 단위수 / n값 없으면 6자리 까지 출력
    --    9) RAW(SIZE) - 200 BYTE 이진데이터(0/1) 저장
    --       LONG RAW - 2GB       이진데이터 / 웹사이트에서 이미지는 이진데이터로 저장하지 않는다. 이미지를 분해해서 다시 조립하는 셈이라서...
    --   10) LOB : CLOB, NCLOB, BLOB, BFILE
    
    
    -- 자료형 끝 --
    
    
-- FIRST_VALUE 분석함수 : 정렬된 값 중에 첫 번째 값
SELECT FIRST_VALUE(BASICPAY) OVER (ORDER BY BASICPAY DESC) FIRST
FROM INSA;

SELECT FIRST_VALUE(BASICPAY) OVER (PARTITION BY BUSEO ORDER BY BASICPAY DESC) FIRSTBUSEO
FROM INSA;

-- 가장 많은 급여(BASICPAY) 각 사원의 BASICPAY의 차이를 출력? => FIRST_VALUE 사용
SELECT BUSEO, NAME, BASICPAY
     , FIRST_VALUE(BASICPAY) OVER (ORDER BY BASICPAY DESC) MAX
     , FIRST_VALUE(BASICPAY) OVER (ORDER BY BASICPAY DESC) - BASICPAY 차이
FROM INSA;


-- COUNT ~ OVER : 질의한 행의 누적된 결과를 출력 => COUNT(*)만으로는 GROUP BY 오류가 뜸, 이를 방지
-- SUM ~ OVER : 질의한 행의 누적된 합 결과 출력          (집계함수 그룹바이 안해도 됨)
-- AVG ~ OVER : '' 평균 출력
SELECT NAME, BASICPAY, BUSEO
     , AVG(BASICPAY) OVER (PARTITION BY BUSEO ORDER BY BASICPAY) 누적평균
    -- , SUM(BASICPAY) OVER (PARTITION BY BUSEO ORDER BY BASICPAY) 부서합
    -- , COUNT(*) OVER (PARTITION BY BUSEO ORDER BY BASICPAY)
FROM INSA;


SELECT NAME, BASICPAY, BUSEO
     , SUM(BASICPAY) OVER (ORDER BY BUSEO)
      -- , COUNT(*) OVER (ORDER BY BASICPAY)
FROM INSA;

-- 위의 코딩과 같은 결과(간단함.그냥 보기만 해라 쉬우니까...)
SELECT BUSEO, SUM(BASICPAY)
FROM INSA
GROUP BY BUSEO
ORDER BY BUSEO;


-- * 테이블 생성, 수정, 삭제 * 
-- DDL : CREATE, ALTER, DROP
-- 테이블(Table) : 데이터 저장소
-- 아이디    문자  10 BYTE
-- 이름      문자  20
-- 나이      숫자  30
-- 전화번호  문자  20
-- 생일      날짜
-- 비고      문자 255


-- 테이블 생성
CREATE TABLE TBL_SAMPLE
(
ID VARCHAR2 (10)
, NAME VARCHAR2 (20)
, AGE NUMBER (3)
, BIRTH DATE
);
--Table TBL_SAMPLE이(가) 생성되었습니다.
SELECT *
FROM TABS
-- WHERE TABLE_NAME LIKE 'TBL\_%' ESCAPE '\';
WHERE REGEXP_LIKE (TABLE_NAME, '^TBL_');
--
DESC TBL_SAMPLE;
DESC TBL_EXAMPLE;
COMMIT;
--
ALTER TABLE TBL_SAMPLE
ADD (TEL VARCHAR2(20)
    , BIGO VARCHAR2(255)
);

-- 비고 칼럼의 크기, 자료형 수정하려면? => MODIFY
-- 문자열 -> 숫자형 으로 변경은 불가 => CHAR 와 VARCHAR2 상호간의 변경만 가능.
-- BIGO(255) -> (100)
ALTER TABLE TBL_SAMPLE
MODIFY (BIGO VARCHAR2(100));

-- BIGO 칼럼명 -> MEMO 로 변경?
ALTER TABLE TBL_SAMPLE
RENAME COLUMN BIGO TO MEMO; 

-- MEMO 컬럼 제거?
ALTER TABLE TBL_SAMPLE
DROP COLUMN MEMO;

-- 테이블명을 변경?
RENAME TBL_SAMPLE TO TBL_EXAMPLE;
-- 테이블 이름이 변경되었습니다.



       
        
       

















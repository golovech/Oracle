----[문제풀이]
-- 1. emp테이블의 잡의 갯수 조회
SELECT COUNT(DISTINCT job)
FROM emp;
--
SELECT COUNT(*)
FROM(
    SELECT DISTINCT job
    FROM emp
    ) e;

-- 2. emp테이블의 부서별 사원수 조회
-- 같다.

SELECT count(*)
     , CASE  deptno   WHEN 10 THEN sum(depyno)
                END
         , CASE  deptno   WHEN 20 THEN sum(depyno)
                END
                     , CASE  deptno   WHEN 30 THEN sum(depyno)
                END
                
FROM emp;

--

SELECT 10 "a" ,count(*) "부서별 인원"
FROM emp
WHERE deptno = 10
UNION ALL
SELECT 20, COUNT(*)
FROM emp
WHERE deptno = 20
UNION ALL
SELECT 30, COUNT(*)
FROM emp
WHERE deptno = 30
UNION ALL
SELECT NULL, COUNT(*)
FROM emp;

--

SELECT deptno 부서명, COUNT(*)
FROM emp
GROUP BY deptno
ORDER BY deptno ASC;
-- 40번 부서 0명도 출력하고 싶다면? (존재하지 않는 부서...)
SELECT COUNT(*)
     -- , DECODE(deptno,10,1)
     , COUNT(DECODE(deptno,10,1)) "10"
     , COUNT(DECODE(deptno,20,1)) "20"
     , COUNT(DECODE(deptno,30,2)) "30"
     , COUNT(DECODE(deptno,40,3)) "40" -- count()는 null값은 제외하고 카운팅한다...
FROM emp;

-- 문제

SELECT COUNT(*)
    , COUNT(DECODE(MOD(SUBSTR(ssn,-7,1),2),1,'남')) gender
    , COUNT(DECODE(MOD(SUBSTR(ssn,-7,1), 1),2,'여')) gender
FROM insa ;

--
SELECT DECODE(MOD(SUBSTR(ssn,-7,1), 2),1,'남',0,'여') gen, COUNT(*)
FROM insa
GROUP BY MOD(SUBSTR(ssn,-7,1), 2);


-- CASE
SELECT '전체' gender, COUNT(*)
FROM INSA
UNION ALL
SELECT  CASE MOD(SUBSTR(ssn,-7,1), 2) WHEN 1 THEN '남'
                                   ELSE '여'
    END gender
    ,COUNT(*)
FROM insa
GROUP BY MOD(SUBSTR(ssn,-7,1), 2);

-- GROUP BY + rollup
SELECT  CASE MOD(SUBSTR(ssn,-7,1), 2) WHEN 1 THEN '남자'
                                      WHEN 0 THEN '여자'
                                      ELSE '전체'
    END gender
    ,COUNT(*)
FROM insa
GROUP BY ROLLUP (MOD(SUBSTR(ssn,-7,1), 2));

-- 문제.급여 제일많이받는사람의 정보를 조회
SELECT *
FROM emp
WHERE sal+NVL(comm,0) = (
                            SELECT MAX(sal+NVL(comm,0))
                            FROM emp
                            );

-- SQL 연산자 : all, some, any, exists
-- 급여 가장 적게 받는 사람의 정보를 조회
SELECT *
FROM emp
WHERE sal+NVL(comm,0) <= all (SELECT sal+NVL(comm,0) FROM emp); -- 이중for문과 같다.


-- 문제) emp 테이블에서 각 부서별 최고 급여를 받는 사원의 정보 조회

SELECT *
FROM emp
WHERE sal+NVL(comm,0) >= all (SELECT sal+NVL(comm,0) FROM emp WHERE deptno = 10)
UNION 
SELECT *
FROM emp
WHERE sal+NVL(comm,0) >= all (SELECT sal+NVL(comm,0) FROM emp WHERE deptno = 20)
UNION
SELECT *
FROM emp
WHERE sal+NVL(comm,0) >= all (SELECT sal+NVL(comm,0) FROM emp WHERE deptno = 30);

--
SELECT deptno, MAX(sal+NVL(comm,0))
     --, MIN (sal+NVL(comm,0))
FROM emp
GROUP BY deptno
ORDER BY deptno ASC;

-- 틀린코딩이지만 출력값은 맞음
SELECT *
FROM emp
WHERE sal+NVL(comm,0) = any (SELECT MAX(sal+NVL(comm,0))
                             FROM emp
                             GROUP BY deptno);
                         
                             
--상관서브쿼리 사용 : WHERE절의 서브쿼리 : 
--                   ()안에 있는 서브쿼리 -> 바깥의 쿼리를 이용해 값 계산 -> 다시 ()안으로 와서 계산
SELECT *
FROM emp m
WHERE sal+NVL(comm,0) = (
                        SELECT MAX(sal+NVL(comm,0))
                        FROM emp s
                        WHERE deptno = m.deptno 
                        );
                        
                        
-- emp 테이블별로 pay 순위

SELECT m.*
     , (SELECT COUNT(*) +1 FROM emp WHERE sal > m.sal)
     , (SELECT COUNT(*) +1 FROM emp WHERE sal > m.sal AND deptno = m.deptno)
FROM emp m
ORDER BY deptno;
--
SELECT *
FROM (
            SELECT m.*
                 , (SELECT COUNT(*) +1 FROM emp WHERE sal > m.sal) rank
                 , (SELECT COUNT(*) +1 FROM emp WHERE sal > m.sal AND deptno = m.deptno) dept_rank
            FROM emp m
           
            )t
             WHERE t.dept_rank <= 2
             ORDER BY deptno, dept_rank;
             
             
-- insa테이블에서 부서별 인원수가 10명 이상인 부서를 조회

SELECT *
FROM (
            SELECT i.*
                , (SELECT COUNT(*) +1 FROM insa WHERE buseo > i.buseo)
            FROM insa i
            
            )a 
            
WHERE a.buseo >=10;

-- 여자가 5명 이상인 부서를 조회
SELECT buseo, COUNT(DECODE(MOD(SUBSTR(ssn,-7,1),2),0,'여자')) "여자의 수"
FROM insa
GROUP BY buseo
HAVING COUNT(DECODE(MOD(SUBSTR(ssn,-7,1),2),0,'여자')) >= 5;


--
SELECT *
FROM(
       SELECT insa.*
       ,(SELECT COUNT(*) +1 FROM insa WHERE DECODE(MOD(SUBSTR(ssn,-7,1),0, '여자'))   

)
GROUP BY buseo
HAVING COUNT(DECODE(SUBSTR(ssn,-7,1),2)) >=5;


-- 올바른 코딩 : 여자가 5명 이상인 부서를 조회
SELECT buseo, COUNT(*)
FROM insa
WHERE MOD(SUBSTR(ssn,-7,1),2) = 0 -- 여자만 걸러낸 후
GROUP BY buseo -- 부서별로 집계해서
HAVING COUNT(*) >= 5; -- 5명 이상인 곳을 센 것.


---- emp 테이블에서 사원들의 전체 평균 급여 계산 후,
---- 각 사원들의 급여가 평균급여보다 많을 경우 "많다" 출력, 적으면 "적다" 출력

SELECT sal+NVL(comm,0) pay, COUNT(*)
,DECODE( AVG(sal+NVL(comm,0)), AVG(sal+NVL(comm,0)  > sal+NVL(comm,0),'많다', AVG(sal+NVL(comm,0) < sal+NVL(comm,0),'적다')
FROM emp;

--맞는 코딩
SELECT empno, ename, pay, ROUND(avg_pay,2) avg_pay
     , CASE WHEN pay > avg_pay THEN '많다'
            WHEN pay < avg_pay THEN '적다'
            ELSE '같다'
        END
FROM(
        SELECT emp.*
            , sal+NVL(comm,0) pay
            , (SELECT AVG(sal+NVL(comm,0) )FROM emp) avg_pay
        FROM emp
)e;


-- emp테이블에서 급여 가장 많이 받는사람/가장적게 받는 사람 출력 (max, min)
 
-- SELECT *
--     , CASE WHEN MAX(sal+NVL(comm,0)) > (SELECT AVG(sal+NVL(comm,0) )FROM emp) THEN 'max'
--            WHEN MIN(sal+NVL(comm,0)) < (SELECT AVG(sal+NVL(comm,0) )FROM emp) THEN 'min'
-- FROM emp
-- WHERE MAX(sal+NVL(comm,0)) ;
 
 
-- SELECT emp.*
--     , sal+NVL(comm,0) pay
--     , (SELECT MAX(sal+NVL(comm,0)) FROM emp )
-- FROM emp

----
SELECT *
FROM emp
WHERE sal + NVL(comm, 0) IN (
    SELECT MIN(sal + NVL(comm, 0)) FROM emp
    UNION ALL
    SELECT MAX(sal + NVL(comm, 0)) FROM emp
);

-- insa테이블에서 서울출신 사원중에 부서별 남자, 여자 사원수,
-- 남자 급여 총합 / 여자 급여 총합 을 조회.
-- sum(buseo), str(), regexp_like(), 
SELECT buseo, city, ssn, basicpay+NVL(sudang,0) pay
FROM insa
WHERE REGEXP_LIKE (city, '^서울') AND basicpay+NVL(sudang,0) IN (
            (SELECT DECODE(MOD(SUBSTR(ssn,-7,1),2,'여자'))), (SELECT DECODE(MOD(SUBSTR(ssn,-7,1),1,'남자')))
            
            );

GROUP BY buseo

-----
SELECT buseo
     , COUNT(*) "총사원수"
     , COUNT(DECODE(MOD(SUBSTR(ssn,-7,1),2),1,'m' )) "m"
     , COUNT(DECODE(MOD(SUBSTR(ssn,-7,1),2),0,'f' )) "f"
     , SUM (DECODE(MOD(SUBSTR(ssn,-7,1),2),1,basicpay ))
     , SUM (DECODE(MOD(SUBSTR(ssn,-7,1),2),0,basicpay ))
FROM insa
WHERE city = '서울'
GROUP BY buseo
ORDER BY buseo ASC;

-------
SELECT buseo, jikwi, COUNT(*), SUM(basicpay), AVG(basicpay)
FROM insa
GROUP BY ROLLUP(buseo, jikwi)
ORDER BY buseo, jikwi;

----
SELECT buseo
     , DECODE(MOD(SUBSTR(ssn,-7,1),2),0,'여자','남자') gender
     , COUNT(*) inwon
     , SUM(basicpay) "총급여합"
FROM insa
WHERE city = '서울'
GROUP BY buseo, MOD(SUBSTR(ssn,-7,1),2)
ORDER BY buseo, MOD(SUBSTR(ssn,-7,1),2);

---- ROWNUM / ROWID 의사칼럼(수도칼럼) : 표시되진 않지만 내부에 존재하는 칼럼
DESC emp;
SELECT ROWNUM, ROWID, ename, hiredate, job
FROM emp;

-------- [ TOP - N 분석 ]

	SELECT 컬럼명,..., ROWNUM
	FROM (
          SELECT 컬럼명,... from 테이블명
	      ORDER BY top_n_컬럼명
          )
    WHERE ROWNUM <= n;
    
----[ROWNUM 활용]
SELECT ROWNUM,e.*
FROM(
        SELECT *
        FROM emp
        ORDER BY sal DESC
        )e
-- WHERE ROWNUM BETWEEN 3 AND 5 : 이건 안된다.
WHERE ROWNUM = 1; -- 1등
WHERE ROWNUM <= 3; -- 1~3등

-- ORDER BY 절과 함께 ROWNUM 사용 X (인라인뷰는 가능)
SELECT ROWNUM, emp.*
FROM emp
ORDER BY sal DESC;

-- 인라인뷰로 가공(ROWNUM AS " ")하면 3~5 출력은 가능.
SELECT *
FROM(
        SELECT ROWNUM seq,e.*
        FROM(
                SELECT *
                FROM emp
                ORDER BY sal DESC
                )e
        )
WHERE seq BETWEEN 3 AND 5;

-- ROLLUP/CUBE 설명
-- 1) ROLLUP : 그룹화하고 그룹에 대한 부분합
-- join
SELECT dname, job, COUNT(*)
FROM emp e, dept d
WHERE e.deptno = d.deptno
--GROUP BY d.dname, job
GROUP BY ROLLUP ( dname, job) -- ROLLUP 부분합
ORDER BY dname;

--ORDER BY d.deptno ASC;

--2. CUBE : ROLLUP결과에 GROUP BY절의 조건에 따라 가능한 모~든 그룹핑 조합결과 출력.
--          그룹화하고 그룹에 대한 부분합, 아래에 그룹별 집계합 출력
SELECT dname, job, COUNT(*)
FROM emp e, dept d
WHERE e.deptno = d.deptno
--GROUP BY d.dname, job
GROUP BY CUBE ( dname, job) -- ROLLUP 부분합
ORDER BY dname;

---- [순위(RANK)와 관련된 함수]

SELECT ename, sal+NVL(comm,0) pay
     , RANK() OVER(ORDER BY sal+NVL(comm,0) DESC) RANK순번 -- 일반순번
      , DENSE_RANK() OVER(ORDER BY sal+NVL(comm,0) DESC) DENSERANK -- 같은 값이면 순번은 같게 하고, 중복은 1개로 치고 순위매김.
      , ROW_NUMBER() OVER(ORDER BY sal+NVL(comm,0) DESC) ROW_NUMBER -- 같은 값이라도 순번을 다르게 매김.
FROM emp;

SELECT *
FROM emp;

UPDATE emp
SET sal = 2850
WHERE empno = 7566;
COMMIT;


----------[ PARTITION BY ] 순위 함수 사용 예제
----------부서별로 급여 순위를 매기자.
SELECT *
FROM(
        SELECT emp.*
             , RANK() OVER (PARTITION BY deptno ORDER BY sal+NVL(comm,0) DESC) 순위
              , RANK() OVER ( ORDER BY sal+NVL(comm,0) DESC) 전체순위
        FROM emp
        )
WHERE 순위 BETWEEN 2 AND 3 ;
WHERE 순위 = 1;

--------- insa 테이블의 사원들을 14명씩 팀 짜겠다.
-- 14명씩 나눠야함. -> 몇팀이 나올지 계산하자. 나누기/ 나머지 몫 구하기.
SELECT CEIL((COUNT(*))/14)
FROM insa;

-- insa테이블에서 사원수가 가장 많은 부서의 , 부서명, 사원수 출력
SELECT *
FROM(
        SELECT buseo, COUNT(*)
             , RANK() OVER (ORDER BY COUNT(*) DESC) 부서순위
             FROM insa
             GROUP BY buseo



     )e
WHERE 부서순위 = 1;

-- 인사테이블에서 여자수가 가장많은 부서 및 사원수

SELECT *
FROM(
        
        SELECT buseo, ssn, COUNT(*)
             , RANK () OVER (ORDER BY COUNT(MOD(SUBSTR(ssn,-7,1),2) ) DESC) 여자많은부서순위
        FROM insa
        GROUP BY buseo, ssn
        )
WHERE 여자많은부서순위 = 1;
---
SELECT *
FROM(
        SELECT buseo, ssn, COUNT(*)
             , RANK() OVER (ORDER BY COUNT(*) DESC) 부서순위
             FROM insa
             WHERE MOD(SUBSTR(ssn,-7,1),2)  = 0
             GROUP BY buseo, ssn

     )e
WHERE 부서순위 = 1;

-- [문제] insa 테이블에서 basicpay가 상위 10%만 출력 (이름,기본급)

SELECT *
FROM(
        SELECT name, basicpay
             , RANK() OVER (ORDER BY basicpay DESC) pay순위
             FROM insa
             -- GROUP BY basicpay
             )p
WHERE p.pay순위 <= (SELECT COUNT(*)*0.1 FROM insa);



SELECT *
FROM
(
SELECT name, basicpay
         ,PERCENT_RANK() OVER (ORDER BY basicpay DESC) pr
         FROM insa
         )
         WHERE pr <= 0.1;
         

         















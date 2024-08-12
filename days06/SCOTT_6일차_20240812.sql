
-- 틀림...
SELECT e.*
FROM(
        SELECT ENAME, SAL+NVL(COMM,0) "PAY", AVG(SAL+NVL(COMM,0)) "AVG_PAY"
        ,ROUND(AVG(SAL+NVL(COMM,0)),2) "차 반올림"
        ,CEIL(SAL+NVL(COMM,0)) -  AVG(SAL+NVL(COMM,0)*100)/100 "차 올림"
        ,TRUNC((SAL+NVL(COMM,0),2) - AVG(SAL+NVL(COMM,0))) "차 내림"
       
        )e;
        
--- EMP에서 급여페이가 많다, 적다, 같다 출력
WITH TEMP AS 
    ( 
    SELECT ENAME, SAL+NVL(COMM,0) "PAY"
    ,(SELECT AVG(SAL+NVL(COMM,0)) FROM EMP) "AVG_PAY"
    FROM EMP) 
         
SELECT T.*
     , CASE
            WHEN PAY > AVG_PAY THEN '많다'
            WHEN PAY < AVG_PAY THEN '적다'
            ELSE '같다'
            END 평가
FROM TEMP T;

-- 이순신 주민등록번호 오늘날짜의 월,일로 수정
-- 생일 지남 여부 출력. / SYSDATE 에서 - 월,일 추출해서 생일 빼서 -1과 같거나 많으면 안 지난것.

SELECT NAME, SSN
     , SUBSTR(SSN,0,2)
     , TO_CHAR (SYSDATE, 'MMDD')
FROM INSA
WHERE NUM = 1002;

UPDATE INSA
SET SSN = SUBSTR(SSN,0,2) || TO_CHAR (SYSDATE, 'MMDD') || SUBSTR(SSN,7)
WHERE NUM = 1002;
COMMIT;

--------- 생일지났는지 확인
SELECT NAME, SSN
     , SUBSTR(SSN,3,2)
     , TO_DATE(SUBSTR(SSN,3,4), 'MMDD')
     , CASE SIGN(TO_DATE(SUBSTR(SSN,3,4), 'MMDD') - TRUNC(SYSDATE)) -- TRUNC(A): 시간,분초가 짤림. SIGN(A):
        WHEN  1 THEN 'X'
        WHEN 0 THEN 'O'
        ELSE '오늘'
        END E
FROM INSA;

-- INSA TABS SSN 만나이 계산해서 출력 1800 0,9 / 1900, 1,2 / 2000, 3, 4/ 외국인 1900 5,6 / 2000 7,8
-- 2024-1998 -1(생일지남여부. 생일지나면 -1빼고, 아니면 빼지말고)
SELECT NAME, SSN
     , SUBSTR(SSN,0,2) 출생년도
     , EXTRACT(YEAR FROM SYSDATE) 올해년도
     , CASE SIGN (TO_DATE(SUBSTR(SSN,0,2),'YY') + ( CASE SUBSTR(SSN,7,1) WHEN 1 OR 2 THEN '19YY' WHEN 3 OR 4 THEN '20YY' WHEN )
     - TRUNC(SYSDATE))
     WHEN  THEN
     WHEN  TEHN
     WHEN  THEN
     WHEN  TEHN
     END A
FROM INSA;

----------
SELECT T.NAME, T.SSN, 출생년도, 올해년도
     , 올해년도 - 출생년도 + CASE  DS WHEN -1 THEN -1
                                        ELSE 0
                                    END 만나이
FROM (
SELECT NAME, SSN
     , EXTRACT(YEAR FROM SYSDATE) 올해년도
     , SUBSTR(SSN,-7,1) 성별
     , SUBSTR(SSN,0,2) 출생2자리년도
     , CASE 
        WHEN  SUBSTR(SSN,-7,1) IN (1,2,5,6) THEN 1900
        WHEN  SUBSTR(SSN,-7,1) IN (3,4,7,9) THEN 2000
        ELSE 1800
     END + SUBSTR(SSN,0,2) 출생년도
     -- 0이거나 -1이면 생일 지난 것.
     -- 1이라면 생일 안지난것 -> 나이계산에서 -1 해줄것.
     , SIGN(TO_DATE(SUBSTR(SSN,3,4), 'MMDD') - TRUNC(SYSDATE)) DS
FROM INSA
) T; 

-------- DBMS_RANDOM 패키지
-- STRING(), VALUE() 함수
-- 자바의 패키지 : 서로 관련된 클래스들의 묶음을 의미
-- 오라클의 패키지 : 서로 관련된 타입, 객체, 서브프로그램을 묶어놓은 것.
-- 유지보수, 관리가 편함.
-- 0.0 < SYS.DBMS_RANDOM.VALUE < 1.0 실수값
SELECT 
     SYS.DBMS_RANDOM.VALUE
--     , SYS.DBMS_RANDOM.VALUE(0,100) -- 0.0 <= 100.0
--     , SYS.DBMS_RANDOM.STRING('U',5) -- 랜덤 대문자 5글자 발생
--     , SYS.DBMS_RANDOM.STRING('X',5) -- 랜덤 대문자+숫자
--     , SYS.DBMS_RANDOM.STRING('L',5) -- 랜덤 소문자 5글자
     , SYS.DBMS_RANDOM.STRING('P',5) -- 랜덤 대문자+소문자+숫자+특수문자
     , SYS.DBMS_RANDOM.STRING('A',5) -- 랜덤 대문자+소문자(알파벳)
     
FROM DUAL;

-- 임의의 국어점수 1개 출력
-- 임의의 로또 번호 1개 출력 (1~45)
-- 임의의 숫자 6자리 발생시켜서 출력

SELECT TRUNC(SYS.DBMS_RANDOM.VALUE (0,100)) 국어점수
     , ROUND(SYS.DBMS_RANDOM.VALUE (0,100)) 국어점수
     , TRUNC(SYS.DBMS_RANDOM.VALUE (1,45))  로또번호
     , TRUNC(SYS.DBMS_RANDOM.VALUE (1,45)) || ' '
     || TRUNC(SYS.DBMS_RANDOM.VALUE (1,45)) || ' ' 
     || TRUNC(SYS.DBMS_RANDOM.VALUE (1,45)) || ' '
     || TRUNC(SYS.DBMS_RANDOM.VALUE (1,45)) || ' ' 
     || TRUNC(SYS.DBMS_RANDOM.VALUE (1,45)) || ' ' 
     || TRUNC(SYS.DBMS_RANDOM.VALUE (1,45)) "로또번호6자리출력"
     , TRUNC(SYS.DBMS_RANDOM.VALUE (100000,999999)) "6자리출력"
     
FROM DUAL;

-----인사테이블, 남자사원수, 여자사원수 몇명?
-- 인사테이블, 부서별 남자사원수, 여자사원수
-- 1.
SELECT DECODE(SUBSTR(SSN,-7,1),2,'남','여') 성별, COUNT(*) "남녀수"
FROM INSA
GROUP BY SUBSTR(SSN,-7,1);

-- 2.
SELECT DECODE(SUBSTR(SSN,-7,1),2,'남','여') 성별, BUSEO ,COUNT(*) "부서별 남녀수"
FROM INSA
GROUP BY SUBSTR(SSN,-7,1), BUSEO
ORDER BY 성별, BUSEO;

-- 두번째 풀이
SELECT DECODE(MOD(SUBSTR(SSN,-7,1),2),1,'남','여') 성별, BUSEO ,COUNT(*) "부서별 남녀수"
FROM INSA
GROUP BY MOD(SUBSTR(SSN,-7,1),2), BUSEO
ORDER BY 성별, BUSEO;

-- EMP테이블의 최고급여자 누구? 최저급여자 누구? 사원정보 출력
-- 틀리게 푼 쿼리..
--SELECT CASE WHEN 1 THEN '최고급여자'
--            ELSE 2 THEN '최저급여자'
--FROM (
--        SELECT EMPNO, ENAME, JOB, MGR, HIREDATE, DEPTNO,  MAX(SAL) 최고급여, MIN(SAL) 최저급여
--             , RANK () OVER (ORDER BY SAL) RANK
--             , ROW_NUMBER() OVER (ORDER BY SAL ASC) "1"
--             , ROW_NUMBER() OVER (ORDER BY SAL DESC) "2"
--        FROM EMP
--        )
--        GROUP BY  EMPNO, ENAME, JOB, MGR, HIREDATE, DEPTNO , SAL;
------------------------
        
SELECT *
FROM EMP
WHERE SAL IN(
            (SELECT MAX(SAL)
            FROM EMP), (SELECT MIN(SAL)
            FROM EMP)
            );
            
---- 다른 풀이

SELECT *
FROM EMP m
WHERE SAL IN(
            (SELECT MAX(SAL) FROM EMP WHERE deptno=m.deptno)
            ,(SELECT MIN(SAL) FROM EMP WHERE deptno=m.deptno)
            )
ORDER BY sal, deptno desc;

-- 다른 풀이
SELECT *
FROM EMP A , (SELECT DEPTNO, MAX(SAL) MAX, MIN(SAL) MIN FROM EMP GROUP BY DEPTNO) B
WHERE A.SAL = B.MAX OR A.SAL = B.MIN AND A.DEPTNO = B.DEPTNO
ORDER BY A.DEPTNO, SAL DESC;


------ 부서별 최고/최저급여자
SELECT *
FROM    (
        SELECT EMP.* -- MAX(SAL) 최고급여, MIN(SAL) 최저급여
          , RANK () OVER (PARTITION BY DEPTNO ORDER BY SAL DESC) RANK
          , RANK () OVER (PARTITION BY DEPTNO ORDER BY SAL ASC) RANK1
         FROM EMP
         ) E
             
WHERE E.RANK = 1 OR E.RANK1 = 1
ORDER BY DEPTNO;

             
---- 문제) EMP테이블 COMM 400이하인 사원의 정보, COMM NULL 인 사원도 400이하에  포함.
SELECT EMP.*
     , NVL(COMM,0) COMM
FROM EMP
 WHERE COMM <= 400 OR COMM IS NULL;
 
-------LNNVL() 함수 : WHERE 조건이 UNKNOW나 FALSE면 TRUE...

SELECT *
FROM EMP
WHERE LNNVL(COMM > 400); -- == COMM이 <= 400 OR COMM IS NULL 과 똑같은 뜻.

---- 이번 달의 마지막 날짜가 몇일까지 있나?
SELECT LAST_DAY(SYSDATE)
     , ADD_MONTHS(TRUNC(SYSDATE, 'MONTH'),1)
     , TO_CHAR(ADD_MONTHS(TRUNC(SYSDATE, 'MONTH'),2), 'DD' )
     , TO_CHAR(LAST_DAY(SYSDATE),'DD') -- 마지막 날짜 가져오기.
FROM DUAL;

-- EMP테이블에서 SAL이 상위 20%에 해당하는 사원 정보 출력
SELECT *
FROM (
      SELECT EMP.*
     , RANK () OVER (ORDER BY SAL DESC) "AVG_SAL"
     FROM EMP
     ) E

WHERE E.AVG_SAL <= SELECT FLOOR(COUNT(*) *0.2 FROM EMP);

------------ PERCENT_RANK() OVER () : 자동으로 상위 퍼센트를 매겨주는 함수.
SELECT *
FROM (
      SELECT EMP.*
     , PERCENT_RANK () OVER (ORDER BY SAL DESC) PR -- PERCENT_RANK
     FROM EMP
     ) T

WHERE T.PR <= 0.2;

--------- 다음 주 월요일은 휴강입니다. 다음주 월요일의 날짜를 조회.
SELECT TO_CHAR(SYSDATE,'DS TS DAY')
     , NEXT_DAY(SYSDATE, '월')
FROM DUAL;

------- EMP테이블에서 각 사원들의 입사일자를 기준으로 10년 5개월 20일째 되는 날짜를 조회
SELECT ENAME, HIREDATE, ADD_MONTHS(HIREDATE, 10*12 + 5) + 20
FROM EMP;

-- 문제) 

insa 테이블에서 
[실행결과]
               부서사원수/전체사원수 == 부/전 비율
               부서의 해당성별사원수/전체사원수 == 부성/전%
               부서의 해당성별사원수/부서사원수 == 성/부%
                                           
부서명     총사원수 부서사원수 성별  성별사원수  부/전%   부성/전%   성/부%
개발부       60       14         F       8       23.3%     13.3%       57.1%
개발부       60       14         M       6       23.3%     10%       42.9%
기획부       60       7         F       3       11.7%       5%       42.9%
기획부       60       7         M       4       11.7%   6.7%       57.1%
영업부       60       16         F       8       26.7%   13.3%       50%
영업부       60       16         M       8       26.7%   13.3%       50%
인사부       60       4         M       4       6.7%   6.7%       100%
자재부       60       6         F       4       10%       6.7%       66.7%
자재부       60       6         M       2       10%       3.3%       33.3%
총무부       60       7         F       3       11.7%   5%           42.9%
총무부       60       7         M    4       11.7%   6.7%       57.1%
홍보부       60       6         F       3       10%       5%           50%
홍보부       60       6         M       

SELECT I.*
FROM 
        (
        SELECT BUSEO, COUNT(*)
             , COUNT(BUSEO)
             , NVL(SSN,-7,1) 성별
             , 
        FROM INSA
        GROUP BY BUSEO
        ) I
WHERE SUM(BUSEO)
ORDER BY BUSEO ASC;
-- WHERE COUNT(*) =( SELECT COUNT(NAME))

-- 쌤 풀이
SELECT S.*
     , ROUND(부서사원수/총사원수*100, 2) || '%' "부서사원수/총사원수"
     , ROUND(성별사원수/총사원수*100, 2) || '%' "성별사원수/총사원수"
     , ROUND(성별사원수/부서사원수*100, 2) || '%' "성별사원수/부서사원수"
FROM
        (
        SELECT BUSEO
             , (SELECT COUNT(*) FROM INSA WHERE  ) 총사원수 
             , (SELECT COUNT(*) FROM INSA WHERE BUSEO = T.BUSEO) 부서사원수
             , GENDER 성별
             , COUNT(*) 성별사원수 
        FROM(
                SELECT BUSEO, NAME, SSN
                     , DECODE(MOD(SUBSTR(SSN,-7,1),2),1,'M','F') GENDER
                FROM INSA
             ) T
        GROUP BY BUSEO, GENDER
        ORDER BY BUSEO, GENDER
        ) S;
        
------ [ LISTAGG (A, '구분기호') WITHIN GROUP (ORDER BY A ) ]

--[실행결과]
--10   CLARK/MILLER/KING
--20   FORD/JONES/SMITH
--30   ALLEN/BLAKE/JAMES/MARTIN/TURNER/WARD
--40  사원없음  

SELECT DEPTNO, LISTAGG(ENAME, '/') WITHIN GROUP (ORDER BY ENAME DESC)
FROM EMP
GROUP BY DEPTNO;
---------

SELECT DEPTNO, LISTAGG(ENAME, ',') WITHIN GROUP(ORDER BY ENAME DESC)
FROM EMP
GROUP BY DEPTNO
ORDER BY DEPTNO ASC;

--------- 인사테이블에서 TOP-N 분석방식으로, 급여 많이 받는 TOP10 조회?
SELECT ROWNUM seq, I.*
FROM
(
SELECT *
FROM INSA
ORDER BY BASICPAY DESC
) I
WHERE ROWNUM <=10;

------

SELECT TRUNC( SYSDATE , 'YYYY') -- 2024
     , TRUNC( SYSDATE , 'MM') -- 08
     , TRUNC( SYSDATE , 'DD') -- 12
     , TRUNC( SYSDATE ) -- 2024/08/12
FROM DUAL;

--------------------------

[실행결과]
DEPTNO ENAME PAY BAR_LENGTH      / 100단위로 # 1개. 반올림한것 (RPAD, LPAD)
---------- ---------- ---------- ----------
30   BLAKE   2850   29    #############################
30   MARTIN   2650   27    ###########################
30   ALLEN   1900   19    ###################
30   WARD   1750   18    ##################
30   TURNER   1500   15    ###############
30   JAMES   950       10    ##########

SELECT DEPTNO, ENAME, SAL+NVL(COMM,0) PAY
     , ROUND((SAL+NVL(COMM,0))/100) || RPAD(' ',ROUND((SAL+NVL(COMM,0))/100) +1,'#') "BAR_LENGTH" -- +1해주기
FROM EMP
WHERE DEPTNO = 30
ORDER BY PAY DESC;

--
SELECT HIREDATE
     , TO_CHAR(HIREDATE, 'WW') -- 연중 몇번째 주
     , TO_CHAR(HIREDATE, 'IW') -- 연중 몇번째 주
     , TO_CHAR(HIREDATE, 'W') -- 월중 몇번째 주?
FROM EMP;

----
SELECT 
     TO_CHAR(TO_DATE('2022.01.01'),'WW')
     ,TO_CHAR(TO_DATE('2022.01.02'),'IW')
FROM DUAL;

-- 사원수가 가장 많은 부서명(DNAME), 사원수
-- 사원수가 가장 적은 부서명, 사원수 출력

SELECT A.*
FROM (
        SELECT COUNT(I.BUSEO), I.BUSEO
        JOIN INSA I
        ON EMP E
        FROM I.DNAME = E.DNAME
        ) A
WHERE MAX(E.DNAME) AND MIN(E.DNAME);


-- 조인, 테이블 2개. 외래키는 DNAME
-- SET 집합연산자 / UNION을 써서 푸는게 가장 쉽다. 한번 해보는것도...
-- [INNER] JOIN : 두 테이블의 공통된 부분만 출력하겠다는 뜻.
-- [LEFT / RIGHT]OUTER JOIN : 
SELECT D.DEPTNO,DNAME, COUNT(EMPNO) CNT
FROM DEPT D 
LEFT OUTER JOIN EMP E -- JOIN과 같음. 
ON E.DEPTNO = D.DEPTNO
GROUP BY D.DEPTNO, DNAME
ORDER BY D. DEPTNO;


-------
SELECT *
FROM
(
SELECT D.DEPTNO,DNAME, COUNT(EMPNO) CNT
     , RANK () OVER (ORDER BY COUNT(EMPNO) DESC) CNT_RANK
     , RANK () OVER (ORDER BY COUNT(EMPNO) ASC) CNT_RANK2
FROM DEPT D 
LEFT OUTER JOIN EMP E 
ON E.DEPTNO = D.DEPTNO
GROUP BY D.DEPTNO, DNAME
ORDER BY CNT_RANK ASC
) T
WHERE T.CNT_RANK = 1;


WITH TEMP AS (
                SELECT D.DEPTNO,DNAME, COUNT(EMPNO) CNT
                     , RANK () OVER (ORDER BY COUNT(EMPNO) DESC) CNT_RANK
                FROM DEPT D 
                LEFT OUTER JOIN EMP E 
                ON E.DEPTNO = D.DEPTNO
                GROUP BY D.DEPTNO, DNAME
                ORDER BY CNT_RANK ASC
                ) 
SELECT *
FROM TEMP
WHERE TEMP.CNT_RANK 
    IN ((SELECT MAX(CNT_RANK) FROM TEMP) 
       ,(SELECT MIN(CNT_RANK) FROM TEMP)
       );


---- WITH 절 암기!!------ WITH A AS (), B AS ()
WITH A AS (
        SELECT D.DEPTNO,DNAME, COUNT(EMPNO) CNT
        FROM DEPT D 
        LEFT OUTER JOIN EMP E 
        ON E.DEPTNO = D.DEPTNO
        GROUP BY D.DEPTNO, DNAME
        
        ) -- A
     , B AS (
        SELECT MAX(CNT) maxcnt, MIN(CNT) mincnt
        FROM A
     
     )
SELECT A.DEPTNO, A.dname, A.cnt
FROM A, B
WHERE A.cnt IN (B.MAXCNT, B.MINCNT);

-- 피봇(Pivot), 언피봇(unpivot) 암기 **
-- 각 JOB별 사원수 출력

SELECT 
    COUNT(DECODE(job, 'CLERK', 'O')) CLERK
    , COUNT(DECODE(job, 'SALESMAN', 'O')) SALESMAN
    , COUNT(DECODE(job, 'PRESIDENT', 'O')) PRESIDENT
    , COUNT(DECODE(job, 'MANAGER', 'O')) MANAGER
    , COUNT(DECODE(job, 'ANALYST', 'O')) ANALYST
FROM EMP;

------------

SELECT JOB
FROM EMP;

--

SELECT *
FROM (SELECT JOB
        FROM EMP)
PIVOT (COUNT(JOB) FOR JOB IN ('CLERK','SALESMAN','PRESIDENT','MANAGER', 'ANALYST'));
-- PIVOT == 축을 중심으로 회전시키다.

-- 2) EMP 테이블에서 각 월별 입사한 사원 수를 조회
SELECT *
FROM ( SELECT TO_CHAR(HIREDATE,'YYYY') YEAR
     , TO_CHAR(HIREDATE,'MM') MONTH
        FROM EMP)
PIVOT (COUNT(MONTH) FOR MONTH IN ('01' AS "1월",'02','03','04','05','06','07','08','09','10','11','12'))
ORDER BY YEAR;


-- 문제) EMP 테이블에서 JOB별 사원수 조회
SELECT *
FROM
        (
        SELECT JOB
        FROM EMP
        )
PIVOT (COUNT(JOB) FOR JOB IN ('CLERK','SALESMAN','PRESIDENT','MANAGER', 'ANALYST'));


-- 문제) EMP 테이블에서 부서별로 구분, JOB별 사원수 조회 / JOIN

--    DEPTNO DNAME             'CLERK' 'SALESMAN' 'PRESIDENT'  'MANAGER'  'ANALYST'
------------ -------------- ---------- ---------- ----------- ---------- ----------
--        10 ACCOUNTING              1          0           1          1          0
--        20 RESEARCH                1          0           0          1          1
--        30 SALES                   1          4           0          1          0
--        40 OPERATIONS              0          0           0          0          0


        
SELECT *
FROM 
        (
        SELECT d.DEPTNO, DNAME,job 
        FROM EMP e, DEPT D
        WHERE E.Deptno(+) = D.Deptno
        ) 
        
PIVOT (
        COUNT(JOB) FOR JOB IN ('CLERK', 'SALESMAN' ,'PRESIDENT' , 'MANAGER' , 'ANALYST')
        );

------------ 각 부서별 총 급여합을 조회
SELECT *
FROM (
        SELECT DEPTNO, SAL+nvl(COMM,0) PAY
        FROM EMP
        )
PIVOT (
        SUM(PAY) 
        FOR DEPTNO IN ('10','20','30','40')  
        ); -- SUM(A) 와 FOR B IN -> A와 B의 값은 다를 수 있다.
        
        
---------- NULL값 처리는 어떻게 하는가?
--SELECT *
--FROM (
--SELECT JOB, DEPTNO, SAL, ENAME
--FROM EMP
--      )
--      PIVOT (
--      SUM(SAL) AS 합계, MAX(SAL) AS 최대값 ,MAX(ENAME) AS 최고연봉
--      FOR DEPTNO IN ('10','20','30','40')
--      );

-- 피봇 문제)
---- 생일지난사람, 생일 안지난사람 수    오늘 생일인 사람
--            20              30             1

-- **********************************************
SELECT * 
FROM
    (
        SELECT SIGN(TO_DATE(SUBSTR(SSN,3,4),'MMDD') - TRUNC(SYSDATE)) 생일자
        FROM INSA
             )
PIVOT(
        COUNT(생일자)
        FOR 생일자 IN ('1' AS "생일지난사람",'0' AS "생일안지난사람",'-1' AS "오늘생일자")
);
-- SIGN이 머지?


-- 부서번호 4자리로 출력
SELECT DEPTNO
     , LPAD(DEPTNO,4,'0')
     , TO_CHAR(DEPTNO, '0999')
FROM DEPT;

-- **********************************************
---- 암기!!! INSA테이블에서 각 부서별/출신지역별/사원수 몇명인지 출력?

SELECT BUSEO, CITY, COUNT(*) 사원수
FROM INSA
GROUP BY BUSEO, CITY
ORDER BY BUSEO, CITY;

-- **********************************************

-- [ PARTITION BY OUTER JOIN ] 구문 사용! // FROM INSA I PARTITION BY (BUSEO) RIGHT OUTER JOIN C ON I.CITY = C.CITY
WITH C AS (
        SELECT DISTINCT CITY
        FROM INSA
        )
        SELECT BUSEO, C.CITY, COUNT(NUM)
FROM INSA I PARTITION BY (BUSEO) RIGHT OUTER JOIN C ON I.CITY = C.CITY
GROUP BY BUSEO, C.CITY
ORDER BY  BUSEO, C.CITY;

--**********************************************








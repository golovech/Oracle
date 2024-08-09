
    -- 5. 산술 연산자
--        1. 나머지 구하는 연산자 : MOD(), REMINDER
--        2. 몫 구하는 절삭함수 : floor()
    SELECT FLOOR(5/3)
    FROM dual;
    
    
    -- 6. SET(집합) 연산자 : UNION, UNION ALL, INTERSECT, MINUS
    --    1) UNION        : 합집합
    --    2) UNION ALL    : 합집합
        
        -- ORA-00937: not a single-group group function => 단일행 함수가 아니다. 
        --                     name,buseo 등과 count(*)함수는 같이 쓰지 못한다.
    
    SELECT COUNT(*) -- 14명
    FROM(
            SELECT name, buseo, city
            FROM insa 
            WHERE buseo = '개발부'
        )  ;
        
    SELECT COUNT(*)  -- 9명
    FROM(
            SELECT name, buseo, city
            FROM insa 
            WHERE city = '인천'
        )  ;
        

    SELECT name, buseo, city -- 6명
    FROM insa 
    WHERE city = '인천' AND buseo = '개발부';   
    -- 개발부 + 인천 합집합
    -- UNION : 중복된 데이터는 제거 -> 합집합을 구한다.
    -- UNION ALL : 중복을 허용하여 합집합.

            SELECT name, buseo, city -- 17명
            FROM insa 
            WHERE buseo = '개발부'
            -- ORA-00933: SQL command not properly ended : 집합 연산의 대상이 되는 두 테이블의 컬럼 수가 같고,
            --                                             대응되는 컬럼끼리 데이터 타입이 동일해야 한다.
            UNION ALL
            SELECT name, buseo, city
            FROM insa 
            WHERE city = '인천'
            ORDER BY buseo, city ; -- ORDER BY는 쿼리 마지막에.
            

    -- 
    SELECT ename, hiredate,TO_CHAR(deptno) n -- deptno || ''
    FROM emp
    UNION
    SELECT name, ibsadate, buseo
    FROM insa;
    
    --JOIN 사용
    SELECT ename, hiredate, dname-- TO_CHAR(deptno) n -- deptno || ''
    FROM emp, dept
    WHERE emp.deptno = dept.deptno
    UNION
    SELECT name, ibsadate, buseo
    FROM insa;
    
    -- 테이블 안에 데이터를 쪼개놓은 것 : 데이터베이스 모델링(정규화) => 중복성 제거 . . .

    -- 조인(join) 으로 바꾼다면?
    -- 사원번호, 사원명, 입사일자, 부서명
    -- emp : 
    
    -- 부모테이블/자식테이블
    -- FK : 자식이 부모의 key를 참조하는것. => JOIN
    SELECT empno, ename, hiredate, dname, dept.deptno
    FROM emp, dept -- JOIN / 두 테이블을 조인하겠다.
    WHERE emp.deptno = dept.deptno; -- JOIN 조건
    
    -- 알리야스 조인도 가능.
    SELECT empno, ename, hiredate, dname, d.deptno
    FROM emp e, dept d 
    WHERE e.deptno = d.deptno; -- JOIN 조건
    
    -- [ , ] 대신 [ A JOIN B ON ]  을 쓸 수 있음.
    SELECT empno, ename, hiredate, dname, d.deptno
    FROM emp e JOIN dept d ON e.deptno = d.deptno; -- JOIN 조건
    

    
    
    

--    3) INTERSECT    : 교집합
    SELECT name, buseo, city -- 6명
    FROM insa 
    WHERE buseo = '개발부'
    INTERSECT
    SELECT name, buseo, city
    FROM insa 
    WHERE city = '인천'
    ORDER BY buseo, city ;


--    4) MINUS        : 차집합
    SELECT name, buseo, city -- 8명
    FROM insa 
    WHERE buseo = '개발부'
    MINUS
    SELECT name, buseo, city
    FROM insa 
    WHERE city = '인천'
    ORDER BY buseo, city ;
    
    -- 만약 UNION 을 쓰고싶다면? : NULL city 널값을 줘서 별칭을 붙여준다.
    SELECT name, NULL city,  buseo-- 8명
    FROM insa 
    WHERE buseo = '개발부'
    UNION
    SELECT name, buseo, city
    FROM insa 
    WHERE city = '인천'
    ORDER BY buseo ;
    
    -- 집합 연산자 사용 시 주의할 점 (시험)
    --    1. 칼럼 수 같아야 함
    --    2. 타입이 동일해야 함
    --    3. 칼럼이름은 달라도 상관없다-> 첫번째 줄 칼럼명을 따른다.
    --    4. 오더바이는 마지막 쿼리에 붙여야한다.
    

---- [계층적 질의 연산자] : PRIOR, CONNECT_BY_ROOT 연산자
-- IS [NOT] NAN : NOT A NUMBER 줄임말
-- IS [NOT] INFINITE  : 무한대니? 묻는 연산자



---- [오라클 함수(function)]
-- 1) 단일행 함수
    --ㄱ. 문자 함수
    -- UPPER(), LOWER(), INITCAP()
    SELECT UPPER (dname), LOWER(dname), INITCAP(dname)
    FROM dept;
    
    -- [LENGTH()] 문자열 길이
    SELECT dname
        , LENGTH(dname)
    FROM dept;
    
    -- [SUBSTR()]
    SELECT ssn, SUBSTR(ssn,-7)  -- (ssn,-7,7)과 같음.
    FROM insa
    
    -- [INSTR(a)] : a가 어느자리에 있는지 찾는 함수.  
    SELECT dname, INSTR(dname,UPPER('s'),2,1) "두번째 s"
    , INSTR('S','OR',1,2) "s"
            , INSTR(dname,UPPER('s')) "첫번째 s"
    FROM dept;
    

    -- 1. 지역번호만 추출해서 출력
    SELECT tel
       
    FROM TBL_TEL;
    -- 2. 전화번호의 앞자리(3~4자리) 출력
    SELECT tel
        , SUBSTR(TEL, 1, INSTR(tel,')')) "지역번호"
        , SUBSTR(TEL, INSTR(tel,')')+1,  INSTR(tel,'-') - INSTR(tel,')')-1) "앞자리 3~4"
        , SUBSTR(TEL, -4, INSTR(tel,'-')) "뒷 4번호"
    FROM tbl_tel;
    
    ------- 오른쪽에 * 찍어보자.
    SELECT RPAD ('Corea', 12 , '*' )
    FROM dual;
    
    SELECT ename, sal + NVL(comm,0) pay
            , RPAD(sal + NVL(comm,0), 10, '*')
    FROM emp;
    
    
    -- *로 막대그래프 그리겠다.
    select last_name,rpad(' ', salary/1000/1,'*') "Salary" 
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
    
    -- [RTRIM(), LTRIM(), TRIM('a'의 공백제거)] : 특정글자를 지우는 함수
    SELECT RTRIM('xyBROWINGyxXxy','xy') "RTRIM example" 
         , LTRIM('*****3421','*') "LTRIM *제거"
         , LTRIM('    3421',' ') "LTRIM 공백제거"
         , TRIM('    xx    ')||']'
    FROM dual;
    
    ---- [ASCII()]
    
    SELECT ASCII ('A'), CHR(65)
    FROM dual;
    

    SELECT ename
         , SUBSTR(ename,1,1)
         , ASCII(SUBSTR(ename,1,1)) "ASCII EX"
    FROM emp;
    
    ---- [GREATEST()/LEAST()] : 나열된 숫자 또는 문자 중, 가장 큰/작은값을 반환하는 함수
    
    SELECT GREATEST (3,5,2,4,1) max
         , LEAST (3,5,2,4,1) min
         , GREATEST ('a','b','c','d','e') max
         , LEAST ('a','b','c','d','e') min 
    FROM dual;
    
    ---- [VSIZE()] : ()안의 사이즈를 알려주는 함수
    
    SELECT VSIZE(1), VSIZE('A'), VSIZE('아')
    FROM dual;
    
    
    
    -- ㄴ. 숫자 함수 : 숫자값을 리턴
--    ROUND(a[,b]) - 반올림 함수 . 
--          a : 값, b : 반올림하려는 자릿값
--                  b : 양수/음수 둘다 가능.
        
    SELECT 3.141592
    ,ROUND(3.141592,0) ㄱ -- 3
    ,ROUND(3.141592,3) ㄴ -- 3.142
    ,ROUND(12345.6789, -2) ㄷ -- 12300 : 음수가 붙으면 양수자리로 넘어가서 반올림됨.
    FROM dual;
    
    --    [절삭함수 : TRUNC(A[,B]), FLOOR(A[,B]) 차이점?] -- 날짜함수에도 사용 가능.
    SELECT FLOOR(3.141592) ㄱ
        , FLOOR(3.99999) ㄴ
        , TRUNC(3.141592,3) ㄷ -- b 자리의 소숫점까지만 잘라냄!
        , TRUNC(3.941592,1) ㄹ 
        , TRUNC(12395.6789, -2) ㅁ 
    FROM dual;
    
    --    [올림(절상)함수 : CEIL(A)]
    SELECT CEIL(3.14) ㄱ , CEIL(3.99) ㄴ -- 그냥 올려서 절상.
    FROM dual;
    
    -- 게시판 : 총게시글수 페이지 나누기에 CEIL() 사용 가능.
    SELECT CEIL(161/10)
        , ABS(-10), ABS(10) -- ABS() : 절댓값 구하는 함수.
        
    FROM dual;
    
    -- SIGN(n) 함수 : n의 값이 0보다 크면 1 / 0이면 0 / 0보다 작으면 -1 반환.
    SELECT SIGN(95) 양수
        , SIGN(0)
        , SIGN(-111) 음수
        , SIGN(3.14) 실수
    FROM dual;
    
    -- POWER(a,b) : a의b승 값 출력
    SELECT POWER(2,3) "a의 b승"
        , SQRT(2) "a의 제곱근 합"
    FROM dual;
    
    -- ㄷ. 날짜 함수 : SYSDATE / ROUND / TRUNC 
    
    -- [반올림 ROUND()]
   SELECT SYSDATE "SYSDATE"-- 현재의 날짜+시간(초)를 리턴하는 함수
        , ROUND(SYSDATE) "ROUND" -- 정오 기준으로 날짜가 반올림 됨.
        , ROUND(SYSDATE, 'YEAR') A -- 1년의 반이 지났는지?
        , ROUND(SYSDATE, 'DD') B -- 기본이 DD임
        , ROUND(SYSDATE, 'MONTH') C -- 15일을 기준으로 반올림.
        , ROUND(SYSDATE, 'CC') D -- 한 세기
   FROM dual;
   
   -- [절삭 TRUNC()]
   SELECT SYSDATE
        , TO_CHAR(SYSDATE,'DS TS') a
        , TRUNC(SYSDATE) b
        , TO_CHAR(TRUNC(SYSDATE),'DS TS') c -- 0시 0분 0초로 절삭.
        , TO_CHAR(TRUNC(SYSDATE, 'DD'),'DS TS') d -- ""
        , TRUNC(SYSDATE, 'MONTH') f -- 달에서 절삭, MM
        , TRUNC(SYSDATE, 'YEAR') g -- 년에서 절삭, YY
        , TRUNC(SYSDATE, 'MM')
   FROM DUAL;
    
    
    -- [날짜]에 [산술연산자]를 사용하는 경우
    
    SELECT SYSDATE
         , SYSDATE +7 "휴일"
         , SYSDATE -7 "1일"
         , SYSDATE - 2/24 "시간"
         , SYSDATE - SYSDATE - 13
    FROM dual;
    
    -- 입사후 근무일수?
    SELECT ename, hiredate
         , CEIL(SYSDATE - hiredate)+1 "근무일수"
    FROM emp;
    
    -- 개강후 지난일수?
    SELECT ename, '2024/07/01'
         , TRUNC (SYSDATE) - TRUNC (TO_DATE('2024/07/01')) + 1 "지난일수"
    FROM emp;
    
    -- [MONTHS_BETWEEN()] 두 날짜의 날짜차를 구하는 함수
    
    
    SELECT ename, hiredate, SYSDATE
         , MONTHS_BETWEEN( SYSDATE, hiredate ) 근무개월수
         , MONTHS_BETWEEN( SYSDATE, hiredate ) / 12 근무년수
    FROM emp;
    
    -- [ADD_MONTHS()] : 한달 증가
    SELECT SYSDATE
         , ADD_MONTHS(SYSDATE, 1)   "1달증가"
         , ADD_MONTHS(SYSDATE, -1)   "1달전"
         , ADD_MONTHS(SYSDATE, 12)  "1년증가"
         , ADD_MONTHS(SYSDATE, -12)  "1년전"
    FROM dual;
    
    -- [LAST_DAY()] : 그 달의 마지막 날
    
    SELECT SYSDATE
         , LAST_DAY(SYSDATE) "이번달의 마지막일"
         , to_CHAR(LAST_DAY(SYSDATE), 'DD') "마지막 일 추출"
         , TRUNC(SYSDATE, 'MONTH') "이번달의 첫날"
         , TO_CHAR(TRUNC(SYSDATE, 'MONTH'), 'DAY') "요일?"
         , ADD_MONTHS(TRUNC(SYSDATE, 'MONTH'), 1) 
    FROM dual;
    
    -- [NEXT_DAY()] : 돌아오는 요일의 날짜
    SELECT SYSDATE
         , NEXT_DAY(SYSDATE, '월')
         , NEXT_DAY(SYSDATE, '금') +7 -- 다다음주라면?
    FROM dual;
    
    -- 10월 첫번째 월요일이 휴강이라면?
    
    SELECT SYSDATE
        , NEXT_DAY(ADD_MONTHS(TRUNC(SYSDATE, 'MONTH'),2),'월')
        , NEXT_DAY(TO_DATE('24/10/01'),'월') 
    FROM dual;
    
    --
    
    SELECT SYSDATE, CURRENT_DATE
         , CURRENT_TIMESTAMP
    FROM dual;
    
    -- ㄹ. 변환 함수 : TO_DATE, TO_CHAR, TO_NUMBER
    
    SELECT '1234'
         , TO_NUMBER('1234')
    FROM dual;
    
    
    -- TO_CHAR(NUMBER) / TO_CHAR(CHAR) / TO_CHAR(DATE) :문자로 변환하는 함수
    
    SELECT NUM, NAME
         , BASICPAY, SUDANG
         , BASICPAY + SUDANG "PAY"
         , TO_CHAR(BASICPAY + SUDANG, '9G999G999D00') "PAY"
         , TO_CHAR(BASICPAY + SUDANG, 'L9,999,999') "PAY" -- L : $
    FROM INSA;
    
    SELECT
         TO_CHAR(100, 'S9999')
         , TO_CHAR(-100, 'S9999')
         , TO_CHAR(100, '9999MI')
         , TO_CHAR(-100, '9999MI')
         , TO_CHAR(-100, '9999PR') -- 음수일 경우 <>묶어 출력
    FROM DUAL;
    
    SELECT ENAME, TO_CHAR((SAL+NVL(COMM,0))*12, 'L999G999G999') PAY -- 연봉
    FROM EMP;
    
    --
    
    
    SELECT NAME, IBSADATE
         , TO_CHAR(IBSADATE, 'YYYY''MM''DD')
         , TO_CHAR(IBSADATE, 'YYYY"년" MM"월" DD"일" DAY') -- "문자열"
         
    FROM INSA;
    
    
    SELECT ENAME, sal, comm
         , SAL + NVL(COMM,0) PAY
         , SAL + NVL2(COMM,COMM,0) PAY
         , COALESCE(sal+comm,sal,0) P -- null이 아닐 경우 그 값을 리턴한다.
    FROM EMP;
    
    -- DECODE 함수 *********
    -- IF문과 같다.
    -- FROM절 외에 모두 사용 가능
    -- 비교 연산은 = 만 가능하다.
    -- DECODE함수의 확장함수 : CASE
    
    SELECT NAME, SSN
        -- , NVL2(NULLIF(MOD(SUBSTR(ssn,-7,1),2),1), '여','남' ) g
          ,DECODE(SUBSTR(ssn,-7,1),1,'남',2,'여') gender
          ,DECODE(MOD(SUBSTR(ssn,-7,1),2),0,'여','남') -- 왜 0이 들어가나?
    FROM INSA;
    
    -- 문제) emp 테이블에서 sal의 10% 인상을 하자.
    SELECT ename,sal+(sal*0.1) sal
         , sal *1.1 sal
    FROM emp;
    
    -- 문제) emp테이블에서 10번 부서원은 15% pay 인상, 20번 부서원은 10% 인상, 그 외 부서원은 20% 인상.
    SELECT deptno, ename, NVL(comm,0) comm, sal, sal+NVL(comm,0) pay
         , DECODE( deptno,10,(sal+NVL(comm,0))*1.15
                        , 20, (sal+NVL(comm,0))*1.1
                        , (sal+NVL(comm,0))*1.2 ) "급여인상"
                        
        ,(sal+NVL(comm,0)) * DECODE( deptno,10,1.15
                        , 20,1.1,1.2 ) -- 함수 앞에 값을 곱할 수 있는 원리가 뭔지?
    FROM emp;
    
    -- CASE 함수 *********
    
    CASE 컬럼명|표현식 WHEN 조건1 THEN 결과1
          [WHEN 조건2 THEN 결과2
                            ......
           WHEN 조건n THEN 결과n
          ELSE 결과4]
	END


    SELECT NAME, SSN
          ,DECODE(MOD(SUBSTR(ssn,-7,1),2),0,'여','남') 
          ,CASE MOD(SUBSTR(ssn,-7,1),2) WHEN 1 THEN '남자'
                                        -- WHEN 0 THEN '여'이것도 가능
                                        ELSE '여자'
          END gender
    FROM INSA; 
  
  ------  
    
       SELECT deptno, ename, NVL(comm,0) comm, sal, sal+NVL(comm,0) pay
         , DECODE( deptno,10,(sal+NVL(comm,0))*1.15
                        , 20, (sal+NVL(comm,0))*1.1
                        , (sal+NVL(comm,0))*1.2 ) "급여인상"
        ,CASE deptno WHEN 10 THEN (sal+NVL(comm,0))*1.15
                    WHEN 20 THEN (sal+NVL(comm,0))*1.1
                    ELSE (sal+NVL(comm,0))*1.2 
        END "인상페이"
    FROM emp;
    
    -- ㅁ. 일반 함수

-- 2) 복수행 함수 (그룹 함수)
-- 집계함수 : 집계함수 안의 요소는 중복으로 쓰지 못한다.
    -- null을 무시하기 때문에, null을 바꿔주는 작업 해야함.
    SELECT COUNT(*),COUNT(ename), COUNT(comm), COUNT(sal)
         -- , sal
         , SUM(sal)
         , SUM(comm)/COUNT(*) "AVG comm"
         , AVG(comm) -- null은 평균에서 자동으로 빼버림 -> 나누기 4 한거임.
         , MAX(sal)
         , MIN(sal)
    FROM emp;
    
    
    -- 각 부서별 사원수 조회 : 같은 부서수를 합해서 각 부서인원을 조회
    
    
    SELECT COUNT(deptno)
            , SUM(deptno)
            -- , DECODE(deptno,10, SUM(),20,30)
            
    FROM emp
    WHERE deptno LIKE '10' = SUM();
    
    SELECT COUNT(deptno)
    FROM emp
    WHERE deptno = 10
    UNION ALL
    SELECT COUNT(deptno)
    FROM emp
    WHERE deptno = 20
    UNION ALL
    SELECT COUNT(deptno)
    FROM emp
    WHERE deptno = 30;
    
    SELECT deptno
         , CASE deptno WHEN 10 THEN a
                    WHEN 20 THEN b
                    c
         END
    FROM emp;






    
    
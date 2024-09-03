
-- [ 인덱스 ] B-TREE 에 대해 이해해보자.

--1. 데이터베이스의 물리적 저장
--ㄱ. 테이블 생성 후 INSERT문으로 데이터 저장 시, DBMS는 어디에 저장될까.

--ㄴ. 질의처리과정
    1. 사용자 -> 2. SQL툴로 SQL 작성 -> 3. DBMS에 의해 처리방법 결정 
    -> 4. OS의 각 장치(하드디스크등 물리적저장..) 작업 처리 
    -> 5. 최종적으로 OS의 파일 시스템에 데이터베이스 파일로 보조기억장치(HDD,SDD)에 저장됨.
    
--ㄷ. 하드디스크는 원형 플레이트로 구성됨 / 플레이트는 논리적으로 트랙으로 나뉨 -> 트랙은 섹터로 나뉨
    엑세스(디스크 입출력) 시간 = 탐색시간 + 회전지연시간 + 데이터전송시간    
    -> DBMS가 하드디스크에 데이터를 저장하고 읽어올 때는 속도 문제 발생함(1000배는 느림!)
    -> 느리니까~ 자주 사용하는 데이터는 DB 버퍼캐시로 만들어 저장해둠.
    SGA(system global area)에 저장한다.
    
--    [ 오라클의 주요 파일 ]
    1) 데이터파일 
    2) 온라인 리두 로그 - 변경사항 모두 기록.
    3) 컨트롤 파일
    
    4) 오라클은 논리적 저장 영역을 구분하여 사용함.
        블록(8kb) < 익스텐트(블록 x 8) < 세그먼트 < 테이블스페이스(익스텐트 x 16)
        오라클은 저장 시 공간 부족하면 -> 익스텐트 단위로 공간 저장함.
    
--    [ 인덱스와 B-Tree ]
    1) 인덱스(index, 색인) : 자료를 쉽고 빠르게 찾을 수 있도록 만든 데이터 구조.
    2) 도서관에서 책의 위치를 쉽게 찾도록 만든 것 = 인덱스!
    3) 원하는 데이터를 빠르게 찾기 위해 위치값을 저장한 것.
        예) rowid
        select rowid, emp.*
        from emp;
    4) RDBMS의 인덱스는 대부분 B-Tree 구조이다.
    
    루트 노드 -> 내부 노드 -> 리프 노드
    - 검색 속도가 무지 빠름. 절반으로 갈라서, 또 절반으로 가르는 식으로 검색하기 때문. (Tree구조)
    
--    [ 인덱스의 특징 ]
    1) 인덱스는 테이블에서 한 개 이상의 속성을 이용하여 생성한다.
    2) 빠른 검색, 효율적인 레코드 접근이 가능하다.
    3) 테이블보다 적은 공간을 차지한다.
    4) 저장된 값들은 테이블의 부분집합이 된다.
    5) 일반적으로 B-Tree 구조임.
    6) 데이터의 수정, 삭제등 변경이 있으면 인덱스의 재구성이 필요.
    7) 단일컬럼, 복합컬럼 인덱스가 존재함.
    8) 범위검색은 성능이 떨어짐. 군데군데 저장되어있기 때문.
    9) 인덱스는 테이블 당 여러 개를 만들 수 있음.
    
    [ 오라클의 인덱스 종류 ]
    1) B-Tree 인덱스
    2) IOT 인덱스
    3) 비트맵 인덱스
    
    
select *
from emp
where empno = '7369'; -- F10 누르면 실행계획이 뜬다! 풀스캔, 래인지스캔 등.
--
select *
from emp
where ename = 'SMITH';
--
select *
from emp
where SUBSTR(empno, 0, 2) = 76; -- 0.011초  full scan (가공하면 index 안 걸림!!)
where empno = 7369; -- 0.013초  index (usique scan)
where deptno = 30 and sal > 1300;   -- 0.011초, full scan (인덱스 생성 전)
                                    -- 0.014초 , range scan (인덱스 생성 후 F10 결과)
where empno > 7600;
--
create index DS_EMP ON emp (deptno, sal); 
-- Index DS_EMP이(가) 생성되었습니다.
ALTER~
DROP INDEX DS_EMP;
-- Index DS_EMP이(가) 삭제되었습니다.


-- 인덱스 조회    
select *
from user_indexes
where table_name = 'EMP';



---------------------------
-- 등급별로 
SELECT s.grade, e.deptno, e.empno, e.job, e.ename, e.sal+NVL(e.comm,0) pay
FROM
(
    SELECT grade, count(*)
    FROM emp e 
    JOIN salgrade s ON e.sal BETWEEN s.losal AND s.hisal
    group by grade
    ORDER BY grade
) a
JOIN salgrade s ON a.sal BETWEEN s.losal and s.hisal
group by s.grade,e.deptno, e.empno, e.job, e.ename, e.sal+NVL(e.comm,0);
----

SELECT grade, count(*)
FROM emp e 
JOIN salgrade s ON e.sal BETWEEN s.losal AND s.hisal
group by grade
ORDER BY grade;

select grade, s.losal, s.hisal, count(*) cnt
from salgrade a join emp e on sal BETWEEN losal AND hisal
group by grade, s.losal, s.hisal
ORDER BY grade;


SELECT grade, deptno, empno, job, ename, e.sal+NVL(comm,0) pay
FROM emp e 
JOIN salgrade s ON e.sal BETWEEN s.losal AND s.hisal
WHERE grade IN (
    SELECT grade
    FROM emp e
    JOIN salgrade s ON e.sal BETWEEN s.losal AND s.hisal
    group by grade
    HAVING COUNT(*) >0

)
ORDER BY grade, empno;






select count(grade)
from FROM emp e JOIN dept d ON e.deptno = d.deptno 
JOIN salgrade s ON e.sal BETWEEN s.losal AND s.hisal;



SELECT grade, deptno, empno, job, ename, sal
FROM 
JOIN  ON
JOIN  ON



SELECT 
FROM
WHERE
GROUP BY


/*
[실행결과]
1등급   (     700~1200 ) - 2명                        key
      20   RESEARCH   7369   SMITH   800               value
      30   SALES         7900   JAMES   950
2등급   (   1201~1400 ) - 2명
   30   SALES   7654   MARTIN   2650
   30   SALES   7521   WARD      1750   
3등급   (   1401~2000 ) - 2명
   30   SALES   7499   ALLEN      1900
   30   SALES   7844   TURNER   1500
4등급   (   2001~3000 ) - 4명
    10   ACCOUNTING   7782   CLARK   2450
   20   RESEARCH   7902   FORD   3000
   20   RESEARCH   7566   JONES   2975
   30   SALES   7698   BLAKE   2850
5등급   (   3001~9999 ) - 1명   
   10   ACCOUNTING   7839   KING   5000
*/      
/*
[실행결과]
1등급   (     700~1200 ) - 2명                        key
      20   RESEARCH   7369   SMITH   800               value
      30   SALES         7900   JAMES   950
2등급   (   1201~1400 ) - 2명
   30   SALES   7654   MARTIN   2650
   30   SALES   7521   WARD      1750   
3등급   (   1401~2000 ) - 2명
   30   SALES   7499   ALLEN      1900
   30   SALES   7844   TURNER   1500
4등급   (   2001~3000 ) - 4명
    10   ACCOUNTING   7782   CLARK   2450
   20   RESEARCH   7902   FORD   3000
   20   RESEARCH   7566   JONES   2975
   30   SALES   7698   BLAKE   2850
5등급   (   3001~9999 ) - 1명   
   10   ACCOUNTING   7839   KING   5000
*/      

    
select d.deptno, dname, empno, ename, sal
from dept d 
right join emp e on d.deptno = e.deptno
join salgrade s on sal between losal and hisal
where grade = 3;


select d.deptno, dname, empno, ename, sal 
from dept d right join emp e on d.deptno = e.deptno 
join salgrade s on sal between losal and hisal 
where grade =5;


SELECT *
FROM emp;
FROM dept;

select *
from dept
where deptno = 50;

UPDATE dept
SET dname = DEFAULT
WHERE dname =%s














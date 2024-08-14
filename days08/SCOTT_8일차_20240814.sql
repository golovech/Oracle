-- [ 수업 끝난 테이블 상황 ]
-- TBL_BONUS, TBL_EMP 있는 상태
--  ㄴ ID, BONUS   ㄴ ID, NAME, SALARY, BONUS



-- 1) 게시판 테이블 생성
-- 2) 컬럼 : 글번호, 작성자, 비밀번호, 제목, 내용, 작성일, 조회수


-- CREATE [GLOBAL TEMPORARY] TABLE : 임시테이블(로그아웃하면 사라지는 테이블)
--    [ 형식 ]
--    CREATE [GLOBAL TEMPORARY] TABLE [schema.] table
--          ( 
--            열이름  데이터타입 [DEFAULT 표현식] [제약조건] 
--           [,열이름  데이터타입 [DEFAULT 표현식] [제약조건] ] 
--           [,...]  
--          ); 

CREATE  TABLE SCOTT.TBL_BOARD -- [GLOVAL TEMPRARY]
        (
          SEQ NUMBER (38) NOT NULL PRIMARY KEY -- 글번호로 게시글을 구분한다. 다른컬럼은 중복가능하니까...
        , WRITER VARCHAR2 (20) NOT NULL
        , PASSWORD VARCHAR2 (20) NOT NULL
        , TITLE VARCHAR2 (100) NOT NULL
        , CONTENT CLOB
        , REGDATE DATE DEFAULT SYSDATE
        );

-- Table SCOTT.TBL_BOARD이(가) 생성되었습니다.


-- 시퀀스 생성하기 * SEQ(글번호)의 시퀀스 생성
CREATE SEQUENCE SEQ_TBLBOARD
        NOCACHE;
--        INCREMENT BY 1 -- 1식 증가하겠다.
--        START WITH 1 -- 1부터 시작하겠다.
--        MINVALUE 10 -- 다시 돌아올 때 10부터 돌아오겠다.

-- 테이블 시퀀스 조회
SELECT *
FROM USER_SEQUENCES;
-- 테이블 이름 조회
SELECT *
FROM TABS
WHERE REGEXP_LIKE(TABLE_NAME, '^TBL_B');
-- DDL문
CREATE TABLE
ALTER TABLE
DROP TABEL TBL_BORAD CASCADE; -- 테이블 삭제 


-- 게시글 작성 쿼리
-- 작성자, 내용, 글쓰기버튼, 취소버튼

DESC TBL_BOARD;


INSERT INTO TBL_BOARD (SEQ, WRITER, PASSWORD, TITLE, CONTENT) VALUES ( SEQ_TBLBOARD.NEXTVAL,'최사랑','1234','TENT-1','TEST-1');

INSERT INTO tbl_board (SEQ, WRITER, PASSWORD, TITLE, CONTENT)
VALUES ( seq_tblboard.NEXTVAL , '이시훈', '1234', 'TEST-2', 'TEST-2');


--
SELECT *
FROM TBL_BOARD;
--
COMMIT;
--
SELECT SEQ, SUBJECT, WRITER, TO_CHAR(REGDATE,'YYYY-MM-DD') REGDATE, READED, LASTREGDATE
FROM TBL_BOARD
ORDER BY SEQ DESC;
--

-- ORA-02289: sequence does not exist : 처음에는 CURRVAL 사용 못한다. 현재는 0개에서 시작하니까...

-- 테이블의 제약조건 확인

-- SEQ IN PK : P
-- SEQ    NN : C
--           : R 
-- P : PRIMARY KEY / C : NOTNULL / R : 래퍼런스(참조키)

SELECT *
FROM USER_CONSTRAINTS
WHERE TABLE_NAME = UPPER('TBL_BOARD'); 
-- SYS_~~~ 제약조건 이름 자동 부여됨.


-- 조회수 칼럼 추가
ALTER TABLE TBL_BOARD
ADD READED NUMBER(38) DEFAULT 0;
-- Table TBL_BOARD이(가) 변경되었습니다.


-- 1) 조회수 1 증가(클릭) // 게시글 상세보기 하면 일어나는 일. 쿼리로~
UPDATE TBL_BOARD
SET READED = READED+1
WHERE SEQ = 2;
-- 2) 게시글(SEQ)의 정보를 조회
SELECT *
FROM TBL_BOARD
WHERE SEQ = 2;

-- 게시판의 작성자(WRITER) 칼럼 15 -> 40 SIZE 확장시키려면? (컬럼 자료형 크기 수정)
-- 주의 : 제약조건은 수정할 수 없다. // 변경시, 제약조건 삭제하고 새로 생성해야함
ALTER TABLE TBL_BOARD
MODIFY WRITER VARCHAR2 (40);
-- Table TBL_BOARD이(가) 변경되었습니다.

-- TITLE 칼럼명을 SUBJECT로 수정?
-- 1) 알리야스 사용
-- 2) 수정쿼리
ALTER TABLE TBL_BOARD
RENAME COLUMN TITLE TO SUBJECT;
--
DESC TBL_BOARD;
-- 수정할 때의 날짜 정보 저장할 컬럼 추가. LastREGDATE // -> 수정한 날짜 데이터 저장할 테이블!! 추가해야함.
ALTER TABLE TBL_BOARD
ADD LASTREGDATE DATE;

--
UPDATE TBL_BOARD
SET SUBJECT = '제목수정-3', CONTENT = '내용수정-3', LASTREGDATE = SYSDATE
WHERE SEQ = 3;
COMMIT;
--
SELECT *
FROM TBL_MYBOARD;
-- LASTREGDATE 삭제
ALTER TABLE TBL_BOARD
DROP COLUMN LASTREGDATE ;
-- TBL_BOARD -> TBL_MYBOARD 로 테이블명 수정
RENAME TBL_BOARD TO TBL_MYBOARD;

-- [ 테이블 생성 방법 ]
-- 1. CREATE TABLE 쿼리
-- 2. SUBQUERY 를 이용한 테이블 생성
--  - 기존에 이미 존재하는 테이블을 이용 -> 새로운 테이블을 생성 (+ 레코드(데이터) 추가생성 가능)
--  - CREATE TABLE 테이블명 [컬럼명, ...]
--  - AS (서브쿼리) // 테이블 안의 컬럼명 수와 서브쿼리 안의 컬럼명 수 가 같아야 함 // 서브쿼리 컬럼명으로 테이블이 만들어짐.

-- 예) EMP 테이블 - 30번 사원들만 새로운 테이블 생성?
CREATE TABLE TBL_EMP30 ( ENO, ENAME, HIREDATE, JOB, PAY ) 
    AS (
        SELECT EMPNO, ENAME, HIREDATE, JOB, SAL+NVL(COMM,0) PAY
        FROM EMP
        WHERE DEPTNO = 30
        );
-- Table TBL_EMP30이(가) 생성되었습니다.
DESC TBL_EMP30;
-- EMP 제약조건 확인?
-- 제약조건은 복사가 안된다.
SELECT *
FROM USER_CONSTRAINTS
WHERE TABLE_NAME IN ('EMP','TBL_EMP30');
-- EMP -> 새로운 테이블 생성 + 데이터 복사 X
DROP TABLE TBL_EMP30 ; -- 테이블삭제

-- 데이터 복사하고 싶지 않을때는? // 테이블 구조만 복사하고 데이터는 필요없을 때. WHERE 1 = 0은 항상 거짓이므로...
CREATE TABLE TBL_EMPCOPY
AS
(
    SELECT *
    FROM EMP
    WHERE 1 = 0
);
SELECT *
FROM TBL_EMPCOPY;
DROP TABLE TBL_EMPCOPY;
-- 테이블 전부 삭제
DROP TABLE TBL_CHAR;
DROP TABLE TBL_TEL;
DROP TABLE TBL_LOVE;
DROP TABLE TBL_MYBOARD;
DROP TABLE TBL_NCHAR;
DROP TABLE TBL_NUMBER;
DROP TABLE TBL_PIVOT;
DROP TABLE TBL_SAMPLE;

-- SQL 확장 -> PL/SQL

-- [문제] 
-- emp, dept , SALGRADE 테이블을 이용해서 deptno, dname, empno, ename, hiredate, pay, grade 컬럼을
-- 가진 새로운 테이블 생성 (tbl_empgrade)
-- 이렇게도 할수있다. 3개 쪼인
--SELECT T.DEPTNO, T.DNAME, T.EMPNO, T.ENAME, T.HIREDATE, T.PAY, S.GRADE
--FROM (
--    SELECT D.DEPTNO, DNAME, EMPNO, ENAME, HIREDATE, SAL+NVL(COMM,0) PAY, SAL
--    FROM EMP E
--    JOIN DEPT D
--    ON D.DEPTNO = E.DEPTNO 
--    )T, SALGRADE S
--WHERE T.SAL BETWEEN S.LOSAL AND S.HISAL;

-- 테이블 3개 JOIN
CREATE TABLE TBL_EMPGRADE
AS(
SELECT D.DEPTNO, DNAME, EMPNO, ENAME, HIREDATE, SAL+NVL(COMM,0) PAY, GRADE -- 양쪽 테이블에 다 있는 칼럼만 D.을 붙이면 됨
FROM EMP E, DEPT D, SALGRADE S
WHERE D.DEPTNO = E.DEPTNO AND E.SAL BETWEEN S.LOSAL AND S.HISAL
); 
--
SELECT *
FROM TBL_EMPGRADE;
--
DROP TABLE TBL_EMPGRADE; -- 정식버전에서는 삭제해도 휴지통으로 이동함
PURGE RECYCLEBIN; -- 휴지통 비우기
DROP TABLE TBL_EMPGRADE PURGE; -- 완전삭제

-- JON ON 구문으로 수정.

CREATE TABLE TBL_EMPGRADE
AS(
    SELECT D.DEPTNO, D.DNAME, EMPNO,ENAME, HIREDATE, SAL+NVL(COMM,0) PAY, S.LOSAL || '~' || S.HISAL SAL_RANGE, GRADE -- 양쪽 테이블에 다 있는 칼럼만 D.을 붙이면 됨
    FROM EMP E
         JOIN DEPT D 
         ON D.DEPTNO = E.DEPTNO
         JOIN SALGRADE S 
         ON E.SAL BETWEEN S.LOSAL AND S.HISAL
        
    );

-- EMP 테이블의 구조만 복사, 새로운 TBL_EMP테이블 생성
CREATE TABLE TBL_EMP
AS
(
    SELECT *
    FROM EMP
    WHERE 1=0

);
--
SELECT *
FROM TBL_EMP;
-- 10번 부서원을 INSERT?
-- 1. INSERT INTO TBL_EMP (EMPNO, ENAME, HIREDATE) VALUES ();
INSERT INTO TBL_EMP SELECT * FROM EMP WHERE DEPTNO = 10;
COMMIT;

-- 1) DIRECT LOAD INSERT에 의한 ROW 삽입 
INSERT INTO TBL_EMP (EMPNO, ENAME) SELECT EMPNO, ENAME FROM EMP WHERE DEPTNO = 20;

DROP TABLE tbl_empgrade;

-- [ 다중 insert문 4가지 ]
-- 1) unconditional insert all
CREATE TABLE tbl_emp10 AS(SELECT * FROM emp WHERE 1 = 0);
CREATE TABLE tbl_emp20 AS(SELECT * FROM emp WHERE 1 = 0);
CREATE TABLE tbl_emp30 AS(SELECT * FROM emp WHERE 1 = 0);
CREATE TABLE tbl_emp40 AS(SELECT * FROM emp WHERE 1 = 0);
--
INSERT INTO tbl_emp10 SELECT * FROM emp;
INSERT INTO tbl_emp20 SELECT * FROM emp;
INSERT INTO tbl_emp30 SELECT * FROM emp;
INSERT INTO tbl_emp40 SELECT * FROM emp;
--
SELECT * FROM tbl_emp30;
ROLLBACK;

-- 위의 커리(insert) 4개를 한번에 처리하려면? -> unconditional insert all문 사용 => 조건없이 전부 들어감
INSERT ALL 
    INTO tbl_emp10 VALUES ( empno, ename, job, mgr, hiredate, sal, comm, deptno )
    INTO tbl_emp20 VALUES ( empno, ename, job, mgr, hiredate, sal, comm, deptno )
    INTO tbl_emp30 VALUES ( empno, ename, job, mgr, hiredate, sal, comm, deptno )
    INTO tbl_emp40 VALUES ( empno, ename, job, mgr, hiredate, sal, comm, deptno )
SELECT *
FROM emp;

-- 2) Conditional INSERT ALL : 조건이 있는 INSERT ALL문 => 조건에 맞는 요소만 들어감.
INSERT ALL 
    WHEN deptno = 10 THEN 
        INTO tbl_emp10 VALUES ( empno, ename, job, mgr, hiredate, sal, comm, deptno )
    WHEN deptno = 20 THEN
        INTO tbl_emp20 VALUES ( empno, ename, job, mgr, hiredate, sal, comm, deptno )
    WHEN deptno = 30 THEN
        INTO tbl_emp30 VALUES ( empno, ename, job, mgr, hiredate, sal, comm, deptno )
    ELSE
        INTO tbl_emp40 VALUES ( empno, ename, job, mgr, hiredate, sal, comm, deptno )
SELECT *
FROM emp;

-- 3) conditional first insert : 조건을 만족하는 첫번째 쿼리에만 들어감 / 나머지가 같더라도./ ALL과 FIRST여부만 다름
INSERT FIRST
    WHEN deptno = 10 THEN 
        INTO tbl_emp10 VALUES ( empno, ename, job, mgr, hiredate, sal, comm, deptno )
    WHEN sal >= 2500 THEN
        INTO tbl_emp20 VALUES ( empno, ename, job, mgr, hiredate, sal, comm, deptno )
    WHEN deptno = 30 THEN
        INTO tbl_emp30 VALUES ( empno, ename, job, mgr, hiredate, sal, comm, deptno )
    ELSE
        INTO tbl_emp40 VALUES ( empno, ename, job, mgr, hiredate, sal, comm, deptno )
SELECT *
FROM emp;


-- 4) Pivoting insert
CREATE table tbl_sales(
  employee_id        number(6),
  week_id            number(2),
  sales_mon          number(8,2),
  sales_tue          number(8,2),
  sales_wed          number(8,2),
  sales_thu          number(8,2),
  sales_fri          number(8,2));
--
DESC tbl_sales;
--
INSERT INTO tbl_sales VALUES(1101,4,100,150,80,60,120);
INSERT INTO tbl_sales VALUES(1102,5,300,300,230,120,150);
--
commit;
-- 조회
SELECT *
FROM tbl_sales;
-- 
CREATE TABLE tbl_salesdata(
  employee_id        number(6),
  week_id            number(2),
  sales              number(8,2));
-- 출력을 세로로 바꿈
INSERT ALL
  INTO tbl_salesdata VALUES(employee_id, week_id, sales_mon)
  INTO tbl_salesdata VALUES(employee_id, week_id, sales_tue)
  INTO tbl_salesdata VALUES(employee_id, week_id, sales_wed)
  INTO tbl_salesdata VALUES(employee_id, week_id, sales_thu)
  INTO tbl_salesdata VALUES(employee_id, week_id, sales_fri)
  SELECT employee_id, week_id, sales_mon, sales_tue, sales_wed,
         sales_thu, sales_fri
  from tbl_sales;
-- 확인
SELECT *
FROM tbl_salesdata;


-- tbl 삭제
DROP TABLE tbl_emp10;
DROP TABLE tbl_emp20;
DROP TABLE tbl_emp30;
DROP TABLE tbl_emp40;
DROP TABLE tbl_sales;
DROP TABLE tbl_salesdata;

-- DELECT 문, DROP TABLE 문, TRUNCATE문 차이점?
-- DELECT (DML) : 레코드 삭제
-- DROP TABLE (DDL) : 테이블 삭제
-- TRUNCATE (DML) : 레코드 모두 삭제

TRUNCATE TABLE FROM 테이블명;  
-- 자동커밋(롤백 불가능)

DELETE FROM 테이블명;   -- 커밋 / 롤백 필수
-- ㄴ WHERE 조건절이 없으면 모든 레코드 삭제


-- 문제) INSA 테이블에서 num, name 칼럼만을 복사해서 새로운 테이블 tbl_score 생성
CREATE TABLE tbl_score
    AS
    (
        SELECT num, name
        FROM insa
        WHERE num <= 1005
       );
--
DESC tbl_score;
SELECT *
FROM tbl_score;

-- 문제) tbl_score테이블에 kor, eng, mat, tot, avg, grade(수 자료형), rank 컬럼 추가
ALTER TABLE tbl_score
ADD (
         kor number(3) DEFAULT 0
        ,eng number(3) DEFAULT 0
        ,mat number(3) DEFAULT 0
        ,tot number(3) DEFAULT 0
        ,avg number(5,2) DEFAULT 0
        ,grade char(3)
        ,rank number(3)
        );
--
DESC tbl_score;

-- 문제) 1001~1005 모든학생의 국영수 점수를 임의의 정수를 발생시켜서 수정
SELECT *
FROM tbl_score;

UPDATE tbl_score
SET   kor = ROUND(SYS.DBMS_RANDOM.VALUE(0,101))
    , eng = ROUND(SYS.DBMS_RANDOM.VALUE(0,101))
    , mat = ROUND(SYS.DBMS_RANDOM.VALUE(0,101));
COMMIT;

-- 문제) 1005번 학생의 국영수 점수를 1001번 학생의 국영수 점수로 수정.
UPDATE tbl_score
SET (kor, eng, mat) = (SELECT kor,eng, mat FROM tbl_score WHERE num = 1001)
WHERE num = 1005;

COMMIT;
SELECT *
FROM tbl_score;

-- 문제) 모든 학생의 총점, 평균점수 업데이트
UPDATE tbl_score
SET tot = kor+eng+mat, avg = (kor+eng+mat)/3;

-- 문제) 모든 학생의 등수를 업데이트
-- 아래 더 풀어보기
UPDATE tbl_score
SET (SELECT sum, tot, avg, RANK () OVER (ORDER BY tot asc) FROM tbl_score);

-- 쌤 쿼리. 나중에 살펴볼 것
UPDATE tbl_score p
SET rank = (
               SELECT t.r
               FROM (
                   SELECT num, tot, RANK() OVER(ORDER BY tot DESC ) r
                   FROM tbl_score
               ) t
               WHERE t.num =p.num
           );

-- 문제) 등급 수정        avg 90점 이상 '수', 80점 이상 '우'~ '가'

UPDATE tbl_score
SET grade =    CASE WHEN avg >= 90 THEN '수'
                    WHEN avg >= 80 THEN '우'
                    WHEN avg >= 70 THEN '미'
                    WHEN avg >= 60 THEN '양'
                    ELSE '가'
                    end;
                            
-- 디코드도 가능. DECODE( FLOOR(avg/10),10,'수',9,'수',8,'우',7,'미',6,'양',5,'가' )

-- 이것도 가능.
--NSERT ALL
--    WHEN avg >= 90 THEN
--         INTO tbl_score (grade) VALUES( 'A' )
--    WHEN avg >= 80 THEN
--         INTO tbl_score (grade) VALUES( 'B' )
--    WHEN avg >= 70 THEN
--         INTO tbl_score (grade) VALUES( 'C' )
--    WHEN avg >= 60 THEN
--         INTO tbl_score (grade) VALUES( 'D' )
--    ELSE
--         INTO tbl_score (grade) VALUES( 'F' )
--SELECT avg FROM tbl_score ; 


-- 모든 학생의 영어점수를 40점 올린다. 100점 초과하면 안됨.
UPDATE tbl_score
SET eng = CASE WHEN eng <= 60 THEN eng + 40
             ELSE eng + (100 - eng)
             END;
                     
commit;

-- 문제) 남학생들만 국어점수를 5점 감소
-- 컬럼에 ssn 추가(조인). 0점 미만으로 안 떨어지게 함.
-- 내 풀이
UPDATE tbl_score
SET kor =  (SELECT i.ssn
            , CASE WHEN gender = '남' THEN kor - 5
              END
            , DECODE(MOD(SUBSTR(ssn,-7,1),2),1,'남',0,'여') gender
             FROM tbl_score t RIGHT JOIN insa i ON i.ssn = t.ssn
             );
------ 정답 ------     
     
UPDATE tbl_score
SET kor =  CASE WHEN kor -5 < 0 THEN 0
                ELSE kor -5
              END

WHERE num IN ( SELECT num 
                FROM insa 
                WHERE num <= 1005 AND MOD(SUBSTR(ssn,-7,1),2) = 1
                ) ;


-- 선생님 풀이
UPDATE tbl_score t
SET  kor = CASE  
              WHEN kor -5 < 0 THEN 0
              ELSE kor -5
           END
             
WHERE num IN (
                    SELECT num 
                    FROM insa
                    WHERE num <= 1005 AND MOD(SUBSTR(ssn,-7,1),2)=1
             );
            
where t.num = (
                select num 
                from insa 
                where MOD(substr(ssn,8,1), 2)=1 and t.num =num
            );           
            
WHERE num = ANY (
                    SELECT num 
                    FROM insa
                    WHERE num <= 1005 AND MOD(SUBSTR(ssn,-7,1),2)=1
             );     

-- 문제) result 칼럼 추가
--              합격, 불합격, 과락(1과목이 40점 미만 or 3과목 평균이 60점 미만이면 과락)

ALTER TABLE tbl_score
ADD result VARCHAR(10);
--
UPDATE tbl_score
SET result = CASE WHEN KOR < 40 or eng < 40 or mat < 40  THEN '과락'
                  WHEN avg < 60 THEN '불합격'
                  ELSE '합격'
                  end;
--
COMMIT;
SELECT *
FROM tbl_score;


----------------------------------------------------------------------------
-- [ MERGE ] : 분리되어있던 테이블 데이터를 -> 연말에 하나로 합치는 경우 사용.
--             컬럼(기타등등)이 있으면 -> UPDATE, 없으면 INSERT

DROP TABLE tbl_score PURGE;

create table tbl_emp(
  id number primary key, 
  name varchar2(10) not null,
  salary  number,
  bonus number default 100);
-- Table TBL_EMP이(가) 생성되었습니다.
  
insert into tbl_emp(id,name,salary) values(1001,'jijoe',150);
insert into tbl_emp(id,name,salary) values(1002,'cho',130);
insert into tbl_emp(id,name,salary) values(1003,'kim',140);
commit;

select * 
from tbl_emp;
--
create table tbl_bonus(id number, bonus number default 100);

insert into tbl_bonus(id)
(SELECT e.id from tbl_emp e);
INSERT INTO tbl_bonus VALUES( 1004, 50);
COMMIT;

SELECT *
FROM tbl_bonus;

--1001	100
--1002	100
--1003	100
--1004	50
-- merge
MERGE INTO tbl_bonus b
USING (SELECT id, salary FROM tbl_emp) e
ON (b.id = e.id)
WHEN MATCHED THEN
    UPDATE 
    SET b.bonus = b.bonus + e.salary * 0.01 
WHEN NOT MATCHED THEN
    INSERT (b.id, b.bonus) VALUES (e.id, e.salary * 0.01)
    ;


-- 아래는 실행하지 않기~~ 테이블 없음 그냥 적은거임
-- 이 구문 이해해보기~
MERGE INTO T1 T
USING T2 S
ON (T.EMPNO = S.EMPNO)
WHEN MATCHED THEN
UPDATE SET T.SAL = S.SAL -500
WHERE T.JOB = 'CLERK'
DELETE WHERE T.SAL < 2000
WHEN NOT MATCHED THEN 
INSERT (T.EMPNO,T.ENAME,T.JOB) VALUES (S.EMPNO,S.ENAME,S.JOB)
WHERE S.JOB = 'CLERK';







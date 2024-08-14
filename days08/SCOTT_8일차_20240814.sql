-- [ ���� ���� ���̺� ��Ȳ ]
-- TBL_BONUS, TBL_EMP �ִ� ����
--  �� ID, BONUS   �� ID, NAME, SALARY, BONUS



-- 1) �Խ��� ���̺� ����
-- 2) �÷� : �۹�ȣ, �ۼ���, ��й�ȣ, ����, ����, �ۼ���, ��ȸ��


-- CREATE [GLOBAL TEMPORARY] TABLE : �ӽ����̺�(�α׾ƿ��ϸ� ������� ���̺�)
--    [ ���� ]
--    CREATE [GLOBAL TEMPORARY] TABLE [schema.] table
--          ( 
--            ���̸�  ������Ÿ�� [DEFAULT ǥ����] [��������] 
--           [,���̸�  ������Ÿ�� [DEFAULT ǥ����] [��������] ] 
--           [,...]  
--          ); 

CREATE  TABLE SCOTT.TBL_BOARD -- [GLOVAL TEMPRARY]
        (
          SEQ NUMBER (38) NOT NULL PRIMARY KEY -- �۹�ȣ�� �Խñ��� �����Ѵ�. �ٸ��÷��� �ߺ������ϴϱ�...
        , WRITER VARCHAR2 (20) NOT NULL
        , PASSWORD VARCHAR2 (20) NOT NULL
        , TITLE VARCHAR2 (100) NOT NULL
        , CONTENT CLOB
        , REGDATE DATE DEFAULT SYSDATE
        );

-- Table SCOTT.TBL_BOARD��(��) �����Ǿ����ϴ�.


-- ������ �����ϱ� * SEQ(�۹�ȣ)�� ������ ����
CREATE SEQUENCE SEQ_TBLBOARD
        NOCACHE;
--        INCREMENT BY 1 -- 1�� �����ϰڴ�.
--        START WITH 1 -- 1���� �����ϰڴ�.
--        MINVALUE 10 -- �ٽ� ���ƿ� �� 10���� ���ƿ��ڴ�.

-- ���̺� ������ ��ȸ
SELECT *
FROM USER_SEQUENCES;
-- ���̺� �̸� ��ȸ
SELECT *
FROM TABS
WHERE REGEXP_LIKE(TABLE_NAME, '^TBL_B');
-- DDL��
CREATE TABLE
ALTER TABLE
DROP TABEL TBL_BORAD CASCADE; -- ���̺� ���� 


-- �Խñ� �ۼ� ����
-- �ۼ���, ����, �۾����ư, ��ҹ�ư

DESC TBL_BOARD;


INSERT INTO TBL_BOARD (SEQ, WRITER, PASSWORD, TITLE, CONTENT) VALUES ( SEQ_TBLBOARD.NEXTVAL,'�ֻ��','1234','TENT-1','TEST-1');

INSERT INTO tbl_board (SEQ, WRITER, PASSWORD, TITLE, CONTENT)
VALUES ( seq_tblboard.NEXTVAL , '�̽���', '1234', 'TEST-2', 'TEST-2');


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

-- ORA-02289: sequence does not exist : ó������ CURRVAL ��� ���Ѵ�. ����� 0������ �����ϴϱ�...

-- ���̺��� �������� Ȯ��

-- SEQ IN PK : P
-- SEQ    NN : C
--           : R 
-- P : PRIMARY KEY / C : NOTNULL / R : ���۷���(����Ű)

SELECT *
FROM USER_CONSTRAINTS
WHERE TABLE_NAME = UPPER('TBL_BOARD'); 
-- SYS_~~~ �������� �̸� �ڵ� �ο���.


-- ��ȸ�� Į�� �߰�
ALTER TABLE TBL_BOARD
ADD READED NUMBER(38) DEFAULT 0;
-- Table TBL_BOARD��(��) ����Ǿ����ϴ�.


-- 1) ��ȸ�� 1 ����(Ŭ��) // �Խñ� �󼼺��� �ϸ� �Ͼ�� ��. ������~
UPDATE TBL_BOARD
SET READED = READED+1
WHERE SEQ = 2;
-- 2) �Խñ�(SEQ)�� ������ ��ȸ
SELECT *
FROM TBL_BOARD
WHERE SEQ = 2;

-- �Խ����� �ۼ���(WRITER) Į�� 15 -> 40 SIZE Ȯ���Ű����? (�÷� �ڷ��� ũ�� ����)
-- ���� : ���������� ������ �� ����. // �����, �������� �����ϰ� ���� �����ؾ���
ALTER TABLE TBL_BOARD
MODIFY WRITER VARCHAR2 (40);
-- Table TBL_BOARD��(��) ����Ǿ����ϴ�.

-- TITLE Į������ SUBJECT�� ����?
-- 1) �˸��߽� ���
-- 2) ��������
ALTER TABLE TBL_BOARD
RENAME COLUMN TITLE TO SUBJECT;
--
DESC TBL_BOARD;
-- ������ ���� ��¥ ���� ������ �÷� �߰�. LastREGDATE // -> ������ ��¥ ������ ������ ���̺�!! �߰��ؾ���.
ALTER TABLE TBL_BOARD
ADD LASTREGDATE DATE;

--
UPDATE TBL_BOARD
SET SUBJECT = '�������-3', CONTENT = '�������-3', LASTREGDATE = SYSDATE
WHERE SEQ = 3;
COMMIT;
--
SELECT *
FROM TBL_MYBOARD;
-- LASTREGDATE ����
ALTER TABLE TBL_BOARD
DROP COLUMN LASTREGDATE ;
-- TBL_BOARD -> TBL_MYBOARD �� ���̺�� ����
RENAME TBL_BOARD TO TBL_MYBOARD;

-- [ ���̺� ���� ��� ]
-- 1. CREATE TABLE ����
-- 2. SUBQUERY �� �̿��� ���̺� ����
--  - ������ �̹� �����ϴ� ���̺��� �̿� -> ���ο� ���̺��� ���� (+ ���ڵ�(������) �߰����� ����)
--  - CREATE TABLE ���̺�� [�÷���, ...]
--  - AS (��������) // ���̺� ���� �÷��� ���� �������� ���� �÷��� �� �� ���ƾ� �� // �������� �÷������� ���̺��� �������.

-- ��) EMP ���̺� - 30�� ����鸸 ���ο� ���̺� ����?
CREATE TABLE TBL_EMP30 ( ENO, ENAME, HIREDATE, JOB, PAY ) 
    AS (
        SELECT EMPNO, ENAME, HIREDATE, JOB, SAL+NVL(COMM,0) PAY
        FROM EMP
        WHERE DEPTNO = 30
        );
-- Table TBL_EMP30��(��) �����Ǿ����ϴ�.
DESC TBL_EMP30;
-- EMP �������� Ȯ��?
-- ���������� ���簡 �ȵȴ�.
SELECT *
FROM USER_CONSTRAINTS
WHERE TABLE_NAME IN ('EMP','TBL_EMP30');
-- EMP -> ���ο� ���̺� ���� + ������ ���� X
DROP TABLE TBL_EMP30 ; -- ���̺����

-- ������ �����ϰ� ���� ��������? // ���̺� ������ �����ϰ� �����ʹ� �ʿ���� ��. WHERE 1 = 0�� �׻� �����̹Ƿ�...
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
-- ���̺� ���� ����
DROP TABLE TBL_CHAR;
DROP TABLE TBL_TEL;
DROP TABLE TBL_LOVE;
DROP TABLE TBL_MYBOARD;
DROP TABLE TBL_NCHAR;
DROP TABLE TBL_NUMBER;
DROP TABLE TBL_PIVOT;
DROP TABLE TBL_SAMPLE;

-- SQL Ȯ�� -> PL/SQL

-- [����] 
-- emp, dept , SALGRADE ���̺��� �̿��ؼ� deptno, dname, empno, ename, hiredate, pay, grade �÷���
-- ���� ���ο� ���̺� ���� (tbl_empgrade)
-- �̷��Ե� �Ҽ��ִ�. 3�� ����
--SELECT T.DEPTNO, T.DNAME, T.EMPNO, T.ENAME, T.HIREDATE, T.PAY, S.GRADE
--FROM (
--    SELECT D.DEPTNO, DNAME, EMPNO, ENAME, HIREDATE, SAL+NVL(COMM,0) PAY, SAL
--    FROM EMP E
--    JOIN DEPT D
--    ON D.DEPTNO = E.DEPTNO 
--    )T, SALGRADE S
--WHERE T.SAL BETWEEN S.LOSAL AND S.HISAL;

-- ���̺� 3�� JOIN
CREATE TABLE TBL_EMPGRADE
AS(
SELECT D.DEPTNO, DNAME, EMPNO, ENAME, HIREDATE, SAL+NVL(COMM,0) PAY, GRADE -- ���� ���̺� �� �ִ� Į���� D.�� ���̸� ��
FROM EMP E, DEPT D, SALGRADE S
WHERE D.DEPTNO = E.DEPTNO AND E.SAL BETWEEN S.LOSAL AND S.HISAL
); 
--
SELECT *
FROM TBL_EMPGRADE;
--
DROP TABLE TBL_EMPGRADE; -- ���Ĺ��������� �����ص� ���������� �̵���
PURGE RECYCLEBIN; -- ������ ����
DROP TABLE TBL_EMPGRADE PURGE; -- ��������

-- JON ON �������� ����.

CREATE TABLE TBL_EMPGRADE
AS(
    SELECT D.DEPTNO, D.DNAME, EMPNO,ENAME, HIREDATE, SAL+NVL(COMM,0) PAY, S.LOSAL || '~' || S.HISAL SAL_RANGE, GRADE -- ���� ���̺� �� �ִ� Į���� D.�� ���̸� ��
    FROM EMP E
         JOIN DEPT D 
         ON D.DEPTNO = E.DEPTNO
         JOIN SALGRADE S 
         ON E.SAL BETWEEN S.LOSAL AND S.HISAL
        
    );

-- EMP ���̺��� ������ ����, ���ο� TBL_EMP���̺� ����
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
-- 10�� �μ����� INSERT?
-- 1. INSERT INTO TBL_EMP (EMPNO, ENAME, HIREDATE) VALUES ();
INSERT INTO TBL_EMP SELECT * FROM EMP WHERE DEPTNO = 10;
COMMIT;

-- 1) DIRECT LOAD INSERT�� ���� ROW ���� 
INSERT INTO TBL_EMP (EMPNO, ENAME) SELECT EMPNO, ENAME FROM EMP WHERE DEPTNO = 20;

DROP TABLE tbl_empgrade;

-- [ ���� insert�� 4���� ]
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

-- ���� Ŀ��(insert) 4���� �ѹ��� ó���Ϸ���? -> unconditional insert all�� ��� => ���Ǿ��� ���� ��
INSERT ALL 
    INTO tbl_emp10 VALUES ( empno, ename, job, mgr, hiredate, sal, comm, deptno )
    INTO tbl_emp20 VALUES ( empno, ename, job, mgr, hiredate, sal, comm, deptno )
    INTO tbl_emp30 VALUES ( empno, ename, job, mgr, hiredate, sal, comm, deptno )
    INTO tbl_emp40 VALUES ( empno, ename, job, mgr, hiredate, sal, comm, deptno )
SELECT *
FROM emp;

-- 2) Conditional INSERT ALL : ������ �ִ� INSERT ALL�� => ���ǿ� �´� ��Ҹ� ��.
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

-- 3) conditional first insert : ������ �����ϴ� ù��° �������� �� / �������� ������./ ALL�� FIRST���θ� �ٸ�
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
-- ��ȸ
SELECT *
FROM tbl_sales;
-- 
CREATE TABLE tbl_salesdata(
  employee_id        number(6),
  week_id            number(2),
  sales              number(8,2));
-- ����� ���η� �ٲ�
INSERT ALL
  INTO tbl_salesdata VALUES(employee_id, week_id, sales_mon)
  INTO tbl_salesdata VALUES(employee_id, week_id, sales_tue)
  INTO tbl_salesdata VALUES(employee_id, week_id, sales_wed)
  INTO tbl_salesdata VALUES(employee_id, week_id, sales_thu)
  INTO tbl_salesdata VALUES(employee_id, week_id, sales_fri)
  SELECT employee_id, week_id, sales_mon, sales_tue, sales_wed,
         sales_thu, sales_fri
  from tbl_sales;
-- Ȯ��
SELECT *
FROM tbl_salesdata;


-- tbl ����
DROP TABLE tbl_emp10;
DROP TABLE tbl_emp20;
DROP TABLE tbl_emp30;
DROP TABLE tbl_emp40;
DROP TABLE tbl_sales;
DROP TABLE tbl_salesdata;

-- DELECT ��, DROP TABLE ��, TRUNCATE�� ������?
-- DELECT (DML) : ���ڵ� ����
-- DROP TABLE (DDL) : ���̺� ����
-- TRUNCATE (DML) : ���ڵ� ��� ����

TRUNCATE TABLE FROM ���̺��;  
-- �ڵ�Ŀ��(�ѹ� �Ұ���)

DELETE FROM ���̺��;   -- Ŀ�� / �ѹ� �ʼ�
-- �� WHERE �������� ������ ��� ���ڵ� ����


-- ����) INSA ���̺��� num, name Į������ �����ؼ� ���ο� ���̺� tbl_score ����
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

-- ����) tbl_score���̺� kor, eng, mat, tot, avg, grade(�� �ڷ���), rank �÷� �߰�
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

-- ����) 1001~1005 ����л��� ������ ������ ������ ������ �߻����Ѽ� ����
SELECT *
FROM tbl_score;

UPDATE tbl_score
SET   kor = ROUND(SYS.DBMS_RANDOM.VALUE(0,101))
    , eng = ROUND(SYS.DBMS_RANDOM.VALUE(0,101))
    , mat = ROUND(SYS.DBMS_RANDOM.VALUE(0,101));
COMMIT;

-- ����) 1005�� �л��� ������ ������ 1001�� �л��� ������ ������ ����.
UPDATE tbl_score
SET (kor, eng, mat) = (SELECT kor,eng, mat FROM tbl_score WHERE num = 1001)
WHERE num = 1005;

COMMIT;
SELECT *
FROM tbl_score;

-- ����) ��� �л��� ����, ������� ������Ʈ
UPDATE tbl_score
SET tot = kor+eng+mat, avg = (kor+eng+mat)/3;

-- ����) ��� �л��� ����� ������Ʈ
-- �Ʒ� �� Ǯ���
UPDATE tbl_score
SET (SELECT sum, tot, avg, RANK () OVER (ORDER BY tot asc) FROM tbl_score);

-- �� ����. ���߿� ���캼 ��
UPDATE tbl_score p
SET rank = (
               SELECT t.r
               FROM (
                   SELECT num, tot, RANK() OVER(ORDER BY tot DESC ) r
                   FROM tbl_score
               ) t
               WHERE t.num =p.num
           );

-- ����) ��� ����        avg 90�� �̻� '��', 80�� �̻� '��'~ '��'

UPDATE tbl_score
SET grade =    CASE WHEN avg >= 90 THEN '��'
                    WHEN avg >= 80 THEN '��'
                    WHEN avg >= 70 THEN '��'
                    WHEN avg >= 60 THEN '��'
                    ELSE '��'
                    end;
                            
-- ���ڵ嵵 ����. DECODE( FLOOR(avg/10),10,'��',9,'��',8,'��',7,'��',6,'��',5,'��' )

-- �̰͵� ����.
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


-- ��� �л��� ���������� 40�� �ø���. 100�� �ʰ��ϸ� �ȵ�.
UPDATE tbl_score
SET eng = CASE WHEN eng <= 60 THEN eng + 40
             ELSE eng + (100 - eng)
             END;
                     
commit;

-- ����) ���л��鸸 ���������� 5�� ����
-- �÷��� ssn �߰�(����). 0�� �̸����� �� �������� ��.
-- �� Ǯ��
UPDATE tbl_score
SET kor =  (SELECT i.ssn
            , CASE WHEN gender = '��' THEN kor - 5
              END
            , DECODE(MOD(SUBSTR(ssn,-7,1),2),1,'��',0,'��') gender
             FROM tbl_score t RIGHT JOIN insa i ON i.ssn = t.ssn
             );
------ ���� ------     
     
UPDATE tbl_score
SET kor =  CASE WHEN kor -5 < 0 THEN 0
                ELSE kor -5
              END

WHERE num IN ( SELECT num 
                FROM insa 
                WHERE num <= 1005 AND MOD(SUBSTR(ssn,-7,1),2) = 1
                ) ;


-- ������ Ǯ��
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

-- ����) result Į�� �߰�
--              �հ�, ���հ�, ����(1������ 40�� �̸� or 3���� ����� 60�� �̸��̸� ����)

ALTER TABLE tbl_score
ADD result VARCHAR(10);
--
UPDATE tbl_score
SET result = CASE WHEN KOR < 40 or eng < 40 or mat < 40  THEN '����'
                  WHEN avg < 60 THEN '���հ�'
                  ELSE '�հ�'
                  end;
--
COMMIT;
SELECT *
FROM tbl_score;


----------------------------------------------------------------------------
-- [ MERGE ] : �и��Ǿ��ִ� ���̺� �����͸� -> ������ �ϳ��� ��ġ�� ��� ���.
--             �÷�(��Ÿ���)�� ������ -> UPDATE, ������ INSERT

DROP TABLE tbl_score PURGE;

create table tbl_emp(
  id number primary key, 
  name varchar2(10) not null,
  salary  number,
  bonus number default 100);
-- Table TBL_EMP��(��) �����Ǿ����ϴ�.
  
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


-- �Ʒ��� �������� �ʱ�~~ ���̺� ���� �׳� ��������
-- �� ���� �����غ���~
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







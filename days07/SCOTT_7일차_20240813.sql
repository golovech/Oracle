-- EMP, DEPT
-- ����� �������� �ʴ� �μ��� �μ���ȣ, �μ����� ���.
-- LEFT OUTER JOIN

-- �⺻ Ǯ��

SELECT D.DEPTNO, DNAME, COUNT(EMPNO) �μ��ο��� 
FROM EMP E RIGHT JOIN DEPT D -- EMP�� ���� ����ϰ� DEPT�� �����ո� ���. 
ON D.DEPTNO = E.DEPTNO
GROUP BY D.DEPTNO, DNAME
HAVING COUNT(EMPNO) = 0
ORDER BY D.DEPTNO;

-- 1. WITH�� Ǯ��
WITH T AS (
            SELECT DEPTNO
            FROM DEPT
            MINUS
            SELECT DISTINCT DEPTNO
            FROM EMP
            )
SELECT T.DEPTNO, D.DNAME
FROM T JOIN DEPT D ON T.DEPTNO = D.DEPTNO; -- ������


-- 2. �ζ��κ� Ǯ��
SELECT T.DEPTNO, D.DNAME
FROM
 (
            SELECT DEPTNO
            FROM DEPT
            MINUS
            SELECT DISTINCT DEPTNO
            FROM EMP
            ) T JOIN DEPT D ON T.DEPTNO = D.DEPTNO; -- ������


-- 3. SQL�����ڸ� �̿��� Ǯ��
SELECT M.DEPTNO, M.DNAME
FROM DEPT M
WHERE  NOT EXISTS (SELECT EMPNO FROM EMP WHERE DEPTNO = M.DEPTNO); -- �������� ������ ����Ѵ�.


-- 4. ����������� ��� (WHERE���� ��������)
SELECT M.DEPTNO, M.DNAME
FROM DEPT M
WHERE (SELECT COUNT(*) FROM EMP WHERE DEPTNO = M.DEPTNO) = 0;

-- INSA���̺��� �� �μ��� ���ڻ���� �ľ�, 5�� �̻��� �μ� ���� ���.
-- COUNT MOD SUBSTR / WHERE  COUNT() >= 5

SELECT BUSEO, DECODE(MOD(SUBSTR(SSN,-7,1),2 ),1,'��','��' ) ����, COUNT(BUSEO) �����ο�
FROM INSA
WHERE DECODE(MOD(SUBSTR(SSN,-7,1),2 ),1,'��','��' ) = '��'
HAVING COUNT(*) >= 5
GROUP BY BUSEO, DECODE(MOD(SUBSTR(SSN,-7,1),2 ),1,'��','��' );

------------

-- [����] insa ���̺�
--     [�ѻ����]      [���ڻ����]      [���ڻ����] [��������� �ѱ޿���]  [��������� �ѱ޿���] [����-max(�޿�)] [����-max(�޿�)]
------------ ---------- ---------- ---------- ---------- ---------- ----------
--        60                31              29           51961200                41430400                  2650000          2550000

SELECT COUNT(BUSEO)
, COUNT(DECODE(MOD(SUBSTR(SSN,-7,1),2 ),1,'��' )) ����
, COUNT(DECODE(MOD(SUBSTR(SSN,-7,1),2 ),0,'��' ))
, SUM(DECODE(MOD(SUBSTR(SSN,-7,1),2 ),1,BASICPAY ))
, SUM(DECODE(MOD(SUBSTR(SSN,-7,1),2 ),0,BASICPAY ))
, MAX(DECODE(MOD(SUBSTR(SSN,-7,1),2 ),1,BASICPAY ))
, MIN(DECODE(MOD(SUBSTR(SSN,-7,1),2 ),0,BASICPAY ))

FROM INSA;

-- �ٸ� Ǯ��

SELECT
      COUNT(*)
      , DECODE(MOD(SUBSTR(SSN,-7,1),2 ),0,'����', 0, '����', '��ü' ) || '�����'
      , SUM(BASICPAY)
      , MAX(BASICPAY)
FROM INSA
GROUP BY ROLLUP(MOD(SUBSTR(SSN,-7,1),2) );


-- [����] emp ���̺���~
--      �� �μ��� �����, �μ� �ѱ޿���, �μ� ��ձ޿�
���)
    DEPTNO       �μ�����       �ѱ޿���            ���
---------- ----------       ----------    ----------
        10          3          8750       2916.67
        20          3          6775       2258.33
        30          6         11600       1933.33 
        40          0         0             0


-- OUTER JOIN DEPT+EMP
-- 1.
SELECT D.DEPTNO
     , COUNT(EMPNO) �μ�����
     , NVL(SUM(SAL+NVL(COMM,0)),0) �ѱ޿���
     , NVL(ROUND(AVG(SAL+NVL(COMM,0)),2),0) ���
FROM DEPT D LEFT JOIN EMP E ON D.DEPTNO = E.DEPTNO
GROUP BY D.DEPTNO
ORDER BY D.DEPTNO;

-- 2.
SELECT D.DEPTNO
     , COUNT(EMPNO) �μ�����
     , NVL(SUM(SAL+NVL(COMM,0)),0) �ѱ޿���
     , NVL(ROUND(AVG(SAL+NVL(COMM,0)),2),0) ���
FROM EMP E, DEPT D
WHERE E.DEPTNO(+) = D.DEPTNO
GROUP BY D.DEPTNO
ORDER BY D.DEPTNO ASC;


-- [ ROLLUP, CUBE �� ]
--GROUP BY ������ ����. �׷캰 �Ұ踦 �߰��� �����ִ� ����
--��, �߰����� ���� ������ �����ش�.
SELECT
     CASE MOD(SUBSTR(SSN,-7,1) ,2)
     WHEN 1 THEN '����'
     WHEN 0 THEN '����'
     END ����
     , COUNT(*) �����

FROM INSA
GROUP BY MOD(SUBSTR(SSN,-7,1) ,2)

UNION ALL

SELECT '��ü', COUNT(*)
FROM INSA;

-- GROUP BY ROLLUB / CUBE ���
SELECT
     CASE MOD(SUBSTR(SSN,-7,1) ,2)
     WHEN 1 THEN '����'
     WHEN 0 THEN '����'
     ELSE '��ü'
     END ����
     , COUNT(*) �����

FROM INSA
GROUP BY CUBE (MOD(SUBSTR(SSN,-7,1) ,2));
GROUP BY ROLLUP (MOD(SUBSTR(SSN,-7,1) ,2));


-- [ROLLUP / CUBE�� ������?]

SELECT BUSEO, JIKWI, COUNT(*) �����
FROM INSA
GROUP BY BUSEO, JIKWI
UNION ALL
SELECT BUSEO, NULL, COUNT(*) �����
FROM INSA
GROUP BY BUSEO
ORDER BY BUSEO, JIKWI;

-- ���� ���� �ڵ�. ROLLUP�� ����ϸ� ������.
SELECT BUSEO, JIKWI, COUNT(*) �����
FROM INSA
GROUP BY CUBE(BUSEO, JIKWI) -- �κкκ� ���踦 ���ִ� CUBE
ORDER BY BUSEO, JIKWI;

-- 2.
SELECT BUSEO, JIKWI, COUNT(*) �����
FROM INSA
GROUP BY BUSEO, JIKWI

UNION ALL

SELECT BUSEO, NULL, COUNT(*) �����
FROM INSA
GROUP BY BUSEO

UNION ALL

SELECT NULL, JIKWI, COUNT(*) �����
FROM INSA
GROUP BY JIKWI;


-- ���� ROLLUP : ROLLUP�� Į�� �ϳ��� ���� �� ���� 
            -- -> ��ü����� �� ������, ���� ���� Į���� ���踸 ����.
SELECT BUSEO, JIKWI, COUNT(*) �����
FROM INSA
GROUP BY ROLLUP(JIKWI), BUSEO -- �μ� �κ� ���踸 ����.
--GROUP BY ROLLUP(BUSEO), JIKWI -- ������ �κ� ���踸 ����.
--GROUP BY ROLLUP(BUSEO, JIKWI) -- 1�� ����(�μ���) -> ��ü���� ����.
--GROUP BY CUBE(BUSEO, JIKWI) -- 1�� ����(�μ���) -> ������ ���� -> ��ü���� ����.
ORDER BY BUSEO, JIKWI;


-- [GROUPING SETS �Լ�] : �׷����� ���踸 ����ϴ� �Լ�.
SELECT BUSEO, '', COUNT(*) �����
FROM INSA
GROUP BY BUSEO

UNION ALL

SELECT '', JIKWI, COUNT(*) �����
FROM INSA
GROUP BY JIKWI;

--

SELECT BUSEO, JIKWI, COUNT(*) �����
FROM INSA
GROUP BY GROUPING SETS( BUSEO, JIKWI ) -- �׷����� ���踸 ��µȴ�.
ORDER BY BUSEO, JIKWI;

-- PIVOT

--1. ���̺� ���谡 �߸��� ��Ȳ -> ������Ʈ ���� -> ���� �������� �����ߴ� ����

tbl_pivot
��ȣ, �̸�, ������ ���� ���̺�
-- DDL �� ����� CREATE�غ���.

CREATE TABLE tbl_pivot
(
--    Į���� �ڷ���(ũ��) ��������...
    NO NUMBER PRIMARY KEY -- ������Ű(PK) ��������
    , NAME VARCHAR2(20 BYTE) NOT NULL -- NOTNULL(NN) �������� ( == �ʼ��Է»���)
    , JUMSU NUMBER(3) -- NULL ���
);
-- Table TBL_PIVOT��(��) �����Ǿ����ϴ�.
SELECT *
FROM TBL_PIVOT; -- ��� ����

-- 

INSERT INTO TBL_PIVOT ( no, name, jumsu ) VALUES ( 1, '�ڿ���', 90 );  -- kor
INSERT INTO TBL_PIVOT ( no, name, jumsu ) VALUES ( 2, '�ڿ���', 89 );  -- eng
INSERT INTO TBL_PIVOT ( no, name, jumsu ) VALUES ( 3, '�ڿ���', 99 );  -- mat
 
INSERT INTO TBL_PIVOT ( no, name, jumsu ) VALUES ( 4, '�Ƚ���', 56 );  -- kor
INSERT INTO TBL_PIVOT ( no, name, jumsu ) VALUES ( 5, '�Ƚ���', 45 );  -- eng
INSERT INTO TBL_PIVOT ( no, name, jumsu ) VALUES ( 6, '�Ƚ���', 12 );  -- mat 
 
INSERT INTO TBL_PIVOT ( no, name, jumsu ) VALUES ( 7, '���', 99 );  -- kor
INSERT INTO TBL_PIVOT ( no, name, jumsu ) VALUES ( 8, '���', 85 );  -- eng
INSERT INTO TBL_PIVOT ( no, name, jumsu ) VALUES ( 9, '���', 100 );  -- mat 

COMMIT; 

--- �� �巡�� �� ����

SELECT *
FROM TBL_PIVOT;

-- ����) �Ǻ�
--��ȣ �̸�   ��,  ��,  ��
--1   �ڿ���  90 89 99
--2   �Ƚ���  56 45 12
--3   ���    99 85 100


-- ����� ����� ���ڰ� �ٶ�Ѥ�.
SELECT *
FROM 
    (SELECT TRUNC((NO-1)/3) + 1 NO
    , NAME �̸�
    , JUMSU
    --, DECODE(MOD(NO,3),1,'����',2,'����',3,'����') SUB
    , ROW_NUMBER() OVER (PARTITION BY NAME ORDER BY NO) SUB
    FROM TBL_PIVOT)
PIVOT (SUM(JUMSU) FOR SUB IN (1 AS "����",2 AS "����",3 AS "����") )
ORDER BY NO;

-- �Ի��� ����� ��� / �⵵����,. EMP
-- PARTITION BY OUTER JOIN ���
-- FROM INSA I PARTITION BY (BUSEO) RIGHT OUTER JOIN C ON I.CITY = C.CITY ����
--ORA-01788: CONNECT BY clause required in this query block
SELECT LEVEL AS "MONTH" -- ����(�ܰ�)
FROM DUAL
CONNECT BY LEVEL <= 12;

--

select empno, TO_CHAR(hiredate,'YYYY') year
     , TO_CHAR(hiredate,'MM') month
from emp;

-- �� Ŀ���� �������� ��ģ��.
SELECT YEAR, M.MONTH, NVL(COUNT(EMPNO),0) N
FROM (
         select empno, TO_CHAR(hiredate,'YYYY') year
             , TO_CHAR(hiredate,'MM') month
         from emp
         ) e
         
         PARTITION BY (E.YEAR ) RIGHT OUTER JOIN -- ��¥��µǴ� LEVEL�� RIGHT ������.(������ĸ��߷�)
         
         ( 
        SELECT LEVEL AS "MONTH" -- ����(�ܰ�)
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


-- INSA �μ�, ������ ���
SELECT BUSEO, JIKWI, COUNT(*)
FROM INSA
GROUP BY BUSEO, JIKWI
ORDER BY BUSEO, JIKWI;
-- �μ��� ������ �ּһ���� �ִ����� ��ȸ
-- ����� ���� ���� ����, ���� ���� ����

--SELECT BUSEO, JIKWI, COUNT(JIKWI) -- �Լ����̴� ��ƴ�.
--     , DECODE()
--     , CASE 
--     WHEN  THEN
--     WHEN  THEN
--     END ����
--FROM INSA
--WHERE COUNT 
--GROUP BY CUBE(BUSEO, JIKWI)
--ORDER BY BUSEO, JIKWI;

-- 2����
-- 1) �м��Լ� FIRST, LAST
--    �����Լ�(COUNT,SUM,AVG,MAX,MIN)�� �Բ� ����Ͽ�
--    �־��� �׷쿡 ���� ���������� ������ �Ű� ����� ������
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

-- 2) SELF JOIN : �ڱ��ڽ� ���̺�� join�ϰڴ�.
-- ex) ���� mgr = ���ӻ���� �̸��� �������ڴ�. -> �������� �� : ���� mgr = ���ӻ���� empno
select a.empno, a.ename, a.mgr, b.ename
from emp a join emp b on a.mgr = b.empno;

-- [ non equal join ] ���������� : ����� Į���� ���� ��
-- �������� = �̳�����  from emp e inner join dete d on e.deptno = d.deptno
select *
from salgrade;
-- ���������� ����
select empno, ename, sal --, grade �����ؾ� ����.
from emp e join salgrade s on e.sal BETWEEN s.losal and s.hisal ;

-- == �Ʒ��� ����.

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
     , b.jikwi �ּ��ο�����, b.tot_count �ּ��ο����������
FROM t2 a, t1 b
where a.buseo = b.buseo AND a.buseo_min_count = b.tot_count ;

-- �� �ڵ� first, last����Ͽ� Ǯ���. �ִ��ο����� ���غ���.

-- �Ʒ� ������ Ǯ��
WITH t AS (
    SELECT buseo, jikwi, COUNT(num) tot_count
    FROM insa
    GROUP BY buseo, jikwi
)
select t.buseo
     , min(t.jikwi) KEEP(DENSE_RANK FIRST ORDER BY t.tot_count asc) �ּ�����
     , min(t.tot_count) �ּһ����
     , max(t.jikwi) KEEP(DENSE_RANK last ORDER BY t.tot_count asc) �ִ�����
     , max(t.tot_count) �ִ�����
from t
group by t.buseo
order by t.buseo;


-- ����) emp ���̺��� ���� �Ի����ڰ� ���� �����, ���� �Ի����ڰ� ���� ������� �Ի��� ����
-- 

select max(hiredate) - min(hiredate)
from emp;

-- �м��Լ� : CUME_DIST()
--            �־��� �׷쿡 ���� ������� ���� ������ �� ���
--            ������(����)��    0 <     <=1

select deptno, ename, sal
     , CUME_DIST() OVER (order by sal asc) dept_list
     , CUME_DIST() OVER (PARTITION BY deptno order by sal asc) dept_list
from emp;


--  [ �м��Լ� : PERCENT_RANK() ]
--     �� �ش� �׷� ���� ����� ����
--        0 <     ������ ��   <=1
--      * ����� ������: �׷� �ȿ��� �ش� ���� ������ ���� ���� ����

-- [ NTILE() : (NŸ��) ]
--    ��Ƽ�Ǻ��� (ǥ����)�� ��õȸ�ŭ ������ ����� ����ϴ� �Լ�

SELECT DEPTNO, ENAME, SAL
     , NTILE(3) OVER (ORDER BY SAL ASC) NTILE
     , WIDTH_BUCKET(SAL, 1000, 4000, 4)
FROM EMP;

--

SELECT DEPTNO, ENAME, SAL
     , NTILE(4) OVER (PARTITION BY DEPTNO ORDER BY SAL ASC) NTILE
     
FROM EMP;

-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 

-- [ WIDTH_BUCKET() ] �Լ� 
-- : WIDTH_BUCKET(�÷�,�ּҰ�,�ִ�,���� ����)
-- WIDTH_BUCKET(SAL, 1000, 4000, 4)


-- LAG(ǥ����, OFFSET, DEFAULT_VALUE)
--    �� �־��� �׷�� ������ ���� �ٸ� �࿡ �ִ� ���� ������ �� ����ϴ� �Լ�
--    �� ���� ��    
--    �� ���� N�� �̸� ���ܿ��� �Լ�

-- LEAD(ǥ����, OFFSET, DEFAULT_VALUE)
--    �� �־��� �׷�� ������ ���� �ٸ� �࿡ �ִ� ���� ������ �� ����ϴ� �Լ�
--    �� ����(��) ��
--    �� ���� N�� �ڷ� �о�� �Լ�

SELECT DEPTNO, ENAME, HIREDATE, SAL
     , LAG(SAL,3,0) OVER(ORDER BY HIREDATE) PRE_SAL
     , LEAD(SAL,1,-1) OVER(ORDER BY HIREDATE) NEXT_SAL
FROM EMP
WHERE DEPTNO = 30;

-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 

    --               [ ����Ŭ �ڷ��� (DATE TYPE) ]
    
    --1) CHAR [ (SIZE [BYTE|CHAR]) ] ���ڿ��ڷ���
    --   CHAR == CHAR(1 BYTE) == CHAR(1)
    --   CHAR(3 BYTE) = CHAR(3) 'ABC'  '��'
    --   CHAR(3 CHAR) 'ABC' '�ϵѼ�'
    --   ���� ������ ���ڿ� �ڷ���
    --   name CHAR(10 BYTE)
    --   2000 BYTE���� ũ�� �Ҵ��� �� �ִ�.
    --   �� ) �ֹε�Ϲ�ȣ (14), �й�, �����ȣ, ��ȭ��ȣ // ������ ���̰� �������

-- TEST

CREATE TABLE TBL_CHAR
(
AA CHAR -- CHAR(1) == CHAR(1 BYTE)
, BB CHAR(3)
, CC CHAR (3 CHAR)

);
-- Table TBL_CHAR��(��) �����Ǿ����ϴ�.
COMMIT;

DESC TBL_CHAR
INSERT INTO TBL_CHAR (AA,BB,CC) VALUES ('A','AA','AAA');
INSERT INTO TBL_CHAR (AA,BB,CC) VALUES ('B','��','�ѿ츮');
INSERT INTO TBL_CHAR (AA,BB,CC) VALUES ('C','�ѿ츮','�ѿ츮');


    -- 2) NCHAR
    --    N == UNICODE(�����ڵ�)
    --    NCHAR[(SIZE)]
    --    NCHAR(1) == NCHAR
    --    NCHAR(10) // ���ĺ�,���� ���� 10���� �־ �ȴ�.
    --    �������� ���ڿ� �ڷ���
    --    2000 BYTE���� ���� ����.

CREATE TABLE TBL_NCHAR
(
AA CHAR(3) -- CHAR(3 BYTE ��3 ��1)
, BB CHAR(3 CHAR)
, cc NCHAR (3) -- ���� 3���� ���尡��

);
COMMIT;
INSERT INTO TBL_nCHAR (AA,BB,cc) VALUES ('ȫ','�浿','ȫ�浿');
INSERT INTO TBL_nCHAR (AA,BB,CC) VALUES ('ȫ�浿','ȫ�浿','ȫ�浿');


    -- ���� ���� ���ڿ�
    -- 3) VAR + CHAR2 ==> VARCHAR
    --    ���� ���� ���ڿ� �ڷ���
    --    4000 BYTE �ִ� ũ��
    --    VARCHAR2(SIZE BYTE|CHAR)
    --    VARCHAR2(1) = VARCHAR2(1 BYTE) = VARCHAR2
    --    NAME VARCHAR2(10) -> 5����Ʈ ���Ǹ� ���� 5����Ʈ�� ����. (����)
    
    -- 4) N + VAR + CHAR2
    --    �����ڵ� + �������� + ���ڿ� �ڷ���
    --    NVARCHAR2(SIZE)
    --    NVARCHAR2(1) = NVARCHAR2
    --    4000 BYTE �ִ� ũ��

 5) NUMBER[(p[,s])]
            precision       scale
             ��Ȯ��         �Ը�
            ��ü�ڸ���   �Ҽ��������ڸ���
             1~38          -85~ -127
    NUMBER = NUMBER(38,127)
    NUMBER(p) = NUMBER(p, 0)
    
    ����)
    CREATE TABLE TBL_NUMBER
    (
    NO NUMBER(2) NOT NULL PRIMARY KEY  -- NN + UK
    , NAME VARCHAR2( 30 ) NOT NULL
    , KOR NUMBER(3) --  -999 ~ 999
    , ENG NUMBER(3) --  0 <=  <= 100
    , MAT NUMBER(3) DEFAULT 0
    )
    COMMIT;
    INSERT INTO TBL_NUMBER (NO, NAME, KOR, ENG, MAT) VALUES (1, 'ȫ�浿', 90, 88, 67)
--        INSERT INTO TBL_NUMBER (NO, NAME, KOR, ENG, MAT) VALUES (2, '�ֻ��', 100, 98)
    INSERT INTO TBL_NUMBER (NO, NAME, KOR, ENG) VALUES (2, '�ֻ��', 100, 98)
    ROLLBACK;
    INSERT INTO TBL_NUMBER VALUES (3, '������', 60, 95, 100);
    INSERT INTO TBL_NUMBER (NAME,NO, KOR, ENG,MAT) VALUES ( '�����',4, 80, 55, 100);
    INSERT INTO TBL_NUMBER (NO, NAME, KOR, ENG, MAT) VALUES (5, '�ܽ���', 110, 56.934, -333); -- �Ǽ��ε� �ݿø� �˾Ƽ� �ǳ�...
    
    
    SELECT *
    FROM TBL_NUMBER;
    -- 1283.34569
    -- ���� NUMBER(4,5)ó�� scale�� precision���� ũ�ٸ�, �̴� ù�ڸ��� 0�� ���̰� �ȴ�. < ���� ��?
    
    --    6) FLOAT [(p)] : ���������� NUMBER ó�� ��Ÿ����.
    --    7) LONG     ��������(VAR) ��Ÿ���� ���ڿ� �ڷ��� / 2GB ���� ���尡��
    --    8) DATE     ��¥, �ð�(��)  �������� 7 BYTE
    --       TIMESTAMP[(n)] : n = �и������� ������ / n�� ������ 6�ڸ� ���� ���
    --    9) RAW(SIZE) - 200 BYTE ����������(0/1) ����
    --       LONG RAW - 2GB       ���������� / ������Ʈ���� �̹����� ���������ͷ� �������� �ʴ´�. �̹����� �����ؼ� �ٽ� �����ϴ� ���̶�...
    --   10) LOB : CLOB, NCLOB, BLOB, BFILE
    
    
    -- �ڷ��� �� --
    
    
-- FIRST_VALUE �м��Լ� : ���ĵ� �� �߿� ù ��° ��
SELECT FIRST_VALUE(BASICPAY) OVER (ORDER BY BASICPAY DESC) FIRST
FROM INSA;

SELECT FIRST_VALUE(BASICPAY) OVER (PARTITION BY BUSEO ORDER BY BASICPAY DESC) FIRSTBUSEO
FROM INSA;

-- ���� ���� �޿�(BASICPAY) �� ����� BASICPAY�� ���̸� ���? => FIRST_VALUE ���
SELECT BUSEO, NAME, BASICPAY
     , FIRST_VALUE(BASICPAY) OVER (ORDER BY BASICPAY DESC) MAX
     , FIRST_VALUE(BASICPAY) OVER (ORDER BY BASICPAY DESC) - BASICPAY ����
FROM INSA;


-- COUNT ~ OVER : ������ ���� ������ ����� ��� => COUNT(*)�����δ� GROUP BY ������ ��, �̸� ����
-- SUM ~ OVER : ������ ���� ������ �� ��� ���          (�����Լ� �׷���� ���ص� ��)
-- AVG ~ OVER : '' ��� ���
SELECT NAME, BASICPAY, BUSEO
     , AVG(BASICPAY) OVER (PARTITION BY BUSEO ORDER BY BASICPAY) �������
    -- , SUM(BASICPAY) OVER (PARTITION BY BUSEO ORDER BY BASICPAY) �μ���
    -- , COUNT(*) OVER (PARTITION BY BUSEO ORDER BY BASICPAY)
FROM INSA;


SELECT NAME, BASICPAY, BUSEO
     , SUM(BASICPAY) OVER (ORDER BY BUSEO)
      -- , COUNT(*) OVER (ORDER BY BASICPAY)
FROM INSA;

-- ���� �ڵ��� ���� ���(������.�׳� ���⸸ �ض� ����ϱ�...)
SELECT BUSEO, SUM(BASICPAY)
FROM INSA
GROUP BY BUSEO
ORDER BY BUSEO;


-- * ���̺� ����, ����, ���� * 
-- DDL : CREATE, ALTER, DROP
-- ���̺�(Table) : ������ �����
-- ���̵�    ����  10 BYTE
-- �̸�      ����  20
-- ����      ����  30
-- ��ȭ��ȣ  ����  20
-- ����      ��¥
-- ���      ���� 255


-- ���̺� ����
CREATE TABLE TBL_SAMPLE
(
ID VARCHAR2 (10)
, NAME VARCHAR2 (20)
, AGE NUMBER (3)
, BIRTH DATE
);
--Table TBL_SAMPLE��(��) �����Ǿ����ϴ�.
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

-- ��� Į���� ũ��, �ڷ��� �����Ϸ���? => MODIFY
-- ���ڿ� -> ������ ���� ������ �Ұ� => CHAR �� VARCHAR2 ��ȣ���� ���游 ����.
-- BIGO(255) -> (100)
ALTER TABLE TBL_SAMPLE
MODIFY (BIGO VARCHAR2(100));

-- BIGO Į���� -> MEMO �� ����?
ALTER TABLE TBL_SAMPLE
RENAME COLUMN BIGO TO MEMO; 

-- MEMO �÷� ����?
ALTER TABLE TBL_SAMPLE
DROP COLUMN MEMO;

-- ���̺���� ����?
RENAME TBL_SAMPLE TO TBL_EXAMPLE;
-- ���̺� �̸��� ����Ǿ����ϴ�.



       
        
       

















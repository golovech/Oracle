SELECT job, empno, ename, hiredate
FROM emp;

-- ����� �ȳ� -- HR���� �ؾ���.
SELECT first_name, last_name, ( first_name + last_name )name
FROM emp
WHERE ( first_name + last_name ) name;

--SELECT name, buseo �μ�
--FROM insa;
SELECT DISTINCT buseo �μ�
FROM insa
ORDER BY buseo; -- ���������� �⺻.
ORDER BY buseo DESC; -- ��������
ORDER BY buseo ACS; -- ��������

SELECT  deptno, ename, ( sal + NVL(comm, 0) ) pay
FROM emp
ORDER BY 1 ASC, 3 DESC; 
ORDER BY deptno ASC, pay DESC; -- 2�� ����
ORDER By pay DESC;

-- with�� ��Ī : temp�� �����. �ӽ� ������ �ʿ��ϴϱ�.
WITH temp AS(
    SELECT emp.*, ( sal + NVL(comm, 0) ) pay
    FROM emp
    WHERE deptno !=30
    )
SELECT *
FROM temp
WHERE pay BETWEEN 1000 AND 3000
ORDER BY ename ASC;

-- �ζ��κ� ���
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

desc insa; -- �λ��� ����Ʈ ������ȸ

SELECT insa.*, NVL(tel,'����ó ��� �ȵ�') ��� -- ����ȯ �� �ʿ�� ����.
FROM insa
WHERE tel is null;

SELECT num, name, buseo, tel, NVL2(tel,'O','X') tel2
FROM insa
WHERE buseo LIKE '���ߺ�'
ORDER BY tel2 DESC;

SELECT empno, ename, sal, NVL(comm,0) comm, sal + NVL(comm,0) pay
FROM emp;

SELECT emp.*
FROM emp
WHERE deptno IN (10,20);
WHERE deptno LIKE '10' OR deptno LIKE '20';

SELECT emp.*
FROM emp
WHERE ename = UPPER('KING'); -- ��ҹ��� ����. UPPER('KING')
WHERE ename LIKE UPPER('KING');

SELECT insa.*
FROM insa
WHERE REGEXP_LIKE(city,'^[^����|���|��õ]');
WHERE city IN('����','���','��õ');
WHERE city NOT IN('����','���','��õ');

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

-- ����ǥ����
SELECT name, ssn
FROM insa
WHERE REGEXP_LIKE(ssn,'^7\d12')
ORDER BY ssn ASC;
-- LIKE
SELECT name, ssn
FROM insa
WHERE ssn LIKE '7_12%'
ORDER BY ssn;

-- 21. insa ���̺��� 70��� ���� ����� ��ȸ.   
-- ����ǥ���� ���
SELECT insa.*
    , MOD(SUBSTR(ssn,-7,1),2) gender -- MOD����� ������
FROM insa
WHERE ssn LIKE '7%' AND MOD(SUBSTR(ssn,-7,1),2)=1; -- MOD����� ������.
WHERE REGEXP_LIKE(ssn,'^7\d{5}-[13579]'); -- ����ǥ����
WHERE REGEXP_LIKE(ssn,'^\d\d\d\d\d\d-1');
-- SUBSTR ���
SELECT *
FROM insa
WHERE SUBSTR(ssn,-7,1) = 1;
-- LIKE��
SELECT *
FROM insa
WHERE ssn LIKE '7______1%';



SELECT emp.*
FROM emp
WHERE REGEXP_LIKE(ename, 'la', 'i'); -- [i] [g] [m] : ��ҹ��� �������� �ʰ�. 
WHERE ename LIKE '%'|| UPPER('la') ||'%'; -- ����صα�!!
WHERE ename LIKE UPPER('%la%'); -- UPPER('%la%')
WHERE ename LIKE '%%'; -- ��� ���� �����ϴ�.

-- 23.insa ���̺��� ���ڴ� 'X', ���ڴ� 'O' �� ����(gender) ����ϴ� ���� �ۼ�   
-- PL / SQL (DQL)
SELECT name, ssn
    -- ,MOD(SUBSTR(ssn,-7,1),2) = 1 GENDER
    ,NVL2 (NULLIF(MOD(SUBSTR(ssn,-7,1),2), 1), 'O', 'X' ) gender
FROM insa; -- DECODE() ,CASE() �Լ� ����ص� ����.

-- 24. insa ���̺��� 2000�� ���� �Ի��� ���� ��ȸ�ϴ� ���� �ۼ�
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
         -- HOUR~SECOND�� CAST�� ����ȯ ����� ��!
          , EXTRACT(YEAR FROM SYSDATE)   year
          , EXTRACT(MONTH FROM SYSDATE) MON
          , EXTRACT(DAY FROM SYSDATE) DAY
          --, EXTRACT(HOUR FROM CURRENT_TIMESTAMP) H����
          , EXTRACT(HOUR FROM CAST (SYSDATE AS TIMESTAMP)) H���� -- �̰� ����
          --, EXTRACT(MINUTE FROM SYSTIMESTAMP) M
          , EXTRACT(MINUTE FROM CAST(SYSDATE AS TIMESTAMP)) M
         -- , EXTRACT(SECOND FROM SYSTIMESTAMP) S
          , EXTRACT(SECOND FROM CAST(SYSDATE AS TIMESTAMP)) S
FROM dual;


-- [ dual�̶�? ]
DESC DUAL;
-- DUMMY    VARCHAR2(1) 
SELECT DUMMY
FROM DUAL;
-- ���ڵ�(��) 1�� ��. // ���̰� X

SELECt SYSDATE
FROM dual;
-- 1���� ��µǰ� �Ϸ���. ���ڵ� 1���� ���� �����ϱ�!

SELECT *
FROM dual;
-- �� �����.. sys.dual �� �Ⱥٿ��� �ǳ�?
-- ���� SYS.dual �̶�� ����ϳ�, ����Ŭ�� �ó��(public synonym)�� �ٿ��� ������ ���̺��� �Ȱ�.
-- �ó�� : ��Ī�� �ٿ��� ��.

--26
SELECT *
FROM insa
WHERE REGEXP_LIKE(name, '^[����]') AND REGEXP_LIKE(ssn, '^[7\d12\d%]')
ORDER BY name ASC;

--27
SELECT COUNT(*)
FROM insa;

------------------ �������� Ǯ�� �� ----------------------

-- [LIKE �������� ESCAPE �ɼ� ����]
-- wildcard(%,_)�� �Ϲ� ����ó�� ���� ���� ��쿡�� ESCAPE �ɼ��� ���.
SELECT deptno, dname, loc
FROM dept;
-- dept table�� ���ο� �μ������� �߰��Ϸ���?
-- 1. dept table ����Ŭ���ؼ� -> ������ Ŭ�� -> �߰� -> �Է��ϰ� Ŀ��(Ŀ���ʼ�)
-- 2. DML : INSERT��!
-- ORA-00001: unique constraint (SCOTT.PK_DEPT) violated 
-- ���� ���� �̹� �ִٴ� ��. 50 ���� �̹� �����ؼ�. -> 60���� �ٲ�!
INSERT INTO dept (deptno, dname, loc) VALUES (60, '�ѱ�_����', 'KOREA'); 
INSERT INTO dept VALUES (60, '�ѱ�_����', 'KOREA');-- (deptno, dname, loc) ��������
COMMIT;
ROLLBACK;

-- �μ��� % ���ڰ� ���Ե� �μ������� ��ȸ�Ϸ���?
SELECT dname
FROM dept
WHERE dname LIKE '%\%%' ESCAPE '\'; 
-- ESCAPE '\' �� �ָ�, LIKE�ڿ� �ִ� ���ϵ�ī�带 �Ϲݹ��ڷ� �ν���.
WHERE REGEXP_LIKE(dname,'[%%%]'); -- �̰͵� ����

-- DML(DELETE)
DELETE FROM dept
WHERE deptno = 60; -- ������� �� �����ִ� ��ȣ(deptno)�� �����̹�Ű�� �༭ �����ϸ� ��.
DELETE FROM EMP; -- WHERE ������ ������ ��� emp ������... �����̹�Ű�� �־����.

SELECT *
FROM emp; 

SELECT *
FROM dept;

-- DML(UPDATE)
UPDATE ���̺��
SET Į���� = Į����, Į���� = Į����, Į���� = Į����;

UPDATE dept
SET dname = 'QC';
ROLLBACK;

UPDATE dept
SET dname = SUBSTR(dname,0,2 ),loc = 'KOREA'
WHERE deptno = 50;

-- [����] 40�� �μ��� �μ���, �������� ���ͼ�
--        50�� �μ��� �μ�������, ���������� �����ϴ� ���� �ۼ� (40���� ����)
UPDATE dept
SET dname = (SELECT dname FROM dept WHERE deptno = 40)
    ,loc = (SELECT loc FROM dept WHERE deptno = 40)
WHERE deptno = 50;
-- �� ������ �����ϰ� ����?
-- �̷��� �ϸ� �ȴ�. ����ϱ�!
UPDATE dept
SET (dname, loc)  = (SELECT dname, loc FROM dept WHERE deptno = 50)
WHERE deptno = 50;

-- [����] dept        50,60,70 deptno �����Ϸ���?
DELETE FROM dept
WHERE deptno IN (50, 60, 70); -- == deptno = 50 OR deptno = 60 OR deptno = 70; in���� ���氡�� !!!!!
WHERE deptno BETWEEN 50 AND 70;
WHERE deptno = 50 OR deptno = 60 OR deptno = 70;
DELETE FROM dept;
COMMIT;

SELECT *
FROM dept;

-- [����] emp���̺��� ��� ����� sal �⺻���� pay �޿��� 10% �λ��ϴ� update��

UPDATE emp
SET sal = sal + (sal + NVL(comm,0))* 0.1 ; 

SELECT ename, sal, comm
    ,sal + (sal + NVL(comm,0)) * 0.1 "10% �λ��" -- �� ������ SET�� �ٿ������� !
FROM emp;

-- �ó�� 
-- ��Ű��.��ü�� 

-- PUBLIC �ó�� �����غ���.
CREATE PUBLIC SYNONYM arirang
FOR scott.emp;
-- ORA-01031: insufficient privileges : ������ ����? => DBA������ ���⶧��.

 -- select���Ѻο�
GRANT SELECT ON emp TO hr;

-- ���� ȸ���Ҷ� / REVOKE
REVOKE SELECT ON emp FROM HR CASCADE constraint;


---------------------------------------------------------------------------


-- [����Ŭ ������(operator) ����]

1) �� ������ : =    !=  >   <   >=  <=
                WHERE ������ ����, ����, ��¥ �񱳽� ����Ѵ�.
                ANY, SOME, ALL �񱳿����� ->  SQL �����ڿ� ���Ե�.

2) �� ������ : AND, OR, NOT
                WHERE ������ ������ ������ �� ����Ѵ�.
                
3) SQL ������ : SQL ���� ����.
                [NOT] IN (list)  
                [NOT] BETWEEN a AND b 
                [NOT] LIKE 
                IS [NOT] NULL 
                ANY, SOME , ALL     WHERE ������ ��� + (��������)
                TRUE/FALSE  EXISTS  WHERE ������ ��� + (��������)
                
4) NULL ������ : IS NULL, IS NOT NULL
5) ��� ������ : ����, ����, ����, ������
                  +     *     -       /

SELECT 5+3, 5*3, 5-3, 5/3
        , FLOOR(5/3) -- ��(����)�� ���ϴ� �Լ� FLOOR
        , MOD(5,3)
FROM dual;






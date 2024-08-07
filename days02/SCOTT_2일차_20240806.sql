SELECT *
FROM dba_tables;
FROM all_users;
FROM user_table;
FROM tabs;

-- INSA table ���� �ľ�
DESC insa;
DESCRIBE insa;

-- INSA ���̺� ��� ��� ���� ��ȸ
SELECT *
FROM insa;
-- '01/10/11'  'RR/MM/DD'    'YY/MM/DD' �� ������?;
SELECT * 
FROM v$nls_parameters; -- nls ��� ���� �̸�.
-- emp table���� ����� ���� ��ȸ (�����ȣ, �����, �Ի����ڸ�)

1[ WITH]
6 SELECT 
2 FROM
3 WHERE
4 GROUP BY
5 HAVING
7 ORDER BY

-- ���� = �⺻�� + ���� Į���� �߰��ؼ� ��ȸ.
SELECT empno, ename, hiredate
--    , sal, comm
--    , NVL(comm,0)
--    , NVL2(comm,comm,0)
    ,sal + NVL(comm,0) pay -- AS "pay"
    -- null������ �����ϸ� �ᱣ���� ��� null�� ���Ѵ�.
    -- NVL(comm,0)�Լ� �ʿ�!
    -- NVL2(1,2,3)

FROM emp;
-- 1) ����Ŭ null�� � �ǹ�? : ��Ȯ�ε� ��(������ Ȯ�ε��� ����)
-- 2) comm(����) �ᱣ���� ���� ����.
-- emp tabs ���� �����ȣ, �����, ���ӻ�� (mgr(manager))��ȸ
-- ���ӻ�簡 null�̸�? 'CEO'��� ���
SELECT empno, ename
    -- , NVL(mgr, 'CEO') mgr : ORA-01722 : invalid number
    -- mgr�� �ڷ����� ���ڴϱ�, ���ڷ� ����ȯ���Ѿ� ��.
    -- TO_CHAR(mgr)   /   mgr || ''
    , NVL(TO_CHAR(mgr), 'CEO') mgr
    , NVL( mgr || '', 'CEO') mgr
FROM emp;
-- emp tabs ���� �̸��� '����'�̰�, ������ ���� �̴�. ���

SELECT '�̸��� ' ''  || ename  || '' '�̰�, ������ '|| job ||'�̴�.'
-- ���ڿ��� '' �ַ���... '''' ����ϸ�ȴ�...
-- ���ؼ���Ǯ��  65 -> A  �� Ȱ��.
SELECT '�̸��� '|| CHR(39) || ename|| CHR(39) || '�̰�, ������ '||job||'�̴�'
FROM emp;


-- emp tabs���� �μ���ȣ�� 10���� ����鸸 ��ȸ
SELECT *
FROM dept ;
-- emp ���̺��� �� ����� ���� �ִ� �μ���ȣ�� ��ȸ?
-- SELECT DISTINCT deptno -- DISTINCT �ߺ�����
SELECT *
FROM emp
WHERE deptno = 10;

-- ����) emp ���̺��� 10�� �μ����� ������ ������ ����� ���� ��ȸ
SELECT *
FROM emp
WHERE NOT (deptno = 10);
WHERE deptno > 10;
-- WHERE deptno != 10;
-- �ڹ�  &&   ||   !
-- ����  AND  OR  NOT
--
SELECT *
FROM emp
WHERE deptno IN (20,30,40); -- �Ʒ� ������ 100% ����.
WHERE deptno = 20 OR deptno = 30 OR deptno = 40;
-->  NOT IN (list)    SQL������

--[����] emp_tabs���� ������� ford�� ����� ��� ������� ���.

SELECT *
FROM emp
WHERE ename = UPPER('Ford'); -- ORA-00904: "FORD": invalid identifier (Ȭ����ǥ ��� ����� ����)
-- ���� ���Ҷ�, ��ҹ��� ��Ȯ�ϰ� ��� ��.
-- LOWER, UPPER, INITCAP(�ձ��ڸ� �빮��)
SELECT LOWER(ename) LOWER, INITCAP( job ) INITCAP
FROM emp;

-- emp ���̺��� Ŀ�̼��� null�� ����� ���� ���?
SELECT *
FROM emp
WHERE comm is null;
-- is null (�� ��ü�� ���.)  = null�� �˻��ϸ� ���� null�� ���� �˻���.


-- [����] emp tabs ���� 2000�̻� 4000���� (sal + comm)
SELECT e.*, (sal + NVL(comm,0)) pay
FROM emp e -- e ��� �˸��߽��� �ذ�.
WHERE (sal+NVL(comm,0)) >=2000 AND (sal+NVL(comm,0)) <=4000;

-- �Ʒ� �ڵ��� �� �����ϰ� ����.
WITH temp AS (
        SELECT emp.*, (sal + NVL(comm,0)) pay
        FROM emp
    )
SELECT *
FROM temp
WHERE pay >= 2000 AND pay <= 4000; 

-- WITH + BETWEEN
WITH temp AS (
    SELECT emp.*, (sal+NVL(comm,0)) pay
    FROM emp
    )
SELECT *
FROM temp
WHERE pay BETWEEN 2000 AND 4000;
-- with - from - where - select ������� �ϴϱ� pay�� �ᵵ ��.

-- �ζ��κ�(inline view) : from�� �ڿ� ���� ��������
-- WHERE ���� ���� ����������? : Nasted(��ø) ��������
-- correlated subquery : Nested subquery�߿��� �����ϴ� ���̺��� parent, child���踦 ������ �������� 
-- ����������? : �� �ڿ� ���� (). �ڿ��� �� �˸��߽��� �ش�.

SELECT *
FROM (
         SELECT emp.*, (sal + NVL(comm,0)) pay
         FROM emp
        )e  -- �ζ��κ�(���ξȿ� �ִ� ��. ����.)
WHERE pay >= 2000 AND pay <= 4000; 


-- between 1
SELECT e.*, (sal + NVL(comm,0)) pay
FROM emp e
WHERE (sal + NVL(comm,0)) BETWEEN 2000 AND 4000;

-- between 2 **
SELECT *
FROM (
         SELECT emp.*, (sal + NVL(comm,0)) pay
         FROM emp
        )e  
WHERE pay BETWEEN 2000 AND 4000; 


--[����] INSA tabs ���� 70���� ��� ���� ��ȸ / �̸�, �����, �ֹι�ȣ
-- REGEXP_


--SELECT name, ssn
--       ,SUBSTR(ssn,0,1)
--       ,SUBSTR(ssn,1,1)
--       ,SUBSTR(ssn,1,2)
--       ,INSTR(ssn,7)
--FROM insa
--WHERE INSTR(ssn,7) = 1;
--WHERE TO_NUMBER(SUBSTR(ssn,0,2)) BETWEEN 70 AND 79;
--WHERE SUBSTR(ssn,0,2) BETWEEN 70 AND 79;

-- SUBSTR() --
SELECT name, ssn
--    ,SUBSTR(ssn,0,8) || '******' RRN
--    ,CONCAT(SUBSTR(ssn,0,8), '******') RRN
--    ,RPAD(SUBSTR(ssn,0,8),14,'*') rrn
--    ,REPLACE(ssn, SUBSTR(ssn,-6),'******' ) rrn
    ,REGEXP_REPLACE(ssn,'(\d{6}-\d)\d{6}','\1******') rrn
FROM insa;

--�� Ǯ��
--SELECT CONCAT(CONCAT(name, SUBSTR(ssn,0,8)),'******') RRN
--FROM insa;

SELECT name, ssn 
    , SUBSTR(ssn,0,6)
    , SUBSTR(ssn,0,2) YEAR
    , SUBSTR(ssn,3,2) MONTH
    , SUBSTR(ssn,5,2) "DATE" -- ORA-00923: FROM keyword not found where expected : DATE�� ������. intó��...������ " " �ٿ�����.
    , TO_DATE(SUBSTR(ssn,0,6)) birth
    , TO_CHAR(TO_DATE(SUBSTR(ssn,0,6)), 'YY') y
FROM insa
WHERE TO_CHAR(TO_DATE(SUBSTR(ssn,0,6)), 'YY') BETWEEN 70 AND 79;
WHERE TO_DATE(SUBSTR(ssn,0,6)) BETWEEN '70/01/01' AND '79/12/31';
-- BETWEEN 'a' AND 'b' �� ��¥���� �� �� �ִ�.
SELECT ename, hiredate
--    , SUBSTR(hiredate,0,2) YEAR
--    , SUBSTR(hiredate,4,2) MONTH
--    , SUBSTR(hiredate,-2,2) DAY -- -n ���� �������°� �� ���ϴ�!
--    , TO_CHAR(hiredate, 'YEAR')
    , TO_CHAR(hiredate, 'YYYY') y
    , TO_CHAR(hiredate, 'DD') d -- ���� ��¥
    , TO_CHAR(hiredate, 'DY') d -- ��
    , TO_CHAR(hiredate, 'DAY') d -- ������
    
    -- EXTRACT() : ���ڷ� ��µ�.
    , EXTRACT( YEAR FROM hiredate ) year
    , EXTRACT( MONTH FROM hiredate ) mon
    , EXTRACT( DAY FROM hiredate ) day
FROM emp;

-- ���� ��¥���� �⵵,��,��,�ð�,��,�� ��������?

SELECT SYSDATE a -- sysdate�� �� ��ü�� �Լ���.
    ,TO_CHAR(SYSDATE, 'Ds Ts') 
    ,CURRENT_TIMESTAMP
FROM emp;

-- insa tabs �� 70���� ��� ��ȸ. LIKE 
-- LIKE
-- REGEXT_LIKE �Լ� ���(����ǥ����)

SELECT *
FROM insa
WHERE regexp_LIKE(ssn,'^7[0-9]12');
WHERE regexp_LIKE(ssn,'^7\d12');
WHERE regexp_like(ssn,'^[78]');
WHERE regexp_like(ssn,'^7||8');
WHERE regexp_like(ssn,'^7');
WHERE ssn LIKE '7_12%';
WHERE ssn LIKE '______-1%';
WHERE ssn LIKE '%-1%';
WHERE name LIKE '%��';
WHERE name LIKE '%��%';
WHERE name LIKE '��%';

SELECT *
FROM insa
W
WHERE regexp_LIKE(name,'^[^��]');


-- [����] insa ���̺��� �达 ���� ������ ��� ���  ���
-- [����]��ŵ��� ����, �λ�, �뱸 �̸鼭 ��ȭ��ȣ�� 5 �Ǵ� 7�� ���Ե� �ڷ� ����ϵ�
--      �μ����� ������ �δ� ��µ��� �ʵ�����. 
--      (�̸�, ��ŵ�, �μ���, ��ȭ��ȣ)

SELECT name, city, LENGTH(buseo) ���� ,SUBSTR(buseo,0,LENGTH(buseo)-1 ) �μ�, tel
FROM insa
WHERE REGEXP_LIKE (city, '[����|�λ�|�뱸]')
    AND
    REGEXP_LIKE (tel,'[57]');
-- ����ǥ������ []�ȿ� �־�� �Ѵ�. [57] // []�ȿ� ^�� ������ ������ ���̴�.


WHERE REGEXP_LIKE(name, '^[^����ȫ���峪]'); -- �� ������ ���ڴ�. '^[^]'
WHERE name NOT LIKE '��%';





















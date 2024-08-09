----[����Ǯ��]
-- 1. emp���̺��� ���� ���� ��ȸ
SELECT COUNT(DISTINCT job)
FROM emp;
--
SELECT COUNT(*)
FROM(
    SELECT DISTINCT job
    FROM emp
    ) e;

-- 2. emp���̺��� �μ��� ����� ��ȸ
-- ����.

SELECT count(*)
     , CASE  deptno   WHEN 10 THEN sum(depyno)
                END
         , CASE  deptno   WHEN 20 THEN sum(depyno)
                END
                     , CASE  deptno   WHEN 30 THEN sum(depyno)
                END
                
FROM emp;

--

SELECT 10 "a" ,count(*) "�μ��� �ο�"
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

SELECT deptno �μ���, COUNT(*)
FROM emp
GROUP BY deptno
ORDER BY deptno ASC;
-- 40�� �μ� 0�� ����ϰ� �ʹٸ�? (�������� �ʴ� �μ�...)
SELECT COUNT(*)
     -- , DECODE(deptno,10,1)
     , COUNT(DECODE(deptno,10,1)) "10"
     , COUNT(DECODE(deptno,20,1)) "20"
     , COUNT(DECODE(deptno,30,2)) "30"
     , COUNT(DECODE(deptno,40,3)) "40" -- count()�� null���� �����ϰ� ī�����Ѵ�...
FROM emp;

-- ����

SELECT COUNT(*)
    , COUNT(DECODE(MOD(SUBSTR(ssn,-7,1),2),1,'��')) gender
    , COUNT(DECODE(MOD(SUBSTR(ssn,-7,1), 1),2,'��')) gender
FROM insa ;

--
SELECT DECODE(MOD(SUBSTR(ssn,-7,1), 2),1,'��',0,'��') gen, COUNT(*)
FROM insa
GROUP BY MOD(SUBSTR(ssn,-7,1), 2);


-- CASE
SELECT '��ü' gender, COUNT(*)
FROM INSA
UNION ALL
SELECT  CASE MOD(SUBSTR(ssn,-7,1), 2) WHEN 1 THEN '��'
                                   ELSE '��'
    END gender
    ,COUNT(*)
FROM insa
GROUP BY MOD(SUBSTR(ssn,-7,1), 2);

-- GROUP BY + rollup
SELECT  CASE MOD(SUBSTR(ssn,-7,1), 2) WHEN 1 THEN '����'
                                      WHEN 0 THEN '����'
                                      ELSE '��ü'
    END gender
    ,COUNT(*)
FROM insa
GROUP BY ROLLUP (MOD(SUBSTR(ssn,-7,1), 2));

-- ����.�޿� ���ϸ��̹޴»���� ������ ��ȸ
SELECT *
FROM emp
WHERE sal+NVL(comm,0) = (
                            SELECT MAX(sal+NVL(comm,0))
                            FROM emp
                            );

-- SQL ������ : all, some, any, exists
-- �޿� ���� ���� �޴� ����� ������ ��ȸ
SELECT *
FROM emp
WHERE sal+NVL(comm,0) <= all (SELECT sal+NVL(comm,0) FROM emp); -- ����for���� ����.


-- ����) emp ���̺��� �� �μ��� �ְ� �޿��� �޴� ����� ���� ��ȸ

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

-- Ʋ���ڵ������� ��°��� ����
SELECT *
FROM emp
WHERE sal+NVL(comm,0) = any (SELECT MAX(sal+NVL(comm,0))
                             FROM emp
                             GROUP BY deptno);
                         
                             
--����������� ��� : WHERE���� �������� : 
--                   ()�ȿ� �ִ� �������� -> �ٱ��� ������ �̿��� �� ��� -> �ٽ� ()������ �ͼ� ���
SELECT *
FROM emp m
WHERE sal+NVL(comm,0) = (
                        SELECT MAX(sal+NVL(comm,0))
                        FROM emp s
                        WHERE deptno = m.deptno 
                        );
                        
                        
-- emp ���̺��� pay ����

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
             
             
-- insa���̺��� �μ��� �ο����� 10�� �̻��� �μ��� ��ȸ

SELECT *
FROM (
            SELECT i.*
                , (SELECT COUNT(*) +1 FROM insa WHERE buseo > i.buseo)
            FROM insa i
            
            )a 
            
WHERE a.buseo >=10;

-- ���ڰ� 5�� �̻��� �μ��� ��ȸ
SELECT buseo, COUNT(DECODE(MOD(SUBSTR(ssn,-7,1),2),0,'����')) "������ ��"
FROM insa
GROUP BY buseo
HAVING COUNT(DECODE(MOD(SUBSTR(ssn,-7,1),2),0,'����')) >= 5;


--
SELECT *
FROM(
       SELECT insa.*
       ,(SELECT COUNT(*) +1 FROM insa WHERE DECODE(MOD(SUBSTR(ssn,-7,1),0, '����'))   

)
GROUP BY buseo
HAVING COUNT(DECODE(SUBSTR(ssn,-7,1),2)) >=5;


-- �ùٸ� �ڵ� : ���ڰ� 5�� �̻��� �μ��� ��ȸ
SELECT buseo, COUNT(*)
FROM insa
WHERE MOD(SUBSTR(ssn,-7,1),2) = 0 -- ���ڸ� �ɷ��� ��
GROUP BY buseo -- �μ����� �����ؼ�
HAVING COUNT(*) >= 5; -- 5�� �̻��� ���� �� ��.


---- emp ���̺��� ������� ��ü ��� �޿� ��� ��,
---- �� ������� �޿��� ��ձ޿����� ���� ��� "����" ���, ������ "����" ���

SELECT sal+NVL(comm,0) pay, COUNT(*)
,DECODE( AVG(sal+NVL(comm,0)), AVG(sal+NVL(comm,0)  > sal+NVL(comm,0),'����', AVG(sal+NVL(comm,0) < sal+NVL(comm,0),'����')
FROM emp;

--�´� �ڵ�
SELECT empno, ename, pay, ROUND(avg_pay,2) avg_pay
     , CASE WHEN pay > avg_pay THEN '����'
            WHEN pay < avg_pay THEN '����'
            ELSE '����'
        END
FROM(
        SELECT emp.*
            , sal+NVL(comm,0) pay
            , (SELECT AVG(sal+NVL(comm,0) )FROM emp) avg_pay
        FROM emp
)e;


-- emp���̺��� �޿� ���� ���� �޴»��/�������� �޴� ��� ��� (max, min)
 
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

-- insa���̺��� ������� ����߿� �μ��� ����, ���� �����,
-- ���� �޿� ���� / ���� �޿� ���� �� ��ȸ.
-- sum(buseo), str(), regexp_like(), 
SELECT buseo, city, ssn, basicpay+NVL(sudang,0) pay
FROM insa
WHERE REGEXP_LIKE (city, '^����') AND basicpay+NVL(sudang,0) IN (
            (SELECT DECODE(MOD(SUBSTR(ssn,-7,1),2,'����'))), (SELECT DECODE(MOD(SUBSTR(ssn,-7,1),1,'����')))
            
            );

GROUP BY buseo

-----
SELECT buseo
     , COUNT(*) "�ѻ����"
     , COUNT(DECODE(MOD(SUBSTR(ssn,-7,1),2),1,'m' )) "m"
     , COUNT(DECODE(MOD(SUBSTR(ssn,-7,1),2),0,'f' )) "f"
     , SUM (DECODE(MOD(SUBSTR(ssn,-7,1),2),1,basicpay ))
     , SUM (DECODE(MOD(SUBSTR(ssn,-7,1),2),0,basicpay ))
FROM insa
WHERE city = '����'
GROUP BY buseo
ORDER BY buseo ASC;

-------
SELECT buseo, jikwi, COUNT(*), SUM(basicpay), AVG(basicpay)
FROM insa
GROUP BY ROLLUP(buseo, jikwi)
ORDER BY buseo, jikwi;

----
SELECT buseo
     , DECODE(MOD(SUBSTR(ssn,-7,1),2),0,'����','����') gender
     , COUNT(*) inwon
     , SUM(basicpay) "�ѱ޿���"
FROM insa
WHERE city = '����'
GROUP BY buseo, MOD(SUBSTR(ssn,-7,1),2)
ORDER BY buseo, MOD(SUBSTR(ssn,-7,1),2);

---- ROWNUM / ROWID �ǻ�Į��(����Į��) : ǥ�õ��� ������ ���ο� �����ϴ� Į��
DESC emp;
SELECT ROWNUM, ROWID, ename, hiredate, job
FROM emp;

-------- [ TOP - N �м� ]

	SELECT �÷���,..., ROWNUM
	FROM (
          SELECT �÷���,... from ���̺��
	      ORDER BY top_n_�÷���
          )
    WHERE ROWNUM <= n;
    
----[ROWNUM Ȱ��]
SELECT ROWNUM,e.*
FROM(
        SELECT *
        FROM emp
        ORDER BY sal DESC
        )e
-- WHERE ROWNUM BETWEEN 3 AND 5 : �̰� �ȵȴ�.
WHERE ROWNUM = 1; -- 1��
WHERE ROWNUM <= 3; -- 1~3��

-- ORDER BY ���� �Բ� ROWNUM ��� X (�ζ��κ�� ����)
SELECT ROWNUM, emp.*
FROM emp
ORDER BY sal DESC;

-- �ζ��κ�� ����(ROWNUM AS " ")�ϸ� 3~5 ����� ����.
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

-- ROLLUP/CUBE ����
-- 1) ROLLUP : �׷�ȭ�ϰ� �׷쿡 ���� �κ���
-- join
SELECT dname, job, COUNT(*)
FROM emp e, dept d
WHERE e.deptno = d.deptno
--GROUP BY d.dname, job
GROUP BY ROLLUP ( dname, job) -- ROLLUP �κ���
ORDER BY dname;

--ORDER BY d.deptno ASC;

--2. CUBE : ROLLUP����� GROUP BY���� ���ǿ� ���� ������ ��~�� �׷��� ���հ�� ���.
--          �׷�ȭ�ϰ� �׷쿡 ���� �κ���, �Ʒ��� �׷캰 ������ ���
SELECT dname, job, COUNT(*)
FROM emp e, dept d
WHERE e.deptno = d.deptno
--GROUP BY d.dname, job
GROUP BY CUBE ( dname, job) -- ROLLUP �κ���
ORDER BY dname;

---- [����(RANK)�� ���õ� �Լ�]

SELECT ename, sal+NVL(comm,0) pay
     , RANK() OVER(ORDER BY sal+NVL(comm,0) DESC) RANK���� -- �Ϲݼ���
      , DENSE_RANK() OVER(ORDER BY sal+NVL(comm,0) DESC) DENSERANK -- ���� ���̸� ������ ���� �ϰ�, �ߺ��� 1���� ġ�� �����ű�.
      , ROW_NUMBER() OVER(ORDER BY sal+NVL(comm,0) DESC) ROW_NUMBER -- ���� ���̶� ������ �ٸ��� �ű�.
FROM emp;

SELECT *
FROM emp;

UPDATE emp
SET sal = 2850
WHERE empno = 7566;
COMMIT;


----------[ PARTITION BY ] ���� �Լ� ��� ����
----------�μ����� �޿� ������ �ű���.
SELECT *
FROM(
        SELECT emp.*
             , RANK() OVER (PARTITION BY deptno ORDER BY sal+NVL(comm,0) DESC) ����
              , RANK() OVER ( ORDER BY sal+NVL(comm,0) DESC) ��ü����
        FROM emp
        )
WHERE ���� BETWEEN 2 AND 3 ;
WHERE ���� = 1;

--------- insa ���̺��� ������� 14�� �� ¥�ڴ�.
-- 14�� ��������. -> ������ ������ �������. ������/ ������ �� ���ϱ�.
SELECT CEIL((COUNT(*))/14)
FROM insa;

-- insa���̺��� ������� ���� ���� �μ��� , �μ���, ����� ���
SELECT *
FROM(
        SELECT buseo, COUNT(*)
             , RANK() OVER (ORDER BY COUNT(*) DESC) �μ�����
             FROM insa
             GROUP BY buseo



     )e
WHERE �μ����� = 1;

-- �λ����̺��� ���ڼ��� ���帹�� �μ� �� �����

SELECT *
FROM(
        
        SELECT buseo, ssn, COUNT(*)
             , RANK () OVER (ORDER BY COUNT(MOD(SUBSTR(ssn,-7,1),2) ) DESC) ���ڸ����μ�����
        FROM insa
        GROUP BY buseo, ssn
        )
WHERE ���ڸ����μ����� = 1;
---
SELECT *
FROM(
        SELECT buseo, ssn, COUNT(*)
             , RANK() OVER (ORDER BY COUNT(*) DESC) �μ�����
             FROM insa
             WHERE MOD(SUBSTR(ssn,-7,1),2)  = 0
             GROUP BY buseo, ssn

     )e
WHERE �μ����� = 1;

-- [����] insa ���̺��� basicpay�� ���� 10%�� ��� (�̸�,�⺻��)

SELECT *
FROM(
        SELECT name, basicpay
             , RANK() OVER (ORDER BY basicpay DESC) pay����
             FROM insa
             -- GROUP BY basicpay
             )p
WHERE p.pay���� <= (SELECT COUNT(*)*0.1 FROM insa);



SELECT *
FROM
(
SELECT name, basicpay
         ,PERCENT_RANK() OVER (ORDER BY basicpay DESC) pr
         FROM insa
         )
         WHERE pr <= 0.1;
         

         















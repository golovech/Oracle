
-- [ �ε��� ] B-TREE �� ���� �����غ���.

--1. �����ͺ��̽��� ������ ����
--��. ���̺� ���� �� INSERT������ ������ ���� ��, DBMS�� ��� ����ɱ�.

--��. ����ó������
    1. ����� -> 2. SQL���� SQL �ۼ� -> 3. DBMS�� ���� ó����� ���� 
    -> 4. OS�� �� ��ġ(�ϵ��ũ�� ����������..) �۾� ó�� 
    -> 5. ���������� OS�� ���� �ý��ۿ� �����ͺ��̽� ���Ϸ� ���������ġ(HDD,SDD)�� �����.
    
--��. �ϵ��ũ�� ���� �÷���Ʈ�� ������ / �÷���Ʈ�� �������� Ʈ������ ���� -> Ʈ���� ���ͷ� ����
    ������(��ũ �����) �ð� = Ž���ð� + ȸ�������ð� + ���������۽ð�    
    -> DBMS�� �ϵ��ũ�� �����͸� �����ϰ� �о�� ���� �ӵ� ���� �߻���(1000��� ����!)
    -> �����ϱ�~ ���� ����ϴ� �����ʹ� DB ����ĳ�÷� ����� �����ص�.
    SGA(system global area)�� �����Ѵ�.
    
--    [ ����Ŭ�� �ֿ� ���� ]
    1) ���������� 
    2) �¶��� ���� �α� - ������� ��� ���.
    3) ��Ʈ�� ����
    
    4) ����Ŭ�� ���� ���� ������ �����Ͽ� �����.
        ���(8kb) < �ͽ���Ʈ(��� x 8) < ���׸�Ʈ < ���̺����̽�(�ͽ���Ʈ x 16)
        ����Ŭ�� ���� �� ���� �����ϸ� -> �ͽ���Ʈ ������ ���� ������.
    
--    [ �ε����� B-Tree ]
    1) �ε���(index, ����) : �ڷḦ ���� ������ ã�� �� �ֵ��� ���� ������ ����.
    2) ���������� å�� ��ġ�� ���� ã���� ���� �� = �ε���!
    3) ���ϴ� �����͸� ������ ã�� ���� ��ġ���� ������ ��.
        ��) rowid
        select rowid, emp.*
        from emp;
    4) RDBMS�� �ε����� ��κ� B-Tree �����̴�.
    
    ��Ʈ ��� -> ���� ��� -> ���� ���
    - �˻� �ӵ��� ���� ����. �������� ����, �� �������� ������ ������ �˻��ϱ� ����. (Tree����)
    
--    [ �ε����� Ư¡ ]
    1) �ε����� ���̺��� �� �� �̻��� �Ӽ��� �̿��Ͽ� �����Ѵ�.
    2) ���� �˻�, ȿ������ ���ڵ� ������ �����ϴ�.
    3) ���̺��� ���� ������ �����Ѵ�.
    4) ����� ������ ���̺��� �κ������� �ȴ�.
    5) �Ϲ������� B-Tree ������.
    6) �������� ����, ������ ������ ������ �ε����� �籸���� �ʿ�.
    7) �����÷�, �����÷� �ε����� ������.
    8) �����˻��� ������ ������. �������� ����Ǿ��ֱ� ����.
    9) �ε����� ���̺� �� ���� ���� ���� �� ����.
    
    [ ����Ŭ�� �ε��� ���� ]
    1) B-Tree �ε���
    2) IOT �ε���
    3) ��Ʈ�� �ε���
    
    
select *
from emp
where empno = '7369'; -- F10 ������ �����ȹ�� ���! Ǯ��ĵ, ��������ĵ ��.
--
select *
from emp
where ename = 'SMITH';
--
select *
from emp
where SUBSTR(empno, 0, 2) = 76; -- 0.011��  full scan (�����ϸ� index �� �ɸ�!!)
where empno = 7369; -- 0.013��  index (usique scan)
where deptno = 30 and sal > 1300;   -- 0.011��, full scan (�ε��� ���� ��)
                                    -- 0.014�� , range scan (�ε��� ���� �� F10 ���)
where empno > 7600;
--
create index DS_EMP ON emp (deptno, sal); 
-- Index DS_EMP��(��) �����Ǿ����ϴ�.
ALTER~
DROP INDEX DS_EMP;
-- Index DS_EMP��(��) �����Ǿ����ϴ�.


-- �ε��� ��ȸ    
select *
from user_indexes
where table_name = 'EMP';



---------------------------
-- ��޺��� 
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
[������]
1���   (     700~1200 ) - 2��                        key
      20   RESEARCH   7369   SMITH   800               value
      30   SALES         7900   JAMES   950
2���   (   1201~1400 ) - 2��
   30   SALES   7654   MARTIN   2650
   30   SALES   7521   WARD      1750   
3���   (   1401~2000 ) - 2��
   30   SALES   7499   ALLEN      1900
   30   SALES   7844   TURNER   1500
4���   (   2001~3000 ) - 4��
    10   ACCOUNTING   7782   CLARK   2450
   20   RESEARCH   7902   FORD   3000
   20   RESEARCH   7566   JONES   2975
   30   SALES   7698   BLAKE   2850
5���   (   3001~9999 ) - 1��   
   10   ACCOUNTING   7839   KING   5000
*/      
/*
[������]
1���   (     700~1200 ) - 2��                        key
      20   RESEARCH   7369   SMITH   800               value
      30   SALES         7900   JAMES   950
2���   (   1201~1400 ) - 2��
   30   SALES   7654   MARTIN   2650
   30   SALES   7521   WARD      1750   
3���   (   1401~2000 ) - 2��
   30   SALES   7499   ALLEN      1900
   30   SALES   7844   TURNER   1500
4���   (   2001~3000 ) - 4��
    10   ACCOUNTING   7782   CLARK   2450
   20   RESEARCH   7902   FORD   3000
   20   RESEARCH   7566   JONES   2975
   30   SALES   7698   BLAKE   2850
5���   (   3001~9999 ) - 1��   
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














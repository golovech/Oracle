
-- Ʋ��...
SELECT e.*
FROM(
        SELECT ENAME, SAL+NVL(COMM,0) "PAY", AVG(SAL+NVL(COMM,0)) "AVG_PAY"
        ,ROUND(AVG(SAL+NVL(COMM,0)),2) "�� �ݿø�"
        ,CEIL(SAL+NVL(COMM,0)) -  AVG(SAL+NVL(COMM,0)*100)/100 "�� �ø�"
        ,TRUNC((SAL+NVL(COMM,0),2) - AVG(SAL+NVL(COMM,0))) "�� ����"
       
        )e;
        
--- EMP���� �޿����̰� ����, ����, ���� ���
WITH TEMP AS 
    ( 
    SELECT ENAME, SAL+NVL(COMM,0) "PAY"
    ,(SELECT AVG(SAL+NVL(COMM,0)) FROM EMP) "AVG_PAY"
    FROM EMP) 
         
SELECT T.*
     , CASE
            WHEN PAY > AVG_PAY THEN '����'
            WHEN PAY < AVG_PAY THEN '����'
            ELSE '����'
            END ��
FROM TEMP T;

-- �̼��� �ֹε�Ϲ�ȣ ���ó�¥�� ��,�Ϸ� ����
-- ���� ���� ���� ���. / SYSDATE ���� - ��,�� �����ؼ� ���� ���� -1�� ���ų� ������ �� ������.

SELECT NAME, SSN
     , SUBSTR(SSN,0,2)
     , TO_CHAR (SYSDATE, 'MMDD')
FROM INSA
WHERE NUM = 1002;

UPDATE INSA
SET SSN = SUBSTR(SSN,0,2) || TO_CHAR (SYSDATE, 'MMDD') || SUBSTR(SSN,7)
WHERE NUM = 1002;
COMMIT;

--------- ������������ Ȯ��
SELECT NAME, SSN
     , SUBSTR(SSN,3,2)
     , TO_DATE(SUBSTR(SSN,3,4), 'MMDD')
     , CASE SIGN(TO_DATE(SUBSTR(SSN,3,4), 'MMDD') - TRUNC(SYSDATE)) -- TRUNC(A): �ð�,���ʰ� ©��. SIGN(A):
        WHEN  1 THEN 'X'
        WHEN 0 THEN 'O'
        ELSE '����'
        END E
FROM INSA;

-- INSA TABS SSN ������ ����ؼ� ��� 1800 0,9 / 1900, 1,2 / 2000, 3, 4/ �ܱ��� 1900 5,6 / 2000 7,8
-- 2024-1998 -1(������������. ���������� -1����, �ƴϸ� ��������)
SELECT NAME, SSN
     , SUBSTR(SSN,0,2) ����⵵
     , EXTRACT(YEAR FROM SYSDATE) ���س⵵
     , CASE SIGN (TO_DATE(SUBSTR(SSN,0,2),'YY') + ( CASE SUBSTR(SSN,7,1) WHEN 1 OR 2 THEN '19YY' WHEN 3 OR 4 THEN '20YY' WHEN )
     - TRUNC(SYSDATE))
     WHEN  THEN
     WHEN  TEHN
     WHEN  THEN
     WHEN  TEHN
     END A
FROM INSA;

----------
SELECT T.NAME, T.SSN, ����⵵, ���س⵵
     , ���س⵵ - ����⵵ + CASE  DS WHEN -1 THEN -1
                                        ELSE 0
                                    END ������
FROM (
SELECT NAME, SSN
     , EXTRACT(YEAR FROM SYSDATE) ���س⵵
     , SUBSTR(SSN,-7,1) ����
     , SUBSTR(SSN,0,2) ���2�ڸ��⵵
     , CASE 
        WHEN  SUBSTR(SSN,-7,1) IN (1,2,5,6) THEN 1900
        WHEN  SUBSTR(SSN,-7,1) IN (3,4,7,9) THEN 2000
        ELSE 1800
     END + SUBSTR(SSN,0,2) ����⵵
     -- 0�̰ų� -1�̸� ���� ���� ��.
     -- 1�̶�� ���� �������� -> ���̰�꿡�� -1 ���ٰ�.
     , SIGN(TO_DATE(SUBSTR(SSN,3,4), 'MMDD') - TRUNC(SYSDATE)) DS
FROM INSA
) T; 

-------- DBMS_RANDOM ��Ű��
-- STRING(), VALUE() �Լ�
-- �ڹ��� ��Ű�� : ���� ���õ� Ŭ�������� ������ �ǹ�
-- ����Ŭ�� ��Ű�� : ���� ���õ� Ÿ��, ��ü, �������α׷��� ������� ��.
-- ��������, ������ ����.
-- 0.0 < SYS.DBMS_RANDOM.VALUE < 1.0 �Ǽ���
SELECT 
     SYS.DBMS_RANDOM.VALUE
--     , SYS.DBMS_RANDOM.VALUE(0,100) -- 0.0 <= 100.0
--     , SYS.DBMS_RANDOM.STRING('U',5) -- ���� �빮�� 5���� �߻�
--     , SYS.DBMS_RANDOM.STRING('X',5) -- ���� �빮��+����
--     , SYS.DBMS_RANDOM.STRING('L',5) -- ���� �ҹ��� 5����
     , SYS.DBMS_RANDOM.STRING('P',5) -- ���� �빮��+�ҹ���+����+Ư������
     , SYS.DBMS_RANDOM.STRING('A',5) -- ���� �빮��+�ҹ���(���ĺ�)
     
FROM DUAL;

-- ������ �������� 1�� ���
-- ������ �ζ� ��ȣ 1�� ��� (1~45)
-- ������ ���� 6�ڸ� �߻����Ѽ� ���

SELECT TRUNC(SYS.DBMS_RANDOM.VALUE (0,100)) ��������
     , ROUND(SYS.DBMS_RANDOM.VALUE (0,100)) ��������
     , TRUNC(SYS.DBMS_RANDOM.VALUE (1,45))  �ζǹ�ȣ
     , TRUNC(SYS.DBMS_RANDOM.VALUE (1,45)) || ' '
     || TRUNC(SYS.DBMS_RANDOM.VALUE (1,45)) || ' ' 
     || TRUNC(SYS.DBMS_RANDOM.VALUE (1,45)) || ' '
     || TRUNC(SYS.DBMS_RANDOM.VALUE (1,45)) || ' ' 
     || TRUNC(SYS.DBMS_RANDOM.VALUE (1,45)) || ' ' 
     || TRUNC(SYS.DBMS_RANDOM.VALUE (1,45)) "�ζǹ�ȣ6�ڸ����"
     , TRUNC(SYS.DBMS_RANDOM.VALUE (100000,999999)) "6�ڸ����"
     
FROM DUAL;

-----�λ����̺�, ���ڻ����, ���ڻ���� ���?
-- �λ����̺�, �μ��� ���ڻ����, ���ڻ����
-- 1.
SELECT DECODE(SUBSTR(SSN,-7,1),2,'��','��') ����, COUNT(*) "�����"
FROM INSA
GROUP BY SUBSTR(SSN,-7,1);

-- 2.
SELECT DECODE(SUBSTR(SSN,-7,1),2,'��','��') ����, BUSEO ,COUNT(*) "�μ��� �����"
FROM INSA
GROUP BY SUBSTR(SSN,-7,1), BUSEO
ORDER BY ����, BUSEO;

-- �ι�° Ǯ��
SELECT DECODE(MOD(SUBSTR(SSN,-7,1),2),1,'��','��') ����, BUSEO ,COUNT(*) "�μ��� �����"
FROM INSA
GROUP BY MOD(SUBSTR(SSN,-7,1),2), BUSEO
ORDER BY ����, BUSEO;

-- EMP���̺��� �ְ�޿��� ����? �����޿��� ����? ������� ���
-- Ʋ���� Ǭ ����..
--SELECT CASE WHEN 1 THEN '�ְ�޿���'
--            ELSE 2 THEN '�����޿���'
--FROM (
--        SELECT EMPNO, ENAME, JOB, MGR, HIREDATE, DEPTNO,  MAX(SAL) �ְ�޿�, MIN(SAL) �����޿�
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
            
---- �ٸ� Ǯ��

SELECT *
FROM EMP m
WHERE SAL IN(
            (SELECT MAX(SAL) FROM EMP WHERE deptno=m.deptno)
            ,(SELECT MIN(SAL) FROM EMP WHERE deptno=m.deptno)
            )
ORDER BY sal, deptno desc;

-- �ٸ� Ǯ��
SELECT *
FROM EMP A , (SELECT DEPTNO, MAX(SAL) MAX, MIN(SAL) MIN FROM EMP GROUP BY DEPTNO) B
WHERE A.SAL = B.MAX OR A.SAL = B.MIN AND A.DEPTNO = B.DEPTNO
ORDER BY A.DEPTNO, SAL DESC;


------ �μ��� �ְ�/�����޿���
SELECT *
FROM    (
        SELECT EMP.* -- MAX(SAL) �ְ�޿�, MIN(SAL) �����޿�
          , RANK () OVER (PARTITION BY DEPTNO ORDER BY SAL DESC) RANK
          , RANK () OVER (PARTITION BY DEPTNO ORDER BY SAL ASC) RANK1
         FROM EMP
         ) E
             
WHERE E.RANK = 1 OR E.RANK1 = 1
ORDER BY DEPTNO;

             
---- ����) EMP���̺� COMM 400������ ����� ����, COMM NULL �� ����� 400���Ͽ�  ����.
SELECT EMP.*
     , NVL(COMM,0) COMM
FROM EMP
 WHERE COMM <= 400 OR COMM IS NULL;
 
-------LNNVL() �Լ� : WHERE ������ UNKNOW�� FALSE�� TRUE...

SELECT *
FROM EMP
WHERE LNNVL(COMM > 400); -- == COMM�� <= 400 OR COMM IS NULL �� �Ȱ��� ��.

---- �̹� ���� ������ ��¥�� ���ϱ��� �ֳ�?
SELECT LAST_DAY(SYSDATE)
     , ADD_MONTHS(TRUNC(SYSDATE, 'MONTH'),1)
     , TO_CHAR(ADD_MONTHS(TRUNC(SYSDATE, 'MONTH'),2), 'DD' )
     , TO_CHAR(LAST_DAY(SYSDATE),'DD') -- ������ ��¥ ��������.
FROM DUAL;

-- EMP���̺��� SAL�� ���� 20%�� �ش��ϴ� ��� ���� ���
SELECT *
FROM (
      SELECT EMP.*
     , RANK () OVER (ORDER BY SAL DESC) "AVG_SAL"
     FROM EMP
     ) E

WHERE E.AVG_SAL <= SELECT FLOOR(COUNT(*) *0.2 FROM EMP);

------------ PERCENT_RANK() OVER () : �ڵ����� ���� �ۼ�Ʈ�� �Ű��ִ� �Լ�.
SELECT *
FROM (
      SELECT EMP.*
     , PERCENT_RANK () OVER (ORDER BY SAL DESC) PR -- PERCENT_RANK
     FROM EMP
     ) T

WHERE T.PR <= 0.2;

--------- ���� �� �������� �ް��Դϴ�. ������ �������� ��¥�� ��ȸ.
SELECT TO_CHAR(SYSDATE,'DS TS DAY')
     , NEXT_DAY(SYSDATE, '��')
FROM DUAL;

------- EMP���̺��� �� ������� �Ի����ڸ� �������� 10�� 5���� 20��° �Ǵ� ��¥�� ��ȸ
SELECT ENAME, HIREDATE, ADD_MONTHS(HIREDATE, 10*12 + 5) + 20
FROM EMP;

-- ����) 

insa ���̺��� 
[������]
               �μ������/��ü����� == ��/�� ����
               �μ��� �ش缺�������/��ü����� == �μ�/��%
               �μ��� �ش缺�������/�μ������ == ��/��%
                                           
�μ���     �ѻ���� �μ������ ����  ���������  ��/��%   �μ�/��%   ��/��%
���ߺ�       60       14         F       8       23.3%     13.3%       57.1%
���ߺ�       60       14         M       6       23.3%     10%       42.9%
��ȹ��       60       7         F       3       11.7%       5%       42.9%
��ȹ��       60       7         M       4       11.7%   6.7%       57.1%
������       60       16         F       8       26.7%   13.3%       50%
������       60       16         M       8       26.7%   13.3%       50%
�λ��       60       4         M       4       6.7%   6.7%       100%
�����       60       6         F       4       10%       6.7%       66.7%
�����       60       6         M       2       10%       3.3%       33.3%
�ѹ���       60       7         F       3       11.7%   5%           42.9%
�ѹ���       60       7         M    4       11.7%   6.7%       57.1%
ȫ����       60       6         F       3       10%       5%           50%
ȫ����       60       6         M       

SELECT I.*
FROM 
        (
        SELECT BUSEO, COUNT(*)
             , COUNT(BUSEO)
             , NVL(SSN,-7,1) ����
             , 
        FROM INSA
        GROUP BY BUSEO
        ) I
WHERE SUM(BUSEO)
ORDER BY BUSEO ASC;
-- WHERE COUNT(*) =( SELECT COUNT(NAME))

-- �� Ǯ��
SELECT S.*
     , ROUND(�μ������/�ѻ����*100, 2) || '%' "�μ������/�ѻ����"
     , ROUND(���������/�ѻ����*100, 2) || '%' "���������/�ѻ����"
     , ROUND(���������/�μ������*100, 2) || '%' "���������/�μ������"
FROM
        (
        SELECT BUSEO
             , (SELECT COUNT(*) FROM INSA WHERE  ) �ѻ���� 
             , (SELECT COUNT(*) FROM INSA WHERE BUSEO = T.BUSEO) �μ������
             , GENDER ����
             , COUNT(*) ��������� 
        FROM(
                SELECT BUSEO, NAME, SSN
                     , DECODE(MOD(SUBSTR(SSN,-7,1),2),1,'M','F') GENDER
                FROM INSA
             ) T
        GROUP BY BUSEO, GENDER
        ORDER BY BUSEO, GENDER
        ) S;
        
------ [ LISTAGG (A, '���б�ȣ') WITHIN GROUP (ORDER BY A ) ]

--[������]
--10   CLARK/MILLER/KING
--20   FORD/JONES/SMITH
--30   ALLEN/BLAKE/JAMES/MARTIN/TURNER/WARD
--40  �������  

SELECT DEPTNO, LISTAGG(ENAME, '/') WITHIN GROUP (ORDER BY ENAME DESC)
FROM EMP
GROUP BY DEPTNO;
---------

SELECT DEPTNO, LISTAGG(ENAME, ',') WITHIN GROUP(ORDER BY ENAME DESC)
FROM EMP
GROUP BY DEPTNO
ORDER BY DEPTNO ASC;

--------- �λ����̺��� TOP-N �м��������, �޿� ���� �޴� TOP10 ��ȸ?
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

[������]
DEPTNO ENAME PAY BAR_LENGTH      / 100������ # 1��. �ݿø��Ѱ� (RPAD, LPAD)
---------- ---------- ---------- ----------
30   BLAKE   2850   29    #############################
30   MARTIN   2650   27    ###########################
30   ALLEN   1900   19    ###################
30   WARD   1750   18    ##################
30   TURNER   1500   15    ###############
30   JAMES   950       10    ##########

SELECT DEPTNO, ENAME, SAL+NVL(COMM,0) PAY
     , ROUND((SAL+NVL(COMM,0))/100) || RPAD(' ',ROUND((SAL+NVL(COMM,0))/100) +1,'#') "BAR_LENGTH" -- +1���ֱ�
FROM EMP
WHERE DEPTNO = 30
ORDER BY PAY DESC;

--
SELECT HIREDATE
     , TO_CHAR(HIREDATE, 'WW') -- ���� ���° ��
     , TO_CHAR(HIREDATE, 'IW') -- ���� ���° ��
     , TO_CHAR(HIREDATE, 'W') -- ���� ���° ��?
FROM EMP;

----
SELECT 
     TO_CHAR(TO_DATE('2022.01.01'),'WW')
     ,TO_CHAR(TO_DATE('2022.01.02'),'IW')
FROM DUAL;

-- ������� ���� ���� �μ���(DNAME), �����
-- ������� ���� ���� �μ���, ����� ���

SELECT A.*
FROM (
        SELECT COUNT(I.BUSEO), I.BUSEO
        JOIN INSA I
        ON EMP E
        FROM I.DNAME = E.DNAME
        ) A
WHERE MAX(E.DNAME) AND MIN(E.DNAME);


-- ����, ���̺� 2��. �ܷ�Ű�� DNAME
-- SET ���տ����� / UNION�� �Ἥ Ǫ�°� ���� ����. �ѹ� �غ��°͵�...
-- [INNER] JOIN : �� ���̺��� ����� �κи� ����ϰڴٴ� ��.
-- [LEFT / RIGHT]OUTER JOIN : 
SELECT D.DEPTNO,DNAME, COUNT(EMPNO) CNT
FROM DEPT D 
LEFT OUTER JOIN EMP E -- JOIN�� ����. 
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


---- WITH �� �ϱ�!!------ WITH A AS (), B AS ()
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

-- �Ǻ�(Pivot), ���Ǻ�(unpivot) �ϱ� **
-- �� JOB�� ����� ���

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
-- PIVOT == ���� �߽����� ȸ����Ű��.

-- 2) EMP ���̺��� �� ���� �Ի��� ��� ���� ��ȸ
SELECT *
FROM ( SELECT TO_CHAR(HIREDATE,'YYYY') YEAR
     , TO_CHAR(HIREDATE,'MM') MONTH
        FROM EMP)
PIVOT (COUNT(MONTH) FOR MONTH IN ('01' AS "1��",'02','03','04','05','06','07','08','09','10','11','12'))
ORDER BY YEAR;


-- ����) EMP ���̺��� JOB�� ����� ��ȸ
SELECT *
FROM
        (
        SELECT JOB
        FROM EMP
        )
PIVOT (COUNT(JOB) FOR JOB IN ('CLERK','SALESMAN','PRESIDENT','MANAGER', 'ANALYST'));


-- ����) EMP ���̺��� �μ����� ����, JOB�� ����� ��ȸ / JOIN

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

------------ �� �μ��� �� �޿����� ��ȸ
SELECT *
FROM (
        SELECT DEPTNO, SAL+nvl(COMM,0) PAY
        FROM EMP
        )
PIVOT (
        SUM(PAY) 
        FOR DEPTNO IN ('10','20','30','40')  
        ); -- SUM(A) �� FOR B IN -> A�� B�� ���� �ٸ� �� �ִ�.
        
        
---------- NULL�� ó���� ��� �ϴ°�?
--SELECT *
--FROM (
--SELECT JOB, DEPTNO, SAL, ENAME
--FROM EMP
--      )
--      PIVOT (
--      SUM(SAL) AS �հ�, MAX(SAL) AS �ִ밪 ,MAX(ENAME) AS �ְ���
--      FOR DEPTNO IN ('10','20','30','40')
--      );

-- �Ǻ� ����)
---- �����������, ���� ��������� ��    ���� ������ ���
--            20              30             1

-- **********************************************
SELECT * 
FROM
    (
        SELECT SIGN(TO_DATE(SUBSTR(SSN,3,4),'MMDD') - TRUNC(SYSDATE)) ������
        FROM INSA
             )
PIVOT(
        COUNT(������)
        FOR ������ IN ('1' AS "�����������",'0' AS "���Ͼ��������",'-1' AS "���û�����")
);
-- SIGN�� ����?


-- �μ���ȣ 4�ڸ��� ���
SELECT DEPTNO
     , LPAD(DEPTNO,4,'0')
     , TO_CHAR(DEPTNO, '0999')
FROM DEPT;

-- **********************************************
---- �ϱ�!!! INSA���̺��� �� �μ���/���������/����� ������� ���?

SELECT BUSEO, CITY, COUNT(*) �����
FROM INSA
GROUP BY BUSEO, CITY
ORDER BY BUSEO, CITY;

-- **********************************************

-- [ PARTITION BY OUTER JOIN ] ���� ���! // FROM INSA I PARTITION BY (BUSEO) RIGHT OUTER JOIN C ON I.CITY = C.CITY
WITH C AS (
        SELECT DISTINCT CITY
        FROM INSA
        )
        SELECT BUSEO, C.CITY, COUNT(NUM)
FROM INSA I PARTITION BY (BUSEO) RIGHT OUTER JOIN C ON I.CITY = C.CITY
GROUP BY BUSEO, C.CITY
ORDER BY  BUSEO, C.CITY;

--**********************************************








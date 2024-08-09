
    -- 5. ��� ������
--        1. ������ ���ϴ� ������ : MOD(), REMINDER
--        2. �� ���ϴ� �����Լ� : floor()
    SELECT FLOOR(5/3)
    FROM dual;
    
    
    -- 6. SET(����) ������ : UNION, UNION ALL, INTERSECT, MINUS
    --    1) UNION        : ������
    --    2) UNION ALL    : ������
        
        -- ORA-00937: not a single-group group function => ������ �Լ��� �ƴϴ�. 
        --                     name,buseo ��� count(*)�Լ��� ���� ���� ���Ѵ�.
    
    SELECT COUNT(*) -- 14��
    FROM(
            SELECT name, buseo, city
            FROM insa 
            WHERE buseo = '���ߺ�'
        )  ;
        
    SELECT COUNT(*)  -- 9��
    FROM(
            SELECT name, buseo, city
            FROM insa 
            WHERE city = '��õ'
        )  ;
        

    SELECT name, buseo, city -- 6��
    FROM insa 
    WHERE city = '��õ' AND buseo = '���ߺ�';   
    -- ���ߺ� + ��õ ������
    -- UNION : �ߺ��� �����ʹ� ���� -> �������� ���Ѵ�.
    -- UNION ALL : �ߺ��� ����Ͽ� ������.

            SELECT name, buseo, city -- 17��
            FROM insa 
            WHERE buseo = '���ߺ�'
            -- ORA-00933: SQL command not properly ended : ���� ������ ����� �Ǵ� �� ���̺��� �÷� ���� ����,
            --                                             �����Ǵ� �÷����� ������ Ÿ���� �����ؾ� �Ѵ�.
            UNION ALL
            SELECT name, buseo, city
            FROM insa 
            WHERE city = '��õ'
            ORDER BY buseo, city ; -- ORDER BY�� ���� ��������.
            

    -- 
    SELECT ename, hiredate,TO_CHAR(deptno) n -- deptno || ''
    FROM emp
    UNION
    SELECT name, ibsadate, buseo
    FROM insa;
    
    --JOIN ���
    SELECT ename, hiredate, dname-- TO_CHAR(deptno) n -- deptno || ''
    FROM emp, dept
    WHERE emp.deptno = dept.deptno
    UNION
    SELECT name, ibsadate, buseo
    FROM insa;
    
    -- ���̺� �ȿ� �����͸� �ɰ����� �� : �����ͺ��̽� �𵨸�(����ȭ) => �ߺ��� ���� . . .

    -- ����(join) ���� �ٲ۴ٸ�?
    -- �����ȣ, �����, �Ի�����, �μ���
    -- emp : 
    
    -- �θ����̺�/�ڽ����̺�
    -- FK : �ڽ��� �θ��� key�� �����ϴ°�. => JOIN
    SELECT empno, ename, hiredate, dname, dept.deptno
    FROM emp, dept -- JOIN / �� ���̺��� �����ϰڴ�.
    WHERE emp.deptno = dept.deptno; -- JOIN ����
    
    -- �˸��߽� ���ε� ����.
    SELECT empno, ename, hiredate, dname, d.deptno
    FROM emp e, dept d 
    WHERE e.deptno = d.deptno; -- JOIN ����
    
    -- [ , ] ��� [ A JOIN B ON ]  �� �� �� ����.
    SELECT empno, ename, hiredate, dname, d.deptno
    FROM emp e JOIN dept d ON e.deptno = d.deptno; -- JOIN ����
    

    
    
    

--    3) INTERSECT    : ������
    SELECT name, buseo, city -- 6��
    FROM insa 
    WHERE buseo = '���ߺ�'
    INTERSECT
    SELECT name, buseo, city
    FROM insa 
    WHERE city = '��õ'
    ORDER BY buseo, city ;


--    4) MINUS        : ������
    SELECT name, buseo, city -- 8��
    FROM insa 
    WHERE buseo = '���ߺ�'
    MINUS
    SELECT name, buseo, city
    FROM insa 
    WHERE city = '��õ'
    ORDER BY buseo, city ;
    
    -- ���� UNION �� ����ʹٸ�? : NULL city �ΰ��� �༭ ��Ī�� �ٿ��ش�.
    SELECT name, NULL city,  buseo-- 8��
    FROM insa 
    WHERE buseo = '���ߺ�'
    UNION
    SELECT name, buseo, city
    FROM insa 
    WHERE city = '��õ'
    ORDER BY buseo ;
    
    -- ���� ������ ��� �� ������ �� (����)
    --    1. Į�� �� ���ƾ� ��
    --    2. Ÿ���� �����ؾ� ��
    --    3. Į���̸��� �޶� �������-> ù��° �� Į������ ������.
    --    4. �������̴� ������ ������ �ٿ����Ѵ�.
    

---- [������ ���� ������] : PRIOR, CONNECT_BY_ROOT ������
-- IS [NOT] NAN : NOT A NUMBER ���Ӹ�
-- IS [NOT] INFINITE  : ���Ѵ��? ���� ������



---- [����Ŭ �Լ�(function)]
-- 1) ������ �Լ�
    --��. ���� �Լ�
    -- UPPER(), LOWER(), INITCAP()
    SELECT UPPER (dname), LOWER(dname), INITCAP(dname)
    FROM dept;
    
    -- [LENGTH()] ���ڿ� ����
    SELECT dname
        , LENGTH(dname)
    FROM dept;
    
    -- [SUBSTR()]
    SELECT ssn, SUBSTR(ssn,-7)  -- (ssn,-7,7)�� ����.
    FROM insa
    
    -- [INSTR(a)] : a�� ����ڸ��� �ִ��� ã�� �Լ�.  
    SELECT dname, INSTR(dname,UPPER('s'),2,1) "�ι�° s"
    , INSTR('S','OR',1,2) "s"
            , INSTR(dname,UPPER('s')) "ù��° s"
    FROM dept;
    

    -- 1. ������ȣ�� �����ؼ� ���
    SELECT tel
       
    FROM TBL_TEL;
    -- 2. ��ȭ��ȣ�� ���ڸ�(3~4�ڸ�) ���
    SELECT tel
        , SUBSTR(TEL, 1, INSTR(tel,')')) "������ȣ"
        , SUBSTR(TEL, INSTR(tel,')')+1,  INSTR(tel,'-') - INSTR(tel,')')-1) "���ڸ� 3~4"
        , SUBSTR(TEL, -4, INSTR(tel,'-')) "�� 4��ȣ"
    FROM tbl_tel;
    
    ------- �����ʿ� * ����.
    SELECT RPAD ('Corea', 12 , '*' )
    FROM dual;
    
    SELECT ename, sal + NVL(comm,0) pay
            , RPAD(sal + NVL(comm,0), 10, '*')
    FROM emp;
    
    
    -- *�� ����׷��� �׸��ڴ�.
    select last_name,rpad(' ', salary/1000/1,'*') "Salary" 
    FROM employees
    WHERE department_id = 80
    ORDER BY last_name, "Salary"; 
    --
    SELECT last_name
        , salary ��
        , salary/1000 ��
        , ROUND(salary/1000) �� -- �ݿø�
        , RPAD(' ',ROUND(salary/1000)+1,'*')
    FROM employees;
    
    -- [RTRIM(), LTRIM(), TRIM('a'�� ��������)] : Ư�����ڸ� ����� �Լ�
    SELECT RTRIM('xyBROWINGyxXxy','xy') "RTRIM example" 
         , LTRIM('*****3421','*') "LTRIM *����"
         , LTRIM('    3421',' ') "LTRIM ��������"
         , TRIM('    xx    ')||']'
    FROM dual;
    
    ---- [ASCII()]
    
    SELECT ASCII ('A'), CHR(65)
    FROM dual;
    

    SELECT ename
         , SUBSTR(ename,1,1)
         , ASCII(SUBSTR(ename,1,1)) "ASCII EX"
    FROM emp;
    
    ---- [GREATEST()/LEAST()] : ������ ���� �Ǵ� ���� ��, ���� ū/�������� ��ȯ�ϴ� �Լ�
    
    SELECT GREATEST (3,5,2,4,1) max
         , LEAST (3,5,2,4,1) min
         , GREATEST ('a','b','c','d','e') max
         , LEAST ('a','b','c','d','e') min 
    FROM dual;
    
    ---- [VSIZE()] : ()���� ����� �˷��ִ� �Լ�
    
    SELECT VSIZE(1), VSIZE('A'), VSIZE('��')
    FROM dual;
    
    
    
    -- ��. ���� �Լ� : ���ڰ��� ����
--    ROUND(a[,b]) - �ݿø� �Լ� . 
--          a : ��, b : �ݿø��Ϸ��� �ڸ���
--                  b : ���/���� �Ѵ� ����.
        
    SELECT 3.141592
    ,ROUND(3.141592,0) �� -- 3
    ,ROUND(3.141592,3) �� -- 3.142
    ,ROUND(12345.6789, -2) �� -- 12300 : ������ ������ ����ڸ��� �Ѿ�� �ݿø���.
    FROM dual;
    
    --    [�����Լ� : TRUNC(A[,B]), FLOOR(A[,B]) ������?] -- ��¥�Լ����� ��� ����.
    SELECT FLOOR(3.141592) ��
        , FLOOR(3.99999) ��
        , TRUNC(3.141592,3) �� -- b �ڸ��� �Ҽ��������� �߶�!
        , TRUNC(3.941592,1) �� 
        , TRUNC(12395.6789, -2) �� 
    FROM dual;
    
    --    [�ø�(����)�Լ� : CEIL(A)]
    SELECT CEIL(3.14) �� , CEIL(3.99) �� -- �׳� �÷��� ����.
    FROM dual;
    
    -- �Խ��� : �ѰԽñۼ� ������ �����⿡ CEIL() ��� ����.
    SELECT CEIL(161/10)
        , ABS(-10), ABS(10) -- ABS() : ���� ���ϴ� �Լ�.
        
    FROM dual;
    
    -- SIGN(n) �Լ� : n�� ���� 0���� ũ�� 1 / 0�̸� 0 / 0���� ������ -1 ��ȯ.
    SELECT SIGN(95) ���
        , SIGN(0)
        , SIGN(-111) ����
        , SIGN(3.14) �Ǽ�
    FROM dual;
    
    -- POWER(a,b) : a��b�� �� ���
    SELECT POWER(2,3) "a�� b��"
        , SQRT(2) "a�� ������ ��"
    FROM dual;
    
    -- ��. ��¥ �Լ� : SYSDATE / ROUND / TRUNC 
    
    -- [�ݿø� ROUND()]
   SELECT SYSDATE "SYSDATE"-- ������ ��¥+�ð�(��)�� �����ϴ� �Լ�
        , ROUND(SYSDATE) "ROUND" -- ���� �������� ��¥�� �ݿø� ��.
        , ROUND(SYSDATE, 'YEAR') A -- 1���� ���� ��������?
        , ROUND(SYSDATE, 'DD') B -- �⺻�� DD��
        , ROUND(SYSDATE, 'MONTH') C -- 15���� �������� �ݿø�.
        , ROUND(SYSDATE, 'CC') D -- �� ����
   FROM dual;
   
   -- [���� TRUNC()]
   SELECT SYSDATE
        , TO_CHAR(SYSDATE,'DS TS') a
        , TRUNC(SYSDATE) b
        , TO_CHAR(TRUNC(SYSDATE),'DS TS') c -- 0�� 0�� 0�ʷ� ����.
        , TO_CHAR(TRUNC(SYSDATE, 'DD'),'DS TS') d -- ""
        , TRUNC(SYSDATE, 'MONTH') f -- �޿��� ����, MM
        , TRUNC(SYSDATE, 'YEAR') g -- �⿡�� ����, YY
        , TRUNC(SYSDATE, 'MM')
   FROM DUAL;
    
    
    -- [��¥]�� [���������]�� ����ϴ� ���
    
    SELECT SYSDATE
         , SYSDATE +7 "����"
         , SYSDATE -7 "1��"
         , SYSDATE - 2/24 "�ð�"
         , SYSDATE - SYSDATE - 13
    FROM dual;
    
    -- �Ի��� �ٹ��ϼ�?
    SELECT ename, hiredate
         , CEIL(SYSDATE - hiredate)+1 "�ٹ��ϼ�"
    FROM emp;
    
    -- ������ �����ϼ�?
    SELECT ename, '2024/07/01'
         , TRUNC (SYSDATE) - TRUNC (TO_DATE('2024/07/01')) + 1 "�����ϼ�"
    FROM emp;
    
    -- [MONTHS_BETWEEN()] �� ��¥�� ��¥���� ���ϴ� �Լ�
    
    
    SELECT ename, hiredate, SYSDATE
         , MONTHS_BETWEEN( SYSDATE, hiredate ) �ٹ�������
         , MONTHS_BETWEEN( SYSDATE, hiredate ) / 12 �ٹ����
    FROM emp;
    
    -- [ADD_MONTHS()] : �Ѵ� ����
    SELECT SYSDATE
         , ADD_MONTHS(SYSDATE, 1)   "1������"
         , ADD_MONTHS(SYSDATE, -1)   "1����"
         , ADD_MONTHS(SYSDATE, 12)  "1������"
         , ADD_MONTHS(SYSDATE, -12)  "1����"
    FROM dual;
    
    -- [LAST_DAY()] : �� ���� ������ ��
    
    SELECT SYSDATE
         , LAST_DAY(SYSDATE) "�̹����� ��������"
         , to_CHAR(LAST_DAY(SYSDATE), 'DD') "������ �� ����"
         , TRUNC(SYSDATE, 'MONTH') "�̹����� ù��"
         , TO_CHAR(TRUNC(SYSDATE, 'MONTH'), 'DAY') "����?"
         , ADD_MONTHS(TRUNC(SYSDATE, 'MONTH'), 1) 
    FROM dual;
    
    -- [NEXT_DAY()] : ���ƿ��� ������ ��¥
    SELECT SYSDATE
         , NEXT_DAY(SYSDATE, '��')
         , NEXT_DAY(SYSDATE, '��') +7 -- �ٴ����ֶ��?
    FROM dual;
    
    -- 10�� ù��° �������� �ް��̶��?
    
    SELECT SYSDATE
        , NEXT_DAY(ADD_MONTHS(TRUNC(SYSDATE, 'MONTH'),2),'��')
        , NEXT_DAY(TO_DATE('24/10/01'),'��') 
    FROM dual;
    
    --
    
    SELECT SYSDATE, CURRENT_DATE
         , CURRENT_TIMESTAMP
    FROM dual;
    
    -- ��. ��ȯ �Լ� : TO_DATE, TO_CHAR, TO_NUMBER
    
    SELECT '1234'
         , TO_NUMBER('1234')
    FROM dual;
    
    
    -- TO_CHAR(NUMBER) / TO_CHAR(CHAR) / TO_CHAR(DATE) :���ڷ� ��ȯ�ϴ� �Լ�
    
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
         , TO_CHAR(-100, '9999PR') -- ������ ��� <>���� ���
    FROM DUAL;
    
    SELECT ENAME, TO_CHAR((SAL+NVL(COMM,0))*12, 'L999G999G999') PAY -- ����
    FROM EMP;
    
    --
    
    
    SELECT NAME, IBSADATE
         , TO_CHAR(IBSADATE, 'YYYY''MM''DD')
         , TO_CHAR(IBSADATE, 'YYYY"��" MM"��" DD"��" DAY') -- "���ڿ�"
         
    FROM INSA;
    
    
    SELECT ENAME, sal, comm
         , SAL + NVL(COMM,0) PAY
         , SAL + NVL2(COMM,COMM,0) PAY
         , COALESCE(sal+comm,sal,0) P -- null�� �ƴ� ��� �� ���� �����Ѵ�.
    FROM EMP;
    
    -- DECODE �Լ� *********
    -- IF���� ����.
    -- FROM�� �ܿ� ��� ��� ����
    -- �� ������ = �� �����ϴ�.
    -- DECODE�Լ��� Ȯ���Լ� : CASE
    
    SELECT NAME, SSN
        -- , NVL2(NULLIF(MOD(SUBSTR(ssn,-7,1),2),1), '��','��' ) g
          ,DECODE(SUBSTR(ssn,-7,1),1,'��',2,'��') gender
          ,DECODE(MOD(SUBSTR(ssn,-7,1),2),0,'��','��') -- �� 0�� ����?
    FROM INSA;
    
    -- ����) emp ���̺��� sal�� 10% �λ��� ����.
    SELECT ename,sal+(sal*0.1) sal
         , sal *1.1 sal
    FROM emp;
    
    -- ����) emp���̺��� 10�� �μ����� 15% pay �λ�, 20�� �μ����� 10% �λ�, �� �� �μ����� 20% �λ�.
    SELECT deptno, ename, NVL(comm,0) comm, sal, sal+NVL(comm,0) pay
         , DECODE( deptno,10,(sal+NVL(comm,0))*1.15
                        , 20, (sal+NVL(comm,0))*1.1
                        , (sal+NVL(comm,0))*1.2 ) "�޿��λ�"
                        
        ,(sal+NVL(comm,0)) * DECODE( deptno,10,1.15
                        , 20,1.1,1.2 ) -- �Լ� �տ� ���� ���� �� �ִ� ������ ����?
    FROM emp;
    
    -- CASE �Լ� *********
    
    CASE �÷���|ǥ���� WHEN ����1 THEN ���1
          [WHEN ����2 THEN ���2
                            ......
           WHEN ����n THEN ���n
          ELSE ���4]
	END


    SELECT NAME, SSN
          ,DECODE(MOD(SUBSTR(ssn,-7,1),2),0,'��','��') 
          ,CASE MOD(SUBSTR(ssn,-7,1),2) WHEN 1 THEN '����'
                                        -- WHEN 0 THEN '��'�̰͵� ����
                                        ELSE '����'
          END gender
    FROM INSA; 
  
  ------  
    
       SELECT deptno, ename, NVL(comm,0) comm, sal, sal+NVL(comm,0) pay
         , DECODE( deptno,10,(sal+NVL(comm,0))*1.15
                        , 20, (sal+NVL(comm,0))*1.1
                        , (sal+NVL(comm,0))*1.2 ) "�޿��λ�"
        ,CASE deptno WHEN 10 THEN (sal+NVL(comm,0))*1.15
                    WHEN 20 THEN (sal+NVL(comm,0))*1.1
                    ELSE (sal+NVL(comm,0))*1.2 
        END "�λ�����"
    FROM emp;
    
    -- ��. �Ϲ� �Լ�

-- 2) ������ �Լ� (�׷� �Լ�)
-- �����Լ� : �����Լ� ���� ��Ҵ� �ߺ����� ���� ���Ѵ�.
    -- null�� �����ϱ� ������, null�� �ٲ��ִ� �۾� �ؾ���.
    SELECT COUNT(*),COUNT(ename), COUNT(comm), COUNT(sal)
         -- , sal
         , SUM(sal)
         , SUM(comm)/COUNT(*) "AVG comm"
         , AVG(comm) -- null�� ��տ��� �ڵ����� ������ -> ������ 4 �Ѱ���.
         , MAX(sal)
         , MIN(sal)
    FROM emp;
    
    
    -- �� �μ��� ����� ��ȸ : ���� �μ����� ���ؼ� �� �μ��ο��� ��ȸ
    
    
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






    
    
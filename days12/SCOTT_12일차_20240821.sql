SELECT * FROM t_member; -- ȸ��
SELECT * FROM t_poll; -- ����
SELECT * FROM t_pollsub; -- �����׸�
SELECT * FROM t_voter; -- ��ǥ��

-- t_����� pkŰ
SELECT *  
FROM user_constraints  
WHERE table_name LIKE 'T_M%'  AND constraint_type = 'P';

-- ȸ������
INSERT INTO   T_MEMBER (  MEMBERSEQ,MEMBERID,MEMBERPASSWD,MEMBERNAME,MEMBERPHONE,MEMBERADDRESS )
VALUES                 (  1,         'admin', '1234',  '������', '010-1111-1111', '���� ������' );
INSERT INTO   T_MEMBER (  MEMBERSEQ,MEMBERID,MEMBERPASSWD,MEMBERNAME,MEMBERPHONE,MEMBERADDRESS )
VALUES                 (  2,         'hong', '1234',  'ȫ�浿', '010-1111-1112', '���� ���۱�' );
INSERT INTO   T_MEMBER (  MEMBERSEQ,MEMBERID,MEMBERPASSWD,MEMBERNAME,MEMBERPHONE,MEMBERADDRESS )
VALUES                 (  3,         'kim', '1234',  '���ؼ�', '010-1111-1341', '��� �����ֽ�' );
    COMMIT;
    rollback;
--
--  ��. ȸ�� ���� ����
--  �α��� -> (ȫ�浿) -> [�� ����] -> �� ���� ���� -> [����] -> [�̸�][][][][][][] -> [����]
--  PL/SQL
  UPDATE T_MEMBER
  SET    MEMBERNAME = , MEMBERPHONE = 
  WHERE MEMBERSEQ = 2;
--  ��. ȸ�� Ż��
  DELETE FROM T_MEMBER 
  WHERE MEMBERSEQ = 2;
--
   INSERT INTO T_POLL (PollSeq,Question,SDate, EDAte , ItemCount,PollTotal, RegDate, MemberSEQ )
   VALUES             ( 1  ,'�����ϴ� �����?'
                          , TO_DATE( '2024-02-01 00:00:00'   ,'YYYY-MM-DD HH24:MI:SS')
                          , TO_DATE( '2024-02-15 18:00:00'   ,'YYYY-MM-DD HH24:MI:SS') 
                          , 5
                          , 0
                          , TO_DATE( '2023-01-15 00:00:00'   ,'YYYY-MM-DD HH24:MI:SS')
                          , 1
                    );
INSERT INTO T_PollSub (PollSubSeq          , Answer , ACount , PollSeq  ) 
VALUES                (1 ,'�载��', 0, 1 );
INSERT INTO T_PollSub (PollSubSeq          , Answer , ACount , PollSeq  ) 
VALUES                (2 ,'�����', 0, 1 );
INSERT INTO T_PollSub (PollSubSeq          , Answer , ACount , PollSeq  ) 
VALUES                (3 ,'������', 0, 1 );
INSERT INTO T_PollSub (PollSubSeq          , Answer , ACount , PollSeq  ) 
VALUES                (4 ,'�輱��', 0, 1 );
INSERT INTO T_PollSub (PollSubSeq          , Answer , ACount , PollSeq  ) 
VALUES                (5 ,'ȫ�浿', 0, 1 );      
   COMMIT;                    

-- ��ǥ������ �׸� �߰�
   INSERT INTO T_POLL (PollSeq,Question,SDate, EDAte , ItemCount,PollTotal, RegDate, MemberSEQ )
   VALUES             ( 2  ,'�����ϴ� ����?'
                          , TO_DATE( '2024-08-12 00:00:00'   ,'YYYY-MM-DD HH24:MI:SS')
                          , TO_DATE( '2024-08-28 18:00:00'   ,'YYYY-MM-DD HH24:MI:SS') 
                          , 4
                          , 0
                          , TO_DATE( '2024-02-20 00:00:00'   ,'YYYY-MM-DD HH24:MI:SS')
                          , 1
                    );

INSERT INTO T_PollSub (PollSubSeq          , Answer , ACount , PollSeq  ) 
VALUES                (6 ,'�ڹ�', 0, 2 );
INSERT INTO T_PollSub (PollSubSeq          , Answer , ACount , PollSeq  ) 
VALUES                (7 ,'����Ŭ', 0, 2 );
INSERT INTO T_PollSub (PollSubSeq          , Answer , ACount , PollSeq  ) 
VALUES                (8 ,'HTML5', 0, 2 );
INSERT INTO T_PollSub (PollSubSeq          , Answer , ACount , PollSeq  ) 
VALUES                (9 ,'JSP', 0, 2 );
   
   COMMIT;
--
   INSERT INTO T_POLL (PollSeq,Question,SDate, EDAte , ItemCount,PollTotal, RegDate, MemberSEQ )
   VALUES             ( 3  ,'�����ϴ� ��?'
                          , TO_DATE( '2024-09-01 00:00:00'   ,'YYYY-MM-DD HH24:MI:SS')
                          , TO_DATE( '2024-09-15 18:00:00'   ,'YYYY-MM-DD HH24:MI:SS') 
                          , 3
                          , 0
                          , TO_DATE( '2024-03-01 00:00:00'   ,'YYYY-MM-DD HH24:MI:SS')
                          , 1
                    );
INSERT INTO T_PollSub (PollSubSeq          , Answer , ACount , PollSeq  ) 
VALUES                (10 ,'����', 0, 3 );
INSERT INTO T_PollSub (PollSubSeq          , Answer , ACount , PollSeq  ) 
VALUES                (11 ,'���', 0, 3 );
INSERT INTO T_PollSub (PollSubSeq          , Answer , ACount , PollSeq  ) 
VALUES                (12 ,'�Ķ�', 0, 3 ); 
   
   COMMIT;
--
SELECT *
FROM (
    SELECT  pollseq ��ȣ, question ����, membername �ۼ���
         , sdate ������, edate ������, itemcount �׸��, polltotal �����ڼ�
         , CASE 
              WHEN  SYSDATE > edate THEN  '����'
              WHEN  SYSDATE BETWEEN  sdate AND edate THEN '���� ��'
              ELSE '���� ��'
           END ���� -- ����Ӽ�   ����, ���� ��, ���� ��
    FROM t_poll p JOIN  t_member m ON m.memberseq = p.memberseq
    ORDER BY ��ȣ DESC
) t 
WHERE ���� != '���� ��';  
-- �����󼼺���?
SELECT question, membername
               , TO_CHAR(regdate, 'YYYY-MM-DD AM hh:mi:ss')
               , TO_CHAR(sdate, 'YYYY-MM-DD')
               , TO_CHAR(edate, 'YYYY-MM-DD')
               , CASE 
                  WHEN  SYSDATE > edate THEN  '����'
                  WHEN  SYSDATE BETWEEN  sdate AND edate THEN '���� ��'
                  ELSE '���� ��'
               END ����
               , itemcount
           FROM t_poll p JOIN t_member m ON p.memberseq = m.memberseq
           WHERE pollseq = 2;
-- �����׸� �������� ����
SELECT answer
           FROM t_pollsub
           WHERE pollseq = 2;
-- �� �����ڼ� ���?
SELECT  polltotal  
    FROM t_poll
    WHERE pollseq = 2;
    
-- ����׷��� �׸���
SELECT answer, acount
        , ( SELECT  polltotal      FROM t_poll    WHERE pollseq = 2 ) totalCount
        -- ,  ����׷���
        , ROUND (acount /  ( SELECT  polltotal      FROM t_poll    WHERE pollseq = 2 ) * 100) || '%'
     FROM t_pollsub
    WHERE pollseq = 2;
    
    

--
 INSERT INTO t_voter 
    ( vectorseq, username, regdate, pollseq, pollsubseq, memberseq )
    VALUES
    (      2   ,  'ȫ�浿'      , SYSDATE,   2  ,     6 ,        2 );
    COMMIT;
--
  -- 1)         2/3 �ڵ� UPDATE  [Ʈ����]
    -- (2) t_poll   totalCount = 1����
    UPDATE   t_poll
    SET polltotal = polltotal + 1
    WHERE pollseq = 2;
    
    -- (3)t_pollsub   account = 1����
    UPDATE   t_pollsub
    SET acount = acount + 1
    WHERE  pollsubseq = 6;
    
    commit;




-- PL/SQL ����

-- PL/SQL�̶�?
-- ���, ������ ���� ����Ŭ���� ����� �� �ְ� ����.
-- ��� ������ �Ǿ�����.
-- ����κ� / ����κ� / ����ó���κ� => �� 3�κ�
-- ��� �������� �׷��Լ� ���� ��� �Ұ�



--DECLARE

BEGIN -- �ʼ�
    /*
    select
    UPDATE
    SELECT
    DELETE
    INSERT . . . DML�� �ۼ�����.
    
    */

--EXCEPTION

END; -- �ʼ�


-- 1) Anonymous Procedure (�͸� ���ν���)
DECLARE
    -- ����, ��� ���� �� (v�� �ٿ�����.)
    vename VARCHAR2(10); -- �����ݷ� �ʼ�!!!!!!!
    vpay NUMBER;
    -- �ڹ� ��� ���� : FINAL double PI = 3.141592;
    -- ����Ŭ ��� ���� : 
--    vpi CONSTRAINT NUMBER = 3.141592;
      vpi CONSTANT NUMBER := 3.14;
BEGIN
    SELECT ename, sal+NVL(comm,0) pay
            INTO vename, vpay -- SELECT, PATCH���� "INTO" ����Ͽ� ������ ~���� �Ҵ�.
    FROM emp;
    -- WHERE empno = 7369;
    -- ORA-01422: exact fetch returns more than requested number of rows
    -- �������� : Ŀ�� (CURSOR) ����ؾ���. // �� �� �̻��� ���ڵ尡 ���ɶ�.
    
    -- �����? DBMS_OUTPUT ~
    DBMS_OUTPUT.PUT_LINE(vename || ', ' || vpay );
--EXCEPTION
END;
-- PL/SQL ���ν����� ���������� �Ϸ�Ǿ����ϴ�.



-- ����) dept ���̺��� 
-- 30�� �μ��� �μ����� ���ͼ� ����ϴ�  �͸����ν����� �ۼ�,�׽�Ʈ
DESC DEPT;
DECLARE
--    vdname VARCHAR2(14);
    vdname dept.dname%TYPE; -- plsql������ �̷��� �����. -> ���� �ڷ���ũ�Ⱑ �ٲ�� ������ ���� �ٲ���ϱ⶧��. 
--    vdeptno NUMBER(2);
BEGIN
    SELECT dname INTO vdname
    FROM DEPT
    WHERE deptno = 30;
    DBMS_OUTPUT.PUT_LINE(vdname);
--EXCEPTION
END;


-- ����) dept ���̺��� 
-- 30�� �μ��� �μ����� ���ͼ� 10���μ��� ������������ ����

DECLARE
    VLOC dept.loc%TYPE;
    
BEGIN
    SELECT loc INTO vloc
    FROM dept
    WHERE deptno = 30;
    
    UPDATE dept
    SET loc = vloc
    WHERE deptno = 10;
    
--    COMMIT;
    ROLLBACK;
    
    
--    DBMS_OUTPUT.PUT_LINE(vloc);
END;

SELECT * FROM dept;

--10�� �μ����߿� �ְ�޿� sal�� �޴� ����� ������ ���
SELECT t.*
FROM 
    (SELECT ename, empno, job, sal,  MAX(sal)
    FROM emp
    WHERE deptno = 10
    GROUP BY  ename, empno, job, sal
    ORDER BY sal desc) t
WHERE ROWNUM = 1;

-- 4) PL/SQL ���� ó��.
DECLARE
    VMAX_SAL_10     emp.sal%TYPE;
    vename          emp.ename%TYPE;
    vempno          emp.empno%TYPE;
    vjob            emp.job%TYPE;
    vhiredate        emp.hiredate%TYPE;
    vdeptno          emp.deptno%TYPE;
    vsal            emp.sal%TYPE;
BEGIN
    -- 1.
    SELECT MAX(sal) INTO VMAX_SAL_10
    FROM emp
    WHERE deptno = 10;
    
    -- 2.
    SELECT empno, ename, job, sal, hiredate, deptno INTO vempno, vename, vjob, vsal, vhiredate, vdeptno
    FROM emp
    WHERE sal = VMAX_SAL_10 AND deptno = 10;
    
    DBMS_OUTPUT.PUT_LINE( '�����ȣ : ' || VEMPNO );
    DBMS_OUTPUT.PUT_LINE( '����� : ' || VENAME );
    DBMS_OUTPUT.PUT_LINE( '�Ի����� : ' || VHIREDATE );
--EXCEPTION

END;

-- 5) ROWTYPE

DECLARE
    VMAX_SAL_10     emp.sal%TYPE;
--    vename          emp.ename%TYPE;
--    vempno          emp.empno%TYPE;
--    vjob            emp.job%TYPE;
--    vhiredate        emp.hiredate%TYPE;
--    vdeptno          emp.deptno%TYPE;
--    vsal            emp.sal%TYPE;
    vemprow     emp%ROWTYPE; -- emp�� ��� Į���� ������ �� �ִ� ����
BEGIN
    -- 1.
    SELECT MAX(sal) INTO VMAX_SAL_10
    FROM emp
    WHERE deptno = 10;
    
    -- 2.
    SELECT empno, ename, job, sal, hiredate, deptno 
    INTO vemprow.empno, vemprow.ename, vemprow.job, vemprow.sal, vemprow.hiredate, vemprow.deptno 
    -- ����ϰ��� �ϴ°Ϳ� vemprow. ���̸� ��.
    FROM emp
    WHERE sal = VMAX_SAL_10 AND deptno = 10;
    
    DBMS_OUTPUT.PUT_LINE( '�����ȣ : ' || vemprow.EMPNO ); -- ���⵵ ����
    DBMS_OUTPUT.PUT_LINE( '����� : ' || vemprow.ENAME );
    DBMS_OUTPUT.PUT_LINE( '�Ի����� : ' || vemprow.HIREDATE );
--EXCEPTION

END;

--  := ���Կ�����
DECLARE
    va NUMBER := 1;
    vb NUMBER;
    vc NUMBER := 0;
BEGIN
    vb := 100;
    vc := va + vb;
    DBMS_OUTPUT.PUT_LINE(vc);
--EXCEPTION
END;

-- PL/SQL ���
IF (���ǽ�)(
    //
    //
)

IF ���ǽ� THEN -- (
-- if�� ���ǽ� ��ȣ ���� ����
END IF; -- )


IF ���ǽ� THEN
--
ELSE
--
END IF;


IF ���ǽ� (

)ELSE IF (
)ELSE IF (
)ELSE  (
)

-- ����Ŭ������ ifelse
IF ���ǽ� THEN (
)
ELSIF ���ǽ� THEN (
)
ELSIF ���ǽ� THEN (
)
END IF;


DECLARE
    vnum NUMBER(4) := 0;
    vresult VARCHAR2(6) := 'Ȧ��';
BEGIN
    vnum := :bindNumber; -- ���ε庯�� / �츮�� ���� �Է� ����
    IF MOD(vnum,2)=0 THEN
    vresult := '¦��';
    ELSE
    vresult := 'Ȧ��';
    END IF;
    DBMS_OUTPUT.PUT_LINE(vresult);
END;

-- [����] PL/SQL   IF�� ��������...
--  �������� �Է¹޾Ƽ� ����̾簡 ��� ���... ( �͸����ν��� )
DECLARE
    vkor NUMBER(3) := 0;
    vresult VARCHAR2(3) := '��';
BEGIN
    vkor := :bindNumber;
    IF   vkor >= 90 THEN vresult := '��';
    ELSIF vkor < 90 and vkor >= 80 THEN vresult := '��';
    ELSIF vkor < 80 and vkor >= 70 THEN vresult := '��';
    ELSIF vkor < 70 and vkor >= 60 THEN vresult := '��';
    ELSIF vkor < 60 THEN vresult := '��';
    END IF;
    DBMS_OUTPUT.PUT_LINE(vresult);
END;  

--

DECLARE
    vkor NUMBER(3) := 0;
    vresult VARCHAR2(3) := '��';
BEGIN
    vkor := :bindNumber;
    IF  (vkor BETWEEN 0 AND 100)  THEN 
    vresult := CASE TRUNC(vkor/10)
                WHEN 10 THEN '��'
                WHEN 9 THEN '��'
                WHEN 8 THEN '��'
                WHEN 7 THEN '��'
                WHEN 6 THEN '��'
                ELSE '��'
                END;
                DBMS_OUTPUT.PUT_LINE(vresult);
    
    ELSE DBMS_OUTPUT.PUT_LINE('���� 0~100 �Է�!!');
    END IF;
    
    
END;  
-----------------------
-- �ڹ� : while (���ǹ�)(
-- //
-- )

-- plsql
WHILE (���ǽ�) LOOP -- (
END LOOP; -- )



 -- ������ �ݺ��۾��ϴ� �� -> �ڹ��� WHILE IF BREAK ���� ����.
LOOP
    --
    --
    --
    EXIT WHEN (���ǽ�);
END LOOP;

-- ����) 1~10������ ��.
DECLARE
    vnum NUMBER(2) := 1;
    vsum NUMBER(2) := 0;
BEGIN
    WHILE  vnum <=10  LOOP
    vsum := vsum + vnum;
    vnum := vnum + 1;
    END LOOP;
    DBMS_OUTPUT.PUT_LINE(vsum);

END;

--
DECLARE
    vnum NUMBER(2) := 1;
    vsum NUMBER(2) := 0;
BEGIN
    WHILE  vnum <=10  LOOP
    IF vnum = 10 THEN
    DBMS_OUTPUT.PUT_LINE('+' || vsum);
    ELSE 
    DBMS_OUTPUT.PUT_LINE('=' || vsum);
    end if;
    vsum := vsum + vnum;
    vnum := vnum + 1;
    
    END LOOP;
--    DBMS_OUTPUT.PUT_LINE(vsum);

END;

-- 1~10 �� ��� : plsql for�����
DECLARE
--    vi number ; -- for���� �ݺ������� �������� �ʾƵ� �ȴ�.
    vsum number := 0;
BEGIN
    FOR vi IN 1..10
    LOOP
        DBMS_OUTPUT.PUT(vi || '+');
        vsum := vsum + vi;
    END LOOP;
    DBMS_OUTPUT.PUT_LINE( '=' || vsum);
END;

-- GOTO�� (�߾Ⱦ�, �Ⱦ��°�����)
declare 
      chk number := 0; 
begin 
      <<restart>> 
--      dbms_output.enable; 
      chk := chk +1; 
      dbms_output.put_line(to_char(chk)); 
      if chk <> 5 then -- 5�ϰ� �ٸ���? : ��
      goto restart; -- ���̸� �ٽ� ���ư�.
    end if; -- �����̸� ����.
end; 

--
--DECLARE
BEGIN
  --
  GOTO first_proc;
  --
  <<second_proc>>
  DBMS_OUTPUT.PUT_LINE('> �� ó�� ');
  GOTO third_proc; 
  -- 
  --
  <<first_proc>>
  DBMS_OUTPUT.PUT_LINE('> �� ó�� ');
  GOTO second_proc; 
  -- 
  --
  --
  <<third_proc>>
  DBMS_OUTPUT.PUT_LINE('> �� ó�� '); 
--EXCEPTION
END;

-- ����) ������ ����Ͽ� ������ 2~9�� ��� (����/���� �����)
-- 2 X 1 = 2
DECLARE
    vsum NUMBER := 0;
BEGIN
    FOR vi IN 2..9
    LOOP
        FOR vj in 1..9
        LOOP
            vsum := vi * vj;
            DBMS_OUTPUT.PUT_LINE(vi || 'x' || vj || '=' || vsum);
            
        END LOOP;
        DBMS_OUTPUT.PUT_LINE(''); -- ����
    END LOOP;
END;

-- ����
DECLARE
    vsum NUMBER := 0;
BEGIN
    FOR vi IN 2..9
    LOOP
        FOR vj IN 1..9
        LOOP
            vsum := vi * vj;
            DBMS_OUTPUT.PUT_LINE( vi || 'x' || vj || '=' || vsum );
            
        END LOOP;
        DBMS_OUTPUT.PUT_LINE('');
    END LOOP;
END;





-- for���� ����� select (����ϱ�)
DECLARE
BEGIN
    --    FOR �ݺ�����I IN [REVERSE] ���۰�..���� LOOP
    FOR verow IN (SELECT ename, hiredate, job FROM emp) LOOP
    DBMS_OUTPUT.PUT_LINE( verow.ename || '/' || verow.hiredate || '/' || verow.job);
    END LOOP;
END;
--

-- %TYPE����, %ROWTYPE����, 
SELECT D.DEPTNO, ENAME, EMPNO, SAL+NVL(COMM,0) PAY
FROM DEPT D JOIN EMP E ON D.DEPTNO = E.DEPTNO
WHERE EMPNO = 7369;

-- %TYPE���� ����غ���.
DECLARE
    vDEPTNO dept.deptno%TYPE;
    vdname dept.dname%type;
    vENAME emp.ename%type;
    vEMPNO emp.empno%type;
    vPAY NUMBER;
BEGIN
    SELECT D.DEPTNO, dname, ENAME, EMPNO, SAL+NVL(COMM,0) PAY
        INTO vDEPTNO, vdname, vENAME, vEMPNO, vPAY
    FROM DEPT D JOIN EMP E ON D.DEPTNO = E.DEPTNO
    WHERE EMPNO = 7369;
    DBMS_OUTPUT.PUT_LINE( vDEPTNO || ', ' || vdname || ', ' || vENAME || ', ' || vEMPNO || ', ' || vPAY );
END;

-- [ %ROWTYPE ���� ]
DECLARE
    verow emp %ROWTYPE;
    vdrow dept %ROWTYPE;
    vPAY NUMBER;
BEGIN
    SELECT D.DEPTNO, dname, ENAME, EMPNO, SAL+NVL(COMM,0) PAY
           INTO vdrow.DEPTNO, vdrow.dname, verow.ENAME, verow.EMPNO, vPAY
    FROM DEPT D JOIN EMP E ON D.DEPTNO = E.DEPTNO
    WHERE EMPNO = 7369;
    DBMS_OUTPUT.PUT_LINE( vdrow.DEPTNO || ', ' || vdrow.dname || ', ' || verow.ENAME || ', ' || verow.EMPNO || ', ' || vPAY );
END;

-- D.DEPTNO, dname, ENAME, EMPNO, SAL+NVL(COMM,0) PAY
-- RECORD �� ���� : ���� �÷������� ������ ���ڵ�(��) ����
-- == ����ڰ� �����ϴ� ����ü Ÿ�� ����
DECLARE
    TYPE EmpDeptType IS RECORD 
    (
        DEPTNO dept.deptno %TYPE, 
        dname dept.dname %TYPE, 
        ENAME emp.ename %TYPE, 
        EMPNO emp.empno %TYPE, 
        PAY NUMBER
    );
    vedrow EmpDeptType;
BEGIN
    SELECT D.DEPTNO, dname, ENAME, EMPNO, SAL+NVL(COMM,0) PAY
           INTO vedrow.DEPTNO, vedrow.dname, vedrow.ENAME, vedrow.EMPNO, vedrow.PAY
    FROM DEPT D JOIN EMP E ON D.DEPTNO = E.DEPTNO
    WHERE EMPNO = 7369;
    DBMS_OUTPUT.PUT_LINE( vedrow.DEPTNO || ', ' || vedrow.dname || ', ' || vedrow.ENAME || ', ' || vedrow.EMPNO || ', ' || vedrow.PAY );
END;


-- ���� ) insa basic+sudang = pay / 0.025
DECLARE
    vname insa.name%type;
    vpay number;
    vtax number;
    vsil number;
BEGIN 
    SELECT name, basicpay+sudang pay INTO vname, vpay
    FROM insa
    WHERE num = 1001;
    IF vpay >= 2500000 THEN vtax := vpay * 0.025;
    ELSIF vpay >= 2000000 THEN vtax := vpay * 0.02;
    ELSE vtax := 0;
    END IF;
    vsil := vpay - vtax;
    DBMS_OUTPUT.PUT_LINE(vname || ' ' || vpay  || ' ' ||  vtax  || ' ' || vsil);
END;

-- Ŀ��( cursor )��? : PL/SQL���� SELECT�� ������� �����ϴ� ����.
-- �ᱣ���� 1���� �ڵ����� ���������,
-- 2�� �̻��̸� Ŀ���� ����ؾ��Ѵ�.
DECLARE
    TYPE EmpDeptType IS RECORD 
    (
        DEPTNO dept.deptno %TYPE, 
        dname dept.dname %TYPE, 
        ENAME emp.ename %TYPE, 
        EMPNO emp.empno %TYPE, 
        PAY NUMBER
    );
    vedrow EmpDeptType;
    -- 1) Ŀ�� ����
    CURSOR vdecursor IS (SELECT D.DEPTNO, dname, ENAME, EMPNO, SAL+NVL(COMM,0) PAY
                      FROM DEPT D JOIN EMP E ON D.DEPTNO = E.DEPTNO
                      );
BEGIN
    -- 2) Ŀ�� ���� == select�� ����
    OPEN vdecursor; -- CTRL + ENTER
    
    -- 3) FETCH -- ��������
    LOOP 
        FETCH vdecursor INTO vedrow;
        EXIT WHEN vdecursor%NOTFOUND;
         DBMS_OUTPUT.PUT_LINE( vedrow.DEPTNO || ', ' || vedrow.dname || ', ' || 
         vedrow.ENAME || ', ' || vedrow.EMPNO || ', ' || vedrow.PAY );
    END LOOP;
    
    -- 4) Ŀ�� CLOSE
    CLOSE VDECURSOR;
END;

---- FOR���� ����ϴ� �Ͻ��� Ŀ�� ---- �����Ǵ°� ���Ƽ� ���� ������.
BEGIN
    FOR vedrow IN (SELECT D.DEPTNO, dname, ENAME, EMPNO, SAL+NVL(COMM,0) PAY
                      FROM DEPT D JOIN EMP E ON D.DEPTNO = E.DEPTNO
                      ) LOOP
     DBMS_OUTPUT.PUT_LINE( vedrow.DEPTNO || ', ' || vedrow.dname || ', ' || 
         vedrow.ENAME || ', ' || vedrow.EMPNO || ', ' || vedrow.PAY );
    END LOOP;
END;
























-- [ ���� ���ν����� ���� ] --
CREATE OR REPLACE PROCEDURE ���ν�����;
(
    �Ű����� (argument, parameter) ����, -- �Ű����� ĭ���� , ���� / Ÿ��ũ�� ����X
    p�Ű�������  [mode] �ڷ��� -- �տ� p�� ���̰ڴ�.
                  IN �Է¿� �Ķ���� (�⺻���)
                  OUT ��¿� �Ķ����
                  IN OUT ��/��¿� �Ķ����
)
IS -- DECLARE
    ����/��� ����;
    v
BEGIN
END;

-- ���� ���ν����� �����ϴ� ��� 3���� --
--1) EXECUTE ������ ����
--2) �͸� ���ν������� ȣ���Ͽ� ����
--3) �� �ٸ� ���� ���ν������� ȣ���Ͽ� ����

-- ���������� ����ؼ� ���̺� ����
DROP TABLE TBL_DEPT;
DROP TABLE TBL_EMP; -- ���� ����� ���� ����

CREATE TABLE tbl_emp
AS(
    SELECT *
    FROM emp
);
-- Table TBL_EMP��(��) �����Ǿ����ϴ�.
select *
FROM tbl_emp;
-- tbl_emp ���̺��� �����ȣ�� �Է¹޾Ƽ� ����� �����ϴ� ���� -> �������ν��� �����
DELETE FROM tbl_emp
WHERE empno = 7499;

-- up_ == user procedure
CREATE OR REPLACE PROCEDURE up_deltblemp
(
--    pempno NUMBER(4); -> �ڷ���,ũ��,;�� ���� ����.
--    pempno IN tblemp.empno %TYPE -> ���� IN�� ����. ��������
    pempno tbl_emp.empno %TYPE
    
)
IS
    -- ����, ��� �����Ұ� ���.. �����
BEGIN
    DELETE FROM tbl_emp
    WHERE empno = pempno;
    COMMIT;
--EXCEPTION
--    ROLLBACK;    
END;
-- Procedure UP_DELTBLEMP��(��) �����ϵǾ����ϴ�.
-- ���� �����غ���!

--1) EXECUTE ������ ����
EXECUTE up_deltblemp; -- �Ű����� ���� Ÿ���� �߸��Ǿ��ٴ� ���� ��.
EXECUTE up_deltblemp(7566) ;
--EXECUTE up_deltblemp('SMITH') ; -- Ÿ���� �߸��Ǿ���.
EXECUTE up_deltblemp(pempno => 7369) ;
-- PL/SQL ���ν����� ���������� �Ϸ�Ǿ����ϴ�.

SELECT *
FROM tbl_emp; 


--2) �͸� ���ν������� ȣ���Ͽ� ����
--DECLARE
BEGIN
    up_deltblemp(7499) ;
--EXCEPTION
END;


--3) �� �ٸ� ���� ���ν������� ȣ���Ͽ� ����
CREATE OR REPLACE PROCEDURE up_deltblemp_test
(
    pempno tbl_emp.empno%TYPE
)
IS
BEGIN
    up_deltblemp(pempno) ;
--EXCEPTION
END;

-- ���� ����
EXECUTE up_deltblemp_test(7521);

-- CRUD == ���� ���ν����� ó������.
-- ����) dept -> tbl_dept ���̺� ����
CREATE TABLE TBL_DEPT
AS(
    SELECT *
    FROM DEPT
);
-- ����) TBL_DEPT �� �������� Ȯ���� ��, DEPTNO �÷��� PK �������� ����
SELECT *
FROM USER_CONSTRAINTS
WHERE TABLE_NAME LIKE 'TBL_D%';
-- PK �������� ����
ALTER TABLE TBL_DEPT
ADD CONSTRAINT pk_tbldept_deptno PRIMARY KEY (deptno);
--
-- ����) tbl_dept ���̺��� ��� �μ����� �������� SELECT�� ���� -> DBMS_OUTPUT. ����ϴ� �������ν��� ����
-- up_seltbldept
SELECT *
FROM tbl_dept;
-- 2��) �Ͻ��� Ŀ�� ���... for�� ���

DECLARE
BEGIN
    FOR up_seltbldept IN (SELECT * FROM tbl_dept) LOOP
    DBMS_OUTPUT.PUT_LINE(up_seltbldept.deptno || ' ' || up_seltbldept.dname || ' ' || up_seltbldept.loc);
    END LOOP;
END;

-- 1) ����� Ŀ��
CREATE OR REPLACE prOCEDURE up_seltbldept

IS
    --1) Ŀ�� ����
    CURSOR vdcursor IS ( SELECT deptno, dname, loc
                        FROM tbl_dept
    );
    vdrow tbl_dept %ROWTYPE;
BEGIN
    -- 2) Ŀ�� ����
    OPEN vdcursor;
    -- 3) FETCH
    LOOP
        FETCH vdcursor INTO vdrow;
        EXIT WHEN vdcursor %NOTFOUND;
         DBMS_OUTPUT.PUT( vdcursor%ROWCOUNT || ' : '  );
         DBMS_OUTPUT.PUT_LINE( vdrow.deptno || ', ' || vdrow.dname || ', ' ||  vdrow.loc);  
    END LOOP;
    -- 4) CLOSE Ŀ��
    CLOSE vdcursor;

END;

--
EXEC up_seltbldept;

-- for��
CREATE OR REPLACE prOCEDURE up_seltbldept

IS

BEGIN
    for vdrow IN (SELECT deptno, dname, loc FROM tbl_dept) 
    loop
--        DBMS_OUTPUT.PUT( vdcursor%ROWCOUNT || ' : '  );
         DBMS_OUTPUT.PUT_LINE( vdrow.deptno || ', ' || vdrow.dname || ', ' ||  vdrow.loc);  
    end loop;

END;

EXEC up_seltbldept; -- �� ����� �ȶ���...


-- ���ο� �μ��� �߰��ϴ� ���� ���ν��� : UP_INStbldept
-- ������ ���� -> ���۰� 50, ������ 10��
SELECT *
FROM USER_SEQUENCES;

-- seq_tbldept ������ ����� !
CREATE SEQUENCE seq_tbldept 
INCREMENT BY 10 START WITH 50 NOCACHE  NOORDER  NOCYCLE ;
-- Sequence SEQ_TBLDEPT��(��) �����Ǿ����ϴ�.

DESC tbl_dept; --  dname, loc : null���

-- ���������� �����
CREATE OR REPLACE PROCEDURE UP_INStbldept
(
    pdname IN tbl_dept.dname %TYPE DEFAULT NULL,
    ploc IN tbl_dept.loc %TYPE := NULL
)
IS
BEGIN
    INSERT INTO tbl_dept (DEPTNO, dname, loc) VALUES ( seq_tbldept.nextval, pdname , ploc);
    commit;
--EXCEPTION
END;
-- Procedure UP_INSTBLDEPT��(��) �����ϵǾ����ϴ�.
select *
FROM tbl_dept;
EXEC UP_INSTBLDEPT;
EXEC UP_INSTBLDEPT('QC', 'SEOUL');
EXEC UP_INSTBLDEPT(pdname => 'QC', ploc => 'SEOUL');
EXEC UP_INSTBLDEPT(pdname => 'QC2'); -- �ϳ��϶��� ����������. => ���
EXEC UP_INSTBLDEPT(ploc => 'SEOUL');

-- ����) �μ� ��ȣ�� �Է¹޾Ƽ� �����ϴ� up_deltbldept

CREATE OR REPLACE PROCEDURE up_deltbldept
    (pdeptno IN tbl_dept.deptno %TYPE)
IS
    
BEGIN
    DELETE FROM tbl_dept
    WHERE deptno = pdeptno;
    commit;
END;
--
EXEC up_deltbldept(50);
EXEC up_deltbldept(70); -- 70���μ��� �������� ������ ����ó�� ������ҵ�.. / EXCEPTION����.
-- 
SELECT *
FROM TBL_DEPT;


-- 1) Ǯ��
CREATE OR REPLACE PROCEDURE up_updtbldept
    (
    pdeptno tbl_dept.deptno %TYPE,
    pdname tbl_dept.dname %TYPE := NULL,
    ploc tbl_dept.loc %TYPE := NULL
    
    )
IS
        vdname tbl_dept.dname %TYPE; -- ���� �� ���� �μ���
        vloc tbl_dept.loc %TYPE ; -- ���� �� ���� ������

BEGIN

    --1) ���� �� ���� �μ���, �������� ����.
    SELECT dname, loc INTO vdname, vloc
    FROM tbl_Dept
    WHERE deptno = pdeptno;
    
    IF pdname IS NULL AND ploc IS NULL THEN EXIT -- ���⶧���� ���� �ȵ�.
    ELSIF pdname IS NULL THEN
        UPDATE tbl_dept
        SET loc = ploc
        WHERE deptno = pdeptno;
    ELSIF ploc IS NULL THEN 
        UPDATE tbl_dept
        SET loc = ploc, dname = pdname
        WHERE deptno = pdeptno;
    END IF;
    


END; 

-- 2) Ǯ��
CREATE OR REPLACE PROCEDURE up_updtbldept
    (
    pdeptno tbl_dept.deptno %TYPE,
    pdname tbl_dept.dname %TYPE := NULL,
    ploc tbl_dept.loc %TYPE := NULL
    
    )
IS
        vdname tbl_dept.dname %TYPE; -- ���� �� ���� �μ���
        vloc tbl_dept.loc %TYPE ; -- ���� �� ���� ������

BEGIN
    UPDATE tbl_dept
    SET dname = NVL(pdname, dname)
        , loc = CASE 
                    WHEN ploc IS NULL THEN loc
                    ELSE ploc
                END
    WHERE deptno = pdeptno;
    COMMIT;
    
END;


--
EXEC up_updtbldept( 60, 'X', 'Y' );  -- dname, loc
EXEC up_updtbldept( pdeptno=>60,  pdname=>'QC3' );  -- loc
EXEC up_updtbldept( pdeptno=>60,  ploc=>'SEOUL' );  -- 


EXEC up_updtbldept (60);
-- ������ ����.
DROP SEQUENCE seq_tbldept;
-- ����) ����� Ŀ���� ����Ͽ� ��� �μ��� ��ȸ
-- EMP �μ���ȣ�� �Ķ�̤ä��� �޾Ƽ� �ش� �μ����� ��ȸ
-- up_seltblemp

CREATE OR REPLACE PROCEDURE up_seltblemp
    (
    pdeptno tbl_dept.deptno %TYPE := NULL ;
    )
IS

BEGIN
    SELECT * FROM tbl_emp WHERE empno = pempno;
    COMMIT;

END;

-- �� Ǯ��
CREATE OR REPLACE PROCEDURE up_seltblemp
    (
    pdeptno tbl_dept.deptno %TYPE := NULL
    )
IS
    --1) Ŀ�� ����
    CURSOR vecursor IS ( SELECT *
                        FROM tbl_emp
                        WHERE deptno = NVL(pdeptno, 10)
                             );
    verow tbl_emp %ROWTYPE;
BEGIN
    -- 2) Ŀ�� ����
    OPEN vecursor;
    -- 3) FETCH
    LOOP
        FETCH vecursor INTO verow;
        EXIT WHEN vecursor %NOTFOUND;
         DBMS_OUTPUT.PUT( vecursor%ROWCOUNT || ' : '  );
         DBMS_OUTPUT.PUT_LINE( verow.deptno || ', ' || verow.ename || ', ' ||  verow.hiredate);  
    END LOOP;
    -- 4) CLOSE Ŀ��
    CLOSE vecursor;

END;
-- Procedure UP_SELTBLEMP��(��) �����ϵǾ����ϴ�.
EXEC UP_SELTBLEMP(30);

-- [ Ŀ���� �Ķ���͸� �̿��ϴ� ��� ]
CREATE OR REPLACE PROCEDURE up_seltblemp
    (
    pdeptno tbl_dept.deptno %TYPE := NULL
    )
IS
    --1) Ŀ�� ����
    CURSOR vecursor(cdeptno tbl_emp.deptno %TYPE) IS ( SELECT *
                        FROM tbl_emp
                        WHERE deptno = NVL(cdeptno, 10)
                             );
    verow tbl_emp %ROWTYPE;
BEGIN
    -- 2) Ŀ�� ����
    OPEN vecursor ( pdeptno ); -- Ŀ���� ����ɶ� �Ķ���͸� �̿��غ���.
    -- 3) FETCH
    LOOP
        FETCH vecursor INTO verow;
        EXIT WHEN vecursor %NOTFOUND;
         DBMS_OUTPUT.PUT( vecursor%ROWCOUNT || ' : '  );
         DBMS_OUTPUT.PUT_LINE( verow.deptno || ', ' || verow.ename || ', ' ||  verow.hiredate);  
    END LOOP;
    -- 4) CLOSE Ŀ��
    CLOSE vecursor;

END;

-- FOR�� ����� �Ͻ��� Ŀ���� ����
CREATE OR REPLACE PROCEDURE up_seltblemp
    (
    pdeptno tbl_dept.deptno %TYPE := NULL
    )
IS
    
BEGIN
    FOR verow IN (  SELECT *
                    FROM tbl_emp
                    WHERE deptno = NVL(pdeptno, 10)) LOOP
                    DBMS_OUTPUT.PUT_LINE( verow.deptno || ', ' || verow.ename || ', ' ||  verow.hiredate);  
    END LOOP;
END;

--

exec up_seltblemp(30);









-- ���� ���νü�
-- �Ķ���� in���, < out���, in out > ���
-- �����ȣ (IN) -> �����, �ֹι�ȣ ��¿� �Ű�����  ���� ���ν��� ����.
CREATE OR REPLACE PROCEDURE up_selinsa
(
    pnum IN insa.num%TYPE
    , pname OUT insa.name%TYPE
    , pssn OUT insa.ssn%TYPE
)
IS
    vname insa.name%TYPE; -- ������ ����.
    vssn insa.ssn%TYPE;
BEGIN
    select name, ssn INTO vname, vssn
    FROM insa
    WHERE num = pnum;
    
    pname := vname;
    pssn := CONCAT(SUBSTR(vssn,0,8), '******'); -- 111111 - 1******
    
--EXCEPTION
END;
-- Procedure UP_SELINSA��(��) �����ϵǾ����ϴ�.

-- 
--VARIABLE vname
DECLARE
    vname insa.name%TYPE; 
    vssn insa.ssn%TYPE;
BEGIN
    UP_SELINSA(1002, vname, vssn ); -- ������ ����.
    DBMS_OUTPUT.PUT_LINE( vname|| ', ' || vssn);
END;






-- [ IN / OUT ] ���� ���ν��� �Ķ���� ����

-- IN + OUT �Ȱ��� ������ ���
-- �ֹε�Ϲ�ȣ(14�ڸ�)�� �Ķ���� IN
-- �������(6�ڸ�)�� OUT �Ķ���ͷ� �����ִ� ���ν���

CREATE OR REPLACE PROCEDURE up_ssn
(
    pssn IN OUT VARCHAR2
)
IS

BEGIN
    pssn := SUBSTR(pssn,0,6);
END;
-- Procedure UP_SSN��(��) �����ϵǾ����ϴ�.

DECLARE
     Vssn VARCHAR2 (14) := '112345-1234556';
BEGIN
    up_ssn(vssn);
    DBMS_OUTPUT.PUT_LINe(vssn);
END;

-- �����Լ�. ��) �ֹε�Ϲ�ȣ -> ���� üũ 
--               �����ڷ��� varchar2      ���ϰ� '����'  '����'

CREATE OR REPLACE FUNCTION uf_gender
(
    pssn insa.ssn%TYPE
)
RETURN VARCHAR2
IS
    vgender varchar2 (6);
BEGIN
    IF MOD(SUBSTR(pssn,-7,1),2) = 1 THEN vgender := '����';
    ELSE vgender := '����';
    END IF;
    
    RETURN (vgender);
--EXCEPTION

END;
-- Function UF_GENDER��(��) �����ϵǾ����ϴ�.


IF SUBSTR(ssn,-7,1) IN (1,2,5,6)


-- ���̰���ϴ� �����Լ� �����
CREATE OR REPLACE FUNCTION UF_AGE
(
    pssn IN VARCHAR2
    , PTYPE IN NUMBER
)
RETURN NUMBER
IS
    A NUMBER(4); --���س⵵
    B NUMBER(4); -- ���ϳ⵵
    C NUMBER(1); -- �������� ����
    Vcounting_age NUMBER(3); -- ���� ����
    vamerican_age NUMBER (3); -- �� ����
    
BEGIN
    A := TO_CHAR(sysdate , 'yyyy');
    B := CASE 
            WHEN SUBSTR(Pssn,-7,1) IN (1,2,5,6) THEN 1900
            WHEN SUBSTR(Pssn,-7,1) IN (3,4,7,8) THEN 2000
            ELSE 1800 END + SUBSTR(Pssn,0,2) ;
    C := SIGN (TO_DATE(SUBSTR(PSSN, 3,4),'MMDD') - TRUNC(SYSDATE));
    Vcounting_age := A - B + 1;
    vamerican_age := Vcounting_age -1 + CASE C WHEN 1 THEN -1 ELSE 0 END;
    
    IF ptype = 1 THEN
        RETURN Vcounting_age;
    ELSE
        RETURN vamerican_age;
    END IF;

END;
-- Function UF_AGE��(��) �����ϵǾ����ϴ�.

-- ����) -- ��) �ֹε�Ϲ�ȣ-> 1998.01.20(ȭ) ������ ���ڿ��� ��ȯ�ϴ� �����Լ� �ۼ�.�׽�Ʈ
-- ���ڸ��� 1,2�� 19 ���̱� / ���ڸ��� 3,4�� 20 ���̱�.
CREATE OR REPLACE FUNCTION uf_birth
(
    pssn IN NUMBER
)
RETURN VARCHAR2
is
   vcentry NUMBER (2); -- 18,19,20
   vbirth VARCHAR2(20); -- "1999.09.09(ȭ)"
begin
    vbirth := SUBSTR(pssn,0,6);
    vcentry := CASE    WHEN SUBSTR(pssn,8,1) IN (1,2,5,6) THEN 19 
                       WHEN SUBSTR(pssn,8,1) IN (3,4,7,8) THEN 20 
                       ELSE 18 END;
    vbirth := vcentry ||  vbirth;
    vbirth := TO_char(TO_DATE(vbirth), 'YYYY.MM.DD(DY)');
    return (vbirth);
END;

-- 
CREATE TABLE tbl_score
(
     num   NUMBER(4) PRIMARY KEY
   , name  VARCHAR2(20)
   , kor   NUMBER(3)  
   , eng   NUMBER(3)
   , mat   NUMBER(3)  
   , tot   NUMBER(3)
   , avg   NUMBER(5,2)
   , rank  NUMBER(4) 
   , grade CHAR(1 CHAR)
);
-- Table TBL_SCORE��(��) �����Ǿ����ϴ�.

CREATE SEQUENCE seq_tblscore; -- ���ھ� 1�� �÷��ִ� ������.
-- Sequence SEQ_TBLSCORE��(��) �����Ǿ����ϴ�.
SELECT *
FROM user_sequences;
--- ���� 1) �л��� �߰��ϴ� ���� ���νý� ����, �׽�Ʈ
-- �й�, �̸�, ��, ��, �� �հ�, ���
EXEC up_insertscore( 'ȫ�浿', 89,44,55 ); 
EXEC up_insertscore( '�����', 49,55,95 );
EXEC up_insertscore( '�赵��', 90,94,95 );
--
select *
from up_insertscore;
--
CREATE OR REPLACE PROCEDURE up_insertscore
(
      pname VARCHAR2
    , pkor NUMBER
    , peng NUMBER
    , pmat NUMBER
)
IS
    vtot  NUMBER(3) := 0; 
    vavg NUMBER(5,2);
    vgrade tbl_score.grade%TYPE;

BEGIN
    vtot := pkor + peng + pmat;
    vavg := vtot /3 ;
    IF vavg >= 90 THEN vgrade := 'A';
    ELSIF vavg >= 80 THEN vgrade := 'B';
    ELSIF vavg >= 70 THEN vgrade := 'C';
    ELSIF vavg >= 60 THEN vgrade := 'D';
    ELSE vgrade := 'F';
    END IF;
    
    INSERT INTO tbl_score (num, name, kor, eng, mat, tot, avg, rank, grade)
    values (seq_tblscore.NEXTVAL, pname, pkor, peng, pmat, vtot, vavg, 1, vgrade);
    
    -- ��� ó���ϰ� �ʹٸ�?
    -- ��� ��� ���� ó���ϴ� ������Ʈ�� �ָ� ��.
    up_rankScore;
    
END;


-- ����2) up_updateScore �������ν���
EXEC up_updateScore( 1, 100, 100, 100 );
EXEC up_updateScore( 1, pkor =>34 );
EXEC up_updateScore( 1, pkor =>34, pmat => 90 );
EXEC up_updateScore( 1, peng =>45, pmat => 90 );
----
CREATE OR REPLACE PROCEDURE up_updateScore
(
    pnum number, -- �Ķ����
    pkor NUMBER := null,
    pmat NUMBER := null,
    peng NUMBER := null
)
IS
    vkor NUMBER(3);
    vmat NUMBER(3);
    veng NUMBER(3);
    
    vtot NUMBER(3) := 0; -- ��������
    vavg NUMBER(5,2);
    vgrade tbl_score.grade %TYPE;
BEGIN
    SELECT kor, eng, mat INTO vkor, veng, vmat
    FROM tbl_score
    WHERE num = pnum;
    
    vtot := NVL(pkor,vkor) + NVL(peng,veng) +  NVL(pmat,vmat);
    vavg := vtot / 3;   
    
    IF vavg >= 90 THEN vgrade :='A'; 
    ELSIF vavg >= 80 THEN vgrade :='B';
    ELSIF vavg >= 70 THEN vgrade :='C';
    ELSIF vavg >= 60 THEN vgrade :='D';
    ELSE vgrade := 'F' ;
    END IF;
    
    UPDATE tbl_score
    SET kor = NVL(pkor,kor), eng = NVL(peng,eng), mat = NVL(pmat,mat)
--    , tot = vtot, avg = vavg, rank = 1, grade = vgrade
    WHERE num = pnum;
    up_rankScore;
    COMMIT;
END;



-- up_rankscore / ��� �л��� ����� ������Ʈ

CREATE OR REPLACE PROCEDURE up_rankscore
(
    pnum NUMBER,
    ptot NUMBER := NULL,
    pavg NUMBER := NULL,
    prank NUMBER := NULL
)
IS
    vtot NUMBER(3) := 0; -- ��������
    vavg NUMBER(5,2);
    vgrade tbl_score.grade %TYPE;
BEGIN
    UPDATE tbl_score
    SET tot = vtot, avg = vavg, rank = 1, grade = vgrade
    WHERE RANK = PRANK;

END;
--
CREATE OR REPLACE PROCEDURE up_rankScore
IS
BEGIN
    UPDATE tbl_score p
    SET rank = ( SELECT COUNT(*)+1 FROM tbl_score c WHERE p.tot < c.tot  );
    COMMIT;
END;
--
exec up_rankScore;
EXEC up_insertScore( '�ֻ��',100,100,90 );
EXEC up_insertScore( '������',50,60,88 );
EXEC up_insertScore( '������',79,100,90 );
--
select *
FROM tbl_score;

-- up_deleteScore �л� 1�� �й����� ���� + ���ó��
CREATE OR REPLACE PROCEDURE up_deleteScore
(
    pnum number
)
IS
BEGIN
    
    DELETE FROM tbl_score
    WHERE NUM = pnum;
    up_rankScore;
    commit;
END;
--
EXEC up_deleteScore(2);
--
select *
from tbl_score;
-- up_selectScore ��� �л� ������ ��ȸ + �����Ŀ��/�Ͻ���Ŀ��

CREATE OR REPLACE PROCEDURE up_selectScore

IS
    
BEGIN
    FOR vrow IN (SELECT * FROM tbl_score) LOOP
    DBMS_output.PUT_LINE(  
           vrow.num || ', ' || vrow.name || ', ' || vrow.kor
           || vrow.eng || ', ' || vrow.mat || ', ' || vrow.tot
           || vrow.avg || ', ' || vrow.grade || ', ' || vrow.rank
        );
    END LOOP;
    
END;
--

EXEC up_selectScore;


-- ����� Ŀ��
CREATE OR REPLACE PROCEDURE up_selectScore
IS
  --1) Ŀ�� ����
  CURSOR vcursor IS (SELECT * FROM tbl_score);
  vrow tbl_score%ROWTYPE;
BEGIN
  --2) OPEN  Ŀ�� ���� ����..
  OPEN vcursor;
  --3) FETCH  Ŀ�� INTO 
  LOOP  
    FETCH vcursor INTO vrow;
    EXIT WHEN vcursor%NOTFOUND;
    DBMS_OUTPUT.PUT_LINE(  
           vrow.num || ', ' || vrow.name || ', ' || vrow.kor
           || vrow.eng || ', ' || vrow.mat || ', ' || vrow.tot
           || vrow.avg || ', ' || vrow.grade || ', ' || vrow.rank
        );
  END LOOP;
  --4) CLOSE
  CLOSE vcursor;
--EXCEPTION
  -- ROLLBACK;
END;




-- �ϱ�!!
CREATE OR REPLACE PROCEDURE UP_SELECTINSA
(
    -- Ŀ���� �Ķ����(�Ű�����)�� ���޹���.
    pinsacursor SYS_REFCURSOR -- ����Ŭ 9i �������� REF CURSORS
)
IS
    vname insa.name%TYPE;
    vcity insa.city%TYPE;
    vbasicpay insa.basicpay%TYPE;
BEGIN
    LOOP 
        FETCH pinsacursor INTO  vname, vcity, vbasicpay;
        EXIT WHEN pinsacursor%NOTFOUND;
        DBMS_OUTPUT.PUT_LINE(vname || ', ' || vcity || ', ' || vbasicpay);
    END LOOP;
    CLOSE pinsacursor;
END;
-- Procedure UP_SELECTINSA��(��) �����ϵǾ����ϴ�.

CREATE OR REPLACE PROCEDURE UP_SELECTINSA_TEST
IS
    vinsacursor SYS_REFCURSOR;

BEGIN
    -- open ~ for ��
    OPEN vinsacursor FOR SELECT name, city, basicpay FROM insa;
    UP_SELECTINSA(vinsacursor);
END;
-- Procedure UP_SELECTINSA_TEST��(��) �����ϵǾ����ϴ�.
EXEC UP_SELECTINSA_TEST;

----------------
-- [ Ʈ���� ] --

CREATE TABLE tbl_exam1
(
   id NUMBER PRIMARY KEY
   , name VARCHAR2(20)
);

CREATE TABLE tbl_exam2
(
   memo VARCHAR2(100)
   , ilja DATE DEFAULT SYSDATE
);

-- TBL_exam1 ���̺� insert, update, delete �̺�Ʈ���� �߻��ϸ�
-- �ڵ����� tbl_exam2 ���̺� 1���� � �۾��� �Ͼ���� �α׷� ����ϴ� Ʈ����.
create or replace trigger ut_log
AFTER
insert OR delete OR UPDATE ON tbl_exam1
for each row 

--DECLARE
    -- ��������
BEGIN
    IF INSERTING THEN
         INSERT INTO tbl_exam2 (memo) VALUES (:new.name || '�ϳ����𸣰ڴµ�') ;   -- ���౸��
    ELSIF DELETING THEN
         INSERT INTO tbl_exam2 (memo) VALUES (:OLD.name || '����.. �ϳ����𸣰ڴµ�') ;
         ELSIF UPDATING THEN
         INSERT INTO tbl_exam2 (memo) VALUES (:OLD.name || '->' || :NEW.NAME || '����.. �ϳ����𸣰ڴµ�') ;
    END IF;
    
    
END;
--
UPDATE tbl_exam1
SET NAME = 'admin'
where id = 1;
--
select * FROM tbl_exam1;
select * FROM tbl_exam2;
insert into tbl_exam1 VALUES (1, 'hong');
--
delete from tbl_exam1
where id = 1;
rollback;
--
commit;

-- �Ʒ��� ���� ����
create or replace trigger ut_deletelog
AFTER
delete ON tbl_exam1
for each row 

BEGIN
    INSERT INTO tbl_exam2 (memo) VALUES (:OLD.name || '����.. �ϳ����𸣰ڴµ�') ;   -- ���౸��
END;

------- tbl_exam1 ��� ���̺�� DML���� �ٹ��ð�(9-17��) �� �Ǵ� �ָ����� ó�� �ȵǰ� Ʈ���� ����.
CREATE OR REPLACE TRIGGER UT_LOG_BEFORE
BEFORE
INSERT OR UPDATE OR DELETE ON tbl_exam1
--FOR EACH ROW
--DECLARE
    
BEGIN
    IF TO_CHAR(SYSDATE,'DY') IN ('��','��')
    OR TO_CHAR(SYSDATE,'HH24') < 9 
    OR TO_CHAR(SYSDATE,'HH24') > 16 THEN
    RAISE_APPLICATION_ERROR(-20001, '�ٹ��ð��� �ƴ�. DML ���� �� ���ÿ�');       -- ������ ���ܸ� �߻�
    END IF;
END;

INSERT INTO TBL_EXAM1 VALUES (2, 'PARK');
--
DROP TABLE TBL_DEPT;
DROP TABLE TBL_EMP;
DROP TABLE TBL_EXAM1;
DROP TABLE TBL_EXAM2;
DROP TABLE TBL_SCORE;
--




















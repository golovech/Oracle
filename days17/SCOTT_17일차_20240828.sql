
 -- ���� ����
 --   �� ������ ����Ǵ� ������ sql�� �̰��� ���´�. ��� ��
 -- [ ���� ������ ����ϴ� ��� 3���� ]
  1. ������ �ÿ� SQL������ Ȯ������ ���� ��� (�󵵳���)
  ��) WHERE ������... X
  � üũ������ ���� ��, �� üũ�� �Ϸ�Ǿ�� ������ �ϼ��ǰ� �����.
  2. PL/SQL �� �ȿ��� DDL���� ����ϴ� ���
  CREATE, DROP, ALTER ��
  ��αװ���.. �Խ��� ������ ����ų� �����Ҷ�, ������ �ϼ��ǰ� �����.
  3. PL/SQL �� �ȿ��� ALTER SYSTEM / SESSION ��ɾ� ����ϴ� ���
  
  -- [ PL/SQL ���� ������ ����ϴ� ��� 2���� ]
  1. DBMS_SQL ��Ű��
  *** 2. EXECUTE IMMEDIATE �� ***
  SELECT, FETCH, INTO : ������ ���� �Ҵ��� ��.
  ����)
  EXECUTE IMMEDIATE ���������� 
                    [ INTO ������, ... ]
                    [ USING [ IN / OUT / IN OUT ] �Ķ���� (�Ű�������), �Ķ���� ...];
  
  -- �ǽ�����) �͸� ���ν���
  DECLARE
    vsql VARCHAR2(1000); 
    vdeptno emp.deptno%TYPE;
    vempno emp.empno%TYPE;
    vename emp.ename%TYPE;
    vjob emp.job%TYPE;
  BEGIN
    vsql := 'SELECT deptno, empno, ename, job ';
    vsql := vsql || ' FROM emp ';
    vsql := vsql || ' WHERE empno = 7369 ';
    DBMS_OUTPUT.PUT_LINE( VSQL );
    EXECUTE IMMEDIATE vsql
            INTO vdeptno, vempno, vename, vjob;
    DBMS_OUTPUT.PUT_LINE( vdeptno ||', ' || vempno ||', ' || vename ||', ' ||vjob  );
--  EXCEPTION
  
  END;
  
  -- �ǽ�����) �������ν����� ���� �׽�Ʈ
  -- �Ķ���� : �����ȣ �Է¹ޱ�
  CREATE OR REPLACE PROCEDURE up_ndsemp
  (
    pempno emp.empno%TYPE
  )
    IS
    vsql VARCHAR2(1000); 
    vdeptno emp.deptno%TYPE;
    vempno emp.empno%TYPE;
    vename emp.ename%TYPE;
    vjob emp.job%TYPE;
  BEGIN
    vsql := 'SELECT deptno, empno, ename, job ';
    vsql := vsql || ' FROM emp ';
    vsql := vsql || ' WHERE empno = ' || 'pempno ';
    DBMS_OUTPUT.PUT_LINE( VSQL );
    EXECUTE IMMEDIATE vsql
            INTO vdeptno, vempno, vename, vjob;
    DBMS_OUTPUT.PUT_LINE( vdeptno ||', ' || vempno ||', ' || vename ||', ' ||vjob  );
--  EXCEPTION
  
  END;
 
 EXEC UP_NDSEMP(7369);
 
   CREATE OR REPLACE PROCEDURE up_ndsemp
  (
    pempno emp.empno%TYPE
  )
    IS
    vsql VARCHAR2(1000); 
    vdeptno emp.deptno%TYPE;
    vempno emp.empno%TYPE;
    vename emp.ename%TYPE;
    vjob emp.job%TYPE;
  BEGIN
    vsql := 'SELECT deptno, empno, ename, job ';
    vsql := vsql || ' FROM emp ';
    vsql := vsql || ' WHERE empno =: pempno ' ;
    DBMS_OUTPUT.PUT_LINE( VSQL );
    EXECUTE IMMEDIATE vsql
            INTO vdeptno, vempno, vename, vjob
            USING IN pempno;
    DBMS_OUTPUT.PUT_LINE( vdeptno ||', ' || vempno ||', ' || vename ||', ' ||vjob  );
--  EXCEPTION
  
  END;
  
  
  
  -- �ǽ�����) DEPT���̺� ���ο� �μ��� �߰��ϴ� ��������
     CREATE OR REPLACE PROCEDURE up_ndsInsDEPT
  (
    pdname dept.dname%TYPE := null,
    ploc dept.loc%TYPE := null
  )
    IS
    vsql VARCHAR2(1000); 
    vdeptno emp.deptno%TYPE;
  BEGIN
    SELECT NVL(MAX(deptno),0)+10 INTO vdeptno FROM dept;
    vsql := 'INSERT INTO dept ( deptno, dname, loc) ';
    vsql := vsql || ' VALUES (:VDEPTNO, :PDNAME, :PLOC) ';
    DBMS_OUTPUT.PUT_LINE( VSQL );
    EXECUTE IMMEDIATE vsql
            USING IN VDEPTNO, PDNAME, PLOC;
    COMMIT;
    DBMS_OUTPUT.PUT_LINE( 'INSERT ����!' );
  
  END;
 
 
 SELECT * FROM DEPT;
 EXEC up_ndsInsDEPT('QC ','COREA');
 
 
 
 -- ���� SQL - DDL�� ��� (���̺� ����)
 -- ���̺��, �÷��� �Է¹���.
   DECLARE
    vsql VARCHAR2(1000); 
    vtablename VARCHAR2(20);
  BEGIN
    vtablename := 'tbl_test';
    
    vsql := 'CREATE TABLE  ' ||  vtablename ;
    vsql := vsql || ' ( ';
    vsql := vsql || ' ID NUMBER PRIMARY KEY ';
    vsql := vsql || ' ,NAME VARCHAR2(20) ';
    vsql := vsql || ' ) ';
    DBMS_OUTPUT.PUT_LINE( VSQL );
    EXECUTE IMMEDIATE vsql;
  
  END;
  
  DESC
  
  SELECT * FROM USER_TABLES;
--  where like 'TBL%';
 
 
 -- open ~ FOR�� : �������� ���� + �������� ���ڵ�(Ŀ��ó��)
 -- �μ���ȣ�� �Ķ���ͷ� �Է¹޾Ƽ�..
  CREATE OR REPLACE PROCEDURE up_ndsInsDEPT
  (
    pdeptno emp.deptno%TYPE :=10
  )
    IS
    vsql VARCHAR2(1000); 
    vcur SYS_REFCURSOR; --Ŀ���� �ڷ��� ���� Ÿ������ ���� ���
    vrow emp%ROWTYPE;
  BEGIN
    
    vsql := 'SELECT * ';
    vsql := vsql || ' FROM emp ';
    vsql := vsql || ' WHERE deptno = :pdeptno ';
    DBMS_OUTPUT.PUT_LINE( VSQL );
--    EXECUTE IMMEDIATE vsql into ~~ USING IN VDEPTNO, PDNAME, PLOC;
--    OPEN ~ FOR : �������� Ŀ���� ��������.
--    OPEN Ŀ��    FOR ����
    OPEN vcur FOR vsql USING PDEPTNO;
    LOOP 
        FETCH vcur INTO vrow;
        EXIT WHEN vcur%NOTFOUND;
        DBMS_OUTPUT.PUT_LINE(vrow.empno || ', '||vrow.ename);
    END LOOP;
    CLOSE VCUR;
  
  END;
  
  --
  
  
-- emp ���̺��� �˻� ��� ����
-- 1) �˻�����    : 1 �μ���ȣ, 2 �����, 3 ��
-- 2) �˻���      :
CREATE OR REPLACE PROCEDURE up_ndsSearchEmp
(
  psearchCondition NUMBER -- 1. �μ���ȣ, 2.�����, 3. ��
  , psearchWord VARCHAR2
)
IS
  vsql  VARCHAR2(2000);
  vcur  SYS_REFCURSOR;   -- Ŀ�� Ÿ������ ���� ����  9i  REF CURSOR
  vrow emp%ROWTYPE;
BEGIN
  vsql := 'SELECT * ';
  vsql := vsql || ' FROM emp ';
  
  IF psearchCondition = 1 THEN -- �μ���ȣ�� �˻�
    vsql := vsql || ' WHERE  deptno = :psearchWord ';
  ELSIF psearchCondition = 2 THEN -- �����
    vsql := vsql || ' WHERE  REGEXP_LIKE( ename , :psearchWord )';
  ELSIF psearchCondition = 3  THEN -- job
    vsql := vsql || ' WHERE  REGEXP_LIKE( job , :psearchWord , ''i'')';
  END IF; 
   
  OPEN vcur  FOR vsql USING psearchWord;
  LOOP  
    FETCH vcur INTO vrow;
    EXIT WHEN vcur%NOTFOUND;
    DBMS_OUTPUT.PUT_LINE( vrow.empno || ' '  || vrow.ename || ' ' || vrow.job );
  END LOOP;   
  CLOSE vcur; 
EXCEPTION
  WHEN NO_DATA_FOUND THEN
      RAISE_APPLICATION_ERROR(-20001, '>EMP DATA NOT FOUND...');
  WHEN OTHERS THEN
      RAISE_APPLICATION_ERROR(-20004, '>OTHER ERROR...');
END;
--
EXEC UP_NDSSEARCHEMP(1, '20'); 
EXEC UP_NDSSEARCHEMP(2, 'L'); 
EXEC UP_NDSSEARCHEMP(3, 's'); 

 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 

[ Ʈ����� (Transaction) ]
-- ������ü A -> B
 1) UPDATE ( A ���¿��� �ݾ��� ��� )
 2) UPDATE ( B ���¿� ����ݾ׸�ŭ �Ա� )
 
 1) + 2) �� �� �ǰų�(COMMIT), �� �� �ȵǾ�� ��(ROLLBACK)
 
 COMMIT;
 
 
-- 
 CREATE TABLE TBL_DEPT
 AS
 SELECT * FROM DEPT;
 -- Table TBL_DEPT��(��) �����Ǿ����ϴ�.
 
 SELECT * FROM TBL_DEPT;
 
 -- 1) INSERT
 insert into TBL_DEPT values(50,'development','COREA');
 -- 1 �� ��(��) ���ԵǾ����ϴ�.
 
 SAVEPOINT a; -- Ư������ ����
 
 -- 2) UPDATE
 update TBL_DEPT 
 set loc='ROK' 
 where deptno=50;
 
 -- ROLLBACK; -> INSERT �������� �ѹ�
 ROLLBACK TO SAVEPOINT a; -- update�� �ѹ�
 ROLLBACK TO a;
 ROLLBACK;
 
 -- SESSION A
 SELECT *
 FROM TBL_DEPT;
 
 --
 DELETE FROM TBL_DEPT
 WHERE DEPTNO = 40;
 --
 COMMIT;
 --
 

 C O R P ������ü
 ()
 IS
    ���ܹ߻� EXCEPTION
 B
    -- �����
    ��ü�ݾ� A�ܾ�
    SELECT
    UPDATE
    DELETE
    INSERT
      :
    COMMIT;
 
 E
    ROLLBACK;
    RAISE ���ܹ߻�(-20000, '��¼����¼��');
 E;
 
 -- ��Ű��
 -- Package EMPLOYEE_PKG��(��) �����ϵǾ����ϴ�.
 -- ��Ű���� ���� �κ�
 CREATE OR REPLACE PACKAGE employee_pkg 
 AS 
      -- �������α׷� (���� ���ν�����)
      procedure print_ename(p_empno number); -- ���ν������� �Ķ���͸� �߶��
      procedure print_sal(p_empno number); 
      FUNCTION uf_age -- �Լ��� �Ȱ���!
      (
        pssn IN VARCHAR2
        , ptype IN NUMBER
      )
      RETURN NUMBER;
 END employee_pkg; 
 
 -- ��Ű�� ��ü �κ�
CREATE OR REPLACE PACKAGE BODY employee_pkg 
AS 
   
      procedure print_ename(p_empno number) is 
         l_ename emp.ename%type; 
       begin 
         select ename 
           into l_ename 
           from emp 
           where empno = p_empno; 
       dbms_output.put_line(l_ename); 
      exception 
        when NO_DATA_FOUND then 
         dbms_output.put_line('Invalid employee number'); 
     end print_ename; 
   
   procedure print_sal(p_empno number) is 
      l_sal emp.sal%type; 
    begin 
      select sal 
       into l_sal 
        from emp 
        where empno = p_empno; 
     dbms_output.put_line(l_sal); 
    exception 
      when NO_DATA_FOUND then 
        dbms_output.put_line('Invalid employee number'); 
   end print_sal;  
   
   FUNCTION uf_age
(
   pssn IN VARCHAR2 
  ,ptype IN NUMBER --  1(���� ����)  0(������)
)
RETURN NUMBER
IS
   �� NUMBER(4);  -- ���س⵵
   �� NUMBER(4);  -- ���ϳ⵵
   �� NUMBER(1);  -- ���� ���� ����    -1 , 0 , 1
   vcounting_age NUMBER(3); -- ���� ���� 
   vamerican_age NUMBER(3); -- �� ���� 
BEGIN
   -- ������ = ���س⵵ - ���ϳ⵵    ������������X  -1 ����.
   --       =  ���³��� -1  
   -- ���³��� = ���س⵵ - ���ϳ⵵ +1 ;
   �� := TO_CHAR(SYSDATE, 'YYYY');
   �� := CASE 
          WHEN SUBSTR(pssn,8,1) IN (1,2,5,6) THEN 1900
          WHEN SUBSTR(pssn,8,1) IN (3,4,7,8) THEN 2000
          ELSE 1800
        END + SUBSTR(pssn,1,2);
   �� :=  SIGN(TO_DATE(SUBSTR(pssn,3,4), 'MMDD') - TRUNC(SYSDATE));  -- 1 (����X)

   vcounting_age := �� - �� +1 ;
   -- PLS-00204: function or pseudo-column 'DECODE' may be used inside a SQL statement only
   -- vamerican_age := vcounting_age - 1 + DECODE( ��, 1, -1, 0 );
   vamerican_age := vcounting_age - 1 + CASE ��
                                         WHEN 1 THEN -1
                                         ELSE 0
                                        END;

   IF ptype = 1 THEN
      RETURN vcounting_age;
   ELSE 
      RETURN (vamerican_age);
   END IF;
--EXCEPTION
END uf_age;
  
END employee_pkg; 

 --
 
 SELECT NAME, SSN, EMPLOYEE_PKG.UF_AGE(SSN, 1) age
 FROM INSA;

 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
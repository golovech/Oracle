
 -- 동적 쿼리
 --   ㄴ 쿼리가 실행되는 시점에 sql가 미결정 상태다. 라는 뜻
 -- [ 동적 쿼리를 사용하는 경우 3가지 ]
  1. 컴파일 시에 SQL문장이 확정되지 않은 경우 (빈도높음)
  예) WHERE 조건절... X
  어떤 체크조건이 있을 때, 그 체크가 완료되어야 쿼리가 완성되고 실행됨.
  2. PL/SQL 블럭 안에서 DDL문을 사용하는 경우
  CREATE, DROP, ALTER 문
  블로그같이.. 게시판 제목을 만들거나 삭제할때, 쿼리가 완성되고 실행됨.
  3. PL/SQL 블럭 안에서 ALTER SYSTEM / SESSION 명령어 사용하는 경우
  
  -- [ PL/SQL 동적 쿼리를 사용하는 방법 2가지 ]
  1. DBMS_SQL 패키지
  *** 2. EXECUTE IMMEDIATE 문 ***
  SELECT, FETCH, INTO : 변수에 값을 할당할 때.
  형식)
  EXECUTE IMMEDIATE 동적쿼리문 
                    [ INTO 변수명, ... ]
                    [ USING [ IN / OUT / IN OUT ] 파라미터 (매개변수값), 파라미터 ...];
  
  -- 실습예제) 익명 프로시저
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
  
  -- 실습예제) 저장프로시저로 만들어서 테스트
  -- 파라미터 : 사원번호 입력받기
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
  
  
  
  -- 실습예제) DEPT테이블에 새로운 부서를 추가하는 동적쿼리
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
    DBMS_OUTPUT.PUT_LINE( 'INSERT 성공!' );
  
  END;
 
 
 SELECT * FROM DEPT;
 EXEC up_ndsInsDEPT('QC ','COREA');
 
 
 
 -- 동적 SQL - DDL문 사용 (테이블 생성)
 -- 테이블명, 컬럼명 입력받자.
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
 
 
 -- open ~ FOR문 : 동적쿼리 실행 + 여러개의 레코드(커서처리)
 -- 부서번호를 파라미터로 입력받아서..
  CREATE OR REPLACE PROCEDURE up_ndsInsDEPT
  (
    pdeptno emp.deptno%TYPE :=10
  )
    IS
    vsql VARCHAR2(1000); 
    vcur SYS_REFCURSOR; --커서를 자료형 선언 타입으로 쓸때 사용
    vrow emp%ROWTYPE;
  BEGIN
    
    vsql := 'SELECT * ';
    vsql := vsql || ' FROM emp ';
    vsql := vsql || ' WHERE deptno = :pdeptno ';
    DBMS_OUTPUT.PUT_LINE( VSQL );
--    EXECUTE IMMEDIATE vsql into ~~ USING IN VDEPTNO, PDNAME, PLOC;
--    OPEN ~ FOR : 여러개의 커서를 열수있음.
--    OPEN 커서    FOR 쿼리
    OPEN vcur FOR vsql USING PDEPTNO;
    LOOP 
        FETCH vcur INTO vrow;
        EXIT WHEN vcur%NOTFOUND;
        DBMS_OUTPUT.PUT_LINE(vrow.empno || ', '||vrow.ename);
    END LOOP;
    CLOSE VCUR;
  
  END;
  
  --
  
  
-- emp 테이블에서 검색 기능 구현
-- 1) 검색조건    : 1 부서번호, 2 사원명, 3 잡
-- 2) 검색어      :
CREATE OR REPLACE PROCEDURE up_ndsSearchEmp
(
  psearchCondition NUMBER -- 1. 부서번호, 2.사원명, 3. 잡
  , psearchWord VARCHAR2
)
IS
  vsql  VARCHAR2(2000);
  vcur  SYS_REFCURSOR;   -- 커서 타입으로 변수 선언  9i  REF CURSOR
  vrow emp%ROWTYPE;
BEGIN
  vsql := 'SELECT * ';
  vsql := vsql || ' FROM emp ';
  
  IF psearchCondition = 1 THEN -- 부서번호로 검색
    vsql := vsql || ' WHERE  deptno = :psearchWord ';
  ELSIF psearchCondition = 2 THEN -- 사원명
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

 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
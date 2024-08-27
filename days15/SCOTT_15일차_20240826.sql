
[ 트랜잭션 (Transaction) ]
-- 계좌이체 A -> B
 1) UPDATE ( A 계좌에서 금액을 출금 )
 2) UPDATE ( B 계좌에 인출금액만큼 입금 )
 
 1) + 2) 둘 다 되거나(COMMIT), 둘 다 안되어야 함(ROLLBACK)
 
 COMMIT;
 
 
-- 
 CREATE TABLE TBL_DEPT
 AS
 SELECT * FROM DEPT;
 -- Table TBL_DEPT이(가) 생성되었습니다.
 
 SELECT * FROM TBL_DEPT;
 
 -- 1) INSERT
 insert into TBL_DEPT values(50,'development','COREA');
 -- 1 행 이(가) 삽입되었습니다.
 
 SAVEPOINT a; -- 특정지점 설정
 
 -- 2) UPDATE
 update TBL_DEPT 
 set loc='ROK' 
 where deptno=50;
 
 -- ROLLBACK; -> INSERT 이전으로 롤백
 ROLLBACK TO SAVEPOINT a; -- update만 롤백
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
 

 C O R P 계좌이체
 ()
 IS
    예외발생 EXCEPTION
 B
    -- 실행블럭
    이체금액 A잔액
    SELECT
    UPDATE
    DELETE
    INSERT
      :
    COMMIT;
 
 E
    ROLLBACK;
    RAISE 예외발생(-20000, '어쩌구저쩌구');
 E;
 
 -- 패키지
 -- Package EMPLOYEE_PKG이(가) 컴파일되었습니다.
 -- 패키지의 명세서 부분
 CREATE OR REPLACE PACKAGE employee_pkg 
 AS 
      -- 서브프로그램 (저장 프로시저만)
      procedure print_ename(p_empno number); -- 프로시져에서 파라미터만 잘라옴
      procedure print_sal(p_empno number); 
      FUNCTION uf_age -- 함수도 똑같이!
      (
        pssn IN VARCHAR2
        , ptype IN NUMBER
      )
      RETURN NUMBER;
 END employee_pkg; 
 
 -- 패키지 몸체 부분
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
  ,ptype IN NUMBER --  1(세는 나이)  0(만나이)
)
RETURN NUMBER
IS
   ㄱ NUMBER(4);  -- 올해년도
   ㄴ NUMBER(4);  -- 생일년도
   ㄷ NUMBER(1);  -- 생일 지남 여부    -1 , 0 , 1
   vcounting_age NUMBER(3); -- 세는 나이 
   vamerican_age NUMBER(3); -- 만 나이 
BEGIN
   -- 만나이 = 올해년도 - 생일년도    생일지남여부X  -1 결정.
   --       =  세는나이 -1  
   -- 세는나이 = 올해년도 - 생일년도 +1 ;
   ㄱ := TO_CHAR(SYSDATE, 'YYYY');
   ㄴ := CASE 
          WHEN SUBSTR(pssn,8,1) IN (1,2,5,6) THEN 1900
          WHEN SUBSTR(pssn,8,1) IN (3,4,7,8) THEN 2000
          ELSE 1800
        END + SUBSTR(pssn,1,2);
   ㄷ :=  SIGN(TO_DATE(SUBSTR(pssn,3,4), 'MMDD') - TRUNC(SYSDATE));  -- 1 (생일X)

   vcounting_age := ㄱ - ㄴ +1 ;
   -- PLS-00204: function or pseudo-column 'DECODE' may be used inside a SQL statement only
   -- vamerican_age := vcounting_age - 1 + DECODE( ㄷ, 1, -1, 0 );
   vamerican_age := vcounting_age - 1 + CASE ㄷ
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

 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
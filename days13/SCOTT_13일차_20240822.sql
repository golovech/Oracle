
-- [ 저장 프로시저의 형식 ] --
CREATE OR REPLACE PROCEDURE 프로시저명;
(
    매개변수 (argument, parameter) 선언, -- 매개변수 칸에는 , 찍음 / 타입크기 설정X
    p매개변수명  [mode] 자료형 -- 앞에 p를 붙이겠다.
                  IN 입력용 파라미터 (기본모드)
                  OUT 출력용 파라미터
                  IN OUT 입/출력용 파라미터
)
IS -- DECLARE
    변수/상수 선언;
    v
BEGIN
END;

-- 저장 프로시저를 실행하는 방법 3가지 --
--1) EXECUTE 문으로 실행
--2) 익명 프로시저에서 호출하여 실행
--3) 또 다른 저장 프로시저에서 호출하여 실행

-- 서브쿼리를 사용해서 테이블 생성
DROP TABLE TBL_DEPT;
DROP TABLE TBL_EMP; -- 전에 만든것 먼저 삭제

CREATE TABLE tbl_emp
AS(
    SELECT *
    FROM emp
);
-- Table TBL_EMP이(가) 생성되었습니다.
select *
FROM tbl_emp;
-- tbl_emp 테이블에서 사원번호를 입력받아서 사원을 삭제하는 쿼리 -> 저장프로시저 만들기
DELETE FROM tbl_emp
WHERE empno = 7499;

-- up_ == user procedure
CREATE OR REPLACE PROCEDURE up_deltblemp
(
--    pempno NUMBER(4); -> 자료형,크기,;는 쓰지 않음.
--    pempno IN tblemp.empno %TYPE -> 원래 IN이 붙음. 생략가능
    pempno tbl_emp.empno %TYPE
    
)
IS
    -- 변수, 상수 선언할게 없어서.. 비워둠
BEGIN
    DELETE FROM tbl_emp
    WHERE empno = pempno;
    COMMIT;
--EXCEPTION
--    ROLLBACK;    
END;
-- Procedure UP_DELTBLEMP이(가) 컴파일되었습니다.
-- 이제 실행해보자!

--1) EXECUTE 문으로 실행
EXECUTE up_deltblemp; -- 매개변수 수나 타입이 잘못되었다는 오류 뜸.
EXECUTE up_deltblemp(7566) ;
--EXECUTE up_deltblemp('SMITH') ; -- 타입이 잘못되었다.
EXECUTE up_deltblemp(pempno => 7369) ;
-- PL/SQL 프로시저가 성공적으로 완료되었습니다.

SELECT *
FROM tbl_emp; 


--2) 익명 프로시저에서 호출하여 실행
--DECLARE
BEGIN
    up_deltblemp(7499) ;
--EXCEPTION
END;


--3) 또 다른 저장 프로시저에서 호출하여 실행
CREATE OR REPLACE PROCEDURE up_deltblemp_test
(
    pempno tbl_emp.empno%TYPE
)
IS
BEGIN
    up_deltblemp(pempno) ;
--EXCEPTION
END;

-- 삭제 실행
EXECUTE up_deltblemp_test(7521);

-- CRUD == 전부 프로시저로 처리하자.
-- 문제) dept -> tbl_dept 테이블 생성
CREATE TABLE TBL_DEPT
AS(
    SELECT *
    FROM DEPT
);
-- 문제) TBL_DEPT 의 제약조건 확인한 후, DEPTNO 컬럼의 PK 제약조건 설정
SELECT *
FROM USER_CONSTRAINTS
WHERE TABLE_NAME LIKE 'TBL_D%';
-- PK 제약조건 설정
ALTER TABLE TBL_DEPT
ADD CONSTRAINT pk_tbldept_deptno PRIMARY KEY (deptno);
--
-- 문제) tbl_dept 테이블의 모든 부서정보 가져오는 SELECT문 실행 -> DBMS_OUTPUT. 출력하는 저장프로시저 생성
-- up_seltbldept
SELECT *
FROM tbl_dept;
-- 2조) 암시적 커서 사용... for문 사용

DECLARE
BEGIN
    FOR up_seltbldept IN (SELECT * FROM tbl_dept) LOOP
    DBMS_OUTPUT.PUT_LINE(up_seltbldept.deptno || ' ' || up_seltbldept.dname || ' ' || up_seltbldept.loc);
    END LOOP;
END;

-- 1) 명시적 커서
CREATE OR REPLACE prOCEDURE up_seltbldept

IS
    --1) 커서 선언
    CURSOR vdcursor IS ( SELECT deptno, dname, loc
                        FROM tbl_dept
    );
    vdrow tbl_dept %ROWTYPE;
BEGIN
    -- 2) 커서 오픈
    OPEN vdcursor;
    -- 3) FETCH
    LOOP
        FETCH vdcursor INTO vdrow;
        EXIT WHEN vdcursor %NOTFOUND;
         DBMS_OUTPUT.PUT( vdcursor%ROWCOUNT || ' : '  );
         DBMS_OUTPUT.PUT_LINE( vdrow.deptno || ', ' || vdrow.dname || ', ' ||  vdrow.loc);  
    END LOOP;
    -- 4) CLOSE 커서
    CLOSE vdcursor;

END;

--
EXEC up_seltbldept;

-- for문
CREATE OR REPLACE prOCEDURE up_seltbldept

IS

BEGIN
    for vdrow IN (SELECT deptno, dname, loc FROM tbl_dept) 
    loop
--        DBMS_OUTPUT.PUT( vdcursor%ROWCOUNT || ' : '  );
         DBMS_OUTPUT.PUT_LINE( vdrow.deptno || ', ' || vdrow.dname || ', ' ||  vdrow.loc);  
    end loop;

END;

EXEC up_seltbldept; -- 왜 출력이 안뜨지...


-- 새로운 부서를 추가하는 저장 프로시저 : UP_INStbldept
-- 시퀀스 생성 -> 시작값 50, 증가값 10씩
SELECT *
FROM USER_SEQUENCES;

-- seq_tbldept 시퀀스 만들기 !
CREATE SEQUENCE seq_tbldept 
INCREMENT BY 10 START WITH 50 NOCACHE  NOORDER  NOCYCLE ;
-- Sequence SEQ_TBLDEPT이(가) 생성되었습니다.

DESC tbl_dept; --  dname, loc : null허용

-- 본격적으로 만들기
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
-- Procedure UP_INSTBLDEPT이(가) 컴파일되었습니다.
select *
FROM tbl_dept;
EXEC UP_INSTBLDEPT;
EXEC UP_INSTBLDEPT('QC', 'SEOUL');
EXEC UP_INSTBLDEPT(pdname => 'QC', ploc => 'SEOUL');
EXEC UP_INSTBLDEPT(pdname => 'QC2'); -- 하나일때는 명시해줘야함. => 사용
EXEC UP_INSTBLDEPT(ploc => 'SEOUL');

-- 문제) 부서 번호를 입력받아서 삭제하는 up_deltbldept

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
EXEC up_deltbldept(70); -- 70번부서는 존재하지 않으니 예외처리 해줘야할듯.. / EXCEPTION에서.
-- 
SELECT *
FROM TBL_DEPT;


-- 1) 풀이
CREATE OR REPLACE PROCEDURE up_updtbldept
    (
    pdeptno tbl_dept.deptno %TYPE,
    pdname tbl_dept.dname %TYPE := NULL,
    ploc tbl_dept.loc %TYPE := NULL
    
    )
IS
        vdname tbl_dept.dname %TYPE; -- 수정 전 원래 부서명
        vloc tbl_dept.loc %TYPE ; -- 수정 전 원래 지역명

BEGIN

    --1) 수정 전 원래 부서명, 지역명을 저장.
    SELECT dname, loc INTO vdname, vloc
    FROM tbl_Dept
    WHERE deptno = pdeptno;
    
    IF pdname IS NULL AND ploc IS NULL THEN EXIT -- 여기때문에 실행 안됨.
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

-- 2) 풀이
CREATE OR REPLACE PROCEDURE up_updtbldept
    (
    pdeptno tbl_dept.deptno %TYPE,
    pdname tbl_dept.dname %TYPE := NULL,
    ploc tbl_dept.loc %TYPE := NULL
    
    )
IS
        vdname tbl_dept.dname %TYPE; -- 수정 전 원래 부서명
        vloc tbl_dept.loc %TYPE ; -- 수정 전 원래 지역명

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
-- 시퀀스 삭제.
DROP SEQUENCE seq_tbldept;
-- 문제) 명시적 커서를 사용하여 모든 부서원 조회
-- EMP 부서번호를 파라미ㅓㅌ로 받아서 해당 부서원만 조회
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

-- 쌤 풀이
CREATE OR REPLACE PROCEDURE up_seltblemp
    (
    pdeptno tbl_dept.deptno %TYPE := NULL
    )
IS
    --1) 커서 선언
    CURSOR vecursor IS ( SELECT *
                        FROM tbl_emp
                        WHERE deptno = NVL(pdeptno, 10)
                             );
    verow tbl_emp %ROWTYPE;
BEGIN
    -- 2) 커서 오픈
    OPEN vecursor;
    -- 3) FETCH
    LOOP
        FETCH vecursor INTO verow;
        EXIT WHEN vecursor %NOTFOUND;
         DBMS_OUTPUT.PUT( vecursor%ROWCOUNT || ' : '  );
         DBMS_OUTPUT.PUT_LINE( verow.deptno || ', ' || verow.ename || ', ' ||  verow.hiredate);  
    END LOOP;
    -- 4) CLOSE 커서
    CLOSE vecursor;

END;
-- Procedure UP_SELTBLEMP이(가) 컴파일되었습니다.
EXEC UP_SELTBLEMP(30);

-- [ 커서에 파라미터를 이용하는 방법 ]
CREATE OR REPLACE PROCEDURE up_seltblemp
    (
    pdeptno tbl_dept.deptno %TYPE := NULL
    )
IS
    --1) 커서 선언
    CURSOR vecursor(cdeptno tbl_emp.deptno %TYPE) IS ( SELECT *
                        FROM tbl_emp
                        WHERE deptno = NVL(cdeptno, 10)
                             );
    verow tbl_emp %ROWTYPE;
BEGIN
    -- 2) 커서 오픈
    OPEN vecursor ( pdeptno ); -- 커서가 실행될때 파라미터를 이용해보자.
    -- 3) FETCH
    LOOP
        FETCH vecursor INTO verow;
        EXIT WHEN vecursor %NOTFOUND;
         DBMS_OUTPUT.PUT( vecursor%ROWCOUNT || ' : '  );
         DBMS_OUTPUT.PUT_LINE( verow.deptno || ', ' || verow.ename || ', ' ||  verow.hiredate);  
    END LOOP;
    -- 4) CLOSE 커서
    CLOSE vecursor;

END;

-- FOR문 사용한 암시적 커서로 수정
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









-- 저장 프로시서
-- 파라미터 in모드, < out모드, in out > 모드
-- 사원번호 (IN) -> 사원명, 주민번호 출력용 매개변수  저장 프로시저 생성.
CREATE OR REPLACE PROCEDURE up_selinsa
(
    pnum IN insa.num%TYPE
    , pname OUT insa.name%TYPE
    , pssn OUT insa.ssn%TYPE
)
IS
    vname insa.name%TYPE; -- 변수로 선언.
    vssn insa.ssn%TYPE;
BEGIN
    select name, ssn INTO vname, vssn
    FROM insa
    WHERE num = pnum;
    
    pname := vname;
    pssn := CONCAT(SUBSTR(vssn,0,8), '******'); -- 111111 - 1******
    
--EXCEPTION
END;
-- Procedure UP_SELINSA이(가) 컴파일되었습니다.

-- 
--VARIABLE vname
DECLARE
    vname insa.name%TYPE; 
    vssn insa.ssn%TYPE;
BEGIN
    UP_SELINSA(1002, vname, vssn ); -- 변수로 선언.
    DBMS_OUTPUT.PUT_LINE( vname|| ', ' || vssn);
END;






-- [ IN / OUT ] 저장 프로시저 파라미터 예시

-- IN + OUT 똑같은 변수를 사용
-- 주민등록번호(14자리)를 파라미터 IN
-- 생년월일(6자리)을 OUT 파라미터로 돌려주는 프로시저

CREATE OR REPLACE PROCEDURE up_ssn
(
    pssn IN OUT VARCHAR2
)
IS

BEGIN
    pssn := SUBSTR(pssn,0,6);
END;
-- Procedure UP_SSN이(가) 컴파일되었습니다.

DECLARE
     Vssn VARCHAR2 (14) := '112345-1234556';
BEGIN
    up_ssn(vssn);
    DBMS_OUTPUT.PUT_LINe(vssn);
END;

-- 저장함수. 예) 주민등록번호 -> 성별 체크 
--               리턴자료형 varchar2      리턴값 '여자'  '남자'

CREATE OR REPLACE FUNCTION uf_gender
(
    pssn insa.ssn%TYPE
)
RETURN VARCHAR2
IS
    vgender varchar2 (6);
BEGIN
    IF MOD(SUBSTR(pssn,-7,1),2) = 1 THEN vgender := '남자';
    ELSE vgender := '여자';
    END IF;
    
    RETURN (vgender);
--EXCEPTION

END;
-- Function UF_GENDER이(가) 컴파일되었습니다.


IF SUBSTR(ssn,-7,1) IN (1,2,5,6)


-- 나이계산하는 저장함수 만들기
CREATE OR REPLACE FUNCTION UF_AGE
(
    pssn IN VARCHAR2
    , PTYPE IN NUMBER
)
RETURN NUMBER
IS
    A NUMBER(4); --올해년도
    B NUMBER(4); -- 생일년도
    C NUMBER(1); -- 생일지남 여부
    Vcounting_age NUMBER(3); -- 세는 나이
    vamerican_age NUMBER (3); -- 만 나이
    
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
-- Function UF_AGE이(가) 컴파일되었습니다.

-- 문제) -- 예) 주민등록번호-> 1998.01.20(화) 형식의 문자열로 반환하는 저장함수 작성.테스트
-- 뒷자리가 1,2면 19 붙이기 / 뒷자리가 3,4면 20 붙이기.
CREATE OR REPLACE FUNCTION uf_birth
(
    pssn IN NUMBER
)
RETURN VARCHAR2
is
   vcentry NUMBER (2); -- 18,19,20
   vbirth VARCHAR2(20); -- "1999.09.09(화)"
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
-- Table TBL_SCORE이(가) 생성되었습니다.

CREATE SEQUENCE seq_tblscore; -- 스코어 1씩 늘려주는 시퀀스.
-- Sequence SEQ_TBLSCORE이(가) 생성되었습니다.
SELECT *
FROM user_sequences;
--- 문제 1) 학생을 추가하는 저장 프로시스 생성, 테스트
-- 학번, 이름, 국, 수, 영 합계, 등수
EXEC up_insertscore( '홍길동', 89,44,55 ); 
EXEC up_insertscore( '윤재민', 49,55,95 );
EXEC up_insertscore( '김도균', 90,94,95 );
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
    
    -- 등수 처리하고 싶다면?
    -- 모든 등수 새로 처리하는 업데이트문 주면 됨.
    up_rankScore;
    
END;


-- 문제2) up_updateScore 저장프로시적
EXEC up_updateScore( 1, 100, 100, 100 );
EXEC up_updateScore( 1, pkor =>34 );
EXEC up_updateScore( 1, pkor =>34, pmat => 90 );
EXEC up_updateScore( 1, peng =>45, pmat => 90 );
----
CREATE OR REPLACE PROCEDURE up_updateScore
(
    pnum number, -- 파라미터
    pkor NUMBER := null,
    pmat NUMBER := null,
    peng NUMBER := null
)
IS
    vkor NUMBER(3);
    vmat NUMBER(3);
    veng NUMBER(3);
    
    vtot NUMBER(3) := 0; -- 변수선언
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



-- up_rankscore / 모든 학생의 등수를 업데이트

CREATE OR REPLACE PROCEDURE up_rankscore
(
    pnum NUMBER,
    ptot NUMBER := NULL,
    pavg NUMBER := NULL,
    prank NUMBER := NULL
)
IS
    vtot NUMBER(3) := 0; -- 변수선언
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
EXEC up_insertScore( '최사랑',100,100,90 );
EXEC up_insertScore( '강아지',50,60,88 );
EXEC up_insertScore( '이정현',79,100,90 );
--
select *
FROM tbl_score;

-- up_deleteScore 학생 1명 학번으로 삭제 + 등수처리
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
-- up_selectScore 모든 학생 정보를 조회 + 명시적커서/암시적커서

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


-- 명시적 커서
CREATE OR REPLACE PROCEDURE up_selectScore
IS
  --1) 커서 선언
  CURSOR vcursor IS (SELECT * FROM tbl_score);
  vrow tbl_score%ROWTYPE;
BEGIN
  --2) OPEN  커서 실제 실행..
  OPEN vcursor;
  --3) FETCH  커서 INTO 
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




-- 암기!!
CREATE OR REPLACE PROCEDURE UP_SELECTINSA
(
    -- 커서를 파라미터(매개변수)로 전달받자.
    pinsacursor SYS_REFCURSOR -- 오라클 9i 이전에는 REF CURSORS
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
-- Procedure UP_SELECTINSA이(가) 컴파일되었습니다.

CREATE OR REPLACE PROCEDURE UP_SELECTINSA_TEST
IS
    vinsacursor SYS_REFCURSOR;

BEGIN
    -- open ~ for 문
    OPEN vinsacursor FOR SELECT name, city, basicpay FROM insa;
    UP_SELECTINSA(vinsacursor);
END;
-- Procedure UP_SELECTINSA_TEST이(가) 컴파일되었습니다.
EXEC UP_SELECTINSA_TEST;

----------------
-- [ 트리거 ] --

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

-- TBL_exam1 테이블에 insert, update, delete 이벤트ㅏㄱ 발생하면
-- 자동으로 tbl_exam2 테이블에 1에서 어떤 작업이 일어났는지 로그로 기록하는 트리거.
create or replace trigger ut_log
AFTER
insert OR delete OR UPDATE ON tbl_exam1
for each row 

--DECLARE
    -- 뱐수선언
BEGIN
    IF INSERTING THEN
         INSERT INTO tbl_exam2 (memo) VALUES (:new.name || '하나도모르겠는데') ;   -- 실행구문
    ELSIF DELETING THEN
         INSERT INTO tbl_exam2 (memo) VALUES (:OLD.name || '삭제.. 하나도모르겠는데') ;
         ELSIF UPDATING THEN
         INSERT INTO tbl_exam2 (memo) VALUES (:OLD.name || '->' || :NEW.NAME || '수정.. 하나도모르겠는데') ;
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

-- 아래는 실행 ㄴㄴ
create or replace trigger ut_deletelog
AFTER
delete ON tbl_exam1
for each row 

BEGIN
    INSERT INTO tbl_exam2 (memo) VALUES (:OLD.name || '삭제.. 하나도모르겠는데') ;   -- 실행구문
END;

------- tbl_exam1 대상 테이블로 DML문이 근무시간(9-17시) 외 또는 주말에는 처리 안되게 트리거 걸자.
CREATE OR REPLACE TRIGGER UT_LOG_BEFORE
BEFORE
INSERT OR UPDATE OR DELETE ON tbl_exam1
--FOR EACH ROW
--DECLARE
    
BEGIN
    IF TO_CHAR(SYSDATE,'DY') IN ('토','일')
    OR TO_CHAR(SYSDATE,'HH24') < 9 
    OR TO_CHAR(SYSDATE,'HH24') > 16 THEN
    RAISE_APPLICATION_ERROR(-20001, '근무시간이 아님. DML 못해 집 가시오');       -- 강제로 예외를 발생
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




















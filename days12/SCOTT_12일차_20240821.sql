SELECT * FROM t_member; -- 회원
SELECT * FROM t_poll; -- 설문
SELECT * FROM t_pollsub; -- 설문항목
SELECT * FROM t_voter; -- 투표자

-- t_멤버의 pk키
SELECT *  
FROM user_constraints  
WHERE table_name LIKE 'T_M%'  AND constraint_type = 'P';

-- 회원가입
INSERT INTO   T_MEMBER (  MEMBERSEQ,MEMBERID,MEMBERPASSWD,MEMBERNAME,MEMBERPHONE,MEMBERADDRESS )
VALUES                 (  1,         'admin', '1234',  '관리자', '010-1111-1111', '서울 강남구' );
INSERT INTO   T_MEMBER (  MEMBERSEQ,MEMBERID,MEMBERPASSWD,MEMBERNAME,MEMBERPHONE,MEMBERADDRESS )
VALUES                 (  2,         'hong', '1234',  '홍길동', '010-1111-1112', '서울 동작구' );
INSERT INTO   T_MEMBER (  MEMBERSEQ,MEMBERID,MEMBERPASSWD,MEMBERNAME,MEMBERPHONE,MEMBERADDRESS )
VALUES                 (  3,         'kim', '1234',  '김준석', '010-1111-1341', '경기 남양주시' );
    COMMIT;
    rollback;
--
--  ㄹ. 회원 정보 수정
--  로그인 -> (홍길동) -> [내 정보] -> 내 정보 보기 -> [수정] -> [이름][][][][][][] -> [저장]
--  PL/SQL
  UPDATE T_MEMBER
  SET    MEMBERNAME = , MEMBERPHONE = 
  WHERE MEMBERSEQ = 2;
--  ㅁ. 회원 탈퇴
  DELETE FROM T_MEMBER 
  WHERE MEMBERSEQ = 2;
--
   INSERT INTO T_POLL (PollSeq,Question,SDate, EDAte , ItemCount,PollTotal, RegDate, MemberSEQ )
   VALUES             ( 1  ,'좋아하는 여배우?'
                          , TO_DATE( '2024-02-01 00:00:00'   ,'YYYY-MM-DD HH24:MI:SS')
                          , TO_DATE( '2024-02-15 18:00:00'   ,'YYYY-MM-DD HH24:MI:SS') 
                          , 5
                          , 0
                          , TO_DATE( '2023-01-15 00:00:00'   ,'YYYY-MM-DD HH24:MI:SS')
                          , 1
                    );
INSERT INTO T_PollSub (PollSubSeq          , Answer , ACount , PollSeq  ) 
VALUES                (1 ,'배슬기', 0, 1 );
INSERT INTO T_PollSub (PollSubSeq          , Answer , ACount , PollSeq  ) 
VALUES                (2 ,'김옥빈', 0, 1 );
INSERT INTO T_PollSub (PollSubSeq          , Answer , ACount , PollSeq  ) 
VALUES                (3 ,'아이유', 0, 1 );
INSERT INTO T_PollSub (PollSubSeq          , Answer , ACount , PollSeq  ) 
VALUES                (4 ,'김선아', 0, 1 );
INSERT INTO T_PollSub (PollSubSeq          , Answer , ACount , PollSeq  ) 
VALUES                (5 ,'홍길동', 0, 1 );      
   COMMIT;                    

-- 투표가능한 항목 추가
   INSERT INTO T_POLL (PollSeq,Question,SDate, EDAte , ItemCount,PollTotal, RegDate, MemberSEQ )
   VALUES             ( 2  ,'좋아하는 과목?'
                          , TO_DATE( '2024-08-12 00:00:00'   ,'YYYY-MM-DD HH24:MI:SS')
                          , TO_DATE( '2024-08-28 18:00:00'   ,'YYYY-MM-DD HH24:MI:SS') 
                          , 4
                          , 0
                          , TO_DATE( '2024-02-20 00:00:00'   ,'YYYY-MM-DD HH24:MI:SS')
                          , 1
                    );

INSERT INTO T_PollSub (PollSubSeq          , Answer , ACount , PollSeq  ) 
VALUES                (6 ,'자바', 0, 2 );
INSERT INTO T_PollSub (PollSubSeq          , Answer , ACount , PollSeq  ) 
VALUES                (7 ,'오라클', 0, 2 );
INSERT INTO T_PollSub (PollSubSeq          , Answer , ACount , PollSeq  ) 
VALUES                (8 ,'HTML5', 0, 2 );
INSERT INTO T_PollSub (PollSubSeq          , Answer , ACount , PollSeq  ) 
VALUES                (9 ,'JSP', 0, 2 );
   
   COMMIT;
--
   INSERT INTO T_POLL (PollSeq,Question,SDate, EDAte , ItemCount,PollTotal, RegDate, MemberSEQ )
   VALUES             ( 3  ,'좋아하는 색?'
                          , TO_DATE( '2024-09-01 00:00:00'   ,'YYYY-MM-DD HH24:MI:SS')
                          , TO_DATE( '2024-09-15 18:00:00'   ,'YYYY-MM-DD HH24:MI:SS') 
                          , 3
                          , 0
                          , TO_DATE( '2024-03-01 00:00:00'   ,'YYYY-MM-DD HH24:MI:SS')
                          , 1
                    );
INSERT INTO T_PollSub (PollSubSeq          , Answer , ACount , PollSeq  ) 
VALUES                (10 ,'빨강', 0, 3 );
INSERT INTO T_PollSub (PollSubSeq          , Answer , ACount , PollSeq  ) 
VALUES                (11 ,'녹색', 0, 3 );
INSERT INTO T_PollSub (PollSubSeq          , Answer , ACount , PollSeq  ) 
VALUES                (12 ,'파랑', 0, 3 ); 
   
   COMMIT;
--
SELECT *
FROM (
    SELECT  pollseq 번호, question 질문, membername 작성자
         , sdate 시작일, edate 종료일, itemcount 항목수, polltotal 참여자수
         , CASE 
              WHEN  SYSDATE > edate THEN  '종료'
              WHEN  SYSDATE BETWEEN  sdate AND edate THEN '진행 중'
              ELSE '시작 전'
           END 상태 -- 추출속성   종료, 진행 중, 시작 전
    FROM t_poll p JOIN  t_member m ON m.memberseq = p.memberseq
    ORDER BY 번호 DESC
) t 
WHERE 상태 != '시작 전';  
-- 설문상세보기?
SELECT question, membername
               , TO_CHAR(regdate, 'YYYY-MM-DD AM hh:mi:ss')
               , TO_CHAR(sdate, 'YYYY-MM-DD')
               , TO_CHAR(edate, 'YYYY-MM-DD')
               , CASE 
                  WHEN  SYSDATE > edate THEN  '종료'
                  WHEN  SYSDATE BETWEEN  sdate AND edate THEN '진행 중'
                  ELSE '시작 전'
               END 상태
               , itemcount
           FROM t_poll p JOIN t_member m ON p.memberseq = m.memberseq
           WHERE pollseq = 2;
-- 설문항목 가져오는 쿼리
SELECT answer
           FROM t_pollsub
           WHERE pollseq = 2;
-- 총 참여자수 몇명?
SELECT  polltotal  
    FROM t_poll
    WHERE pollseq = 2;
    
-- 막대그래프 그리기
SELECT answer, acount
        , ( SELECT  polltotal      FROM t_poll    WHERE pollseq = 2 ) totalCount
        -- ,  막대그래프
        , ROUND (acount /  ( SELECT  polltotal      FROM t_poll    WHERE pollseq = 2 ) * 100) || '%'
     FROM t_pollsub
    WHERE pollseq = 2;
    
    

--
 INSERT INTO t_voter 
    ( vectorseq, username, regdate, pollseq, pollsubseq, memberseq )
    VALUES
    (      2   ,  '홍길동'      , SYSDATE,   2  ,     6 ,        2 );
    COMMIT;
--
  -- 1)         2/3 자동 UPDATE  [트리거]
    -- (2) t_poll   totalCount = 1증가
    UPDATE   t_poll
    SET polltotal = polltotal + 1
    WHERE pollseq = 2;
    
    -- (3)t_pollsub   account = 1증가
    UPDATE   t_pollsub
    SET acount = acount + 1
    WHERE  pollsubseq = 6;
    
    commit;




-- PL/SQL 시작

-- PL/SQL이란?
-- 제어문, 이프문 등을 오라클에서 사용할 수 있게 해줌.
-- 블록 구조로 되어있음.
-- 선언부분 / 실행부분 / 예외처리부분 => 총 3부분
-- 블록 내에서는 그룹함수 등을 사용 불가



--DECLARE

BEGIN -- 필수
    /*
    select
    UPDATE
    SELECT
    DELETE
    INSERT . . . DML문 작성가능.
    
    */

--EXCEPTION

END; -- 필수


-- 1) Anonymous Procedure (익명 프로시저)
DECLARE
    -- 변수, 상수 선언 블럭 (v를 붙여주자.)
    vename VARCHAR2(10); -- 세미콜론 필수!!!!!!!
    vpay NUMBER;
    -- 자바 상수 선언 : FINAL double PI = 3.141592;
    -- 오라클 상수 선언 : 
--    vpi CONSTRAINT NUMBER = 3.141592;
      vpi CONSTANT NUMBER := 3.14;
BEGIN
    SELECT ename, sal+NVL(comm,0) pay
            INTO vename, vpay -- SELECT, PATCH문에 "INTO" 사용하여 변수에 ~값을 할당.
    FROM emp;
    -- WHERE empno = 7369;
    -- ORA-01422: exact fetch returns more than requested number of rows
    -- 오류내용 : 커서 (CURSOR) 사용해야함. // 두 개 이상의 레코드가 사용될때.
    
    -- 출력은? DBMS_OUTPUT ~
    DBMS_OUTPUT.PUT_LINE(vename || ', ' || vpay );
--EXCEPTION
END;
-- PL/SQL 프로시저가 성공적으로 완료되었습니다.



-- 문제) dept 테이블에서 
-- 30번 부서의 부서명을 얻어와서 출력하는  익명프로시저를 작성,테스트
DESC DEPT;
DECLARE
--    vdname VARCHAR2(14);
    vdname dept.dname%TYPE; -- plsql에서는 이렇게 사용함. -> 만약 자료형크기가 바뀌면 일일이 값을 바꿔야하기때문. 
--    vdeptno NUMBER(2);
BEGIN
    SELECT dname INTO vdname
    FROM DEPT
    WHERE deptno = 30;
    DBMS_OUTPUT.PUT_LINE(vdname);
--EXCEPTION
END;


-- 문제) dept 테이블에서 
-- 30번 부서의 부서명을 얻어와서 10번부서으 ㅣ지역명으로 설정

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

--10번 부서원중에 최고급여 sal을 받는 사원의 정보를 출력
SELECT t.*
FROM 
    (SELECT ename, empno, job, sal,  MAX(sal)
    FROM emp
    WHERE deptno = 10
    GROUP BY  ename, empno, job, sal
    ORDER BY sal desc) t
WHERE ROWNUM = 1;

-- 4) PL/SQL 에서 처리.
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
    
    DBMS_OUTPUT.PUT_LINE( '사원번호 : ' || VEMPNO );
    DBMS_OUTPUT.PUT_LINE( '사원명 : ' || VENAME );
    DBMS_OUTPUT.PUT_LINE( '입사일자 : ' || VHIREDATE );
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
    vemprow     emp%ROWTYPE; -- emp의 모든 칼럼을 저장할 수 있는 변수
BEGIN
    -- 1.
    SELECT MAX(sal) INTO VMAX_SAL_10
    FROM emp
    WHERE deptno = 10;
    
    -- 2.
    SELECT empno, ename, job, sal, hiredate, deptno 
    INTO vemprow.empno, vemprow.ename, vemprow.job, vemprow.sal, vemprow.hiredate, vemprow.deptno 
    -- 출력하고자 하는것에 vemprow. 붙이면 됨.
    FROM emp
    WHERE sal = VMAX_SAL_10 AND deptno = 10;
    
    DBMS_OUTPUT.PUT_LINE( '사원번호 : ' || vemprow.EMPNO ); -- 여기도 수정
    DBMS_OUTPUT.PUT_LINE( '사원명 : ' || vemprow.ENAME );
    DBMS_OUTPUT.PUT_LINE( '입사일자 : ' || vemprow.HIREDATE );
--EXCEPTION

END;

--  := 대입연산자
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

-- PL/SQL 제어문
IF (조건식)(
    //
    //
)

IF 조건식 THEN -- (
-- if에 조건식 괄호 생략 가능
END IF; -- )


IF 조건식 THEN
--
ELSE
--
END IF;


IF 조건식 (

)ELSE IF (
)ELSE IF (
)ELSE  (
)

-- 오라클에서의 ifelse
IF 조건식 THEN (
)
ELSIF 조건식 THEN (
)
ELSIF 조건식 THEN (
)
END IF;


DECLARE
    vnum NUMBER(4) := 0;
    vresult VARCHAR2(6) := '홀수';
BEGIN
    vnum := :bindNumber; -- 바인드변수 / 우리가 직접 입력 가능
    IF MOD(vnum,2)=0 THEN
    vresult := '짝수';
    ELSE
    vresult := '홀수';
    END IF;
    DBMS_OUTPUT.PUT_LINE(vresult);
END;

-- [문제] PL/SQL   IF문 연습문제...
--  국어점수 입력받아서 수우미양가 등급 출력... ( 익명프로시저 )
DECLARE
    vkor NUMBER(3) := 0;
    vresult VARCHAR2(3) := '가';
BEGIN
    vkor := :bindNumber;
    IF   vkor >= 90 THEN vresult := '수';
    ELSIF vkor < 90 and vkor >= 80 THEN vresult := '우';
    ELSIF vkor < 80 and vkor >= 70 THEN vresult := '미';
    ELSIF vkor < 70 and vkor >= 60 THEN vresult := '양';
    ELSIF vkor < 60 THEN vresult := '가';
    END IF;
    DBMS_OUTPUT.PUT_LINE(vresult);
END;  

--

DECLARE
    vkor NUMBER(3) := 0;
    vresult VARCHAR2(3) := '가';
BEGIN
    vkor := :bindNumber;
    IF  (vkor BETWEEN 0 AND 100)  THEN 
    vresult := CASE TRUNC(vkor/10)
                WHEN 10 THEN '수'
                WHEN 9 THEN '수'
                WHEN 8 THEN '우'
                WHEN 7 THEN '미'
                WHEN 6 THEN '양'
                ELSE '가'
                END;
                DBMS_OUTPUT.PUT_LINE(vresult);
    
    ELSE DBMS_OUTPUT.PUT_LINE('국어 0~100 입력!!');
    END IF;
    
    
END;  
-----------------------
-- 자바 : while (조건문)(
-- //
-- )

-- plsql
WHILE (조건식) LOOP -- (
END LOOP; -- )



 -- 무조건 반복작업하는 문 -> 자바의 WHILE IF BREAK 문과 같음.
LOOP
    --
    --
    --
    EXIT WHEN (조건식);
END LOOP;

-- 문제) 1~10까지의 합.
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

-- 1~10 합 출력 : plsql for문사용
DECLARE
--    vi number ; -- for문의 반복변수는 선언하지 않아도 된다.
    vsum number := 0;
BEGIN
    FOR vi IN 1..10
    LOOP
        DBMS_OUTPUT.PUT(vi || '+');
        vsum := vsum + vi;
    END LOOP;
    DBMS_OUTPUT.PUT_LINE( '=' || vsum);
END;

-- GOTO문 (잘안씀, 안쓰는게좋음)
declare 
      chk number := 0; 
begin 
      <<restart>> 
--      dbms_output.enable; 
      chk := chk +1; 
      dbms_output.put_line(to_char(chk)); 
      if chk <> 5 then -- 5하고 다른가? : 참
      goto restart; -- 참이면 다시 돌아감.
    end if; -- 거짓이면 끝남.
end; 

--
--DECLARE
BEGIN
  --
  GOTO first_proc;
  --
  <<second_proc>>
  DBMS_OUTPUT.PUT_LINE('> 아 처리 ');
  GOTO third_proc; 
  -- 
  --
  <<first_proc>>
  DBMS_OUTPUT.PUT_LINE('> 강 처리 ');
  GOTO second_proc; 
  -- 
  --
  --
  <<third_proc>>
  DBMS_OUTPUT.PUT_LINE('> 지 처리 '); 
--EXCEPTION
END;

-- 문제) 포문만 사용하여 구구단 2~9단 출력 (세로/가로 상관ㄴ)
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
        DBMS_OUTPUT.PUT_LINE(''); -- 개행
    END LOOP;
END;

-- 복습
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





-- for문을 사용한 select (기억하기)
DECLARE
BEGIN
    --    FOR 반복변수I IN [REVERSE] 시작값..끝값 LOOP
    FOR verow IN (SELECT ename, hiredate, job FROM emp) LOOP
    DBMS_OUTPUT.PUT_LINE( verow.ename || '/' || verow.hiredate || '/' || verow.job);
    END LOOP;
END;
--

-- %TYPE변수, %ROWTYPE변수, 
SELECT D.DEPTNO, ENAME, EMPNO, SAL+NVL(COMM,0) PAY
FROM DEPT D JOIN EMP E ON D.DEPTNO = E.DEPTNO
WHERE EMPNO = 7369;

-- %TYPE변수 사용해보자.
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

-- [ %ROWTYPE 변수 ]
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
-- RECORD 형 변수 : 위의 컬럼값들을 저장할 레코드(행) 선언
-- == 사용자가 정의하는 구조체 타입 선언
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


-- 문제 ) insa basic+sudang = pay / 0.025
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

-- 커서( cursor )란? : PL/SQL에서 SELECT한 결과물을 저장하는 공간.
-- 결괏값이 1개면 자동으로 저장되지만,
-- 2개 이상이면 커서를 명시해야한다.
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
    -- 1) 커서 선언
    CURSOR vdecursor IS (SELECT D.DEPTNO, dname, ENAME, EMPNO, SAL+NVL(COMM,0) PAY
                      FROM DEPT D JOIN EMP E ON D.DEPTNO = E.DEPTNO
                      );
BEGIN
    -- 2) 커서 오픈 == select문 실행
    OPEN vdecursor; -- CTRL + ENTER
    
    -- 3) FETCH -- 가져오다
    LOOP 
        FETCH vdecursor INTO vedrow;
        EXIT WHEN vdecursor%NOTFOUND;
         DBMS_OUTPUT.PUT_LINE( vedrow.DEPTNO || ', ' || vedrow.dname || ', ' || 
         vedrow.ENAME || ', ' || vedrow.EMPNO || ', ' || vedrow.PAY );
    END LOOP;
    
    -- 4) 커서 CLOSE
    CLOSE VDECURSOR;
END;

---- FOR문을 사용하는 암시적 커서 ---- 생략되는게 많아서 아주 편해짐.
BEGIN
    FOR vedrow IN (SELECT D.DEPTNO, dname, ENAME, EMPNO, SAL+NVL(COMM,0) PAY
                      FROM DEPT D JOIN EMP E ON D.DEPTNO = E.DEPTNO
                      ) LOOP
     DBMS_OUTPUT.PUT_LINE( vedrow.DEPTNO || ', ' || vedrow.dname || ', ' || 
         vedrow.ENAME || ', ' || vedrow.EMPNO || ', ' || vedrow.PAY );
    END LOOP;
END;























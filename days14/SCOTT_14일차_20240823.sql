-- 트리거 실습 

-- 입고테이블에 텔레비전 30개 들어옴 -> 상품테이블 재고수량 트리거로 최신화 ?
-- 판매테이블도 마찬가지

--상품 테이블
PK                   재고수량
1       냉장고          10
2      텔레비전         5
3       자전거          20

-- 입고 테이블

PK
입고번호        입고날짜        입고상품번호(FK)      입고수량            

1000                ??                  2                           30


--판매 테이블
PK
판매번호        판매날짜        판매상품번호(FK)      판매수량

1000                ???                     2                        15


-- 상품 테이블 작성
CREATE TABLE 상품 (
   상품코드      VARCHAR2(6) NOT NULL PRIMARY KEY
  ,상품명        VARCHAR2(30)  NOT NULL
  ,제조사        VARCHAR2(30)  NOT NULL
  ,소비자가격     NUMBER
  ,재고수량       NUMBER DEFAULT 0
);

-- 입고 테이블 작성
CREATE TABLE 입고 (
   입고번호      NUMBER PRIMARY KEY
  ,상품코드      VARCHAR2(6) NOT NULL CONSTRAINT FK_ibgo_no
                 REFERENCES 상품(상품코드)
  ,입고일자     DATE
  ,입고수량      NUMBER
  ,입고단가      NUMBER
);

-- 판매 테이블 작성
CREATE TABLE 판매 (
   판매번호      NUMBER  PRIMARY KEY
  ,상품코드      VARCHAR2(6) NOT NULL CONSTRAINT FK_pan_no
                 REFERENCES 상품(상품코드)
  ,판매일자      DATE
  ,판매수량      NUMBER
  ,판매단가      NUMBER
);


-- 상품 테이블에 자료 추가
INSERT INTO 상품(상품코드, 상품명, 제조사, 소비자가격) VALUES
        ('AAAAAA', '디카', '삼싱', 100000);
INSERT INTO 상품(상품코드, 상품명, 제조사, 소비자가격) VALUES
        ('BBBBBB', '컴퓨터', '엘디', 1500000);
INSERT INTO 상품(상품코드, 상품명, 제조사, 소비자가격) VALUES
        ('CCCCCC', '모니터', '삼싱', 600000);
INSERT INTO 상품(상품코드, 상품명, 제조사, 소비자가격) VALUES
        ('DDDDDD', '핸드폰', '다우', 500000);
INSERT INTO 상품(상품코드, 상품명, 제조사, 소비자가격) VALUES
         ('EEEEEE', '프린터', '삼싱', 200000);
COMMIT;

SELECT * FROM 상품;
SELECT * FROM 입고;

--문제1) 입고 테이블에 상품이 입고가 되면 자동으로 상품 테이블의 재고수량이  update 되는 트리거 생성 + 확인
-- 입고 테이블에 데이터 입력  
 --  ut_insIpgo

CREATE OR REPLACE TRIGGER ut_insIpgo
AFTER --insert(입고) 후에 업데이트해야하니까(재고)
INSERT ON 입고
FOR EACH ROW -- 행 레벨 트리거.. INSERT (입고) 레코드 수만큼 트리거 발동..!
BEGIN
    -- :NEW.상품코드 :NEW.입고수량
    
    UPDATE 상품
    SET 재고수량 = 재고수량 + :NEW.입고수량
    WHERE 상품코드 = :NEW.상품코드;
-- COMMIT ;     트리거는 X

--EXCEPTION
END;
--Trigger UT_INSIPGO이(가) 컴파일되었습니다.


--밑에 실행해서 반영 확인

-- 일단 붙여만 두고 실행 이따가 (트리거 걸고)--
INSERT INTO 입고 (입고번호, 상품코드, 입고일자, 입고수량, 입고단가)
              VALUES (1, 'AAAAAA', '2023-10-10', 5,   50000);
INSERT INTO 입고 (입고번호, 상품코드, 입고일자, 입고수량, 입고단가)
              VALUES (2, 'BBBBBB', '2023-10-10', 15, 700000);
INSERT INTO 입고 (입고번호, 상품코드, 입고일자, 입고수량, 입고단가)
              VALUES (3, 'AAAAAA', '2023-10-11', 15, 52000);
INSERT INTO 입고 (입고번호, 상품코드, 입고일자, 입고수량, 입고단가)
              VALUES (4, 'CCCCCC', '2023-10-14', 15,  250000);
INSERT INTO 입고 (입고번호, 상품코드, 입고일자, 입고수량, 입고단가)
              VALUES (5, 'BBBBBB', '2023-10-16', 25, 700000);
COMMIT;

SELECT * FROM 입고;
SELECT * FROM 상품;



-- 문제2) 입고 테이블에서 입고가 수정되는 경우 (원래 25개인데 30개로 수정해야하는 상황 )
--상품테이블의 재고수량 수정 ?


CREATE OR REPLACE TRIGGER ut_updIpgo
AFTER 
UPDATE ON 입고 -- 입고 테이블에 업데이트가 발생할 때 발동(트리거) 해야 하니까
FOR EACH ROW 
BEGIN
    
    UPDATE 상품
    SET 재고수량 = 재고수량 + :NEW.입고수량 -:OLD.입고수량 
    WHERE 상품코드 = :NEW.상품코드;
-- COMMIT ;     트리거는 X

--EXCEPTION
END;

--트리거 생성 후 테스트
UPDATE 입고 
SET 입고수량 = 30 
WHERE 입고번호 = 5;
COMMIT;






--입고 테이블에서 입고가 취소되어서 입고 삭제.    상품테이블의 재고수량 수정 ?

CREATE OR REPLACE TRIGGER ut_delIpgo
AFTER 
DELETE ON 입고 -- 입고 테이블에 삭제가 발생할 때 발동(트리거) 
FOR EACH ROW 
BEGIN
    -- DEL이라서 :NEW는 쓸 수 없음 (새로운 데이터 X)
    UPDATE 상품
    SET 재고수량 = 재고수량 - :OLD.입고수량 
    WHERE 상품코드 = :OLD.상품코드; --그래서 여기도 OLD가 됨
-- COMMIT ;     트리거는 X

--EXCEPTION
END;




--트리거 생성 후 테스트

DELETE FROM 입고 
WHERE 입고번호 = 5;
COMMIT;

SELECT * FROM 입고;
SELECT * FROM 상품; --엘디 콤퓨타 15개 됐다 ㅇㅋ
SELECT * FROM 판매;


---------------------
--문제
-- 문제4) 판매테이블에 판매가 되면 (INSERT) 
--       상품테이블의 재고수량이 수정
-- ut_inspan

CREATE OR REPLACE TRIGGER ut_inspan
BEFORE 
INSERT ON 판매
FOR EACH ROW
DECLARE -- 여기서도 건웅
    jaego 상품.재고수량%TYPE;
BEGIN
    
    SELECT 재고수량 INTO jaego
    FROM 상품
    WHERE 상품코드 = :NEW.상품코드;
    
    IF :NEW.판매수량 > jaego
    THEN  RAISE_APPLICATION_ERROR(-20008, '수량부족'); 
    ELSE
    UPDATE 상품
    SET 재고수량 = 재고수량 - :NEW.판매수량
    WHERE 상품코드 = :NEW.상품코드;
    END IF;

--EXCEPTION
END;



-- 트리거 만들고 테스트
INSERT INTO 판매 (판매번호, 상품코드, 판매일자, 판매수량, 판매단가) VALUES
               (2, 'AAAAAA', '2023-11-10', 7, 1000000);
 
INSERT INTO 판매 (판매번호, 상품코드, 판매일자, 판매수량, 판매단가) VALUES
               (2, 'AAAAAA', '2023-11-12', 50, 1000000);
COMMIT; 

-- 문제5) 판매번호 1  20     판매수량 5 -> 10 
-- ut_updPan

CREATE OR REPLACE TRIGGER ut_updpan
BEFORE
UPDATE ON 판매
FOR EACH ROW
DECLARE
    jaego 상품.재고수량%TYPE;
BEGIN
    
    SELECT 재고수량 INTO jaego
    FROM 상품
    WHERE 상품코드 = :NEW.상품코드;

    IF :NEW.판매수량 > ( jaego + :OLD.판매수량 )
    THEN  RAISE_APPLICATION_ERROR(-20008, '수량부족, 원래 갯수만큼만 구매합니다'); 
    ELSE
    UPDATE 상품
    SET 재고수량 = 재고수량 +:OLD.판매수량  - :NEW.판매수량
    WHERE 상품코드 = :NEW.상품코드;
    END IF;

--EXCEPTION
END;



UPDATE 판매 
SET 판매수량 = 10
WHERE 판매번호 = 1;

SELECT * FROM 입고;
SELECT * FROM 상품;
SELECT * FROM 판매;




-- 문제6)판매번호 1   (AAAAA  10)   판매 취소 (DELETE)
--      상품테이블에 재고수량 수정
--      ut_delPan

CREATE OR REPLACE TRIGGER ut_delpan
AFTER
DELETE ON 판매
FOR EACH ROW
BEGIN

    UPDATE 상품
    SET 재고수량 = 재고수량 + :OLD.판매수량
    WHERE 상품코드 = :OLD.상품코드;
  

END;

--구매 취소
DELETE FROM 판매 
WHERE 판매번호=1;


SELECT * FROM 입고;
SELECT * FROM 상품;
SELECT * FROM 판매;






----------------예외처리---------------

INSERT INTO emp (empno, ename, deptno)
VALUES ( 9999, 'admin', 90) ;

--명령의 284 행에서 시작하는 중 오류 발생 -
--INSERT INTO emp (empno, ename, deptno)
--VALUES ( 9999, 'admin', 90)
--오류 보고 -
--ORA-02291: integrity constraint (SCOTT.FK_DEPTNO) violated - parent key not found
-- FK 위배 : 90번 부서는 없다

-- 1. 미리정의된 에러처리방법
CREATE OR REPLACE PROCEDURE UP_EXCEPTIONTEST
(
    psal IN emp.sal%TYPE
    
)
IS
    vename emp.ename%TYPE;
    
BEGIN
    SELECT ename INTO vename
    FROM emp
    WHERE sal = psal;
    DBMS_OUTPUT.PUT_LINE('> vename = ' || vename);
EXCEPTION
    WHEN NO_DATA_FOUND THEN
         RAISE_APPLICATION_ERROR(-20001, '> 쿼리 노 데이터 파운드');
    WHEN TOO_MANY_ROWS THEN
         RAISE_APPLICATION_ERROR(-20002, '> TOO_MANY_ROWS');
    WHEN OTHERS THEN
         RAISE_APPLICATION_ERROR(-20003, '> QUERY OTHERS EXCEPTION FOUND.');

END;
-- Procedure UP_EXCEPTIONTEST이(가) 컴파일되었습니다.

EXEC UP_EXCEPTIONTEST (800);
EXEC UP_EXCEPTIONTEST (9000); -- ORA-01403: no data found // 없어서 오류 떨어짐
EXEC UP_EXCEPTIONTEST (2850); -- ORA-01422: exact fetch returns more than requested number of rows
--
SELECT *
FROM emp;
--

-- 2. 미리 정의되지 않은 에러 처리 방법.

--
CREATE OR REPLACE PROCEDURE UP_INSERTEMP
(
    pempno emp.empno%TYPE,
    pename emp.ename%TYPE,
    pdeptno emp.deptno%TYPE
)
IS
    parent_key_not_found EXCEPTION;
    PRAGMA EXCEPTION_INIT (parent_key_not_found, -02291);

BEGIN
    INSERT INTO emp (empno, ename, deptno)
    VALUES ( pempno, pename, pdeptno) ;
    commit;

EXCEPTION
    WHEN parent_key_not_found THEN
         RAISE_APPLICATION_ERROR(-20011, '> QUERY fk 위배...');
    WHEN NO_DATA_FOUND THEN
         RAISE_APPLICATION_ERROR(-20001, '> QUERY NO_DATA_FOUND');
    WHEN TOO_MANY_ROWS THEN
         RAISE_APPLICATION_ERROR(-20002, '> TOO_MANY_ROWS');
    WHEN OTHERS THEN
         RAISE_APPLICATION_ERROR(-20003, '> QUERY OTHERS EXCEPTION FOUND.');

END;



EXEC UP_INSERTemp(9999, 'admin', 90);
-- ORA-20011: > QUERY fk 위배...

-- 3. 사용자가 정의한 에러 처리 방법

-- SAL범위가 A~B값 입력받아 몇명있는지 사원수 카운팅
-- 사원수 0 -> 내가 선언한 예외 강제로 발생
EXEC UP_MYEXCEPTION(800,1200);
EXEC UP_MYEXCEPTION(6000,7200); -- 0

CREATE OR REPLACE PROCEDURE UP_MYEXCEPTION
(
    plosal NUMBER,
    phisal NUMBER
)
IS
    vcount NUMBER;
    
    -- 1) 사용자 정의 예외 객체(변수) 선언
    ZERO_EMP_COUNT EXCEPTION;
BEGIN
    SELECT COUNT(*) INTO vcount
    FROM emp
    WHERE sal beTWEEN plosal AND phisal;
    
    IF vcount = 0 THEN 
        RAISE ZERO_EMP_COUNT;
    ELSE
        DBMS_OUTPUT.PUT_LINE( '> 사원수 : ' || vcount ); 
    END IF;
    

EXCEPTION
    WHEN ZERO_EMP_COUNT THEN
        RAISE_APPLICATION_ERROR(-20022, '> QUERY 사원수가 0이다.');
    WHEN NO_DATA_FOUND THEN
         RAISE_APPLICATION_ERROR(-20001, '> QUERY NO_DATA_FOUND');
    WHEN TOO_MANY_ROWS THEN
         RAISE_APPLICATION_ERROR(-20002, '> TOO_MANY_ROWS');
    WHEN OTHERS THEN
         RAISE_APPLICATION_ERROR(-20003, '> QUERY OTHERS EXCEPTION FOUND.');
END;


--
SELECT ename, sal,
--       LEAD(sal,1) OVER (ORDER BY sal) AS next_sal,
       LAG(sal,2) OVER (ORDER BY sal) AS prev_sal
    FROM emp
    WHERE deptno=10;





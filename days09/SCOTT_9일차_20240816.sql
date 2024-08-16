
-- [ 제약조건 (constraints) ] --

-- 테이블의 제약조건 검색
SELECT *
FROM user_constraints -- 뷰
WHERE table_name LIKE 'TBL_C%';

-- * 제약조건 사용 이유는?
-- 1. data integrity(데이터 무결성)을 위해 사용.
-- 2. 테이블의 삭제방지를 위해 사용됨, 행(row)을 입력, 수정, 삭제할 때 적용되는 규칙으로 사용됨.

-- 참고 ) 무결성이란?
-- 데이터의 정확성과 일관성을 유지하며, 데이터에 결손과 부정합이 없음을 보증하는 것.

-- 제약조건의 특징
-- 1. 하나의 칼럼에 여러가지 제약조건을 줄 수 있다.
-- 2. 여러 컬럼을 조합하여 하나의 KEY를 만들 수 있다.
-- 3. 언제든지 disable, enable 시킬 수 있다.
-- 4. DML작업이 잘못되는 것을 제약조건에 의해 방지한다.
 
 
-- 무결성제약조건(constraint) 생성 2가지
-- 1) 테이블 생성과 동시에 제약조건을 생성
--    ㄱ. IN-LINE 제약조건 설정 (컬럼 레벨)
--        예) seq NUMBER PRIMARY KEY 
--    ㄴ. OUT-OF_LINE 제약조건 설정 방법 (테이블 레벨)
--    CREATE TABLE XX
--    (
--          컬럼 1 -- 컬럼 레벨 (NOT NULL 제약조건은 컬럼레벨에서만 설정가능)
--        , 컬럼 2
--        
--        ...
--        
--        , 제약조건 설정 -- 테이블 레벨 (복합키 설정(여러개의 키를 하나의 키로 설정))
--        , 제약조건 설정 . . .
--    )
--    
--    예) 복합시 설정하는 이유
--    [사원 급여 지급 테이블]
--    PK (급여지급날짜 + 사원번호) 복합키 생성해야함.
--            (그러나 나중에 역정규화로 수정해야 함. 복합키는 후에 데이터 수정시 복잡하기에)
--    
-- 순번    급여지급날짜  사원번호   급여액
-- 1       2024.7.15       1111    3,000,000
-- 2       2024.7.15       1112    3,000,000
--     :
-- 3       2024.8.15       1111    3,000,000
-- 4       2024.8.15       1112    3,000,000
-- (순번 : 역정규화)

-- 컬럼 레벨 방식으로 제약조건 설정해보자! + 테이블 생성과 동시에 제약조건 설정.
DROP TABLE tbl_constraint1; -- 기존에 있다면 제거하자.
DROP TABLE tbl_bonus;
DROP TABLE tbl_emp;

CREATE TABLE tbl_constraint1
(
    -- empno NUMBER (4) PRIMARY KEY NOT NULL -> SYS_CXXXX
    empno NUMBER (4) NOT NULL CONSTRAINT pk_tblconstraint1_empno PRIMARY KEY
    , ename VARCHAR2(20) NOT NULL
    , deptno NUMBER(2) CONSTRAINT fk_tblconstraint1_deptno REFERENCES dept (deptno)
    , email VARCHAR2(150) CONSTRAINT uk_tblconstraint1_email UNIQUE -- email은 중복불가
    , kor NUMBER(3) CONSTRAINT ck_tblconstraint1_kor CHECK (kor BETWEEN 0 AND 100) -- (WHERE조건절)
    , city VARCHAR2(20) CONSTRAINT ck_tblconstraint1_city CHECK (city IN ('서울','부산','대구'))
);

-- 테이블 레벨 방식으로 제약조건 설정해보자! -> CONSTRAINT문 따로 주기 (컬럼명 [, 컬럼명(복합키. 갯수상관X)])
CREATE TABLE tbl_constraint1
(
    -- empno NUMBER (4) PRIMARY KEY NOT NULL -> SYS_CXXXX
    empno NUMBER (4) NOT NULL 
    , ename VARCHAR2(20) NOT NULL
    , deptno NUMBER(2) 
    , email VARCHAR2(150) 
    , kor NUMBER(3) 
    , city VARCHAR2(20) 
    
    , CONSTRAINT pk_tblconstraint1_empno PRIMARY KEY (empno , ename)
    , CONSTRAINT fk_tblconstraint1_deptno FOREIGN KEY(deptno) REFERENCES dept (deptno) -- FOREIGN KEY(deptno)
    , CONSTRAINT uk_tblconstraint1_email UNIQUE (email) -- email은 중복불가
    , CONSTRAINT ck_tblconstraint1_kor CHECK (kor BETWEEN 0 AND 100) -- CHECK는 이미 컬럼정보 들어가있어서 안 고침. 
    , CONSTRAINT ck_tblconstraint1_city CHECK (city IN ('서울','부산','대구'))
); -- 가독성으로는 이것도 괜찮음

-- pk 제약조건 삭제하려면?
ALTER TABLE tbl_constraint1
DROP CONSTRAINT PK_TBLCONSTRAINT1_EMPNO;
--DROP PRIMARY KEY; -- 이것도 가능

-- ck 제약조건 삭제?
ALTER TABLE tbl_constraint1
DROP CONSTRAINT CK_TBLCONSTRAINT1_KOR;
--DROP CHECK (kor); X CHECK는 없다.

-- uk 제약조건 삭제?
ALTER TABLE tbl_constraint1
DROP UNIQUE (email);
--DROP CONSTRAINT uK_TBLCONSTRAINT1_email;


SELECT *
FROM user_constraints -- 뷰
WHERE table_name LIKE 'TBL_C%';

-- ck_tblconstraint1_city 비활성화 하려면? disabel / enable
ALTER TABLE tbl_constraint1
DISABLE CONSTRAINT ck_tblconstraint1_city -- 비활성화
ENABLE CONSTRAINT ck_tblconstraint1_city; -- 활성화
  
 
-- 2. TABLE(테이블) 레벨 무결성제약조건

CREATE TABLE tbl_constraint3
(
    empno NUMBER(4)
    , ename VARCHAR2(20)
    , deptno NUMBER (2)
    
);

-- 1) empno 컬럼에 pk제약조건 추가
ALTER TABLE tbl_constraint3
ADD CONSTRAINT PK_tblconstraint3_empno PRIMARY KEY (empno);

-- 2) deptno에 FK 제약조건 추가
ALTER TABLE tbl_constraint3
ADD CONSTRAINT FK__tblconstraint3_deptno FOREIGN KEY (deptno) REFERENCES dept(deptno);

DROP TABLE tbl_constraint3;

DELETE FROM dept
WHERE deptno = 10;
-- ORA-02292: integrity constraint (SCOTT.FK_DEPTNO) violated - child record found
-- 자식 레코드가 있으니까 삭제 안된단다.

-- emp 테이블 그대로 복사, tbl_emp 생성
-- dept 복사 , tbl_dept 생성
-- 제약조건은 복사 안됨.
CREATE TABLE tbl_emp
AS(
SELECT * FROM emp
);
--
CREATE TABLE tbl_dept
AS(
SELECT * FROM dept
);
--

SELECT *
FROM user_constraints -- 뷰
WHERE table_name LIKE 'TBL_C%';

DESC tbl_emp;

-- 제약조건 추가하자.


empno primary
deptno  on delete cascade;

ALTER TABLE tbl_emp
ADD CONSTRAINT PK_tblemp_empno PRIMARY KEY (empno);

ALTER TABLE tbl_dept
ADD CONSTRAINT PK_tblemp_deptno PRIMARY KEY (deptno);

ALTER TABLE tbl_emp
ADD CONSTRAINT fk_tblemp_deptno FOREIGN KEY(deptno) 
                                REFERENCES tbl_dept(deptno)
                                ON DELETE SET NULL; -- 제약조건은 수정할 수 없음. 삭제 후 다시 만들어야함.
--                                ON DELETE CASCADE; -- 자식테이블의 컬럼도 같이 삭제됨
ALTER TABLE tbl_emp
DROP CONSTRAINT fk_tbldept_deptno;

ALTER TABLE tbl_emp
ADD CONSTRAINT fk_tbldept_deptno FOREIGN KEY(deptno)
                REFERENCES tbl_dept (deptno)
                ON DELETE SET NULL;

DELETE FROM tbl_dept
WHERE deptno= 30;
-- 이러면 30번 부서는 널됨 (제약조건 바뀜)

--              
SELECT *  
FROM tbl_dept;
--
SELECT *  
FROM tbl_emp;
--
DELETE FROM tbl_dept
WHERE deptno = 30; -- 자식테이블의 컬럼도 같이 삭제됨! -> ON DELETE CASCADE; 

ROLLBACK;

--
-- Data Integrity(무결성) 이란?
-- 무결성에는 다음과 같이 분류된다.
--
-- ? 1) 개체 무결성(Entity Integrity)
-- ? 2) 참조 무결성(Relational Integrity)
-- ? 3) 도메인 무결성(domain integrity)

---- JOIN ----

-- 식별관계 : 부모테이블의 pk가 자식테이블의 pk로 전이되는 것

-- 다른팀 쿼리 --

CREATE TABLE book(
       b_id     VARCHAR2(10)    NOT NULL PRIMARY KEY   -- 책ID
      ,title      VARCHAR2(100) NOT NULL  -- 책 제목
      ,c_name  VARCHAR2(100)    NOT NULL     -- c 이름
     -- ,  price  NUMBER(7) NOT NULL
 );
-- Table BOOK이(가) 생성되었습니다.
INSERT INTO book (b_id, title, c_name) VALUES ('a-1', '데이터베이스', '서울');
INSERT INTO book (b_id, title, c_name) VALUES ('a-2', '데이터베이스', '경기');
INSERT INTO book (b_id, title, c_name) VALUES ('b-1', '운영체제', '부산');
INSERT INTO book (b_id, title, c_name) VALUES ('b-2', '운영체제', '인천');
INSERT INTO book (b_id, title, c_name) VALUES ('c-1', '워드', '경기');
INSERT INTO book (b_id, title, c_name) VALUES ('d-1', '엑셀', '대구');
INSERT INTO book (b_id, title, c_name) VALUES ('e-1', '파워포인트', '부산');
INSERT INTO book (b_id, title, c_name) VALUES ('f-1', '엑세스', '인천');
INSERT INTO book (b_id, title, c_name) VALUES ('f-2', '엑세스', '서울');

COMMIT;

SELECT *
FROM book;

-- 단가테이블( 책의 가격 )
CREATE TABLE danga(
       b_id  VARCHAR2(10)  NOT NULL  -- PK , FK   (식별관계 ***)
      ,price  NUMBER(7) NOT NULL    -- 책 가격
      
      ,CONSTRAINT PK_dangga_id PRIMARY KEY(b_id)
      ,CONSTRAINT FK_dangga_id FOREIGN KEY (b_id)
              REFERENCES book(b_id)
              ON DELETE CASCADE
);
-- Table DANGA이(가) 생성되었습니다.
-- book  - b_id(PK), title, c_name
-- danga - b_id(PK,FK), price 
 
INSERT INTO danga (b_id, price) VALUES ('a-1', 300);
INSERT INTO danga (b_id, price) VALUES ('a-2', 500);
INSERT INTO danga (b_id, price) VALUES ('b-1', 450);
INSERT INTO danga (b_id, price) VALUES ('b-2', 440);
INSERT INTO danga (b_id, price) VALUES ('c-1', 320);
INSERT INTO danga (b_id, price) VALUES ('d-1', 321);
INSERT INTO danga (b_id, price) VALUES ('e-1', 250);
INSERT INTO danga (b_id, price) VALUES ('f-1', 510);
INSERT INTO danga (b_id, price) VALUES ('f-2', 400);

COMMIT; 

SELECT *
FROM danga; 

-- 책을 지은 저자테이블
CREATE TABLE au_book(
       id   number(5)  NOT NULL PRIMARY KEY
      ,b_id VARCHAR2(10)  NOT NULL  CONSTRAINT FK_AUBOOK_BID
            REFERENCES book(b_id) ON DELETE CASCADE
      ,name VARCHAR2(20)  NOT NULL
);

INSERT INTO au_book (id, b_id, name) VALUES (1, 'a-1', '저팔개');
INSERT INTO au_book (id, b_id, name) VALUES (2, 'b-1', '손오공');
INSERT INTO au_book (id, b_id, name) VALUES (3, 'a-1', '사오정');
INSERT INTO au_book (id, b_id, name) VALUES (4, 'b-1', '김유신');
INSERT INTO au_book (id, b_id, name) VALUES (5, 'c-1', '유관순');
INSERT INTO au_book (id, b_id, name) VALUES (6, 'd-1', '김하늘');
INSERT INTO au_book (id, b_id, name) VALUES (7, 'a-1', '심심해');
INSERT INTO au_book (id, b_id, name) VALUES (8, 'd-1', '허첨');
INSERT INTO au_book (id, b_id, name) VALUES (9, 'e-1', '이한나');
INSERT INTO au_book (id, b_id, name) VALUES (10, 'f-1', '정말자');
INSERT INTO au_book (id, b_id, name) VALUES (11, 'f-2', '이영애');

COMMIT;

SELECT * 
FROM au_book;

-- 고객            
-- 판매            출판사 <-> 서점
CREATE TABLE gogaek(
       g_id       NUMBER(5) NOT NULL PRIMARY KEY 
      ,g_name     VARCHAR2(20) NOT NULL
      ,g_tel      VARCHAR2(20)
);

INSERT INTO gogaek (g_id, g_name, g_tel) VALUES (1, '우리서점', '111-1111');
INSERT INTO gogaek (g_id, g_name, g_tel) VALUES (2, '도시서점', '111-1111');
INSERT INTO gogaek (g_id, g_name, g_tel) VALUES (3, '지구서점', '333-3333');
INSERT INTO gogaek (g_id, g_name, g_tel) VALUES (4, '서울서점', '444-4444');
INSERT INTO gogaek (g_id, g_name, g_tel) VALUES (5, '수도서점', '555-5555');
INSERT INTO gogaek (g_id, g_name, g_tel) VALUES (6, '강남서점', '666-6666');
INSERT INTO gogaek (g_id, g_name, g_tel) VALUES (7, '강북서점', '777-7777');

COMMIT;

SELECT *
FROM gogaek;

-- 판매
 CREATE TABLE panmai(
       id         NUMBER(5) NOT NULL PRIMARY KEY
      ,g_id       NUMBER(5) NOT NULL CONSTRAINT FK_PANMAI_GID
                     REFERENCES gogaek(g_id) ON DELETE CASCADE
      ,b_id       VARCHAR2(10)  NOT NULL CONSTRAINT FK_PANMAI_BID
                     REFERENCES book(b_id) ON DELETE CASCADE
      ,p_date     DATE DEFAULT SYSDATE
      ,p_su       NUMBER(5)  NOT NULL
);

INSERT INTO panmai (id, g_id, b_id, p_date, p_su) VALUES (1, 1, 'a-1', '2000-10-10', 10);
INSERT INTO panmai (id, g_id, b_id, p_date, p_su) VALUES (2, 2, 'a-1', '2000-03-04', 20);
INSERT INTO panmai (id, g_id, b_id, p_date, p_su) VALUES (3, 1, 'b-1', DEFAULT, 13);
INSERT INTO panmai (id, g_id, b_id, p_date, p_su) VALUES (4, 4, 'c-1', '2000-07-07', 5);
INSERT INTO panmai (id, g_id, b_id, p_date, p_su) VALUES (5, 4, 'd-1', DEFAULT, 31);
INSERT INTO panmai (id, g_id, b_id, p_date, p_su) VALUES (6, 6, 'f-1', DEFAULT, 21);
INSERT INTO panmai (id, g_id, b_id, p_date, p_su) VALUES (7, 7, 'a-1', DEFAULT, 26);
INSERT INTO panmai (id, g_id, b_id, p_date, p_su) VALUES (8, 6, 'a-1', DEFAULT, 17);
INSERT INTO panmai (id, g_id, b_id, p_date, p_su) VALUES (9, 6, 'b-1', DEFAULT, 5);
INSERT INTO panmai (id, g_id, b_id, p_date, p_su) VALUES (10, 7, 'a-2', '2000-10-10', 15);

COMMIT;

SELECT *
FROM panmai;   

-- JOIN(조인) --
--1) EQUL JOIN : = 조인조건절, NATURAL JOIN(오라클)과 동일함, PK, FK로 조인.

-- [문제] 책ID, 책제목, 출판사(c_name), 단가  컬럼 출력....
-- ㄱ. 이퀄조인 / 내추럴조인
SELECT b.b_id, title, c_name, price
FROM book b, danga d
where b.b_id = d.b_id;
-- ㄴ. 이너조인 = 이퀄조인!
SELECT b.b_id, title, c_name, price
FROM book b
INNER join danga d
on b.b_id = d.b_id;
-- ㄷ. USING절 사용 (반드시 b.b_id X / book.b_id  X)
SELECT b_id, title, c_name, price
FROM book
JOIN danga
USING (b_id);
-- ㄹ. NATURAL JOIN
SELECT b_id, title, c_name, price
FROM book
NATURAL join danga;

-- [문제]  책ID, 책제목, 판매수량, 단가, 서점명, 판매금액(=판매수량*단가) 출력
SELECT b.b_id, title, p_su, price, g_name,(p_su * price) 판매금액
FROM book b, danga d, panmai p, gogaek g
WHERE b.b_id = d.b_id AND d.b_id = p.b_id AND p.g_id = g.g_id;

-- join on 사용
SELECT b.b_id, title, p_su, price, g_name,(p_su * price) 판매금액
FROM book b

JOIN danga d ON b.b_id = d.b_id 
JOIN panmai p ON b.b_id = p.b_id
JOIN gogaek g ON p.g_id = g.g_id;


-- JOIN ~ ON 구문
SELECT b.b_id, title, p_su, g_name, price
      , p_su * price 판매금액
FROM book b 
JOIN panmai p ON b.b_id = p.b_id 
JOIN gogaek g ON p.g_id = g.g_id
JOIN danga d  ON d.b_id = b.b_id; 

-- USING 절 사용
SELECT b_id, title, p_su, g_name, price
      , p_su * price 판매금액
FROM book   JOIN panmai USING(b_id)
            JOIN gogaek USING(g_id)
            JOIN danga USING(b_id); -- USING 절 쓰니까 더 간편하다.
            
-- NON EQUL JOIN :     조인조건절 = X,  BETWEEN ~ AND ~
-- emp / sal  grade 
SELECT empno, ename, sal, losal || '~' || hisal, grade
FROM emp e 
JOIN salgrade s 
ON e.sal 
BETWEEN s.losal AND s.hisal;

-- OUTER JOIN : JOIN절을 만족하지 않는 행을 보기 위한 JOIN / (+) 연산자 사용
-- LEFT / RIGTT / FULL
-- KING 사원의 부서번호 확인 -> 부서번호를 null로 업데이트.

SELECT *
FROM emp
WHERE ename = 'KING';

UPDATE emp
SET deptno = NULL
WHERE ename = 'KING';

COMMIT;

-- 부서번호 대신에 부서명으로 출력한 쿼리.
-- JOIN : 모든 emp테이블 사원 정보를 dept 테이블과 조인해서
-- dname, ename, hiredate 칼럼 출력
SELECT dname, ename, hiredate
FROM dept d 
RIGHT OUTER JOIN emp e
ON d.deptno = e.deptno;
--
SELECT dname, ename, hiredate
FROM dept d , emp e
WHERE d.deptno(+) = e.deptno;
--

-- 각 부서의 사원수 조회, 부서명, 사원수
SELECT dname, count(*) cnt
FROM dept d
LEFT JOIN emp e
ON d.deptno = e.deptno
GROUP BY d.deptno, dname
ORDER BY d.deptno;
-- COUNT() 이해 필요... 어쩔때 1이 나오고 어쩔때 다른값이 나오나?

-- FULL JOIN
SELECT d.deptno, dname, ename, hiredate
FROM dept d
FULL JOIN emp e
ON d.deptno = e.deptno;

-- SELF JOIN
-- 사원이름, 입자일자, 직속상사의 이름 출력
SELECT a.empno, a.ename, a.hiredate, b.ename
FROM emp a
JOIN emp b
ON a.mgr = b.empno;

-- 테이블 (대분류) ->  중분류테이블 (대분류의 1~n번까지 순서대로 ...) -> 소분류테이블 (대분류이면서 중분류의 것)
-- 이 모든것을 하나의 테이블로 만들 수도 있다. / 셀프조인 3번 하는것.
-- --> 테이블 3개도 가능 / 테이블 1개로 셀프조인도 가능. / DB모델링 검색. .

-- CROSS JOIN : 데카르트 곱 / 잘 쓰진 않는다.
SELECT e.*, d.*
FROM emp e, dept d;

-- ANTI JOIN : NOT IN 사용한 조인

-- SEMI JOIN : exists 사용한 조인


-- 문제) 출판된 책들이 각각 총 몇권이 판매되었는지 조회     
--      (    책ID, 책제목, 총판매권수, 단가 컬럼 출력   )

SELECT b.b_id, b.title, SUM(p_su) 총판매권수, price 
FROM panmai p, book b, danga d
WHERE b.b_id = p.b_id AND p.b_id = d.b_id 
GROUP BY b.b_id, b.title, price;

-- 서브쿼리 사용
SELECT DISTINCT b.b_id, b.title, price
     , (SELECT SUM(p_su) FROM panmai WHERE b_id = b.b_id) 총권수
FROM panmai p, book b, danga d
WHERE b.b_id = p.b_id AND p.b_id = d.b_id ;

-- 판매권수가 가장 많은 책 정보 조회 // a-1	데이터베이스	300	73
-- TOP - N 방식 사용 : ROWNUM 과 인라인뷰 사용.
SELECT ROWNUM, t.*
FROM
        (
        SELECT b.b_id, b.title, SUM(p_su) 총판매권수, price 
        FROM panmai p, book b, danga d
        WHERE b.b_id = p.b_id AND p.b_id = d.b_id
        GROUP BY b.b_id, b.title, price
        ORDER BY 총판매권수 DESC
        ) t 
WHERE ROWNUM = 1;

-- 2) 순위 매기는 함수 // 굳이~ 복잡하게 WITH 사용하기.
WITH t AS
        (
            SELECT b.b_id, b.title, SUM(p_su) 총판매권수, price 
            FROM panmai p, book b, danga d
            WHERE b.b_id = p.b_id AND p.b_id = d.b_id 
            GROUP BY b.b_id, b.title, price
        ) , s AS (
            SELECT t.*, RANK () OVER (ORDER BY 총판매권수 DESC) 판매순위
            FROM t
        )
SELECT s.*
FROM s
WHERE s.판매순위 = 1 ;

-- 3) 
SELECT t.*
FROM
(
    SELECT b.b_id, b.title, SUM(p_su) 총판매권수, price
         , RANK () OVER (ORDER BY SUM(p_su) DESC) 판매순위
    FROM panmai p, book b, danga d
    WHERE b.b_id = p.b_id AND p.b_id = d.b_id 
    GROUP BY b.b_id, b.title, price
) t
WHERE ROWNUM = 1
;

-- 올해 판매권수가 가장 많은 책 정보를 출력
-- 책 id, 제목, 판매수량
SELECT *
FROM panmai;
-- 내 풀이
SELECT t.*
FROM 
(
SELECT b.b_id, b.title, SUM(p_su) 총판매권수
FROM panmai p, book b, danga d
WHERE b.b_id = p.b_id AND p.b_id = d.b_id AND p_date LIKE '24%' 
GROUP BY b.b_id, b.title
) t
WHERE ROWNUM = 1;
-- RANK 도 사용가능.

-- BOOK 테이블에서 한번도 판매되지 않은 책 ID, 제목, 단가 조회
SELECT b.b_id, title, price
FROM book b 
LEFT JOIN danga d
ON b.b_id = d.b_id 
JOIN panmai p 
ON b.b_id = p.b_id
WHERE p_su IS NULL;
-- 안티 조인도 가능 =>  예시 더 찾아보기

-- book테이블에서 판매가 된적 있는 책 정보?
SELECT DISTINCT b.b_id, title, price
FROM book b 
LEFT JOIN danga d
ON b.b_id = d.b_id 
JOIN panmai p 
ON b.b_id = p.b_id
WHERE p_su IS NOT NULL;
--
  SELECT b.b_id, title, price
FROM book b JOIN danga d ON b.b_id = d.b_id
WHERE EXISTS ( SELECT  b_id
    FROM panmai
    WHERE b_id = b.b_id);
WHERE b.b_id IN (
    SELECT DISTINCT b_id
    FROM panmai
); 
WHERE b.b_id = ANY(
    SELECT DISTINCT b_id
    FROM panmai
); -- 이것들도 다 가능!


--  문제) 고객별 판매 금액 출력 (고객코드, 고객명, 판매금액)
SELECT g.g_id, g_name, sum(price * p_su) 판매금액
FROM  panmai p JOIN gogaek g ON p.g_id = g.g_id
                JOIN danga d  ON p.b_id = d.b_id
     GROUP BY g.g_id, g_name;
     
     
-- 년도, 월별 판매 현황 구하기
SELECT TO_CHAR(p_date, 'YYYY') 년도별, TO_CHAR(p_date, 'MM') 월별 , sum(p_su) 총판매갯수, SUM(p_su * price) 총판매액
FROM panmai p
JOIN danga d
ON p.b_id = d.b_id
GROUP BY TO_CHAR(p_date, 'YYYY'), TO_CHAR(p_date, 'MM')
ORDER BY 년도별 , 월별;

-- 서점별 년도별 판매현황 구하기
SELECT TO_CHAR(p_date, 'YYYY') 년도별, g_name, SUM(p_su) 판매수량
FROM panmai p, gogaek g
WHERE p.g_id = g.g_id
GROUP BY TO_CHAR(p_date, 'YYYY'), g_name
ORDER BY 년도별, g_name;

-- 책의 총판매금액이 15000원 이상 팔린 책의 정보를 조회
--      ( 책ID, 제목, 단가, 총판매권수, 총판매금액 )책의 총판매금액이 15000원 이상 팔린 책의 정보를 조회
--      ( 책ID, 제목, 단가, 총판매권수, 총판매금액 )

SELECT b.b_id, title, price, sum(p_su) 총판매갯수, SUM(p_su * price) 총판매액
FROM book b JOIN panmai p ON  p.b_id = b.b_id
            JOIN danga d ON p.b_id = d.b_id
HAVING SUM(p_su * price) >= 15000 -- 집계함수가 있으면 WHERE 사용 X
GROUP BY b.b_id, title, price
ORDER BY title;
-- 집계함수가 있으면 WHERE 사용 X




-- partition by 참고!!

SELECT LEVEL month  -- 순번(단계) 
FROM dual
CONNECT BY LEVEL <= 12;
--
SELECT empno, TO_CHAR( hiredate, 'YYYY') year
            , TO_CHAR( hiredate, 'MM' ) month
FROM emp;
--
SELECT year, m.month, NVL(COUNT(empno), 0) n
FROM  (
      SELECT empno, TO_CHAR( hiredate, 'YYYY') year
            , TO_CHAR( hiredate, 'MM' ) month
      FROM emp
     ) e
     PARTITION BY ( e.year ) RIGHT OUTER JOIN 
    (
       SELECT LEVEL month   
       FROM dual
       CONNECT BY LEVEL <= 12
     ) m 
     ON e.month = m.month
     GROUP BY year, m.month
     ORDER BY year, m.month;

YEAR      MONTH          N
---- ---------- ----------
1980          1          0
1980          2          0
1980          3          0
1980          4          0
1980          5          0
1980          6          0
1980          7          0
1980          8          0
1980          9          0
1980         10          0
1980         11          0 
1980         12          1
1981          1          0
1981          2          2
1981          3          0
1981          4          1
1981          5          1
1981          6          1
1981          7          0
1981          8          0
1981          9          2
1981         10          0 
1981         11          1
1981         12          2
1982          1          1
1982          2          0
1982          3          0
1982          4          0
1982          5          0
1982          6          0
1982          7          0
1982          8          0
1982          9          0 
1982         10          0
1982         11          0
1982         12          0
-- SELECT LEVEL month  -- 순번(단계) 
FROM dual
CONNECT BY LEVEL <= 12;
--
SELECT empno, TO_CHAR( hiredate, 'YYYY') year
            , TO_CHAR( hiredate, 'MM' ) month
FROM emp;
--
SELECT year, m.month, NVL(COUNT(empno), 0) n
FROM  (
      SELECT empno, TO_CHAR( hiredate, 'YYYY') year
            , TO_CHAR( hiredate, 'MM' ) month
      FROM emp
     ) e
     PARTITION BY ( e.year ) RIGHT OUTER JOIN 
    (
       SELECT LEVEL month   
       FROM dual
       CONNECT BY LEVEL <= 12
     ) m 
     ON e.month = m.month
     GROUP BY year, m.month
     ORDER BY year, m.month;

YEAR      MONTH          N
---- ---------- ----------
1980          1          0
1980          2          0
1980          3          0
1980          4          0
1980          5          0
1980          6          0
1980          7          0
1980          8          0
1980          9          0
1980         10          0
1980         11          0 
1980         12          1
1981          1          0
1981          2          2
1981          3          0
1981          4          1
1981          5          1
1981          6          1
1981          7          0
1981          8          0
1981          9          2
1981         10          0 
1981         11          1
1981         12          2
1982          1          1
1982          2          0
1982          3          0
1982          4          0
1982          5          0
1982          6          0
1982          7          0
1982          8          0
1982          9          0 
1982         10          0
1982         11          0
1982         12          0
-- 









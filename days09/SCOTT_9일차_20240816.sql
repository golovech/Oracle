
-- [ �������� (constraints) ] --

-- ���̺��� �������� �˻�
SELECT *
FROM user_constraints -- ��
WHERE table_name LIKE 'TBL_C%';

-- * �������� ��� ������?
-- 1. data integrity(������ ���Ἲ)�� ���� ���.
-- 2. ���̺��� ���������� ���� ����, ��(row)�� �Է�, ����, ������ �� ����Ǵ� ��Ģ���� ����.

-- ���� ) ���Ἲ�̶�?
-- �������� ��Ȯ���� �ϰ����� �����ϸ�, �����Ϳ� ��հ� �������� ������ �����ϴ� ��.

-- ���������� Ư¡
-- 1. �ϳ��� Į���� �������� ���������� �� �� �ִ�.
-- 2. ���� �÷��� �����Ͽ� �ϳ��� KEY�� ���� �� �ִ�.
-- 3. �������� disable, enable ��ų �� �ִ�.
-- 4. DML�۾��� �߸��Ǵ� ���� �������ǿ� ���� �����Ѵ�.
 
 
-- ���Ἲ��������(constraint) ���� 2����
-- 1) ���̺� ������ ���ÿ� ���������� ����
--    ��. IN-LINE �������� ���� (�÷� ����)
--        ��) seq NUMBER PRIMARY KEY 
--    ��. OUT-OF_LINE �������� ���� ��� (���̺� ����)
--    CREATE TABLE XX
--    (
--          �÷� 1 -- �÷� ���� (NOT NULL ���������� �÷����������� ��������)
--        , �÷� 2
--        
--        ...
--        
--        , �������� ���� -- ���̺� ���� (����Ű ����(�������� Ű�� �ϳ��� Ű�� ����))
--        , �������� ���� . . .
--    )
--    
--    ��) ���ս� �����ϴ� ����
--    [��� �޿� ���� ���̺�]
--    PK (�޿����޳�¥ + �����ȣ) ����Ű �����ؾ���.
--            (�׷��� ���߿� ������ȭ�� �����ؾ� ��. ����Ű�� �Ŀ� ������ ������ �����ϱ⿡)
--    
-- ����    �޿����޳�¥  �����ȣ   �޿���
-- 1       2024.7.15       1111    3,000,000
-- 2       2024.7.15       1112    3,000,000
--     :
-- 3       2024.8.15       1111    3,000,000
-- 4       2024.8.15       1112    3,000,000
-- (���� : ������ȭ)

-- �÷� ���� ������� �������� �����غ���! + ���̺� ������ ���ÿ� �������� ����.
DROP TABLE tbl_constraint1; -- ������ �ִٸ� ��������.
DROP TABLE tbl_bonus;
DROP TABLE tbl_emp;

CREATE TABLE tbl_constraint1
(
    -- empno NUMBER (4) PRIMARY KEY NOT NULL -> SYS_CXXXX
    empno NUMBER (4) NOT NULL CONSTRAINT pk_tblconstraint1_empno PRIMARY KEY
    , ename VARCHAR2(20) NOT NULL
    , deptno NUMBER(2) CONSTRAINT fk_tblconstraint1_deptno REFERENCES dept (deptno)
    , email VARCHAR2(150) CONSTRAINT uk_tblconstraint1_email UNIQUE -- email�� �ߺ��Ұ�
    , kor NUMBER(3) CONSTRAINT ck_tblconstraint1_kor CHECK (kor BETWEEN 0 AND 100) -- (WHERE������)
    , city VARCHAR2(20) CONSTRAINT ck_tblconstraint1_city CHECK (city IN ('����','�λ�','�뱸'))
);

-- ���̺� ���� ������� �������� �����غ���! -> CONSTRAINT�� ���� �ֱ� (�÷��� [, �÷���(����Ű. �������X)])
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
    , CONSTRAINT uk_tblconstraint1_email UNIQUE (email) -- email�� �ߺ��Ұ�
    , CONSTRAINT ck_tblconstraint1_kor CHECK (kor BETWEEN 0 AND 100) -- CHECK�� �̹� �÷����� ���־ �� ��ħ. 
    , CONSTRAINT ck_tblconstraint1_city CHECK (city IN ('����','�λ�','�뱸'))
); -- ���������δ� �̰͵� ������

-- pk �������� �����Ϸ���?
ALTER TABLE tbl_constraint1
DROP CONSTRAINT PK_TBLCONSTRAINT1_EMPNO;
--DROP PRIMARY KEY; -- �̰͵� ����

-- ck �������� ����?
ALTER TABLE tbl_constraint1
DROP CONSTRAINT CK_TBLCONSTRAINT1_KOR;
--DROP CHECK (kor); X CHECK�� ����.

-- uk �������� ����?
ALTER TABLE tbl_constraint1
DROP UNIQUE (email);
--DROP CONSTRAINT uK_TBLCONSTRAINT1_email;


SELECT *
FROM user_constraints -- ��
WHERE table_name LIKE 'TBL_C%';

-- ck_tblconstraint1_city ��Ȱ��ȭ �Ϸ���? disabel / enable
ALTER TABLE tbl_constraint1
DISABLE CONSTRAINT ck_tblconstraint1_city -- ��Ȱ��ȭ
ENABLE CONSTRAINT ck_tblconstraint1_city; -- Ȱ��ȭ
  
 
-- 2. TABLE(���̺�) ���� ���Ἲ��������

CREATE TABLE tbl_constraint3
(
    empno NUMBER(4)
    , ename VARCHAR2(20)
    , deptno NUMBER (2)
    
);

-- 1) empno �÷��� pk�������� �߰�
ALTER TABLE tbl_constraint3
ADD CONSTRAINT PK_tblconstraint3_empno PRIMARY KEY (empno);

-- 2) deptno�� FK �������� �߰�
ALTER TABLE tbl_constraint3
ADD CONSTRAINT FK__tblconstraint3_deptno FOREIGN KEY (deptno) REFERENCES dept(deptno);

DROP TABLE tbl_constraint3;

DELETE FROM dept
WHERE deptno = 10;
-- ORA-02292: integrity constraint (SCOTT.FK_DEPTNO) violated - child record found
-- �ڽ� ���ڵ尡 �����ϱ� ���� �ȵȴܴ�.

-- emp ���̺� �״�� ����, tbl_emp ����
-- dept ���� , tbl_dept ����
-- ���������� ���� �ȵ�.
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
FROM user_constraints -- ��
WHERE table_name LIKE 'TBL_C%';

DESC tbl_emp;

-- �������� �߰�����.


empno primary
deptno  on delete cascade;

ALTER TABLE tbl_emp
ADD CONSTRAINT PK_tblemp_empno PRIMARY KEY (empno);

ALTER TABLE tbl_dept
ADD CONSTRAINT PK_tblemp_deptno PRIMARY KEY (deptno);

ALTER TABLE tbl_emp
ADD CONSTRAINT fk_tblemp_deptno FOREIGN KEY(deptno) 
                                REFERENCES tbl_dept(deptno)
                                ON DELETE SET NULL; -- ���������� ������ �� ����. ���� �� �ٽ� ��������.
--                                ON DELETE CASCADE; -- �ڽ����̺��� �÷��� ���� ������
ALTER TABLE tbl_emp
DROP CONSTRAINT fk_tbldept_deptno;

ALTER TABLE tbl_emp
ADD CONSTRAINT fk_tbldept_deptno FOREIGN KEY(deptno)
                REFERENCES tbl_dept (deptno)
                ON DELETE SET NULL;

DELETE FROM tbl_dept
WHERE deptno= 30;
-- �̷��� 30�� �μ��� �ε� (�������� �ٲ�)

--              
SELECT *  
FROM tbl_dept;
--
SELECT *  
FROM tbl_emp;
--
DELETE FROM tbl_dept
WHERE deptno = 30; -- �ڽ����̺��� �÷��� ���� ������! -> ON DELETE CASCADE; 

ROLLBACK;

--
-- Data Integrity(���Ἲ) �̶�?
-- ���Ἲ���� ������ ���� �з��ȴ�.
--
-- ? 1) ��ü ���Ἲ(Entity Integrity)
-- ? 2) ���� ���Ἲ(Relational Integrity)
-- ? 3) ������ ���Ἲ(domain integrity)

---- JOIN ----

-- �ĺ����� : �θ����̺��� pk�� �ڽ����̺��� pk�� ���̵Ǵ� ��

-- �ٸ��� ���� --

CREATE TABLE book(
       b_id     VARCHAR2(10)    NOT NULL PRIMARY KEY   -- åID
      ,title      VARCHAR2(100) NOT NULL  -- å ����
      ,c_name  VARCHAR2(100)    NOT NULL     -- c �̸�
     -- ,  price  NUMBER(7) NOT NULL
 );
-- Table BOOK��(��) �����Ǿ����ϴ�.
INSERT INTO book (b_id, title, c_name) VALUES ('a-1', '�����ͺ��̽�', '����');
INSERT INTO book (b_id, title, c_name) VALUES ('a-2', '�����ͺ��̽�', '���');
INSERT INTO book (b_id, title, c_name) VALUES ('b-1', '�ü��', '�λ�');
INSERT INTO book (b_id, title, c_name) VALUES ('b-2', '�ü��', '��õ');
INSERT INTO book (b_id, title, c_name) VALUES ('c-1', '����', '���');
INSERT INTO book (b_id, title, c_name) VALUES ('d-1', '����', '�뱸');
INSERT INTO book (b_id, title, c_name) VALUES ('e-1', '�Ŀ�����Ʈ', '�λ�');
INSERT INTO book (b_id, title, c_name) VALUES ('f-1', '������', '��õ');
INSERT INTO book (b_id, title, c_name) VALUES ('f-2', '������', '����');

COMMIT;

SELECT *
FROM book;

-- �ܰ����̺�( å�� ���� )
CREATE TABLE danga(
       b_id  VARCHAR2(10)  NOT NULL  -- PK , FK   (�ĺ����� ***)
      ,price  NUMBER(7) NOT NULL    -- å ����
      
      ,CONSTRAINT PK_dangga_id PRIMARY KEY(b_id)
      ,CONSTRAINT FK_dangga_id FOREIGN KEY (b_id)
              REFERENCES book(b_id)
              ON DELETE CASCADE
);
-- Table DANGA��(��) �����Ǿ����ϴ�.
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

-- å�� ���� �������̺�
CREATE TABLE au_book(
       id   number(5)  NOT NULL PRIMARY KEY
      ,b_id VARCHAR2(10)  NOT NULL  CONSTRAINT FK_AUBOOK_BID
            REFERENCES book(b_id) ON DELETE CASCADE
      ,name VARCHAR2(20)  NOT NULL
);

INSERT INTO au_book (id, b_id, name) VALUES (1, 'a-1', '���Ȱ�');
INSERT INTO au_book (id, b_id, name) VALUES (2, 'b-1', '�տ���');
INSERT INTO au_book (id, b_id, name) VALUES (3, 'a-1', '�����');
INSERT INTO au_book (id, b_id, name) VALUES (4, 'b-1', '������');
INSERT INTO au_book (id, b_id, name) VALUES (5, 'c-1', '������');
INSERT INTO au_book (id, b_id, name) VALUES (6, 'd-1', '���ϴ�');
INSERT INTO au_book (id, b_id, name) VALUES (7, 'a-1', '�ɽ���');
INSERT INTO au_book (id, b_id, name) VALUES (8, 'd-1', '��÷');
INSERT INTO au_book (id, b_id, name) VALUES (9, 'e-1', '���ѳ�');
INSERT INTO au_book (id, b_id, name) VALUES (10, 'f-1', '������');
INSERT INTO au_book (id, b_id, name) VALUES (11, 'f-2', '�̿���');

COMMIT;

SELECT * 
FROM au_book;

-- ��            
-- �Ǹ�            ���ǻ� <-> ����
CREATE TABLE gogaek(
       g_id       NUMBER(5) NOT NULL PRIMARY KEY 
      ,g_name     VARCHAR2(20) NOT NULL
      ,g_tel      VARCHAR2(20)
);

INSERT INTO gogaek (g_id, g_name, g_tel) VALUES (1, '�츮����', '111-1111');
INSERT INTO gogaek (g_id, g_name, g_tel) VALUES (2, '���ü���', '111-1111');
INSERT INTO gogaek (g_id, g_name, g_tel) VALUES (3, '��������', '333-3333');
INSERT INTO gogaek (g_id, g_name, g_tel) VALUES (4, '���Ｍ��', '444-4444');
INSERT INTO gogaek (g_id, g_name, g_tel) VALUES (5, '��������', '555-5555');
INSERT INTO gogaek (g_id, g_name, g_tel) VALUES (6, '��������', '666-6666');
INSERT INTO gogaek (g_id, g_name, g_tel) VALUES (7, '���ϼ���', '777-7777');

COMMIT;

SELECT *
FROM gogaek;

-- �Ǹ�
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

-- JOIN(����) --
--1) EQUL JOIN : = ����������, NATURAL JOIN(����Ŭ)�� ������, PK, FK�� ����.

-- [����] åID, å����, ���ǻ�(c_name), �ܰ�  �÷� ���....
-- ��. �������� / ���߷�����
SELECT b.b_id, title, c_name, price
FROM book b, danga d
where b.b_id = d.b_id;
-- ��. �̳����� = ��������!
SELECT b.b_id, title, c_name, price
FROM book b
INNER join danga d
on b.b_id = d.b_id;
-- ��. USING�� ��� (�ݵ�� b.b_id X / book.b_id  X)
SELECT b_id, title, c_name, price
FROM book
JOIN danga
USING (b_id);
-- ��. NATURAL JOIN
SELECT b_id, title, c_name, price
FROM book
NATURAL join danga;

-- [����]  åID, å����, �Ǹż���, �ܰ�, ������, �Ǹűݾ�(=�Ǹż���*�ܰ�) ���
SELECT b.b_id, title, p_su, price, g_name,(p_su * price) �Ǹűݾ�
FROM book b, danga d, panmai p, gogaek g
WHERE b.b_id = d.b_id AND d.b_id = p.b_id AND p.g_id = g.g_id;

-- join on ���
SELECT b.b_id, title, p_su, price, g_name,(p_su * price) �Ǹűݾ�
FROM book b

JOIN danga d ON b.b_id = d.b_id 
JOIN panmai p ON b.b_id = p.b_id
JOIN gogaek g ON p.g_id = g.g_id;


-- JOIN ~ ON ����
SELECT b.b_id, title, p_su, g_name, price
      , p_su * price �Ǹűݾ�
FROM book b 
JOIN panmai p ON b.b_id = p.b_id 
JOIN gogaek g ON p.g_id = g.g_id
JOIN danga d  ON d.b_id = b.b_id; 

-- USING �� ���
SELECT b_id, title, p_su, g_name, price
      , p_su * price �Ǹűݾ�
FROM book   JOIN panmai USING(b_id)
            JOIN gogaek USING(g_id)
            JOIN danga USING(b_id); -- USING �� ���ϱ� �� �����ϴ�.
            
-- NON EQUL JOIN :     ���������� = X,  BETWEEN ~ AND ~
-- emp / sal  grade 
SELECT empno, ename, sal, losal || '~' || hisal, grade
FROM emp e 
JOIN salgrade s 
ON e.sal 
BETWEEN s.losal AND s.hisal;

-- OUTER JOIN : JOIN���� �������� �ʴ� ���� ���� ���� JOIN / (+) ������ ���
-- LEFT / RIGTT / FULL
-- KING ����� �μ���ȣ Ȯ�� -> �μ���ȣ�� null�� ������Ʈ.

SELECT *
FROM emp
WHERE ename = 'KING';

UPDATE emp
SET deptno = NULL
WHERE ename = 'KING';

COMMIT;

-- �μ���ȣ ��ſ� �μ������� ����� ����.
-- JOIN : ��� emp���̺� ��� ������ dept ���̺�� �����ؼ�
-- dname, ename, hiredate Į�� ���
SELECT dname, ename, hiredate
FROM dept d 
RIGHT OUTER JOIN emp e
ON d.deptno = e.deptno;
--
SELECT dname, ename, hiredate
FROM dept d , emp e
WHERE d.deptno(+) = e.deptno;
--

-- �� �μ��� ����� ��ȸ, �μ���, �����
SELECT dname, count(*) cnt
FROM dept d
LEFT JOIN emp e
ON d.deptno = e.deptno
GROUP BY d.deptno, dname
ORDER BY d.deptno;
-- COUNT() ���� �ʿ�... ��¿�� 1�� ������ ��¿�� �ٸ����� ������?

-- FULL JOIN
SELECT d.deptno, dname, ename, hiredate
FROM dept d
FULL JOIN emp e
ON d.deptno = e.deptno;

-- SELF JOIN
-- ����̸�, ��������, ���ӻ���� �̸� ���
SELECT a.empno, a.ename, a.hiredate, b.ename
FROM emp a
JOIN emp b
ON a.mgr = b.empno;

-- ���̺� (��з�) ->  �ߺз����̺� (��з��� 1~n������ ������� ...) -> �Һз����̺� (��з��̸鼭 �ߺз��� ��)
-- �� ������ �ϳ��� ���̺�� ���� ���� �ִ�. / �������� 3�� �ϴ°�.
-- --> ���̺� 3���� ���� / ���̺� 1���� �������ε� ����. / DB�𵨸� �˻�. .

-- CROSS JOIN : ��ī��Ʈ �� / �� ���� �ʴ´�.
SELECT e.*, d.*
FROM emp e, dept d;

-- ANTI JOIN : NOT IN ����� ����

-- SEMI JOIN : exists ����� ����


-- ����) ���ǵ� å���� ���� �� ����� �ǸŵǾ����� ��ȸ     
--      (    åID, å����, ���ǸűǼ�, �ܰ� �÷� ���   )

SELECT b.b_id, b.title, SUM(p_su) ���ǸűǼ�, price 
FROM panmai p, book b, danga d
WHERE b.b_id = p.b_id AND p.b_id = d.b_id 
GROUP BY b.b_id, b.title, price;

-- �������� ���
SELECT DISTINCT b.b_id, b.title, price
     , (SELECT SUM(p_su) FROM panmai WHERE b_id = b.b_id) �ѱǼ�
FROM panmai p, book b, danga d
WHERE b.b_id = p.b_id AND p.b_id = d.b_id ;

-- �ǸűǼ��� ���� ���� å ���� ��ȸ // a-1	�����ͺ��̽�	300	73
-- TOP - N ��� ��� : ROWNUM �� �ζ��κ� ���.
SELECT ROWNUM, t.*
FROM
        (
        SELECT b.b_id, b.title, SUM(p_su) ���ǸűǼ�, price 
        FROM panmai p, book b, danga d
        WHERE b.b_id = p.b_id AND p.b_id = d.b_id
        GROUP BY b.b_id, b.title, price
        ORDER BY ���ǸűǼ� DESC
        ) t 
WHERE ROWNUM = 1;

-- 2) ���� �ű�� �Լ� // ����~ �����ϰ� WITH ����ϱ�.
WITH t AS
        (
            SELECT b.b_id, b.title, SUM(p_su) ���ǸűǼ�, price 
            FROM panmai p, book b, danga d
            WHERE b.b_id = p.b_id AND p.b_id = d.b_id 
            GROUP BY b.b_id, b.title, price
        ) , s AS (
            SELECT t.*, RANK () OVER (ORDER BY ���ǸűǼ� DESC) �Ǹż���
            FROM t
        )
SELECT s.*
FROM s
WHERE s.�Ǹż��� = 1 ;

-- 3) 
SELECT t.*
FROM
(
    SELECT b.b_id, b.title, SUM(p_su) ���ǸűǼ�, price
         , RANK () OVER (ORDER BY SUM(p_su) DESC) �Ǹż���
    FROM panmai p, book b, danga d
    WHERE b.b_id = p.b_id AND p.b_id = d.b_id 
    GROUP BY b.b_id, b.title, price
) t
WHERE ROWNUM = 1
;

-- ���� �ǸűǼ��� ���� ���� å ������ ���
-- å id, ����, �Ǹż���
SELECT *
FROM panmai;
-- �� Ǯ��
SELECT t.*
FROM 
(
SELECT b.b_id, b.title, SUM(p_su) ���ǸűǼ�
FROM panmai p, book b, danga d
WHERE b.b_id = p.b_id AND p.b_id = d.b_id AND p_date LIKE '24%' 
GROUP BY b.b_id, b.title
) t
WHERE ROWNUM = 1;
-- RANK �� ��밡��.

-- BOOK ���̺��� �ѹ��� �Ǹŵ��� ���� å ID, ����, �ܰ� ��ȸ
SELECT b.b_id, title, price
FROM book b 
LEFT JOIN danga d
ON b.b_id = d.b_id 
JOIN panmai p 
ON b.b_id = p.b_id
WHERE p_su IS NULL;
-- ��Ƽ ���ε� ���� =>  ���� �� ã�ƺ���

-- book���̺��� �ǸŰ� ���� �ִ� å ����?
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
); -- �̰͵鵵 �� ����!


--  ����) ���� �Ǹ� �ݾ� ��� (���ڵ�, ����, �Ǹűݾ�)
SELECT g.g_id, g_name, sum(price * p_su) �Ǹűݾ�
FROM  panmai p JOIN gogaek g ON p.g_id = g.g_id
                JOIN danga d  ON p.b_id = d.b_id
     GROUP BY g.g_id, g_name;
     
     
-- �⵵, ���� �Ǹ� ��Ȳ ���ϱ�
SELECT TO_CHAR(p_date, 'YYYY') �⵵��, TO_CHAR(p_date, 'MM') ���� , sum(p_su) ���ǸŰ���, SUM(p_su * price) ���Ǹž�
FROM panmai p
JOIN danga d
ON p.b_id = d.b_id
GROUP BY TO_CHAR(p_date, 'YYYY'), TO_CHAR(p_date, 'MM')
ORDER BY �⵵�� , ����;

-- ������ �⵵�� �Ǹ���Ȳ ���ϱ�
SELECT TO_CHAR(p_date, 'YYYY') �⵵��, g_name, SUM(p_su) �Ǹż���
FROM panmai p, gogaek g
WHERE p.g_id = g.g_id
GROUP BY TO_CHAR(p_date, 'YYYY'), g_name
ORDER BY �⵵��, g_name;

-- å�� ���Ǹűݾ��� 15000�� �̻� �ȸ� å�� ������ ��ȸ
--      ( åID, ����, �ܰ�, ���ǸűǼ�, ���Ǹűݾ� )å�� ���Ǹűݾ��� 15000�� �̻� �ȸ� å�� ������ ��ȸ
--      ( åID, ����, �ܰ�, ���ǸűǼ�, ���Ǹűݾ� )

SELECT b.b_id, title, price, sum(p_su) ���ǸŰ���, SUM(p_su * price) ���Ǹž�
FROM book b JOIN panmai p ON  p.b_id = b.b_id
            JOIN danga d ON p.b_id = d.b_id
HAVING SUM(p_su * price) >= 15000 -- �����Լ��� ������ WHERE ��� X
GROUP BY b.b_id, title, price
ORDER BY title;
-- �����Լ��� ������ WHERE ��� X




-- partition by ����!!

SELECT LEVEL month  -- ����(�ܰ�) 
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
-- SELECT LEVEL month  -- ����(�ܰ�) 
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









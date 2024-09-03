
-- ��ȣȭ
-- [ DBMS_OBFUSCATION_TOOLKIT ��ȣȭ ��Ű�� ]

CREATE TABLE tbl_member
(
    id VARCHAR2(20) PRIMARY KEY
    , passwd VARCHAR2(20)
); 

INSERT INTO tbl_member ( id, passwd ) VALUES (  'hong',  cryptit.encrypt( '1234', 'test') );
INSERT INTO tbl_member ( id, passwd ) VALUES (  'kenik',  cryptit.encrypt( 'kenik', 'test') );



-- ��Ű�� ���� �κ�
CREATE OR REPLACE PACKAGE CryptIT
IS
   FUNCTION encrypt(str VARCHAR2, HASH VARCHAR2)
       RETURN VARCHAR2;
   FUNCTION decrypt(str VARCHAR2, HASH VARCHAR2)
       RETURN VARCHAR2;
END CryptIT;


-- ��Ű�� ��ü
CREATE OR REPLACE PACKAGE BODY CryptIT
IS
   s VARCHAR2(2000);
    
   FUNCTION encrypt(str VARCHAR2, HASH VARCHAR2)
       RETURN VARCHAR2
        IS
            p NUMBER := ((FLOOR(LENGTH(str)/8+0.9))*8);
        BEGIN
            DBMS_OBFUSCATION_TOOLKIT.DESEncrypt(
               input_string => RPAD(str,p)
                ,key_string => RPAD(HASH,8,'#')
                ,encrypted_string => s
            );
            RETURN s;
        END;
   FUNCTION decrypt(str VARCHAR2, HASH VARCHAR2)
       RETURN VARCHAR2
        IS
        BEGIN
            DBMS_OBFUSCATION_TOOLKIT.DESDecrypt(
               input_string => str
                ,key_string => RPAD(HASH,8,'#')
                ,decrypted_string => s
            );
            RETURN TRIM(s);
        END;    

END CryptIT;


--

rollback;
select *
from tbl_member;


MERGE INTO employees e
USING new_salaries n
ON (e.employee_id = n.employee_id)
WHEN MATCHED THEN
    UPDATE SET e.salary = n.new_salary
WHEN NOT MATCHED THEN
    INSERT (employee_id, salary)
    VALUES (n.employee_id, n.new_salary);









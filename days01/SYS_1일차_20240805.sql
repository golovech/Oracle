-- ��� ����� ������ ��ȸ�ϴ� ����(����)
SELECT *
FROM all_users; 
-- F5 / Ctrl + Enter Ŭ��
-- SCOTT / tiger(�ҹ���) ���� ����
CREATE USER Scott IDENTIFIED BY tiger; -- User SCOTT��(��) �����Ǿ����ϴ�.
--
SELECT *
FROM dba_users;
-- SYS�� CREATE SESSION ���� �ο�
-- GRANT CREATE SESSION TO SCOTT;

GRANT CONNECT, RESOURCE TO SCOTT; -- ROLL �ο�
-- Grant��(��) �����߽��ϴ�.

select *
from dba_tables;
from all_tables; -- ��� ���̺��� ��Ÿ��.
from user_tables; -- ��(view)
from tabs; --user_tables�� ���Ӹ�

-- ORA-01940: cannot drop a user that is currently connected
-- ORA-01922: CASCADE must be specified to drop 'SCOTT' -> cascade�� �޾ƶ�!
drop user scott cascade; -- User SCOTT��(��) �����Ǿ����ϴ�.

create user scott IDENTIFIED by tiger;

-- ��� ����� ���� ��ȸ
-- hr ���� �ִ��� Ȯ�� (���� ����)
select *
from all_users;

-- hr ������ ��й�ȣ�� lion���� ���� -> ����Ŭ�� ����(���)
alter user hr identified by lion; -- User HR��(��) ����Ǿ����ϴ�.
ALTER USER hr ACCOUNT UNLOCK; -- User HR��(��) ����Ǿ����ϴ�. // �������

select *
from all_users;
create user madang identified by madang;
GRANT CONNECT, RESOURCE TO madang; -- ���� ���� ����!
--SELECT *
--FROM dba_users;

SELECT *
FROM all_users;
CREATE USER sarang IDENTIFIED BY sarang;
GRANT CONNECT, RESOURCE TO sarang;

ALTER USER sarang ACCOUNT UNLOCK;

SELECT *
FROM all_tables;

SELECT *
FROM dba_users;


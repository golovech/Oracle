select *
from tabs;

-- SELECT  first_name + last_name  : ORA-01722: invalid number // + �Ἥ!
-- �ڹ�: ���ڿ� ���� ������ +
-- ����Ŭ: ���ڿ� ���� ������ ||, ' ' ���ڿ�, ��¥���� ���� '  ' �ȿ� �ִ´�. Į������ ��Ī�� " " �̴�.
SELECT  first_name as fname, first_name || ' ' || last_name AS "name"
, CONCAT(CONCAT (first_name, ' ' ) ,last_name ) AS name -- " " ��� ��.(���ڿ��� ������ ���ٸ�)
, CONCAT(CONCAT (first_name, ' ' ) ,last_name ) name -- AS ��������
FROM employees;

SELECT *
FROM tabs
WHERE table_name = 'DUAL';
WHERE table_name = 'employees';

SELECT *
FROM arirang;
FROM scott.emp; -- ��Ű��.���̺��

-- SYNONYM ARIRANG��(��) �����Ǿ����ϴ�.
CREATE PUBLIC SYNONYM arirang
FOR scott.emp;

GRANT CONNECT, RESOURCE TO HR;
GRANT SELECT ON scott.emp TO HR; -- GRANT�� select���� ����. �̰� �� �ɱ�?

-- �ó�� �Ƹ��� ����
DROP PUBLIC SYNONYM arirang;

-- �ó�� ��ȸ
SELECT *
FROM all_synonyms
WHERE synonym_name = 'DUAL'; -- �ó���� ��� �����ִ��� ��ȸ

-- ��� ���̺� ��ȸ
SELECT *
FROM dba_tables;
FROM all_tables;
FROM user_tables;


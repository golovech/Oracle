SELECT *
FROM dba_users;
FROM all_users;
-- ��� ���̺� ���� ��ȸ? + OWNER�� SCOTT�� ���̺������� ��ȸ?
SELECT *
FROM all_tables
-- ���� OWNER �� SCOTT�� WHERE;
-- WHERE : ������.
-- LOB : ū �ڷ���
WHERE OWNER = 'SCOTT'; 

--FROM dba_tables;

--
SELECT *
FROM V$RESERVED_WORDS
WHERE keyword = 'DATE'; -- DATE�� ������. intó��...

SELECT *
FROM dba_users;
FROM all_users;
-- 모든 테이블 정보 조회? + OWNER가 SCOTT인 테이블정보만 조회?
SELECT *
FROM all_tables
-- 조건 OWNER 가 SCOTT인 WHERE;
-- WHERE : 조건절.
-- LOB : 큰 자료형
WHERE OWNER = 'SCOTT'; 

--FROM dba_tables;

--
SELECT *
FROM V$RESERVED_WORDS
WHERE keyword = 'DATE'; -- DATE는 예약어다. int처럼...

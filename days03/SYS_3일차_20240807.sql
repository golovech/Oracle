SELECT *
FROM tabs
WHERE table_name = 'DUAL';
WHERE table_name = 'employees';

SELECT *
FROM arirang;
FROM scott.emp; -- 스키마.테이블명

-- SYNONYM ARIRANG이(가) 생성되었습니다.
CREATE PUBLIC SYNONYM arirang
FOR scott.emp;

GRANT CONNECT, RESOURCE TO HR;
GRANT SELECT ON scott.emp TO HR; -- GRANT로 select권한 생성. 이건 왜 될까?

-- 시노님 아리랑 삭제
DROP PUBLIC SYNONYM arirang;

-- 시노님 조회
SELECT *
FROM all_synonyms
WHERE synonym_name = 'DUAL'; -- 시노님이 듀얼 갖고있는지 조회

-- 모든 테이블 조회
SELECT *
FROM dba_tables;
FROM all_tables;
FROM user_tables;


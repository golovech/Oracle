-- 모든 사용자 정보를 조회하는 질의(쿼리)
SELECT *
FROM all_users; 
-- F5 / Ctrl + Enter 클릭
-- SCOTT / tiger(소문자) 계정 생성
CREATE USER Scott IDENTIFIED BY tiger; -- User SCOTT이(가) 생성되었습니다.
--
SELECT *
FROM dba_users;
-- SYS가 CREATE SESSION 권한 부여
-- GRANT CREATE SESSION TO SCOTT;

GRANT CONNECT, RESOURCE TO SCOTT; -- ROLL 부여
-- Grant을(를) 성공했습니다.

select *
from dba_tables;
from all_tables; -- 모든 테이블을 나타냄.
from user_tables; -- 뷰(view)
from tabs; --user_tables의 줄임말

-- ORA-01940: cannot drop a user that is currently connected
-- ORA-01922: CASCADE must be specified to drop 'SCOTT' -> cascade를 달아라!
drop user scott cascade; -- User SCOTT이(가) 삭제되었습니다.

create user scott IDENTIFIED by tiger;

-- 모든 사용자 정보 조회
-- hr 계정 있는지 확인 (샘플 계정)
select *
from all_users;

-- hr 계정의 비밀번호를 lion으로 수정 -> 오라클에 접속(녹색)
alter user hr identified by lion; -- User HR이(가) 변경되었습니다.
ALTER USER hr ACCOUNT UNLOCK; -- User HR이(가) 변경되었습니다. // 잠금해제

select *
from all_users;
create user madang identified by madang;
GRANT CONNECT, RESOURCE TO madang; -- 마당 계정 생성!
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


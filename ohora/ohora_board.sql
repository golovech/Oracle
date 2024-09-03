
SELECT *
FROM OH_ORDER;

SELECT *
FROM OH_PRODUCT;

SELECT *
FROM OH_CART;

SELECT *
FROM OH_USR;

SELECT *
FROM OH_coupon;

--------------------------------------------------------------------------------

-- *** 마이페이지 첫 화면 출력 ***
CREATE OR REPLACE PROCEDURE see_level
(
    pusr_num oh_usr.usr_num%TYPE -- 회원번호를 변수로 받기
)
IS
    vusr_name oh_usr.usr_name%TYPE; -- 회원이름 받아오기
    vusr_level oh_usr.usr_level%TYPE; -- 회원등급 가져오기
    vusr_nam NUMBER; -- 다음등급까지 남은 금액 받아오기
    vusr_sixmonths NUMBER; -- 6개월 누적 구매금액
    vusr_level_check NUMBER; -- 1이면 CREW, 2면 FAMILY, 3이면 FRIEND로 업데이트
    vusr_coupon NUMBER; -- 쿠폰 갯수 가져오기
    vusr_point NUMBER; -- 적립금 금액 가져오기
    vusr_od_preparing NUMBER; -- 상품 준비중
    vusr_od_shipping NUMBER; -- 배송 준비중
    vusr_od_delivering NUMBER; -- 배송중
    vusr_od_delivered NUMBER; -- 배송완료
    vusr_cart_pd_count NUMBER; -- 장바구니 상품 갯수

    -- 주문 상세 정보
    CURSOR order_cursor IS
        SELECT o.od_date, s.os_name, s.os_price
        FROM oh_order o
        JOIN oh_order_sub s ON o.od_num = s.od_num
        WHERE o.usr_num = pusr_num
        ORDER BY o.od_date;
    
    -- 커서 변수
    order_record order_cursor%ROWTYPE;

    -- 일자별 결제금액 저장 변수
    vusr_current_date DATE;
    vusr_daily_sum NUMBER := 0;
    vusr_previous_date DATE := NULL;

BEGIN
    -- 장바구니 품목갯수 카운트
    SELECT COUNT(*) INTO vusr_cart_pd_count
    FROM oh_cart
    WHERE usr_num = pusr_num;
    
    -- 상품 배송상태 카운트
    SELECT COUNT(*) INTO vusr_od_preparing
    FROM oh_order
    WHERE usr_num = pusr_num AND od_status = '상품준비중';
    
    SELECT COUNT(*) INTO vusr_od_shipping
    FROM oh_order
    WHERE usr_num = pusr_num AND od_status = '배송준비중';
    
    SELECT COUNT(*) INTO vusr_od_delivering
    FROM oh_order
    WHERE usr_num = pusr_num AND od_status = '배송중';
    
    SELECT COUNT(*) INTO vusr_od_delivered
    FROM oh_order
    WHERE usr_num = pusr_num AND od_status = '배송완료';
    
    -- 쿠폰 개수 조회
    SELECT COUNT(cp_num) INTO vusr_coupon
    FROM oh_coupon
    WHERE usr_num = pusr_num;
    
    -- 적립금 금액 조회
    SELECT COALESCE(SUM(pt_point), 0) INTO vusr_point
    FROM oh_point
    WHERE usr_num = pusr_num;
    
    -- 6개월 누적 구매금액 조회
    SELECT COALESCE(SUM(od_price), 0) INTO vusr_sixmonths
    FROM oh_order
    WHERE (od_date BETWEEN ADD_MONTHS(SYSDATE, -6) AND SYSDATE) AND usr_num = pusr_num;
    
    -- 등급 결정
    IF 400000 <= vusr_sixmonths THEN
        vusr_nam := 0;
        vusr_level_check := 1; -- CREW
    ELSIF 150000 <= vusr_sixmonths AND vusr_sixmonths < 400000 THEN
        vusr_nam := 400000 - vusr_sixmonths;
        vusr_level_check := 2; -- FAMILY
    ELSIF vusr_sixmonths < 150000 THEN
        vusr_nam := 150000 - vusr_sixmonths;
        vusr_level_check := 3; -- FRIEND
    END IF;
     
    -- 등급 업데이트 및 포인트 비율 설정
    IF vusr_level_check = 1 THEN
        UPDATE oh_level
        SET usr_level = 'CREW', point_rate = 3
        WHERE usr_num = pusr_num;
        UPDATE oh_usr
        SET usr_level = 'CREW'
        WHERE usr_num = pusr_num;
    ELSIF vusr_level_check = 2 THEN
        UPDATE oh_level
        SET usr_level = 'FAMILY', point_rate = 2
        WHERE usr_num = pusr_num;
        UPDATE oh_usr
        SET usr_level = 'FAMILY'
        WHERE usr_num = pusr_num;
    ELSIF vusr_level_check = 3 THEN
        UPDATE oh_level
        SET usr_level = 'FRIEND', point_rate = 1
        WHERE usr_num = pusr_num;
        UPDATE oh_usr
        SET usr_level = 'FRIEND'
        WHERE usr_num = pusr_num;
    END IF;

    COMMIT;

    -- 회원 이름과 등급 조회
    SELECT usr_name, usr_level INTO vusr_name, vusr_level
    FROM oh_usr
    WHERE usr_num = pusr_num;

    -- 결과 출력
    DBMS_OUTPUT.PUT_LINE('===================================');
    DBMS_OUTPUT.PUT_LINE(' ' || vusr_name || '님 반갑습니다.');
    DBMS_OUTPUT.PUT_LINE(' 회원님의 등급은 [ ' || vusr_level || ' ]입니다.');
    DBMS_OUTPUT.PUT_LINE(' 다음 등급까지 ' || vusr_nam || '원 남았습니다.');
    DBMS_OUTPUT.PUT_LINE('- - - - - - - - - - - - - - - - - -');
    DBMS_OUTPUT.PUT_LINE('      my point      my coupon');
    DBMS_OUTPUT.PUT_LINE('       [ ' || vusr_point || ' ]         [ ' || vusr_coupon || ' ]');
    DBMS_OUTPUT.PUT_LINE('===================================');
    DBMS_OUTPUT.PUT_LINE('  상품준비중 : ' || vusr_od_preparing);
    DBMS_OUTPUT.PUT_LINE('  배송준비중 : ' || vusr_od_shipping);
    DBMS_OUTPUT.PUT_LINE('    배송중   : ' || vusr_od_delivering);
    DBMS_OUTPUT.PUT_LINE('   배송완료  : ' || vusr_od_delivered);
    

    -- 커서 열기 및 데이터 조회
    OPEN order_cursor;

    LOOP
        FETCH order_cursor INTO order_record;
        EXIT WHEN order_cursor%NOTFOUND;

        vusr_current_date := order_record.od_date;
        
        -- 일자 변경 시, 이전 일자의 결제금액을 출력
        IF vusr_previous_date IS NOT NULL AND vusr_current_date <> vusr_previous_date THEN
            DBMS_OUTPUT.PUT_LINE('   결제금액  : ' || vusr_daily_sum);
            DBMS_OUTPUT.PUT_LINE('   주문상세  : 더보기 > ');
            vusr_daily_sum := 0;
        END IF;

        -- 일자별 결제금액 누적
        vusr_daily_sum := vusr_daily_sum + order_record.os_price;
        vusr_previous_date := vusr_current_date;
        
        -- 주문 상세 정보 출력
        DBMS_OUTPUT.PUT_LINE('- - - - - - - - - - - - - - - - - -');
        DBMS_OUTPUT.PUT_LINE('   주문일자  : ' || order_record.od_date); 
        DBMS_OUTPUT.PUT_LINE('   상품정보  : ' || order_record.os_name);
        DBMS_OUTPUT.PUT_LINE('   상품금액  : ' || order_record.os_price);
    END LOOP;

    -- 마지막 일자의 결제금액 출력
    IF vusr_previous_date IS NOT NULL THEN
        DBMS_OUTPUT.PUT_LINE('   결제금액  : ' || vusr_daily_sum);
        DBMS_OUTPUT.PUT_LINE('   주문상세  : 더보기 > ');
    END IF;
    
    CLOSE order_cursor;
    
    DBMS_OUTPUT.PUT_LINE('===================================');
    DBMS_OUTPUT.PUT_LINE('   쿠폰내역  : '||vusr_coupon||'장 >');
    DBMS_OUTPUT.PUT_LINE('    적립금   : '||vusr_point||'원 >');
    DBMS_OUTPUT.PUT_LINE('   장바구니  : '||vusr_cart_pd_count||'개 >');

END;

--

EXEC SEE_LEVEL(1);

--
commit;

-------------------------------------------------------------------------------

-- 쿠폰내역 페이지
CREATE OR REPLACE PROCEDURE SEE_COUPON (
    pusr_num IN oh_coupon.usr_num %TYPE -- 회원의 쿠폰 받아오기
) 
IS
    -- 쿠폰 상세 정보 커서
    CURSOR coupon_cursor IS
        SELECT c.cp_name, r.cr_price, r.cr_product, r.cr_date
        FROM oh_coupon c
        JOIN oh_cpn_req r ON c.cr_num = r.cr_num
        WHERE c.usr_num = pusr_num;
    
    -- 커서 변수
    coupon_record coupon_cursor%ROWTYPE;
BEGIN
    -- 쿠폰 정보 출력
    DBMS_OUTPUT.PUT_LINE('=========== * COUPON * ============');
    
    -- 쿠폰 커서 열기 및 루프 처리
    FOR coupon_record IN coupon_cursor LOOP
        DBMS_OUTPUT.PUT_LINE(' 쿠폰명 : ' || coupon_record.cp_name);
        DBMS_OUTPUT.PUT_LINE(' 할인품목 : ' || coupon_record.cr_product);
        DBMS_OUTPUT.PUT_LINE(' 적립 : -'); -- 적립금이 필요하면 추가할 수 있음
        DBMS_OUTPUT.PUT_LINE(' 구매금액조건: ' || coupon_record.cr_price);
        DBMS_OUTPUT.PUT_LINE(' 적용상품 : ' || coupon_record.cr_product);
        DBMS_OUTPUT.PUT_LINE(' 사용기간 : ' || coupon_record.cr_date);
        DBMS_OUTPUT.PUT_LINE('===================================');
    END LOOP;
    
    -- 데이터가 없는 경우 처리
    IF SQL%ROWCOUNT IS NULL THEN
        DBMS_OUTPUT.PUT_LINE(' 해당 회원의 쿠폰 정보가 없습니다.');
    END IF;
    COMMIT;

EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('오류 발생: ' || SQLERRM);
END;
--
EXEC SEE_COUPON(1);
-- 카테고리 완성되면 INSERT후 수정(할인품목, 적용상품 카테고리)

--------------------------------------------------------------------------------
commit;



-- 적립금 조회 / 일반 프로시저
CREATE OR REPLACE PROCEDURE SEE_POINT
(
    pusr_num IN oh_point.usr_num%TYPE
)
IS
    -- 변수 선언
    v_total_pt_point NUMBER := 0;       -- 전체 적립금 합계
    v_cumulative_pt_point NUMBER := 0;  -- 누적 적립금
    v_item_count NUMBER := 0;           -- 총 상품 수

    -- 커서 선언: 개별 주문 정보를 가져오기 위한 커서
    CURSOR order_cursor IS
        SELECT o.od_num, o.od_date, 
               SUM(s.os_price * 0.01) AS order_pt_point,
               COUNT(s.os_name) AS order_item_count
        FROM oh_order o
        LEFT JOIN oh_order_sub s ON o.od_num = s.od_num
        WHERE o.usr_num = pusr_num
        GROUP BY o.od_num, o.od_date
        ORDER BY o.od_date DESC;

    -- 커서 레코드 변수
    order_rec order_cursor%ROWTYPE;

BEGIN
    -- 전체 적립금 합계 및 총 상품 수 계산
    SELECT 
        SUM(s.os_price * 0.01) AS total_pt_point,
        COUNT(s.os_name) AS total_item_count
    INTO 
        v_total_pt_point, v_item_count
    FROM oh_order o
    LEFT JOIN oh_order_sub s ON o.od_num = s.od_num
    WHERE o.usr_num = pusr_num;

    -- 누적 적립금 계산
    SELECT NVL(SUM(pt_point), 0)
    INTO v_cumulative_pt_point
    FROM oh_point
    WHERE usr_num = pusr_num;

    -- 커서 열기
    OPEN order_cursor;

    -- 결과 출력
    DBMS_OUTPUT.PUT_LINE('===================================');
    DBMS_OUTPUT.PUT_LINE('         * DETAIL POINT *          ');
    DBMS_OUTPUT.PUT_LINE('===================================');

    -- 커서에서 각 주문에 대한 정보를 출력
    LOOP
        FETCH order_cursor INTO order_rec;
        EXIT WHEN order_cursor%NOTFOUND;

        DBMS_OUTPUT.PUT_LINE('  주문일자   : ' || TO_CHAR(order_rec.od_date, 'YYYY-MM-DD'));
        DBMS_OUTPUT.PUT_LINE('   적립금    : ' || order_rec.order_pt_point);
        DBMS_OUTPUT.PUT_LINE('   상품수    : ' || order_rec.order_item_count);
        DBMS_OUTPUT.PUT_LINE('===================================');

    END LOOP;

    -- 커서 닫기
    CLOSE order_cursor;

    -- 전체 요약 정보 출력
    DBMS_OUTPUT.PUT_LINE('          * TOTAL POINT *          ');
    DBMS_OUTPUT.PUT_LINE('===================================');
    DBMS_OUTPUT.PUT_LINE('  총 적립금  : ' || v_total_pt_point);
    DBMS_OUTPUT.PUT_LINE(' 누적 적립금 : ' || (v_cumulative_pt_point + v_total_pt_point));
    DBMS_OUTPUT.PUT_LINE('  총 상품수  : ' || v_item_count);
    DBMS_OUTPUT.PUT_LINE('===================================');

    -- 데이터가 없는 경우 처리
    IF v_total_pt_point = 0 AND v_cumulative_pt_point = 0 AND v_item_count = 0 THEN
        DBMS_OUTPUT.PUT_LINE('해당 회원의 적립금 내역이 없습니다.');
    END IF;

    COMMIT;

EXCEPTION
    WHEN NO_DATA_FOUND THEN 
        DBMS_OUTPUT.PUT_LINE('데이터가 없습니다.');
    WHEN OTHERS THEN  
        DBMS_OUTPUT.PUT_LINE('Error: ' || SQLERRM);
END;
--
EXEC SEE_POINT (2);




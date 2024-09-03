
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

-- *** ���������� ù ȭ�� ��� ***
CREATE OR REPLACE PROCEDURE see_level
(
    pusr_num oh_usr.usr_num%TYPE -- ȸ����ȣ�� ������ �ޱ�
)
IS
    vusr_name oh_usr.usr_name%TYPE; -- ȸ���̸� �޾ƿ���
    vusr_level oh_usr.usr_level%TYPE; -- ȸ����� ��������
    vusr_nam NUMBER; -- ������ޱ��� ���� �ݾ� �޾ƿ���
    vusr_sixmonths NUMBER; -- 6���� ���� ���űݾ�
    vusr_level_check NUMBER; -- 1�̸� CREW, 2�� FAMILY, 3�̸� FRIEND�� ������Ʈ
    vusr_coupon NUMBER; -- ���� ���� ��������
    vusr_point NUMBER; -- ������ �ݾ� ��������
    vusr_od_preparing NUMBER; -- ��ǰ �غ���
    vusr_od_shipping NUMBER; -- ��� �غ���
    vusr_od_delivering NUMBER; -- �����
    vusr_od_delivered NUMBER; -- ��ۿϷ�
    vusr_cart_pd_count NUMBER; -- ��ٱ��� ��ǰ ����

    -- �ֹ� �� ����
    CURSOR order_cursor IS
        SELECT o.od_date, s.os_name, s.os_price
        FROM oh_order o
        JOIN oh_order_sub s ON o.od_num = s.od_num
        WHERE o.usr_num = pusr_num
        ORDER BY o.od_date;
    
    -- Ŀ�� ����
    order_record order_cursor%ROWTYPE;

    -- ���ں� �����ݾ� ���� ����
    vusr_current_date DATE;
    vusr_daily_sum NUMBER := 0;
    vusr_previous_date DATE := NULL;

BEGIN
    -- ��ٱ��� ǰ�񰹼� ī��Ʈ
    SELECT COUNT(*) INTO vusr_cart_pd_count
    FROM oh_cart
    WHERE usr_num = pusr_num;
    
    -- ��ǰ ��ۻ��� ī��Ʈ
    SELECT COUNT(*) INTO vusr_od_preparing
    FROM oh_order
    WHERE usr_num = pusr_num AND od_status = '��ǰ�غ���';
    
    SELECT COUNT(*) INTO vusr_od_shipping
    FROM oh_order
    WHERE usr_num = pusr_num AND od_status = '����غ���';
    
    SELECT COUNT(*) INTO vusr_od_delivering
    FROM oh_order
    WHERE usr_num = pusr_num AND od_status = '�����';
    
    SELECT COUNT(*) INTO vusr_od_delivered
    FROM oh_order
    WHERE usr_num = pusr_num AND od_status = '��ۿϷ�';
    
    -- ���� ���� ��ȸ
    SELECT COUNT(cp_num) INTO vusr_coupon
    FROM oh_coupon
    WHERE usr_num = pusr_num;
    
    -- ������ �ݾ� ��ȸ
    SELECT COALESCE(SUM(pt_point), 0) INTO vusr_point
    FROM oh_point
    WHERE usr_num = pusr_num;
    
    -- 6���� ���� ���űݾ� ��ȸ
    SELECT COALESCE(SUM(od_price), 0) INTO vusr_sixmonths
    FROM oh_order
    WHERE (od_date BETWEEN ADD_MONTHS(SYSDATE, -6) AND SYSDATE) AND usr_num = pusr_num;
    
    -- ��� ����
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
     
    -- ��� ������Ʈ �� ����Ʈ ���� ����
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

    -- ȸ�� �̸��� ��� ��ȸ
    SELECT usr_name, usr_level INTO vusr_name, vusr_level
    FROM oh_usr
    WHERE usr_num = pusr_num;

    -- ��� ���
    DBMS_OUTPUT.PUT_LINE('===================================');
    DBMS_OUTPUT.PUT_LINE(' ' || vusr_name || '�� �ݰ����ϴ�.');
    DBMS_OUTPUT.PUT_LINE(' ȸ������ ����� [ ' || vusr_level || ' ]�Դϴ�.');
    DBMS_OUTPUT.PUT_LINE(' ���� ��ޱ��� ' || vusr_nam || '�� ���ҽ��ϴ�.');
    DBMS_OUTPUT.PUT_LINE('- - - - - - - - - - - - - - - - - -');
    DBMS_OUTPUT.PUT_LINE('      my point      my coupon');
    DBMS_OUTPUT.PUT_LINE('       [ ' || vusr_point || ' ]         [ ' || vusr_coupon || ' ]');
    DBMS_OUTPUT.PUT_LINE('===================================');
    DBMS_OUTPUT.PUT_LINE('  ��ǰ�غ��� : ' || vusr_od_preparing);
    DBMS_OUTPUT.PUT_LINE('  ����غ��� : ' || vusr_od_shipping);
    DBMS_OUTPUT.PUT_LINE('    �����   : ' || vusr_od_delivering);
    DBMS_OUTPUT.PUT_LINE('   ��ۿϷ�  : ' || vusr_od_delivered);
    

    -- Ŀ�� ���� �� ������ ��ȸ
    OPEN order_cursor;

    LOOP
        FETCH order_cursor INTO order_record;
        EXIT WHEN order_cursor%NOTFOUND;

        vusr_current_date := order_record.od_date;
        
        -- ���� ���� ��, ���� ������ �����ݾ��� ���
        IF vusr_previous_date IS NOT NULL AND vusr_current_date <> vusr_previous_date THEN
            DBMS_OUTPUT.PUT_LINE('   �����ݾ�  : ' || vusr_daily_sum);
            DBMS_OUTPUT.PUT_LINE('   �ֹ���  : ������ > ');
            vusr_daily_sum := 0;
        END IF;

        -- ���ں� �����ݾ� ����
        vusr_daily_sum := vusr_daily_sum + order_record.os_price;
        vusr_previous_date := vusr_current_date;
        
        -- �ֹ� �� ���� ���
        DBMS_OUTPUT.PUT_LINE('- - - - - - - - - - - - - - - - - -');
        DBMS_OUTPUT.PUT_LINE('   �ֹ�����  : ' || order_record.od_date); 
        DBMS_OUTPUT.PUT_LINE('   ��ǰ����  : ' || order_record.os_name);
        DBMS_OUTPUT.PUT_LINE('   ��ǰ�ݾ�  : ' || order_record.os_price);
    END LOOP;

    -- ������ ������ �����ݾ� ���
    IF vusr_previous_date IS NOT NULL THEN
        DBMS_OUTPUT.PUT_LINE('   �����ݾ�  : ' || vusr_daily_sum);
        DBMS_OUTPUT.PUT_LINE('   �ֹ���  : ������ > ');
    END IF;
    
    CLOSE order_cursor;
    
    DBMS_OUTPUT.PUT_LINE('===================================');
    DBMS_OUTPUT.PUT_LINE('   ��������  : '||vusr_coupon||'�� >');
    DBMS_OUTPUT.PUT_LINE('    ������   : '||vusr_point||'�� >');
    DBMS_OUTPUT.PUT_LINE('   ��ٱ���  : '||vusr_cart_pd_count||'�� >');

END;

--

EXEC SEE_LEVEL(1);

--
commit;

-------------------------------------------------------------------------------

-- �������� ������
CREATE OR REPLACE PROCEDURE SEE_COUPON (
    pusr_num IN oh_coupon.usr_num %TYPE -- ȸ���� ���� �޾ƿ���
) 
IS
    -- ���� �� ���� Ŀ��
    CURSOR coupon_cursor IS
        SELECT c.cp_name, r.cr_price, r.cr_product, r.cr_date
        FROM oh_coupon c
        JOIN oh_cpn_req r ON c.cr_num = r.cr_num
        WHERE c.usr_num = pusr_num;
    
    -- Ŀ�� ����
    coupon_record coupon_cursor%ROWTYPE;
BEGIN
    -- ���� ���� ���
    DBMS_OUTPUT.PUT_LINE('=========== * COUPON * ============');
    
    -- ���� Ŀ�� ���� �� ���� ó��
    FOR coupon_record IN coupon_cursor LOOP
        DBMS_OUTPUT.PUT_LINE(' ������ : ' || coupon_record.cp_name);
        DBMS_OUTPUT.PUT_LINE(' ����ǰ�� : ' || coupon_record.cr_product);
        DBMS_OUTPUT.PUT_LINE(' ���� : -'); -- �������� �ʿ��ϸ� �߰��� �� ����
        DBMS_OUTPUT.PUT_LINE(' ���űݾ�����: ' || coupon_record.cr_price);
        DBMS_OUTPUT.PUT_LINE(' �����ǰ : ' || coupon_record.cr_product);
        DBMS_OUTPUT.PUT_LINE(' ���Ⱓ : ' || coupon_record.cr_date);
        DBMS_OUTPUT.PUT_LINE('===================================');
    END LOOP;
    
    -- �����Ͱ� ���� ��� ó��
    IF SQL%ROWCOUNT IS NULL THEN
        DBMS_OUTPUT.PUT_LINE(' �ش� ȸ���� ���� ������ �����ϴ�.');
    END IF;
    COMMIT;

EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('���� �߻�: ' || SQLERRM);
END;
--
EXEC SEE_COUPON(1);
-- ī�װ� �ϼ��Ǹ� INSERT�� ����(����ǰ��, �����ǰ ī�װ�)

--------------------------------------------------------------------------------
commit;



-- ������ ��ȸ / �Ϲ� ���ν���
CREATE OR REPLACE PROCEDURE SEE_POINT
(
    pusr_num IN oh_point.usr_num%TYPE
)
IS
    -- ���� ����
    v_total_pt_point NUMBER := 0;       -- ��ü ������ �հ�
    v_cumulative_pt_point NUMBER := 0;  -- ���� ������
    v_item_count NUMBER := 0;           -- �� ��ǰ ��

    -- Ŀ�� ����: ���� �ֹ� ������ �������� ���� Ŀ��
    CURSOR order_cursor IS
        SELECT o.od_num, o.od_date, 
               SUM(s.os_price * 0.01) AS order_pt_point,
               COUNT(s.os_name) AS order_item_count
        FROM oh_order o
        LEFT JOIN oh_order_sub s ON o.od_num = s.od_num
        WHERE o.usr_num = pusr_num
        GROUP BY o.od_num, o.od_date
        ORDER BY o.od_date DESC;

    -- Ŀ�� ���ڵ� ����
    order_rec order_cursor%ROWTYPE;

BEGIN
    -- ��ü ������ �հ� �� �� ��ǰ �� ���
    SELECT 
        SUM(s.os_price * 0.01) AS total_pt_point,
        COUNT(s.os_name) AS total_item_count
    INTO 
        v_total_pt_point, v_item_count
    FROM oh_order o
    LEFT JOIN oh_order_sub s ON o.od_num = s.od_num
    WHERE o.usr_num = pusr_num;

    -- ���� ������ ���
    SELECT NVL(SUM(pt_point), 0)
    INTO v_cumulative_pt_point
    FROM oh_point
    WHERE usr_num = pusr_num;

    -- Ŀ�� ����
    OPEN order_cursor;

    -- ��� ���
    DBMS_OUTPUT.PUT_LINE('===================================');
    DBMS_OUTPUT.PUT_LINE('         * DETAIL POINT *          ');
    DBMS_OUTPUT.PUT_LINE('===================================');

    -- Ŀ������ �� �ֹ��� ���� ������ ���
    LOOP
        FETCH order_cursor INTO order_rec;
        EXIT WHEN order_cursor%NOTFOUND;

        DBMS_OUTPUT.PUT_LINE('  �ֹ�����   : ' || TO_CHAR(order_rec.od_date, 'YYYY-MM-DD'));
        DBMS_OUTPUT.PUT_LINE('   ������    : ' || order_rec.order_pt_point);
        DBMS_OUTPUT.PUT_LINE('   ��ǰ��    : ' || order_rec.order_item_count);
        DBMS_OUTPUT.PUT_LINE('===================================');

    END LOOP;

    -- Ŀ�� �ݱ�
    CLOSE order_cursor;

    -- ��ü ��� ���� ���
    DBMS_OUTPUT.PUT_LINE('          * TOTAL POINT *          ');
    DBMS_OUTPUT.PUT_LINE('===================================');
    DBMS_OUTPUT.PUT_LINE('  �� ������  : ' || v_total_pt_point);
    DBMS_OUTPUT.PUT_LINE(' ���� ������ : ' || (v_cumulative_pt_point + v_total_pt_point));
    DBMS_OUTPUT.PUT_LINE('  �� ��ǰ��  : ' || v_item_count);
    DBMS_OUTPUT.PUT_LINE('===================================');

    -- �����Ͱ� ���� ��� ó��
    IF v_total_pt_point = 0 AND v_cumulative_pt_point = 0 AND v_item_count = 0 THEN
        DBMS_OUTPUT.PUT_LINE('�ش� ȸ���� ������ ������ �����ϴ�.');
    END IF;

    COMMIT;

EXCEPTION
    WHEN NO_DATA_FOUND THEN 
        DBMS_OUTPUT.PUT_LINE('�����Ͱ� �����ϴ�.');
    WHEN OTHERS THEN  
        DBMS_OUTPUT.PUT_LINE('Error: ' || SQLERRM);
END;
--
EXEC SEE_POINT (2);




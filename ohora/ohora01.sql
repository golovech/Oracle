
-- DROP TABLE

DROP TABLE OH_BOARD CASCADE CONSTRAINTS;
DROP TABLE OH_CARTCASCADE CONSTRAINTS;
DROP TABLE OH_COUPON CASCADE CONSTRAINTS;
DROP TABLE OH_COUPON_REQUIRE CASCADE CONSTRAINTS;
DROP TABLE OH_DELIVERY CASCADE CONSTRAINTS;
DROP TABLE OH_DELIVERY_LIST CASCADE CONSTRAINTS;
DROP TABLE OH_GIFT CASCADE CONSTRAINTS;
DROP TABLE OH_ORDER_CANCEL CASCADE CONSTRAINTS;
DROP TABLE OH_ORDER_PARTICULAR CASCADE CONSTRAINTS;
DROP TABLE OH_PAY CASCADE CONSTRAINTS;
DROP TABLE OH_POINT CASCADE CONSTRAINTS;
DROP TABLE OH_PRODUCT CASCADE CONSTRAINTS;
DROP TABLE OH_PRODUCT_CATEGORY CASCADE CONSTRAINTS;
DROP TABLE OH_MYDESIGN CASCADE CONSTRAINTS;
DROP TABLE OH_COUPON_REQUIRE CASCADE CONSTRAINTS;
DROP TABLE OH_COUPON CASCADE CONSTRAINTS;
DROP TABLE OH_REVIEW CASCADE CONSTRAINTS;
DROP TABLE OH_CART CASCADE CONSTRAINTS;
DROP TABLE OH_USR CASCADE CONSTRAINTS;
DROP TABLE OH_CATEGORY CASCADE CONSTRAINTS;
DROP TABLE OH_COMMENT CASCADE CONSTRAINTS;
DROP TABLE OH_LEVEL CASCADE CONSTRAINTS;
DROP TABLE OH_ORDER CASCADE CONSTRAINTS;
DROP TABLE OH_ORDER_SUB CASCADE CONSTRAINTS;
DROP TABLE OH_PAY_TYPE CASCADE CONSTRAINTS;
DROP TABLE OH_COMMENTS CASCADE CONSTRAINTS;
DROP TABLE OH_ORDER_CNCL CASCADE CONSTRAINTS;
DROP TABLE OH_ROLES CASCADE CONSTRAINTS;


-- CREATE TABLE!!!!!! ����~

/* ȸ�� */
CREATE TABLE ohora.oh_usr (
   usr_num NUMBER NOT NULL, /* ȸ����ȣ */
   usr_id VARCHAR2(16 CHAR) NOT NULL, /* ȸ��ID */
   usr_tel VARCHAR2(14 CHAR), /* �Ϲ���ȭ */
   usr_phone VARCHAR2(14 CHAR), /* �޴���ȭ */
   usr_name VARCHAR2(20 CHAR) NOT NULL, /* �̸� */
   usr_email VARCHAR2(50) NOT NULL, /* �̸��� */
   usr_email_yn CHAR(1 CHAR), /* �̸��� ���� ���� */
   usr_sms_yn CHAR(1 CHAR), /* SMS ���� ���� */
   usr_level VARCHAR2(6), /* ��޸� */
   usr_birth DATE, /* ������� */
   usr_pw VARCHAR2(16 CHAR) NOT NULL /* ��й�ȣ */
);

COMMENT ON TABLE ohora.oh_usr IS 'ȸ��';

COMMENT ON COLUMN ohora.oh_usr.usr_num IS 'ȸ����ȣ';

COMMENT ON COLUMN ohora.oh_usr.usr_id IS 'ȸ��ID';

COMMENT ON COLUMN ohora.oh_usr.usr_tel IS '�Ϲ���ȭ';

COMMENT ON COLUMN ohora.oh_usr.usr_phone IS '�޴���ȭ';

COMMENT ON COLUMN ohora.oh_usr.usr_name IS '�̸�';

COMMENT ON COLUMN ohora.oh_usr.usr_email IS '�̸���';

COMMENT ON COLUMN ohora.oh_usr.usr_email_yn IS '�̸��� ���� ����';

COMMENT ON COLUMN ohora.oh_usr.usr_sms_yn IS 'SMS ���� ����';

COMMENT ON COLUMN ohora.oh_usr.usr_level IS '��޸�';

COMMENT ON COLUMN ohora.oh_usr.usr_birth IS '�������';

COMMENT ON COLUMN ohora.oh_usr.usr_pw IS '��й�ȣ';

CREATE UNIQUE INDEX ohora.PK_oh_usr
   ON ohora.oh_usr (
      usr_num ASC
   );

ALTER TABLE ohora.oh_usr
   ADD
      CONSTRAINT PK_oh_usr
      PRIMARY KEY (
         usr_num
      );

/* ��� */
CREATE TABLE ohora.oh_level (
   usr_num NUMBER NOT NULL, /* ȸ����ȣ */
   usr_level NVARCHAR2(6) NOT NULL, /* ��޸� */
   point_rate NUMBER NOT NULL /* ������ */
);

COMMENT ON TABLE ohora.oh_level IS '���';

COMMENT ON COLUMN ohora.oh_level.usr_num IS 'ȸ����ȣ';

COMMENT ON COLUMN ohora.oh_level.usr_level IS '��޸�';

COMMENT ON COLUMN ohora.oh_level.point_rate IS '������';

CREATE UNIQUE INDEX ohora.PK_oh_level
   ON ohora.oh_level (
      usr_num ASC
   );

ALTER TABLE ohora.oh_level
   ADD
      CONSTRAINT PK_oh_level
      PRIMARY KEY (
         usr_num
      );

/* ����ּҷ� */
CREATE TABLE ohora.oh_delivery_list (
   usr_num NUMBER NOT NULL, /* ȸ����ȣ */
   dl_addr VARCHAR2(50 CHAR) NOT NULL, /* ����ּ� */
   dl_phone VARCHAR2(14 CHAR) NOT NULL, /* �޴���ȭ */
   dl_tel VARCHAR2(14 CHAR), /* �Ϲ���ȭ */
   dl_name VARCHAR2(20 CHAR) NOT NULL, /* ������ */
   dl_nick VARCHAR2(10 CHAR) NOT NULL, /* ������� */
   dl_dyn CHAR(1 CHAR) /* �⺻ ����� ���� */
);

COMMENT ON TABLE ohora.oh_delivery_list IS '����ּҷ�';

COMMENT ON COLUMN ohora.oh_delivery_list.usr_num IS 'ȸ����ȣ';

COMMENT ON COLUMN ohora.oh_delivery_list.dl_addr IS '����ּ�';

COMMENT ON COLUMN ohora.oh_delivery_list.dl_phone IS '�޴���ȭ';

COMMENT ON COLUMN ohora.oh_delivery_list.dl_tel IS '�Ϲ���ȭ';

COMMENT ON COLUMN ohora.oh_delivery_list.dl_name IS '������';

COMMENT ON COLUMN ohora.oh_delivery_list.dl_nick IS '�������';

COMMENT ON COLUMN ohora.oh_delivery_list.dl_dyn IS '�⺻ ����� ����';

CREATE UNIQUE INDEX ohora.PK_oh_delivery_list
   ON ohora.oh_delivery_list (
      usr_num ASC
   );

ALTER TABLE ohora.oh_delivery_list
   ADD
      CONSTRAINT PK_oh_delivery_list
      PRIMARY KEY (
         usr_num
      );

/* �Խ��� */
CREATE TABLE ohora.oh_board (
   brd_num NUMBER NOT NULL, /* �� ��ȣ */
   brd_theme VARCHAR2(20 CHAR), /* �Խ��� �̸� */
   brd_title VARCHAR2(20 CHAR), /* ���� */
   brd_content VARCHAR2(500 CHAR), /* ���� */
   brd_date DATE, /* �ۼ��� */
   brd_media VARCHAR2(100 CHAR), /* ÷������ */
   brd_view NUMBER, /* ��ȸ�� */
   usr_num NUMBER NOT NULL /* ȸ����ȣ */
);

COMMENT ON TABLE ohora.oh_board IS '�Խ���';

COMMENT ON COLUMN ohora.oh_board.brd_num IS '�� ��ȣ';

COMMENT ON COLUMN ohora.oh_board.brd_theme IS '�Խ��� �̸�';

COMMENT ON COLUMN ohora.oh_board.brd_title IS '����';

COMMENT ON COLUMN ohora.oh_board.brd_content IS '����';

COMMENT ON COLUMN ohora.oh_board.brd_date IS '�ۼ���';

COMMENT ON COLUMN ohora.oh_board.brd_media IS '÷������';

COMMENT ON COLUMN ohora.oh_board.brd_view IS '��ȸ��';

COMMENT ON COLUMN ohora.oh_board.usr_num IS 'ȸ����ȣ';

CREATE UNIQUE INDEX ohora.PK_oh_board
   ON ohora.oh_board (
      brd_num ASC
   );

ALTER TABLE ohora.oh_board
   ADD
      CONSTRAINT PK_oh_board
      PRIMARY KEY (
         brd_num
      );

/* ��� */
CREATE TABLE ohora.oh_comments (
   co_num NUMBER NOT NULL, /* ��� ��ȣ */
   co_content VARCHAR2(100 CHAR), /* ���� */
   usr_num NUMBER NOT NULL /* ȸ����ȣ */
);

COMMENT ON TABLE ohora.oh_comments IS '���';

COMMENT ON COLUMN ohora.oh_comments.co_num IS '��� ��ȣ';

COMMENT ON COLUMN ohora.oh_comments.co_content IS '����';

COMMENT ON COLUMN ohora.oh_comments.usr_num IS 'ȸ����ȣ';

CREATE UNIQUE INDEX ohora.PK_oh_comments
   ON ohora.oh_comments (
      co_num ASC
   );

ALTER TABLE ohora.oh_comments
   ADD
      CONSTRAINT PK_oh_comments
      PRIMARY KEY (
         co_num
      );

/* ���� */
CREATE TABLE ohora.oh_review (
   rv_num NUMBER NOT NULL, /* ���� ��ȣ */
   rv_title VARCHAR2(20 CHAR) NOT NULL, /* ���� */
   rv_content VARCHAR2(100 CHAR) NOT NULL, /* ���� */
   rv_media VARCHAR2(100 CHAR), /* �̹���/���� */
   rv_date DATE, /* �ۼ����� */
   rv_score NUMBER, /* ����(����) */
   rv_like NUMBER, /* ��õ(����ſ�) */
   rv_rank NUMBER NOT NULL, /* ���� */
   usr_num NUMBER NOT NULL, /* ȸ����ȣ */
   od_num NUMBER, /* �ֹ���ȣ */
   pd_num NUMBER NOT NULL /* ��ǰ��ȣ */
);

COMMENT ON TABLE ohora.oh_review IS '����';

COMMENT ON COLUMN ohora.oh_review.rv_num IS '���� ��ȣ';

COMMENT ON COLUMN ohora.oh_review.rv_title IS '����';

COMMENT ON COLUMN ohora.oh_review.rv_content IS '����';

COMMENT ON COLUMN ohora.oh_review.rv_media IS '�̹���/����';

COMMENT ON COLUMN ohora.oh_review.rv_date IS '�ۼ�����';

COMMENT ON COLUMN ohora.oh_review.rv_score IS '����(����)';

COMMENT ON COLUMN ohora.oh_review.rv_like IS '��õ(����ſ�)';

COMMENT ON COLUMN ohora.oh_review.rv_rank IS '����';

COMMENT ON COLUMN ohora.oh_review.usr_num IS 'ȸ����ȣ';

COMMENT ON COLUMN ohora.oh_review.od_num IS '�ֹ���ȣ';

COMMENT ON COLUMN ohora.oh_review.pd_num IS '��ǰ��ȣ';

CREATE UNIQUE INDEX ohora.PK_oh_review
   ON ohora.oh_review (
      rv_num ASC
   );

ALTER TABLE ohora.oh_review
   ADD
      CONSTRAINT PK_oh_review
      PRIMARY KEY (
         rv_num
      );

/* ������ */
CREATE TABLE ohora.oh_point (
   usr_num NUMBER NOT NULL, /* ȸ����ȣ */
   pt_date DATE NOT NULL, /* ������ */
   pt_point NUMBER, /* ������ */
   usr_level VARCHAR2(6), /* ��޸� */
   rv_num NUMBER /* ���� ��ȣ */
);

COMMENT ON TABLE ohora.oh_point IS '������';

COMMENT ON COLUMN ohora.oh_point.usr_num IS 'ȸ����ȣ';

COMMENT ON COLUMN ohora.oh_point.pt_date IS '������';

COMMENT ON COLUMN ohora.oh_point.pt_point IS '������';

COMMENT ON COLUMN ohora.oh_point.usr_level IS '��޸�';

COMMENT ON COLUMN ohora.oh_point.rv_num IS '���� ��ȣ';

CREATE UNIQUE INDEX ohora.PK_oh_point
   ON ohora.oh_point (
      usr_num ASC
   );

ALTER TABLE ohora.oh_point
   ADD
      CONSTRAINT PK_oh_point
      PRIMARY KEY (
         usr_num
      );

/* ���� */
CREATE TABLE ohora.oh_coupon (
   cp_num NUMBER NOT NULL, /* ������ȣ */
   cp_name VARCHAR2(50 CHAR) NOT NULL, /* ���� �̸� */
   cp_rate NUMBER, /* ���� ������ */
   usr_num NUMBER NOT NULL, /* ȸ����ȣ */
   cr_num NUMBER NOT NULL /* �������ǹ�ȣ */
);

COMMENT ON TABLE ohora.oh_coupon IS '����';

COMMENT ON COLUMN ohora.oh_coupon.cp_num IS '������ȣ';

COMMENT ON COLUMN ohora.oh_coupon.cp_name IS '���� �̸�';

COMMENT ON COLUMN ohora.oh_coupon.cp_rate IS '���� ������';

COMMENT ON COLUMN ohora.oh_coupon.usr_num IS 'ȸ����ȣ';

COMMENT ON COLUMN ohora.oh_coupon.cr_num IS '�������ǹ�ȣ';

CREATE UNIQUE INDEX ohora.PK_oh_coupon
   ON ohora.oh_coupon (
      cp_num ASC
   );

ALTER TABLE ohora.oh_coupon
   ADD
      CONSTRAINT PK_oh_coupon
      PRIMARY KEY (
         cp_num
      );

/* �������� */
CREATE TABLE ohora.oh_cpn_req (
   cr_num NUMBER NOT NULL, /* �������ǹ�ȣ */
   cr_date DATE NOT NULL, /* ��ȿ�Ⱓ */
   cr_ratio NUMBER, /* ���� ������ */
   cr_price NUMBER, /* �ݾ� ���� */
   cr_product VARCHAR2(50 CHAR), /* ���� ��� */
   od_num NUMBER NOT NULL, /* �ֹ���ȣ */
   pd_num NUMBER NOT NULL /* ��ǰ��ȣ */
);

COMMENT ON TABLE ohora.oh_cpn_req IS '��������';

COMMENT ON COLUMN ohora.oh_cpn_req.cr_num IS '�������ǹ�ȣ';

COMMENT ON COLUMN ohora.oh_cpn_req.cr_date IS '��ȿ�Ⱓ';

COMMENT ON COLUMN ohora.oh_cpn_req.cr_ratio IS '���� ������';

COMMENT ON COLUMN ohora.oh_cpn_req.cr_price IS '�ݾ� ����';

COMMENT ON COLUMN ohora.oh_cpn_req.cr_product IS '���� ���';

COMMENT ON COLUMN ohora.oh_cpn_req.od_num IS '�ֹ���ȣ';

COMMENT ON COLUMN ohora.oh_cpn_req.pd_num IS '��ǰ��ȣ';

CREATE UNIQUE INDEX ohora.PK_oh_cpn_req
   ON ohora.oh_cpn_req (
      cr_num ASC
   );

ALTER TABLE ohora.oh_cpn_req
   ADD
      CONSTRAINT PK_oh_cpn_req
      PRIMARY KEY (
         cr_num
      );

/* �ֹ� */
CREATE TABLE ohora.oh_order (
   od_num NUMBER NOT NULL, /* �ֹ���ȣ */
   od_date DATE NOT NULL, /* �ֹ����� */
   od_price NUMBER, /* ��ǰ�ݾ� */
   od_status CHAR(1 CHAR) NOT NULL, /* �ֹ� ó������ */
   od_cancel VARCHAR2(2 CHAR), /* ���/��ȯ/��ǰ ó������ */
   usr_num NUMBER NOT NULL, /* ȸ����ȣ */
   pd_num NUMBER NOT NULL, /* ��ǰ��ȣ */
   cart_num NUMBER /* ��ٱ��Ϲ�ȣ */
);

COMMENT ON TABLE ohora.oh_order IS '�ֹ�';

COMMENT ON COLUMN ohora.oh_order.od_num IS '�ֹ���ȣ';

COMMENT ON COLUMN ohora.oh_order.od_date IS '�ֹ�����';

COMMENT ON COLUMN ohora.oh_order.od_price IS '��ǰ�ݾ�';

COMMENT ON COLUMN ohora.oh_order.od_status IS '�ֹ� ó������';

COMMENT ON COLUMN ohora.oh_order.od_cancel IS '���/��ȯ/��ǰ ó������';

COMMENT ON COLUMN ohora.oh_order.usr_num IS 'ȸ����ȣ';

COMMENT ON COLUMN ohora.oh_order.pd_num IS '��ǰ��ȣ';

COMMENT ON COLUMN ohora.oh_order.cart_num IS '��ٱ��Ϲ�ȣ';

CREATE UNIQUE INDEX ohora.PK_oh_order
   ON ohora.oh_order (
      od_num ASC
   );

ALTER TABLE ohora.oh_order
   ADD
      CONSTRAINT PK_oh_order
      PRIMARY KEY (
         od_num
      );

/* ����ǰ ���� */
CREATE TABLE ohora.oh_gift (
   usr_num NUMBER NOT NULL, /* ȸ����ȣ */
   pd_num NUMBER NOT NULL, /* ��ǰ��ȣ */
   od_num NUMBER NOT NULL, /* �ֹ���ȣ */
   gift_price NUMBER /* ����ǰ ���� */
);

COMMENT ON TABLE ohora.oh_gift IS '����ǰ ����';

COMMENT ON COLUMN ohora.oh_gift.usr_num IS 'ȸ����ȣ';

COMMENT ON COLUMN ohora.oh_gift.pd_num IS '��ǰ��ȣ';

COMMENT ON COLUMN ohora.oh_gift.od_num IS '�ֹ���ȣ';

COMMENT ON COLUMN ohora.oh_gift.gift_price IS '����ǰ ����';

CREATE UNIQUE INDEX ohora.PK_oh_gift
   ON ohora.oh_gift (
      usr_num ASC
   );

ALTER TABLE ohora.oh_gift
   ADD
      CONSTRAINT PK_oh_gift
      PRIMARY KEY (
         usr_num
      );

/* ��ٱ��� */
CREATE TABLE ohora.oh_cart (
   cart_num NUMBER NOT NULL, /* ��ٱ��Ϲ�ȣ */
   usr_num NUMBER NOT NULL, /* ȸ����ȣ */
   pd_num NUMBER, /* ��ǰ��ȣ */
   cart_pdcnt NUMBER /* ��ǰ���� */
);

COMMENT ON TABLE ohora.oh_cart IS '��ٱ���';

COMMENT ON COLUMN ohora.oh_cart.cart_num IS '��ٱ��Ϲ�ȣ';

COMMENT ON COLUMN ohora.oh_cart.usr_num IS 'ȸ����ȣ';

COMMENT ON COLUMN ohora.oh_cart.pd_num IS '��ǰ��ȣ';

COMMENT ON COLUMN ohora.oh_cart.cart_pdcnt IS '��ǰ����';

CREATE UNIQUE INDEX ohora.PK_oh_cart
   ON ohora.oh_cart (
      cart_num ASC
   );

ALTER TABLE ohora.oh_cart
   ADD
      CONSTRAINT PK_oh_cart
      PRIMARY KEY (
         cart_num
      );

/* ��ǰ */
CREATE TABLE ohora.oh_product (
   pd_num NUMBER NOT NULL, /* ��ǰ��ȣ */
   pd_name VARCHAR2(50 CHAR) NOT NULL, /* ��ǰ�� */
   pd_date DATE, /* ����� */
   pd_stock NUMBER, /* ���� */
   pd_price NUMBER, /* ���� */
   pd_dc_price NUMBER, /* ���ΰ� */
   pd_view NUMBER, /* ��ȸ�� */
   pd_media VARCHAR2(100 CHAR), /* ����� */
   pd_dc_rate NUMBER, /* ��ü ������ */
   pd_tot_buy NUMBER /* �� ���ż�(��ǰ �α⵵) */
);

COMMENT ON TABLE ohora.oh_product IS '��ǰ';

COMMENT ON COLUMN ohora.oh_product.pd_num IS '��ǰ��ȣ';

COMMENT ON COLUMN ohora.oh_product.pd_name IS '��ǰ��';

COMMENT ON COLUMN ohora.oh_product.pd_date IS '�����';

COMMENT ON COLUMN ohora.oh_product.pd_stock IS '����';

COMMENT ON COLUMN ohora.oh_product.pd_price IS '����';

COMMENT ON COLUMN ohora.oh_product.pd_dc_price IS '���ΰ�';

COMMENT ON COLUMN ohora.oh_product.pd_view IS '��ȸ��';

COMMENT ON COLUMN ohora.oh_product.pd_media IS '�����';

COMMENT ON COLUMN ohora.oh_product.pd_dc_rate IS '��ü ������';

COMMENT ON COLUMN ohora.oh_product.pd_tot_buy IS '�� ���ż�(��ǰ �α⵵)';

CREATE UNIQUE INDEX ohora.PK_oh_product
   ON ohora.oh_product (
      pd_num ASC
   );

ALTER TABLE ohora.oh_product
   ADD
      CONSTRAINT PK_oh_product
      PRIMARY KEY (
         pd_num
      );

/* ������ */
CREATE TABLE ohora.oh_mydesign (
   pmd_hashtag VARCHAR2(10 CHAR) NOT NULL, /* �ؽ��±� */
   pd_num NUMBER NOT NULL, /* ��ǰ��ȣ */
   pmd_lineup VARCHAR2(10 CHAR), /* ���ξ� */
   pmd_color VARCHAR2(10 CHAR), /* �÷� */
   pmd_design VARCHAR2(10 CHAR) /* ������ */
);

COMMENT ON TABLE ohora.oh_mydesign IS '������';

COMMENT ON COLUMN ohora.oh_mydesign.pmd_hashtag IS '�ؽ��±�';

COMMENT ON COLUMN ohora.oh_mydesign.pd_num IS '��ǰ��ȣ';

COMMENT ON COLUMN ohora.oh_mydesign.pmd_lineup IS '���ξ�';

COMMENT ON COLUMN ohora.oh_mydesign.pmd_color IS '�÷�';

COMMENT ON COLUMN ohora.oh_mydesign.pmd_design IS '������';

CREATE UNIQUE INDEX ohora.PK_oh_mydesign
   ON ohora.oh_mydesign (
      pmd_hashtag ASC,
      pd_num ASC
   );

ALTER TABLE ohora.oh_mydesign
   ADD
      CONSTRAINT PK_oh_mydesign
      PRIMARY KEY (
         pmd_hashtag,
         pd_num
      );

/* ī�װ� */
CREATE TABLE ohora.oh_category (
   pd_num NUMBER NOT NULL, /* ��ǰ��ȣ */
   pc_fir VARCHAR2(20 CHAR) NOT NULL, /* ��з� */
   pc_sec VARCHAR2(20 CHAR), /* �ߺз� */
   pc_thd VARCHAR2(20 CHAR) /* �Һз� */
);

COMMENT ON TABLE ohora.oh_category IS 'ī�װ�';

COMMENT ON COLUMN ohora.oh_category.pd_num IS '��ǰ��ȣ';

COMMENT ON COLUMN ohora.oh_category.pc_fir IS '��з�';

COMMENT ON COLUMN ohora.oh_category.pc_sec IS '�ߺз�';

COMMENT ON COLUMN ohora.oh_category.pc_thd IS '�Һз�';

CREATE UNIQUE INDEX ohora.PK_oh_category
   ON ohora.oh_category (
      pd_num ASC
   );

ALTER TABLE ohora.oh_category
   ADD
      CONSTRAINT PK_oh_category
      PRIMARY KEY (
         pd_num
      );

/* �ֹ� �� */
CREATE TABLE ohora.oh_order_sub (
   os_num NUMBER NOT NULL, /* �ֹ� �� ��ȣ */
   od_num NUMBER, /* �ֹ���ȣ */
   os_price NUMBER, /* ��ǰ�ݾ� */
   os_pay_delivery NUMBER, /* ��ۺ� */
   os_name VARCHAR2(50 CHAR) /* ��ǰ �̸� */
);

COMMENT ON TABLE ohora.oh_order_sub IS '�ֹ� ��';

COMMENT ON COLUMN ohora.oh_order_sub.os_num IS '�ֹ� �� ��ȣ';

COMMENT ON COLUMN ohora.oh_order_sub.od_num IS '�ֹ���ȣ';

COMMENT ON COLUMN ohora.oh_order_sub.os_price IS '��ǰ�ݾ�';

COMMENT ON COLUMN ohora.oh_order_sub.os_pay_delivery IS '��ۺ�';

COMMENT ON COLUMN ohora.oh_order_sub.os_name IS '��ǰ �̸�';

CREATE UNIQUE INDEX ohora.PK_oh_order_sub
   ON ohora.oh_order_sub (
      os_num ASC
   );

ALTER TABLE ohora.oh_order_sub
   ADD
      CONSTRAINT PK_oh_order_sub
      PRIMARY KEY (
         os_num
      );

/* ���� */
CREATE TABLE ohora.oh_pay (
   pay_num NUMBER NOT NULL, /* ������ȣ */
   od_num NUMBER NOT NULL, /* �ֹ���ȣ */
   usr_num NUMBER NOT NULL, /* ȸ����ȣ */
   cp_num NUMBER NOT NULL, /* ������ȣ */
   pay_way VARCHAR2(20 CHAR), /* ���������̸� */
   pay_date DATE, /* �������� */
   pay_delivery NUMBER /* ��ۺ� */
);

COMMENT ON TABLE ohora.oh_pay IS '����';

COMMENT ON COLUMN ohora.oh_pay.pay_num IS '������ȣ';

COMMENT ON COLUMN ohora.oh_pay.od_num IS '�ֹ���ȣ';

COMMENT ON COLUMN ohora.oh_pay.usr_num IS 'ȸ����ȣ';

COMMENT ON COLUMN ohora.oh_pay.cp_num IS '������ȣ';

COMMENT ON COLUMN ohora.oh_pay.pay_way IS '���������̸�';

COMMENT ON COLUMN ohora.oh_pay.pay_date IS '��������';

COMMENT ON COLUMN ohora.oh_pay.pay_delivery IS '��ۺ�';

CREATE UNIQUE INDEX ohora.PK_oh_pay
   ON ohora.oh_pay (
      pay_num ASC
   );

ALTER TABLE ohora.oh_pay
   ADD
      CONSTRAINT PK_oh_pay
      PRIMARY KEY (
         pay_num
      );

/* ��� */
CREATE TABLE ohora.oh_delivery (
   d_num NUMBER NOT NULL, /* ����� ��ȣ */
   d_finish DATE, /* ��� �Ϸ��� */
   d_start DATE, /* ��� ������ */
   d_status VARCHAR2(20 CHAR), /* ��� ���� */
   usr_num NUMBER NOT NULL /* ȸ����ȣ */
);

COMMENT ON TABLE ohora.oh_delivery IS '���';

COMMENT ON COLUMN ohora.oh_delivery.d_num IS '����� ��ȣ';

COMMENT ON COLUMN ohora.oh_delivery.d_finish IS '��� �Ϸ���';

COMMENT ON COLUMN ohora.oh_delivery.d_start IS '��� ������';

COMMENT ON COLUMN ohora.oh_delivery.d_status IS '��� ����';

COMMENT ON COLUMN ohora.oh_delivery.usr_num IS 'ȸ����ȣ';

CREATE UNIQUE INDEX ohora.PK_oh_delivery
   ON ohora.oh_delivery (
      d_num ASC
   );

ALTER TABLE ohora.oh_delivery
   ADD
      CONSTRAINT PK_oh_delivery
      PRIMARY KEY (
         d_num
      );

/* ���/��ȯ/��ǰ */
CREATE TABLE ohora.oh_order_cncl (
   od_num NUMBER NOT NULL, /* �ֹ���ȣ */
   pd_num NUMBER NOT NULL, /* ��ǰ��ȣ */
   oc_reason VARCHAR2(20 CHAR), /* �� ���� */
   oc_check VARCHAR2(20 CHAR) NOT NULL, /* ���� ���� */
   oc_status VARCHAR2(20 CHAR), /* ���� ���� */
   oc_cnt NUMBER /* ��� ���� */
);

COMMENT ON TABLE ohora.oh_order_cncl IS '���/��ȯ/��ǰ';

COMMENT ON COLUMN ohora.oh_order_cncl.od_num IS '�ֹ���ȣ';

COMMENT ON COLUMN ohora.oh_order_cncl.pd_num IS '��ǰ��ȣ';

COMMENT ON COLUMN ohora.oh_order_cncl.oc_reason IS '�� ����';

COMMENT ON COLUMN ohora.oh_order_cncl.oc_check IS '���� ����';

COMMENT ON COLUMN ohora.oh_order_cncl.oc_status IS '���� ����';

COMMENT ON COLUMN ohora.oh_order_cncl.oc_cnt IS '��� ����';

CREATE UNIQUE INDEX ohora.PK_oh_order_cncl
   ON ohora.oh_order_cncl (
      od_num ASC,
      pd_num ASC
   );

ALTER TABLE ohora.oh_order_cncl
   ADD
      CONSTRAINT PK_oh_order_cncl
      PRIMARY KEY (
         od_num,
         pd_num
      );

/* ���� */
CREATE TABLE ohora.oh_roles (
   usr_num NUMBER NOT NULL, /* ȸ����ȣ */
   role_name VARCHAR2(10 CHAR) /* �����̸� */
);

COMMENT ON TABLE ohora.oh_roles IS '����';

COMMENT ON COLUMN ohora.oh_roles.usr_num IS 'ȸ����ȣ';

COMMENT ON COLUMN ohora.oh_roles.role_name IS '�����̸�';

CREATE UNIQUE INDEX ohora.PK_oh_roles
   ON ohora.oh_roles (
      usr_num ASC
   );

ALTER TABLE ohora.oh_roles
   ADD
      CONSTRAINT PK_oh_roles
      PRIMARY KEY (
         usr_num
      );

/* �������� */
CREATE TABLE ohora.oh_pay_type (
   pay_way VARCHAR2(20 CHAR) NOT NULL, /* ���������̸� */
   od_num NUMBER /* �ֹ���ȣ */
);

COMMENT ON TABLE ohora.oh_pay_type IS '��������';

COMMENT ON COLUMN ohora.oh_pay_type.pay_way IS '���������̸�';

COMMENT ON COLUMN ohora.oh_pay_type.od_num IS '�ֹ���ȣ';

CREATE UNIQUE INDEX ohora.PK_oh_pay_type
   ON ohora.oh_pay_type (
      pay_way ASC
   );

ALTER TABLE ohora.oh_pay_type
   ADD
      CONSTRAINT PK_oh_pay_type
      PRIMARY KEY (
         pay_way
      );

ALTER TABLE ohora.oh_level
   ADD
      CONSTRAINT FK_oh_usr_TO_oh_level
      FOREIGN KEY (
         usr_num
      )
      REFERENCES ohora.oh_usr (
         usr_num
      );

ALTER TABLE ohora.oh_delivery_list
   ADD
      CONSTRAINT FK_oh_usr_TO_oh_delivery_list
      FOREIGN KEY (
         usr_num
      )
      REFERENCES ohora.oh_usr (
         usr_num
      );

ALTER TABLE ohora.oh_board
   ADD
      CONSTRAINT FK_oh_usr_TO_oh_board
      FOREIGN KEY (
         usr_num
      )
      REFERENCES ohora.oh_usr (
         usr_num
      );

ALTER TABLE ohora.oh_comments
   ADD
      CONSTRAINT FK_oh_usr_TO_oh_comments
      FOREIGN KEY (
         usr_num
      )
      REFERENCES ohora.oh_usr (
         usr_num
      );

ALTER TABLE ohora.oh_review
   ADD
      CONSTRAINT FK_oh_usr_TO_oh_review
      FOREIGN KEY (
         usr_num
      )
      REFERENCES ohora.oh_usr (
         usr_num
      );

ALTER TABLE ohora.oh_review
   ADD
      CONSTRAINT FK_oh_order_TO_oh_review
      FOREIGN KEY (
         od_num
      )
      REFERENCES ohora.oh_order (
         od_num
      );

ALTER TABLE ohora.oh_review
   ADD
      CONSTRAINT FK_oh_product_TO_oh_review
      FOREIGN KEY (
         pd_num
      )
      REFERENCES ohora.oh_product (
         pd_num
      );

ALTER TABLE ohora.oh_point
   ADD
      CONSTRAINT FK_oh_usr_TO_oh_point
      FOREIGN KEY (
         usr_num
      )
      REFERENCES ohora.oh_usr (
         usr_num
      );

ALTER TABLE ohora.oh_point
   ADD
      CONSTRAINT FK_oh_review_TO_oh_point
      FOREIGN KEY (
         rv_num
      )
      REFERENCES ohora.oh_review (
         rv_num
      );

ALTER TABLE ohora.oh_coupon
   ADD
      CONSTRAINT FK_oh_usr_TO_oh_coupon
      FOREIGN KEY (
         usr_num
      )
      REFERENCES ohora.oh_usr (
         usr_num
      );

ALTER TABLE ohora.oh_coupon
   ADD
      CONSTRAINT FK_oh_cpn_req_TO_oh_coupon
      FOREIGN KEY (
         cr_num
      )
      REFERENCES ohora.oh_cpn_req (
         cr_num
      );

ALTER TABLE ohora.oh_cpn_req
   ADD
      CONSTRAINT FK_oh_order_TO_oh_cpn_req
      FOREIGN KEY (
         od_num
      )
      REFERENCES ohora.oh_order (
         od_num
      );

ALTER TABLE ohora.oh_cpn_req
   ADD
      CONSTRAINT FK_oh_product_TO_oh_cpn_req
      FOREIGN KEY (
         pd_num
      )
      REFERENCES ohora.oh_product (
         pd_num
      );

ALTER TABLE ohora.oh_order
   ADD
      CONSTRAINT FK_oh_usr_TO_oh_order
      FOREIGN KEY (
         usr_num
      )
      REFERENCES ohora.oh_usr (
         usr_num
      );

ALTER TABLE ohora.oh_order
   ADD
      CONSTRAINT FK_oh_product_TO_oh_order
      FOREIGN KEY (
         pd_num
      )
      REFERENCES ohora.oh_product (
         pd_num
      );

ALTER TABLE ohora.oh_order
   ADD
      CONSTRAINT FK_oh_cart_TO_oh_order
      FOREIGN KEY (
         cart_num
      )
      REFERENCES ohora.oh_cart (
         cart_num
      );

ALTER TABLE ohora.oh_gift
   ADD
      CONSTRAINT FK_oh_product_TO_oh_gift
      FOREIGN KEY (
         pd_num
      )
      REFERENCES ohora.oh_product (
         pd_num
      );

ALTER TABLE ohora.oh_gift
   ADD
      CONSTRAINT FK_oh_order_TO_oh_gift
      FOREIGN KEY (
         od_num
      )
      REFERENCES ohora.oh_order (
         od_num
      );

ALTER TABLE ohora.oh_gift
   ADD
      CONSTRAINT FK_oh_usr_TO_oh_gift
      FOREIGN KEY (
         usr_num
      )
      REFERENCES ohora.oh_usr (
         usr_num
      );

ALTER TABLE ohora.oh_cart
   ADD
      CONSTRAINT FK_oh_usr_TO_oh_cart
      FOREIGN KEY (
         usr_num
      )
      REFERENCES ohora.oh_usr (
         usr_num
      );

ALTER TABLE ohora.oh_cart
   ADD
      CONSTRAINT FK_oh_product_TO_oh_cart
      FOREIGN KEY (
         pd_num
      )
      REFERENCES ohora.oh_product (
         pd_num
      );

ALTER TABLE ohora.oh_mydesign
   ADD
      CONSTRAINT FK_oh_product_TO_oh_mydesign
      FOREIGN KEY (
         pd_num
      )
      REFERENCES ohora.oh_product (
         pd_num
      );

ALTER TABLE ohora.oh_category
   ADD
      CONSTRAINT FK_oh_product_TO_oh_category
      FOREIGN KEY (
         pd_num
      )
      REFERENCES ohora.oh_product (
         pd_num
      );

ALTER TABLE ohora.oh_order_sub
   ADD
      CONSTRAINT FK_oh_order_TO_oh_order_sub
      FOREIGN KEY (
         od_num
      )
      REFERENCES ohora.oh_order (
         od_num
      );

ALTER TABLE ohora.oh_pay
   ADD
      CONSTRAINT FK_oh_order_TO_oh_pay
      FOREIGN KEY (
         od_num
      )
      REFERENCES ohora.oh_order (
         od_num
      );

ALTER TABLE ohora.oh_pay
   ADD
      CONSTRAINT FK_oh_usr_TO_oh_pay
      FOREIGN KEY (
         usr_num
      )
      REFERENCES ohora.oh_usr (
         usr_num
      );

ALTER TABLE ohora.oh_pay
   ADD
      CONSTRAINT FK_oh_coupon_TO_oh_pay
      FOREIGN KEY (
         cp_num
      )
      REFERENCES ohora.oh_coupon (
         cp_num
      );

ALTER TABLE ohora.oh_pay
   ADD
      CONSTRAINT FK_oh_pay_type_TO_oh_pay
      FOREIGN KEY (
         pay_way
      )
      REFERENCES ohora.oh_pay_type (
         pay_way
      );

ALTER TABLE ohora.oh_delivery
   ADD
      CONSTRAINT FK_oh_usr_TO_oh_delivery
      FOREIGN KEY (
         usr_num
      )
      REFERENCES ohora.oh_usr (
         usr_num
      );

ALTER TABLE ohora.oh_order_cncl
   ADD
      CONSTRAINT FK_oh_order_TO_oh_order_cncl
      FOREIGN KEY (
         od_num
      )
      REFERENCES ohora.oh_order (
         od_num
      );

ALTER TABLE ohora.oh_order_cncl
   ADD
      CONSTRAINT FK_oh_product_TO_oh_order_cncl
      FOREIGN KEY (
         pd_num
      )
      REFERENCES ohora.oh_product (
         pd_num
      );

ALTER TABLE ohora.oh_roles
   ADD
      CONSTRAINT FK_oh_usr_TO_oh_roles
      FOREIGN KEY (
         usr_num
      )
      REFERENCES ohora.oh_usr (
         usr_num
      );

ALTER TABLE ohora.oh_pay_type
   ADD
      CONSTRAINT FK_oh_order_TO_oh_pay_type
      FOREIGN KEY (
         od_num
      )
      REFERENCES ohora.oh_order (
         od_num
      );

ALTER TABLE OH_ORDER
MODIFY OD_STATUS VARCHAR2(10 CHAR);

ALTER TABLE ohora.oh_mydesign 
MODIFY pmd_hashtag VARCHAR2(10 CHAR) NULL; -- �ؽ��±� PK����

ALTER TABLE OH_REVIEW
MODIFY RV_CONTENT VARCHAR2(2000 CHAR);

ALTER TABLE OH_COMMENTS
MODIFY CO_CONTENT VARCHAR2(2000 CHAR);

ALTER TABLE OH_BOARD
MODIFY BRD_CONTENT VARCHAR2(2000 CHAR);

ALTER TABLE oh_usr
ADD CONSTRAINT unique_user_id UNIQUE (usr_id);

ALTER TABLE oh_review
ADD rv_choice VARCHAR2(1 CHAR) DEFAULT 'n';

ALTER TABLE oh_review
ADD rv_dislike NUMBER;

ALTER TABLE oh_review
DROP COLUMN RV_RANK;

ALTER TABLE oh_review
DROP COLUMN RV_MEDIA;

-- ���߿� ���� URL ���̺� �����ϱ�!!!

/* ���� URL */
CREATE TABLE ohora.TABLE (
);

COMMENT ON TABLE ohora.TABLE IS '���� URL';

/* ���� URL */
CREATE TABLE ohora.TABLE2 (
	rv_num NUMBER NOT NULL, /* ���� ��ȣ */
	rv_media VARCHAR2(100 CHAR) /* �̹���/���� */
);

COMMENT ON TABLE ohora.TABLE2 IS '���� URL';

COMMENT ON COLUMN ohora.TABLE2.rv_num IS '���� ��ȣ';

COMMENT ON COLUMN ohora.TABLE2.rv_media IS '�̹���/����';

CREATE UNIQUE INDEX ohora.PK_TABLE2
	ON ohora.TABLE2 (
		rv_num ASC
	);

ALTER TABLE ohora.TABLE2
	ADD
		CONSTRAINT PK_TABLE2
		PRIMARY KEY (
			rv_num
		);

ALTER TABLE ohora.oh_level
	ADD
		CONSTRAINT FK_oh_usr_TO_oh_level
		FOREIGN KEY (
			usr_num
		)
		REFERENCES ohora.oh_usr (
			usr_num
		);

ALTER TABLE ohora.oh_delivery_list
	ADD
		CONSTRAINT FK_oh_usr_TO_oh_delivery_list
		FOREIGN KEY (
			usr_num
		)
		REFERENCES ohora.oh_usr (
			usr_num
		);

ALTER TABLE ohora.oh_board
	ADD
		CONSTRAINT FK_oh_usr_TO_oh_board
		FOREIGN KEY (
			usr_num
		)
		REFERENCES ohora.oh_usr (
			usr_num
		);

ALTER TABLE ohora.oh_comments
	ADD
		CONSTRAINT FK_oh_usr_TO_oh_comments
		FOREIGN KEY (
			usr_num
		)
		REFERENCES ohora.oh_usr (
			usr_num
		);

ALTER TABLE ohora.oh_review
	ADD
		CONSTRAINT FK_oh_usr_TO_oh_review
		FOREIGN KEY (
			usr_num
		)
		REFERENCES ohora.oh_usr (
			usr_num
		);

ALTER TABLE ohora.oh_review
	ADD
		CONSTRAINT FK_oh_order_TO_oh_review
		FOREIGN KEY (
			od_num
		)
		REFERENCES ohora.oh_order (
			od_num
		);

ALTER TABLE ohora.oh_review
	ADD
		CONSTRAINT FK_oh_product_TO_oh_review
		FOREIGN KEY (
			pd_num
		)
		REFERENCES ohora.oh_product (
			pd_num
		);

ALTER TABLE ohora.oh_point
	ADD
		CONSTRAINT FK_oh_usr_TO_oh_point
		FOREIGN KEY (
			usr_num
		)
		REFERENCES ohora.oh_usr (
			usr_num
		);

ALTER TABLE ohora.oh_point
	ADD
		CONSTRAINT FK_oh_review_TO_oh_point
		FOREIGN KEY (
			rv_num
		)
		REFERENCES ohora.oh_review (
			rv_num
		);

ALTER TABLE ohora.oh_coupon
	ADD
		CONSTRAINT FK_oh_usr_TO_oh_coupon
		FOREIGN KEY (
			usr_num
		)
		REFERENCES ohora.oh_usr (
			usr_num
		);

ALTER TABLE ohora.oh_coupon
	ADD
		CONSTRAINT FK_oh_cpn_req_TO_oh_coupon
		FOREIGN KEY (
			cr_num
		)
		REFERENCES ohora.oh_cpn_req (
			cr_num
		);

ALTER TABLE ohora.oh_cpn_req
	ADD
		CONSTRAINT FK_oh_order_TO_oh_cpn_req
		FOREIGN KEY (
			od_num
		)
		REFERENCES ohora.oh_order (
			od_num
		);

ALTER TABLE ohora.oh_cpn_req
	ADD
		CONSTRAINT FK_oh_product_TO_oh_cpn_req
		FOREIGN KEY (
			pd_num
		)
		REFERENCES ohora.oh_product (
			pd_num
		);

ALTER TABLE ohora.oh_order
	ADD
		CONSTRAINT FK_oh_usr_TO_oh_order
		FOREIGN KEY (
			usr_num
		)
		REFERENCES ohora.oh_usr (
			usr_num
		);

ALTER TABLE ohora.oh_order
	ADD
		CONSTRAINT FK_oh_product_TO_oh_order
		FOREIGN KEY (
			pd_num
		)
		REFERENCES ohora.oh_product (
			pd_num
		);

ALTER TABLE ohora.oh_order
	ADD
		CONSTRAINT FK_oh_cart_TO_oh_order
		FOREIGN KEY (
			cart_num
		)
		REFERENCES ohora.oh_cart (
			cart_num
		);

ALTER TABLE ohora.oh_gift
	ADD
		CONSTRAINT FK_oh_product_TO_oh_gift
		FOREIGN KEY (
			pd_num
		)
		REFERENCES ohora.oh_product (
			pd_num
		);

ALTER TABLE ohora.oh_gift
	ADD
		CONSTRAINT FK_oh_order_TO_oh_gift
		FOREIGN KEY (
			od_num
		)
		REFERENCES ohora.oh_order (
			od_num
		);

ALTER TABLE ohora.oh_gift
	ADD
		CONSTRAINT FK_oh_usr_TO_oh_gift
		FOREIGN KEY (
			usr_num
		)
		REFERENCES ohora.oh_usr (
			usr_num
		);

ALTER TABLE ohora.oh_cart
	ADD
		CONSTRAINT FK_oh_usr_TO_oh_cart
		FOREIGN KEY (
			usr_num
		)
		REFERENCES ohora.oh_usr (
			usr_num
		);

ALTER TABLE ohora.oh_cart
	ADD
		CONSTRAINT FK_oh_product_TO_oh_cart
		FOREIGN KEY (
			pd_num
		)
		REFERENCES ohora.oh_product (
			pd_num
		);

ALTER TABLE ohora.oh_mydesign
	ADD
		CONSTRAINT FK_oh_product_TO_oh_mydesign
		FOREIGN KEY (
			pd_num
		)
		REFERENCES ohora.oh_product (
			pd_num
		);

ALTER TABLE ohora.oh_category
	ADD
		CONSTRAINT FK_oh_product_TO_oh_category
		FOREIGN KEY (
			pd_num
		)
		REFERENCES ohora.oh_product (
			pd_num
		);

ALTER TABLE ohora.oh_order_sub
	ADD
		CONSTRAINT FK_oh_order_TO_oh_order_sub
		FOREIGN KEY (
			od_num
		)
		REFERENCES ohora.oh_order (
			od_num
		);

ALTER TABLE ohora.oh_pay
	ADD
		CONSTRAINT FK_oh_order_TO_oh_pay
		FOREIGN KEY (
			od_num
		)
		REFERENCES ohora.oh_order (
			od_num
		);

ALTER TABLE ohora.oh_pay
	ADD
		CONSTRAINT FK_oh_usr_TO_oh_pay
		FOREIGN KEY (
			usr_num
		)
		REFERENCES ohora.oh_usr (
			usr_num
		);

ALTER TABLE ohora.oh_pay
	ADD
		CONSTRAINT FK_oh_coupon_TO_oh_pay
		FOREIGN KEY (
			cp_num
		)
		REFERENCES ohora.oh_coupon (
			cp_num
		);

ALTER TABLE ohora.oh_pay
	ADD
		CONSTRAINT FK_oh_pay_type_TO_oh_pay
		FOREIGN KEY (
			pay_way
		)
		REFERENCES ohora.oh_pay_type (
			pay_way
		);

ALTER TABLE ohora.oh_delivery
	ADD
		CONSTRAINT FK_oh_usr_TO_oh_delivery
		FOREIGN KEY (
			usr_num
		)
		REFERENCES ohora.oh_usr (
			usr_num
		);

ALTER TABLE ohora.oh_order_cncl
	ADD
		CONSTRAINT FK_oh_order_TO_oh_order_cncl
		FOREIGN KEY (
			od_num
		)
		REFERENCES ohora.oh_order (
			od_num
		);

ALTER TABLE ohora.oh_order_cncl
	ADD
		CONSTRAINT FK_oh_product_TO_oh_order_cncl
		FOREIGN KEY (
			pd_num
		)
		REFERENCES ohora.oh_product (
			pd_num
		);

ALTER TABLE ohora.oh_roles
	ADD
		CONSTRAINT FK_oh_usr_TO_oh_roles
		FOREIGN KEY (
			usr_num
		)
		REFERENCES ohora.oh_usr (
			usr_num
		);

ALTER TABLE ohora.oh_pay_type
	ADD
		CONSTRAINT FK_oh_order_TO_oh_pay_type
		FOREIGN KEY (
			od_num
		)
		REFERENCES ohora.oh_order (
			od_num
		);

ALTER TABLE ohora.TABLE2
	ADD
		CONSTRAINT FK_oh_review_TO_TABLE2
		FOREIGN KEY (
			rv_num
		)
		REFERENCES ohora.oh_review (
			rv_num
		);
        
ALTER TABLE oh_order
MODIFY (od_status DEFAULT 0);

ALTER TABLE oh_comments ADD brd_num NUMBER; -- ��ۿ� �Խñ� ��ȣ �߰�
ALTER TABLE oh_comments ADD co_name VARCHAR2(10 char); -- ��ۿ� �ۼ��� (���� �ִ� �ý�����)

ALTER TABLE oh_comments
ADD CONSTRAINT fk_brd_num_to_comments FOREIGN KEY (brd_num) REFERENCES oh_board(brd_num);

ALTER TABLE oh_roles
DROP CONSTRAINT FK_oh_usr_TO_oh_roles;

ALTER TABLE oh_roles
DROP CONSTRAINT PK_oh_roles;

ALTER TABLE oh_roles
ADD CONSTRAINT fk_usr_num
FOREIGN KEY (usr_num)
REFERENCES oh_usr (usr_num)
ON DELETE CASCADE;

ALTER TABLE oh_roles
ADD CONSTRAINT pk_usr_num PRIMARY KEY (usr_num);

--level ���̺� ����(cascade �߰�)
ALTER TABLE oh_level--����
DROP CONSTRAINT FK_oh_usr_TO_oh_level;

ALTER TABLE oh_level--����
DROP CONSTRAINT PK_oh_level;

ALTER TABLE oh_level--cascade �߰�
ADD CONSTRAINT FK_oh_usr_TO_oh_level
FOREIGN KEY (usr_num)
REFERENCES oh_usr (usr_num)
ON DELETE CASCADE;

ALTER TABLE oh_level
ADD CONSTRAINT PK_oh_level PRIMARY KEY (usr_num);

--�������̺� choice �÷� �߰�
ALTER TABLE oh_review
ADD rv_choice VARCHAR2(1 CHAR) DEFAULT 'n';

commit;


-- INSERT �۾�

INSERT INTO oh_usr (USR_NUM, USR_ID, USR_TEL, USR_PHONE, USR_NAME, USR_EMAIL, USR_EMAIL_YN, USR_SMS_YN, USR_LEVEL, USR_BIRTH, USR_PW)
VALUES (1, 'asdf', '1234', '1234', '�ֻ��', 'emailass', 'y', 'n', 'CREW', '1998-02-05', 'AApass'); 

INSERT INTO oh_usr (USR_NUM, USR_ID, USR_TEL, USR_PHONE, USR_NAME, USR_EMAIL, USR_EMAIL_YN, USR_SMS_YN, USR_LEVEL, USR_BIRTH, USR_PW)
VALUES (2, 'qwer', '5678', '5678', '���ؼ�', 'testemail', 'n', 'y', 'FRIEND', '2000-02-25', 'PWPW'); 

--

INSERT INTO OH_PRODUCT (PD_NUM, PD_NAME, PD_DATE, PD_STOCK, PD_PRICE, PD_DC_PRICE, PD_VIEW, PD_MEDIA, PD_DC_RATE, PD_TOT_BUY)
VALUES (1, '�������������', '2024-01-01', 99, 12000, 9600, 15000, 'IMAGE' , 20, 100);

INSERT INTO OH_PRODUCT (PD_NUM, PD_NAME, PD_DATE, PD_STOCK, PD_PRICE, PD_DC_PRICE, PD_VIEW, PD_MEDIA, PD_DC_RATE, PD_TOT_BUY)
VALUES (2, '�Ҳ��е�ť��', '2024-02-01', 88, 10000, 9000, 20000, 'IMAGE' , 10, 50);

INSERT INTO OH_PRODUCT (PD_NUM, PD_NAME, PD_DATE, PD_STOCK, PD_PRICE, PD_DC_PRICE, PD_VIEW, PD_MEDIA, PD_DC_RATE, PD_TOT_BUY)
VALUES (3, '��������', '2024-02-14', 5, 200000, 180000, 50000, 'IMAGE' , 10, 3);

--

INSERT INTO OH_CART (CART_NUM, USR_NUM, PD_NUM, CART_PDCNT) VALUES (1, 1, 1, 1);

INSERT INTO OH_CART (CART_NUM, USR_NUM, PD_NUM, CART_PDCNT) VALUES (2, 2, 2, 1);

INSERT INTO OH_CART (CART_NUM, USR_NUM, PD_NUM, CART_PDCNT) VALUES (3, 1, 3, 1);

--

INSERT INTO OH_ORDER (OD_NUM, OD_DATE, OD_PRICE, OD_STATUS, OD_CANCEL, USR_NUM, PD_NUM, CART_NUM) 
VALUES (1, '2024-08-25', 9600, '�����', 'X', 1, 1, 1); 

INSERT INTO OH_ORDER (OD_NUM, OD_DATE, OD_PRICE, OD_STATUS, OD_CANCEL, USR_NUM, PD_NUM, CART_NUM) 
VALUES (2, '2024-08-28', 9000, '��ǰ�غ���', 'X', 2, 2, 2); 

INSERT INTO OH_ORDER (OD_NUM, OD_DATE, OD_PRICE, OD_STATUS, OD_CANCEL, USR_NUM, PD_NUM, CART_NUM) 
VALUES (3, '2024-08-28', 180000, '��ǰ�غ���', 'X', 1, 3, 3); 

COMMIT;

-- ���

INSERT INTO oh_level (usr_num, usr_level, point_rate) VALUES (1, 'FAMILY', 2);

INSERT INTO oh_level (usr_num, usr_level, point_rate) VALUES (2, 'FRIEND', 1);

-- ����

INSERT INTO oh_review (rv_num, rv_title, rv_content, rv_date, rv_score, rv_like, usr_num, od_num, pd_num, rv_choice, rv_dislike ) 
VALUES (1, 'ǰ���� ���ƿ�', '��� �˵��ϰ� �������� �����ؿ�!', '2024-08-29', 5, 20, 1, 1, 1, 'n','1');

-- ������

INSERT INTO oh_point (usr_num, pt_date, pt_point, usr_level, rv_num) VALUES (1, '2024-08-30', 100, 'FAMILY',1 );

-- �������ǹ�ȣ

INSERT INTO oh_cpn_req (cr_num, cr_date, cr_ratio, cr_price, cr_product, od_num, pd_num) 
VALUES (1, '2024-12-31', 5, 30000, '��������', 1, 1);

-- ����

INSERT INTO oh_coupon (cp_num, cp_name, cp_rate, usr_num, cr_num) 
VALUES (1, '�������� 5% ��������', 5, 1, 1);

--oh_order_sub ���̺��� os_numos_num ������

CREATE SEQUENCE os_num_seq
INCREMENT BY 1 START WITH 1 NOCACHE  NOORDER  NOCYCLE;

--oh_order_sub ���̵�����

INSERT INTO oh_order_sub (os_num, od_num, os_price, os_pay_delivery, os_name)
VALUES (os_num_seq.NEXTVAL, 1, 9600, 3000, '�������������'); 

INSERT INTO oh_order_sub (os_num, od_num, os_price, os_pay_delivery, os_name)
VALUES (os_num_seq.NEXTVAL, 2, 9000, 3000, '�Ҳ��е�ť��'); 

INSERT INTO oh_order_sub (os_num, od_num, os_price, os_pay_delivery, os_name)
VALUES (os_num_seq.NEXTVAL, 3, 180000, 0, '��������');

--��ǰ ���̺��� pd_num ������
CREATE SEQUENCE pd_num_seq
INCREMENT BY 1 START WITH 1 NOCACHE  NOORDER  NOCYCLE;

--��ٱ��� ���̺��� cart_num ������
CREATE SEQUENCE cart_num_seq
INCREMENT BY 1 START WITH 1 NOCACHE  NOORDER  NOCYCLE;

COMMIT;





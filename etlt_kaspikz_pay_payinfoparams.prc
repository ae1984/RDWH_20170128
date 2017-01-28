CREATE OR REPLACE PROCEDURE U1."ETLT_KASPIKZ_PAY_PAYINFOPARAMS"
 is
 vStrDate date := sysdate;
 s_mview_name varchar2(30) := 'T_KASPIKZ_PAY_PAYINFOPARAMS';
 n_max_id number;
 c    integer;
 vLog_id        integer;
  vLog_det       varchar2(4000);
  vRes           varchar2(99);
  --
  nr   integer;
  v_id                    NUMBER;
  v_length_col            NUMBER;
  v_pay_info_id              number(20);
  v_service_params_id        number(10);
  v_str_value                varchar2(4000);

  begin
      select max(id)
      into n_max_id
      from T_KASPIKZ_PAY_PAYINFOPARAMS;

    c := DBMS_HS_PASSTHROUGH.OPEN_CURSOR@db_kr2;
    DBMS_HS_PASSTHROUGH.PARSE@db_kr2(c,
      'select
              t.bintId,
              t.bintPaymentInfoId,
              t.intServiceParameterId,
              cast(t.vchValue as char(4000))
              from dbo.v_Pay_PayInfoParams t
              where t.bintId > '||n_max_id||'
              ');


    LOOP
      nr := DBMS_HS_PASSTHROUGH.FETCH_ROW@db_kr2(c);
      EXIT WHEN nr = 0;
      v_id                    := null;
      v_pay_info_id           := null;
      v_service_params_id     := null;
      v_str_value             := null;
      DBMS_HS_PASSTHROUGH.GET_VALUE@db_kr2(c,  1, v_id);
      DBMS_HS_PASSTHROUGH.GET_VALUE@db_kr2(c,  2, v_pay_info_id);
      DBMS_HS_PASSTHROUGH.GET_VALUE@db_kr2(c,  3, v_service_params_id);
      DBMS_HS_PASSTHROUGH.GET_VALUE@db_kr2(c,  4, v_str_value);
      insert into T_KASPIKZ_PAY_PAYINFOPARAMS (ID, pay_info_id , service_params_id , str_value )
      values (v_id,
              v_pay_info_id ,
              v_service_params_id,
              rtrim(v_str_value)
             );
    END LOOP;
     DBMS_HS_PASSTHROUGH.CLOSE_CURSOR@db_kr2(c);
    commit;

 end ETLT_KASPIKZ_PAY_PAYINFOPARAMS;
/


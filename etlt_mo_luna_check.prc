create or replace procedure u1.ETLT_MO_LUNA_CHECK
     is
       s_mview_name     varchar2(30) := 'T_MO_LUNA_CHECK';
       vStrDate         date := sysdate;
       v_max_id         number;
      begin
       select /*+ parallel(20) */ max(t.request_id) into v_max_id
        from T_MO_LUNA_CHECK t;

        insert /*+ APPEND */ into T_MO_LUNA_CHECK
        select * from U1.T_LUNA_CHECK@MO1_PROD t where t.request_id > v_max_id;
        commit;
end ETLT_MO_LUNA_CHECK;
/


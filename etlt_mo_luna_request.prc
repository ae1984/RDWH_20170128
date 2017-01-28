create or replace procedure u1.ETLT_MO_LUNA_REQUEST
     is
       s_mview_name     varchar2(30) := 'T_MO_LUNA_REQUEST';
       vStrDate         date := sysdate;
       v_max_id         number;
      begin
       select /*+ parallel(20) */ max(t.id) into v_max_id
        from T_MO_LUNA_REQUEST t;

        insert /*+ APPEND */ into T_MO_LUNA_REQUEST
        select * from U1.T_LUNA_REQUEST@MO1_PROD t where t.id > v_max_id;
        commit;
 end ETLT_MO_LUNA_REQUEST;
/


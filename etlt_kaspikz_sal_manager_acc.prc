create or replace procedure u1.ETLT_KASPIKZ_SAL_MANAGER_ACC
 is

v_id number;
v_manager_domain_acc varchar2(100);
v_manager_groups     varchar2(4000);
vStrDate date := sysdate;
 s_mview_name     varchar2(30) := 'T_KASPIKZ_SAL_MANAGER_ACC';
 n_max_id number;
 c    integer;
 nr   integer;
begin
  select max(id)
      into n_max_id
      from T_KASPIKZ_SAL_MANAGER_ACC;

      c := DBMS_HS_PASSTHROUGH.OPEN_CURSOR@db_kr2;
      DBMS_HS_PASSTHROUGH.PARSE@db_kr2(c,
         'select
                t.id,
                t.ManagerDomainAccount,
                cast(t.Groups as char(4000))
                from dbo.dic_KaspiSalesManagerAccount t
                where t.id >'||n_max_id||'
                ');

      LOOP
        nr := DBMS_HS_PASSTHROUGH.FETCH_ROW@db_kr2(c);
        EXIT WHEN nr = 0;
        v_id                    := null;
        v_manager_domain_acc    := null;
        v_manager_groups        := null;
        DBMS_HS_PASSTHROUGH.GET_VALUE@db_kr2(c,  1, v_id);
        DBMS_HS_PASSTHROUGH.GET_VALUE@db_kr2(c,  2, v_manager_domain_acc);
        DBMS_HS_PASSTHROUGH.GET_VALUE@db_kr2(c,  3, v_manager_groups);
        insert into T_KASPIKZ_SAL_MANAGER_ACC(id, manager_domain_acc, manager_groups)
        values (v_id,
                v_manager_domain_acc,
                rtrim(v_manager_groups)
               );
      END LOOP;
      DBMS_HS_PASSTHROUGH.CLOSE_CURSOR@db_kr2(c);
      commit;
end ETLT_KASPIKZ_SAL_MANAGER_ACC;
/


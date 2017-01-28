create or replace procedure u1.ETLT_MOGW_PROCESS_MO1
       is
       s_mview_name     varchar2(30) := 'MOGW_PROCESS_MO1';
       vStrDate         date := sysdate;
       v_max_id         number;
       v_max_date       varchar2(100);
       s_sql            varchar2(2000);
      begin
       select /*+ parallel(20) */
        to_char(max(t.date_start),'dd-mm-yyyy HH24:MI:SS.FF')
        into v_max_date
        from MOGW_PROCESS_MO1 t;

        s_sql := 'insert /*+ APPEND */ into MOGW_PROCESS_MO1
        select * from PROCESS_MO1@MOGW_PROD t
        where t.date_start > to_timestamp('''|| v_max_date||''',''dd-mm-yyyy HH24:MI:SS.FF'')';
        commit;
 end ETLT_MOGW_PROCESS_MO1;
/

